#define DEFAULT_MOVE_SPEED 1.0

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
	Float: gsMoveSpeed[MAX_PLAYERS] = {DEFAULT_MOVE_SPEED, ...};

static Editor_GetFreeObjectSlot() {
	new slot = EDITOR_INVALID_SLOT;

	for (new i; i < MAX_EDITOR_OBJECT; i++)	{
		if (!gsObjectInfo[i][eIsValid])	{
			slot = i;
			break;
		}
	}
	return slot;
}

static Editor_GetObjectSlotFromID(objectid) {
	new slot = EDITOR_INVALID_SLOT;

	for (new i; i < MAX_EDITOR_OBJECT; i++)	{
		if (gsObjectInfo[i][eObjectID] == objectid)	{
			slot = i;
			break;
		}
	}
	return slot;
}

Editor_CreateObject(modelid, Float:pos_x, Float:pos_y, Float:pos_z, Float:rot_x, Float:rot_y, Float:rot_z) {
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

Editor_EditObject(playerid, index) {
	if (!gsObjectInfo[index][eIsValid])
		return 0;

	new objectid = gsObjectInfo[index][eObjectID];
	if (!IsValidDynamicObject(objectid))
		return 0;

	gsEditObjectIndex[playerid] = index;

	SetPlayerEditMode(playerid, EDIT_MODE_OBJECT);
	gsUpdateTimer[playerid] = SetTimerEx("EditObjectUpdate", true, 600, "i", playerid);
	return 1;
}

public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z) {
	new index = Editor_GetObjectSlotFromID(objectid);

	new string[50];
	format(string, sizeof(string), "Object ID: %d, Slot: %d", objectid, index);
	SendClientMessage(playerid, COLOR_WHITE, string);

	CancelEdit(playerid);
	Editor_EditObject(playerid, index);

    #if defined EOF_OnPlayerSelectDynObject
        EOF_OnPlayerSelectDynObject(playerid, objectid, modelid, Float:x, Float:y, Float:z);
    #endif
    return 1;
}

forward EditObjectUpdate(playerid);
public  EditObjectUpdate(playerid) {
	new editmode = GetPlayerEditMode(playerid);

	if (editmode == EDIT_MODE_OBJECT) {
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
			*/

			GetPlayerKeys(playerid, keys, ud, lr);
			//printf("keys: %d", keys);
			if (keys & KEY_SPRINT) {
				// if the "sprint" key is held, switch up/down to move object up and down
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
			SetDynamicObjectPos(objectid, gsObjectInfo[index][ePosX], gsObjectInfo[index][ePosY], gsObjectInfo[index][ePosZ]);
		}
	}
    return 1;
}


#if defined _ALS_OnPlayerSelectDynObject
    #undef OnPlayerSelectDynamicObject
#else
    #define _ALS_OnPlayerSelectDynObject
#endif
#define OnPlayerSelectDynamicObject EOF_OnPlayerSelectDynObject
#if defined EOF_OnPlayerSelectDynObject
    forward EOF_OnPlayerSelectDynObject(playerid, objectid, modelid, Float:x, Float:y, Float:z);
#endif