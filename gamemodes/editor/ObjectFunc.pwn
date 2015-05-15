// Default movement speed for object editing.
#define DEFAULT_MOVE_SPEED 1.0

// Default rotation speed for object editing.
#define DEFAULT_ROTATION_SPEED 5.0

// How often to check key input while editing an object.
#define EDIT_OBJECT_UPDATE_INTERVAL 400

enum {
	MOVE_MODE_MOVE,
	MOVE_MODE_ROTATE
};

enum E_OBJECT_INFO {
	bool:  eIsValid,
		   eObjectID,
		   eModelID,
	Float: ePosX,
	Float: ePosY,
	Float: ePosZ,
	Float: eRotX,
	Float: eRotY,
	Float: eRotZ,
};

static 
		   gsObjectInfo[MAX_EDITOR_OBJECT][E_OBJECT_INFO],
		   gsEditObjectIndex[MAX_PLAYERS],
		   gsUpdateTimer[MAX_PLAYERS],
	Float: gsMoveSpeed[MAX_PLAYERS] = {DEFAULT_MOVE_SPEED, ...},
	Float: gsRotationSpeed[MAX_PLAYERS] = {DEFAULT_ROTATION_SPEED, ...},
		   gsMoveMode[MAX_PLAYERS];

forward OnPlayerSelectEditorObject(playerid, index, objectid, modelid);

static Editor_GetFreeObjectSlot()
{
	new slot = EDITOR_INVALID_SLOT;

	for (new i; i < MAX_EDITOR_OBJECT; i++)	{
		if (!gsObjectInfo[i][eIsValid])	{
			slot = i;
			break;
		}
	}
	return slot;
}

static Editor_GetObjectSlotFromID(objectid)
{
	new slot = EDITOR_INVALID_SLOT;

	for (new i; i < MAX_EDITOR_OBJECT; i++)	{
		if (gsObjectInfo[i][eObjectID] == objectid)	{
			slot = i;
			break;
		}
	}
	return slot;
}

Editor_CreateObject(modelid, Float:pos_x, Float:pos_y, Float:pos_z, Float:rot_x, Float:rot_y, Float:rot_z)
{
	new slot = Editor_GetFreeObjectSlot();

	if (slot != EDITOR_INVALID_SLOT){
		new objectid = CreateDynamicObject(modelid, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z);

		if (IsValidDynamicObject(objectid)) {
			gsObjectInfo[slot][eObjectID] = objectid;
			gsObjectInfo[slot][eModelID] = modelid;
			gsObjectInfo[slot][ePosX] = pos_x;
			gsObjectInfo[slot][ePosY] = pos_y;
			gsObjectInfo[slot][ePosZ] = pos_z;
			gsObjectInfo[slot][eRotX] = rot_x;
			gsObjectInfo[slot][eRotY] = rot_y;
			gsObjectInfo[slot][eRotZ] = rot_z;
			gsObjectInfo[slot][eIsValid] = true;

			// add object to the database
			//Project_AddObject(slot, modelid, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, false);
		}
		else {
			slot = EDITOR_INVALID_SLOT;
		}
	}
	return slot;
}

Editor_EditObject(playerid, index)
{
	if (!gsObjectInfo[index][eIsValid])
		return 0;

	new objectid = gsObjectInfo[index][eObjectID];
	if (!IsValidDynamicObject(objectid))
		return 0;

	gsEditObjectIndex[playerid] = index;
	gsMoveMode[playerid] = MOVE_MODE_MOVE;

	SetPlayerEditMode(playerid, EDIT_MODE_OBJECT);
	gsUpdateTimer[playerid] = SetTimerEx("EditObjectUpdate", EDIT_OBJECT_UPDATE_INTERVAL, true, "i", playerid);
	return 1;
}

Editor_CancelEdit(playerid)
{
	if (GetPlayerEditMode(playerid) == EDIT_MODE_OBJECT) {
		KillTimer(gsUpdateTimer[playerid]);
		gsEditObjectIndex[playerid] = 0;
		SetPlayerEditMode(playerid, EDIT_MODE_NONE);
		return 1;
	}
	return 0;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	// exit editing
	if (newkeys & KEY_ACTION) {
		Editor_CancelEdit(playerid);
		ToggleFlyControls(playerid, true);
		return 1;
	}
	// switch between move & rotate mode
	if (newkeys & KEY_JUMP) {
		if (GetPlayerEditMode(playerid) == EDIT_MODE_OBJECT) {
			if (gsMoveMode[playerid] == MOVE_MODE_MOVE)
			{
				gsMoveMode[playerid] = MOVE_MODE_ROTATE;
			}
			else {
				gsMoveMode[playerid] = MOVE_MODE_MOVE;
			}
		}
		return 1;
	}
    #if defined EOF_OnPlayerKeyStateChange
        EOF_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #endif
    return 1;
}

public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{
	new index = Editor_GetObjectSlotFromID(objectid);

	if (index != EDITOR_INVALID_SLOT) {
		OnPlayerSelectEditorObject(playerid, index, objectid, modelid);
	}

    #if defined EOF_OnPlayerSelectDynObject
        EOF_OnPlayerSelectDynObject(playerid, objectid, modelid, Float:x, Float:y, Float:z);
    #endif
    return 1;
}

forward EditObjectUpdate(playerid);
public  EditObjectUpdate(playerid)
{
	if (!IsPlayerConnected(playerid)) {
		Editor_CancelEdit(playerid);
		ToggleFlyControls(playerid, true);
		return 1;
	}

	new editmode = GetPlayerEditMode(playerid);

	if (editmode != EDIT_MODE_OBJECT) {
		Editor_CancelEdit(playerid);
		ToggleFlyControls(playerid, true);
		return 1;
	}

	new
		index = gsEditObjectIndex[playerid],
		objectid = gsObjectInfo[index][eObjectID]
	;

	if (IsValidDynamicObject(objectid)) {
		new 
			ud,
			lr,
			keys
		;

		/*
		Move mode:
		 Keys up/down/left/right move object on X/Y axis.
		 If the sprint key is held, up/down moves object on Z axis.
		 Pressing jump key switches to rotation mode.
		Rotation mode:
		 keys up/down/left/right rotates on x/y.
		 Holding sprint changes up/down to rotate on z axis.
		Exiting:
		 Pressing the action key will exit out editing.
		*/

		GetPlayerKeys(playerid, keys, ud, lr);

		// handle object positioning
		if (gsMoveMode[playerid] == MOVE_MODE_MOVE) {
		// if the "sprint" key is held, switch up/down to move object up and down on the z-axis
			if (keys & KEY_SPRINT) {
				if (ud == KEY_UP) {
					gsObjectInfo[index][ePosZ] += gsMoveSpeed[playerid];
				}
				else if (ud == KEY_DOWN) {
					gsObjectInfo[index][ePosZ] -= gsMoveSpeed[playerid];					
				}
			}
			else
			{
				if (ud == KEY_UP) {
					gsObjectInfo[index][ePosY] += gsMoveSpeed[playerid];
				}
				else if (ud == KEY_DOWN) {
					gsObjectInfo[index][ePosY] -= gsMoveSpeed[playerid];					
				}
				else if (lr == KEY_LEFT) {
					gsObjectInfo[index][ePosX] -= gsMoveSpeed[playerid];					
				}
				else if (lr == KEY_RIGHT) {
					gsObjectInfo[index][ePosX] += gsMoveSpeed[playerid];					
				}
			}
		}
		// handle object rotation
		else {
		// if the "sprint" key is held, switch up/down to rotate object on the z-axis
			if (keys & KEY_SPRINT) {
				if (ud == KEY_UP) {
					gsObjectInfo[index][eRotZ] += gsRotationSpeed[playerid];
				}
				else if (ud == KEY_DOWN) {
					gsObjectInfo[index][eRotZ] -= gsRotationSpeed[playerid];					
				}
			}
			else
			{
				if (ud == KEY_UP) {
					gsObjectInfo[index][eRotX] -= gsRotationSpeed[playerid];					
				}
				else if (ud == KEY_DOWN) {
					gsObjectInfo[index][eRotX] += gsRotationSpeed[playerid];					
				}
				else if (lr == KEY_LEFT) {
					gsObjectInfo[index][eRotY] -= gsRotationSpeed[playerid];					
				}
				else if (lr == KEY_RIGHT) {
					gsObjectInfo[index][eRotY] += gsRotationSpeed[playerid];
				}
			}
		}
		SetDynamicObjectPos(objectid, gsObjectInfo[index][ePosX], gsObjectInfo[index][ePosY], gsObjectInfo[index][ePosZ]);
		SetDynamicObjectRot(objectid, gsObjectInfo[index][eRotX], gsObjectInfo[index][eRotY], gsObjectInfo[index][eRotZ]);
	}
	else {
		Editor_CancelEdit(playerid);
		ToggleFlyControls(playerid, true);
	}
    return 1;
}

// OnPlayerSelectDynamicObject
#if defined _ALS_OnPlayerSelectDynObject
    #undef OnPlayerSelectDynamicObject
#else
    #define _ALS_OnPlayerSelectDynObject
#endif
#define OnPlayerSelectDynamicObject EOF_OnPlayerSelectDynObject
#if defined EOF_OnPlayerSelectDynObject
    forward EOF_OnPlayerSelectDynObject(playerid, objectid, modelid, Float:x, Float:y, Float:z);
#endif

// OnPlayerKeyStateChange
#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange EOF_OnPlayerKeyStateChange
#if defined EOF_OnPlayerKeyStateChange
    forward EOF_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif