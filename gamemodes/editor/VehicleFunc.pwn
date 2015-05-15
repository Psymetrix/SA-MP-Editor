// Default respawn time for vehicle (in seconds).
#define DEFAULT_VEHICLE_RESPAWN_TIME 60
#define VEHICLE_OBJECT_OFFSET 3.0

enum E_VEHICLE_INFO {
	bool: eIsValid,
		  eSelectObject,
		  eModel,
	Float:ePosX,
	Float:ePosY,
	Float:ePosZ,
	Float:eRotZ,
		  eColor1,
		  eColor2
};

static gsVehicleInfo[MAX_VEHICLES + 1][E_VEHICLE_INFO];
static gsEditVehicle[MAX_VEHICLES];

forward OnPlayerSelectEditorVehicle(playerid, vehicleid);

Editor_CreateVehicle(modelid, Float:pos_x, Float:pos_y, Float:pos_z, Float:rot_z)
{
	// TODO: add check for trains. Trains must be added as AddStaticVehicle.

	new vehicleid = CreateVehicle(modelid, pos_x, pos_y, pos_z, rot_z, 1, 1, DEFAULT_VEHICLE_RESPAWN_TIME);

	if (vehicleid) {
		gsVehicleInfo[vehicleid][eModel] = modelid;
		gsVehicleInfo[vehicleid][ePosX] = pos_x;
		gsVehicleInfo[vehicleid][ePosY] = pos_y;
		gsVehicleInfo[vehicleid][ePosZ] = pos_z;
		gsVehicleInfo[vehicleid][eRotZ] = rot_z;
		gsVehicleInfo[vehicleid][eColor1] = 1;
		gsVehicleInfo[vehicleid][eColor2] = 1;

		gsVehicleInfo[vehicleid][eSelectObject] = CreateDynamicObject(1598, pos_x, pos_y, pos_z + VEHICLE_OBJECT_OFFSET, 0.0, 0.0, rot_z);
		SetDynamicObjectMaterial(gsVehicleInfo[vehicleid][eSelectObject], 0, -1, "none", "none", 0xFF444400);

		gsVehicleInfo[vehicleid][eIsValid] = true;
		return 1;
	}
	return 0;
}

Editor_GetVehicleIDFromObject(objectid)
{
	new vehicleid = INVALID_VEHICLE_ID;

	for (new i; i <= MAX_VEHICLES; i++) {
		if (objectid == gsVehicleInfo[i][eSelectObject]) {
			vehicleid = i;
			break;
		}
	}
	return vehicleid;
}

Editor_EditVehicle(playerid, vehicleid)
{
	// Fix for SetVehiceZAngle not working on
	// vehicles that have never been occupied.

	ToggleFlyMode(playerid, false);
	PutPlayerInVehicle(playerid, vehicleid, 0);
	ToggleFlyMode(playerid, true);

	gsEditVehicle[playerid] = vehicleid;
	EditDynamicObject(playerid, gsVehicleInfo[vehicleid][eSelectObject]);
	SetPlayerEditMode(playerid, EDIT_MODE_VEHICLE);
	return 1;
}

public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{
	new vehicleid = Editor_GetVehicleIDFromObject(objectid);

	if (vehicleid != INVALID_VEHICLE_ID) {
		OnPlayerSelectEditorVehicle(playerid, vehicleid);
	}

    #if defined EVF_OnPlayerSelectDynObject
        EVF_OnPlayerSelectDynObject(playerid, objectid, modelid, Float:x, Float:y, Float:z);
    #endif
    return 1;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	new editmode = GetPlayerEditMode(playerid);
	if (editmode == EDIT_MODE_VEHICLE) {
		new vehicleid = gsEditVehicle[playerid];

		if (!IsVehicleStreamedIn(vehicleid, playerid)) {
			return 1;
		}

		if (objectid == gsVehicleInfo[vehicleid][eSelectObject]) {
			gsVehicleInfo[vehicleid][ePosX] = x;
			gsVehicleInfo[vehicleid][ePosY] = y;
			gsVehicleInfo[vehicleid][ePosZ] = z - VEHICLE_OBJECT_OFFSET;
			gsVehicleInfo[vehicleid][eRotZ] = rz;

			SetVehiclePos(vehicleid, gsVehicleInfo[vehicleid][ePosX], gsVehicleInfo[vehicleid][ePosY], gsVehicleInfo[vehicleid][ePosZ]);
			SetVehicleZAngle(vehicleid, gsVehicleInfo[vehicleid][eRotZ]);

			/*
			DestroyVehicle(vehicleid);

			gsEditVehicle[playerid] = CreateVehicle(
				gsVehicleInfo[vehicleid][eModel], gsVehicleInfo[vehicleid][ePosX], gsVehicleInfo[vehicleid][ePosY], gsVehicleInfo[vehicleid][ePosZ],
				gsVehicleInfo[vehicleid][eRotZ], gsVehicleInfo[vehicleid][eColor1], gsVehicleInfo[vehicleid][eColor2], DEFAULT_VEHICLE_RESPAWN_TIME
			);
			*/

			if (response == EDIT_RESPONSE_CANCEL || response == EDIT_RESPONSE_FINAL) {
				SetPlayerEditMode(playerid, EDIT_MODE_NONE);
				//ToggleFlyControls(playerid, true);
			}

			return 1;
		}
	}
    #if defined EVF_OnPlayerEditDynamicObject
        EVF_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
    #endif
    return 1;
}

// OnPlayerSelectDynamicObject
#if defined _ALS_OnPlayerSelectDynObject
    #undef OnPlayerSelectDynamicObject
#else
    #define _ALS_OnPlayerSelectDynObject
#endif
#define OnPlayerSelectDynamicObject EVF_OnPlayerSelectDynObject
#if defined EVF_OnPlayerSelectDynObject
    forward EVF_OnPlayerSelectDynObject(playerid, objectid, modelid, Float:x, Float:y, Float:z);
#endif

// OnPlayerEditDynamicObject
#if defined _ALS_OnPlayerEditDynamicObject
    #undef OnPlayerEditDynamicObject
#else
    #define _ALS_OnPlayerEditDynamicObject
#endif
#define OnPlayerEditDynamicObject EVF_OnPlayerEditDynamicObject
#if defined EVF_OnPlayerEditDynamicObject
    forward EVF_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
#endif