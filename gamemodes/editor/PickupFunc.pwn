#define MAX_EDITOR_PICKUPS 1000
#define PICKUP_OBJECT_OFFSET 2.0
#define EDITOR_INVALID_PICKUP_ID -1

enum E_PICKUP_INFO {
	bool:  eIsValid,
		   ePickupID,
		   eModel,
	Float: ePosX,
	Float: ePosY,
	Float: ePosZ,
		   eSelectObject
};

static gsPickupInfo[MAX_EDITOR_PICKUPS][E_PICKUP_INFO];
static gsEditPickup[MAX_PLAYERS];

forward OnPlayerSelectEditorPickup(playerid, index, pickupid);

Editor_GetFreePickupSlot()
{
	new slot = EDITOR_INVALID_PICKUP_ID;

	for (new i; i < MAX_EDITOR_PICKUPS; i++) {
		if (!gsPickupInfo[i][eIsValid]) {
			slot = i;
			break;
		}
	}
	return slot;
}

Editor_GetPickupIDFromObject(objectid)
{
	new pickupid = EDITOR_INVALID_PICKUP_ID;

	for (new i; i < MAX_EDITOR_PICKUPS; i++) {
		if (objectid == gsPickupInfo[i][eSelectObject]) {
			pickupid = i;
			break;
		}
	}
	return pickupid;
}

Editor_CreatePickup(modelid, Float:pos_x, Float:pos_y, Float:pos_z)
{
	new slot = Editor_GetFreePickupSlot();

	if (slot == EDITOR_INVALID_PICKUP_ID) {
		return 0;
	}

	gsPickupInfo[slot][eModel] = modelid;
	gsPickupInfo[slot][ePosX] = pos_x;
	gsPickupInfo[slot][ePosY] = pos_y;
	gsPickupInfo[slot][ePosZ] = pos_z;
	gsPickupInfo[slot][eSelectObject] = CreateDynamicObject(1598, pos_x, pos_y, pos_z + PICKUP_OBJECT_OFFSET, 0.0, 0.0, 0.0);
	SetDynamicObjectMaterial(gsPickupInfo[slot][eSelectObject], 0, -1, "none", "none", 0xFF444400);
	gsPickupInfo[slot][ePickupID] = CreateDynamicPickup(modelid, 1, pos_x, pos_y, pos_z);
	gsPickupInfo[slot][eIsValid] = true;
	return 1;
}

Editor_EditPickup(playerid, index)
{
	gsEditPickup[playerid] = index;
	EditDynamicObject(playerid, gsPickupInfo[index][eSelectObject]);
	SetPlayerEditMode(playerid, EDIT_MODE_PICKUP);
	return 1;
}

public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{
	new index = Editor_GetPickupIDFromObject(objectid);

	if (index != EDITOR_INVALID_PICKUP_ID) {
		OnPlayerSelectEditorPickup(playerid, index, gsPickupInfo[index][ePickupID]);
	}

    #if defined EPF_OnPlayerSelectDynObject
        EPF_OnPlayerSelectDynObject(playerid, objectid, modelid, Float:x, Float:y, Float:z);
    #endif
    return 1;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	new editmode = GetPlayerEditMode(playerid);

	if (editmode == EDIT_MODE_PICKUP) {
		new index = gsEditPickup[playerid];

		if (objectid == gsPickupInfo[index][eSelectObject]) {

			gsPickupInfo[index][ePosX] = x;
			gsPickupInfo[index][ePosY] = y;
			gsPickupInfo[index][ePosZ] = z - PICKUP_OBJECT_OFFSET;

			Streamer_SetFloatData(STREAMER_TYPE_PICKUP, gsPickupInfo[index][ePickupID], E_STREAMER_X, gsPickupInfo[index][ePosX]);
			Streamer_SetFloatData(STREAMER_TYPE_PICKUP, gsPickupInfo[index][ePickupID], E_STREAMER_Y, gsPickupInfo[index][ePosY]);
			Streamer_SetFloatData(STREAMER_TYPE_PICKUP, gsPickupInfo[index][ePickupID], E_STREAMER_Z, gsPickupInfo[index][ePosZ]);

			Streamer_Update(playerid, STREAMER_TYPE_PICKUP);

			if (response == EDIT_RESPONSE_CANCEL || response == EDIT_RESPONSE_FINAL) {
				SetPlayerEditMode(playerid, EDIT_MODE_NONE);
				ToggleFlyControls(playerid, true);
			}

			return 1;
		}
	}
    #if defined EPF_OnPlayerEditDynamicObject
        EPF_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
    #endif
    return 1;
}

// OnPlayerSelectDynamicObject
#if defined _ALS_OnPlayerSelectDynObject
    #undef OnPlayerSelectDynamicObject
#else
    #define _ALS_OnPlayerSelectDynObject
#endif
#define OnPlayerSelectDynamicObject EPF_OnPlayerSelectDynObject
#if defined EPF_OnPlayerSelectDynObject
    forward EPF_OnPlayerSelectDynObject(playerid, objectid, modelid, Float:x, Float:y, Float:z);
#endif

// OnPlayerEditDynamicObject
#if defined _ALS_OnPlayerEditDynamicObject
    #undef OnPlayerEditDynamicObject
#else
    #define _ALS_OnPlayerEditDynamicObject
#endif
#define OnPlayerEditDynamicObject EPF_OnPlayerEditDynamicObject
#if defined EPF_OnPlayerEditDynamicObject
    forward EPF_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
#endif