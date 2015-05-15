#define ACTOR_OBJECT_OFFSET 1.5

enum E_ACTOR_INFO {
	bool: eIsValid,
		  eSelectObject,
		  eSkinID,
	Float: ePosX,
	Float: ePosY,
	Float: ePosZ,
	Float: eRotation
};

static gsActorInfo[MAX_ACTORS][E_ACTOR_INFO];
static gsActorSyncTimer[MAX_ACTORS] = {-1, ...};
static gsEditActor[MAX_PLAYERS];

forward OnPlayerSelectEditorActor(playerid, actorid);

Editor_GetActorIDFromObject(objectid)
{
	new actorid = INVALID_ACTOR_ID;

	for (new i; i < MAX_ACTORS; i++) {
		if (objectid == gsActorInfo[i][eSelectObject]) {
			actorid = i;
			break;
		}
	}
	return actorid;
}

Editor_CreateActor(skinid, Float:pos_x, Float:pos_y, Float:pos_z, Float:rotation)
{
	new actorid = CreateActor(skinid, pos_x, pos_y, pos_z, rotation);

	if (IsValidActor(actorid)) {
		gsActorInfo[actorid][eSkinID] = skinid;
		gsActorInfo[actorid][ePosX] = pos_x;
		gsActorInfo[actorid][ePosY] = pos_y;
		gsActorInfo[actorid][ePosZ] = pos_z;
		gsActorInfo[actorid][eRotation] = rotation;
		gsActorInfo[actorid][eSelectObject] = CreateDynamicObject(1598, pos_x, pos_y, pos_z + ACTOR_OBJECT_OFFSET, 0.0, 0.0, 0.0);
		SetDynamicObjectMaterial(gsActorInfo[actorid][eSelectObject], 0, -1, "none", "none", 0xFF444400);		
		gsActorInfo[actorid][eIsValid] = true;
	}
	return actorid;
}

Editor_EditActor(playerid, actorid)
{
	gsEditActor[playerid] = actorid;
	EditDynamicObject(playerid, gsActorInfo[actorid][eSelectObject]);
	SetPlayerEditMode(playerid, EDIT_MODE_ACTOR);
	return 1;
}

forward Editor_SyncActor(actorid);
public  Editor_SyncActor(actorid)
{
	if (IsValidActor(actorid)) {
		SetActorVirtualWorld(actorid, 0);
	}
	gsActorSyncTimer[actorid] = -1;
	return 1;
}

public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{
	new index = Editor_GetActorIDFromObject(objectid);

	if (index != INVALID_ACTOR_ID) {
		OnPlayerSelectEditorActor(playerid, index);
	}

    #if defined EAF_OnPlayerSelectDynObject
        EAF_OnPlayerSelectDynObject(playerid, objectid, modelid, Float:x, Float:y, Float:z);
    #endif
    return 1;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	new editmode = GetPlayerEditMode(playerid);

	if (editmode == EDIT_MODE_ACTOR) {
		new actorid = gsEditActor[playerid];

		if (IsValidActor(actorid)) {

			if (objectid == gsActorInfo[actorid][eSelectObject]) {

				// sync the new facing angle by temporarily changing virtual worlds
				if (gsActorInfo[actorid][eRotation] != rz) {

					if (gsActorSyncTimer[actorid] == -1) {
						gsActorInfo[actorid][eRotation] = rz;
						SetActorFacingAngle(actorid, gsActorInfo[actorid][eRotation]);
						SetActorVirtualWorld(actorid, 1);
						gsActorSyncTimer[actorid] = SetTimerEx("Editor_SyncActor", 300, false, "i", actorid);
					}
				}

				gsActorInfo[actorid][ePosX] = x;
				gsActorInfo[actorid][ePosY] = y;
				gsActorInfo[actorid][ePosZ] = z - ACTOR_OBJECT_OFFSET;

				SetActorPos(actorid, gsActorInfo[actorid][ePosX], gsActorInfo[actorid][ePosY], gsActorInfo[actorid][ePosZ]);

				//SetActorVirtualWorld(actorid, 0);

				//ApplyActorAnimation(actorid, "CARRY", "crry_prtial", 0.1, 0, 1, 1, 0, 5000);

				if (response == EDIT_RESPONSE_CANCEL || response == EDIT_RESPONSE_FINAL) {
					SetPlayerEditMode(playerid, EDIT_MODE_NONE);
					ToggleFlyControls(playerid, true);
				}

				return 1;
			}
		}
	}
    #if defined EAF_OnPlayerEditDynamicObject
        EAF_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
    #endif
    return 1;
}

// OnPlayerSelectDynamicObject
#if defined _ALS_OnPlayerSelectDynObject
    #undef OnPlayerSelectDynamicObject
#else
    #define _ALS_OnPlayerSelectDynObject
#endif
#define OnPlayerSelectDynamicObject EAF_OnPlayerSelectDynObject
#if defined EAF_OnPlayerSelectDynObject
    forward EAF_OnPlayerSelectDynObject(playerid, objectid, modelid, Float:x, Float:y, Float:z);
#endif

// OnPlayerEditDynamicObject
#if defined _ALS_OnPlayerEditDynamicObject
    #undef OnPlayerEditDynamicObject
#else
    #define _ALS_OnPlayerEditDynamicObject
#endif
#define OnPlayerEditDynamicObject EAF_OnPlayerEditDynamicObject
#if defined EAF_OnPlayerEditDynamicObject
    forward EAF_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
#endif