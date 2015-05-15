enum {
	EDIT_MODE_NONE,
	EDIT_MODE_OBJECT,
	EDIT_MODE_VEHICLE,
	EDIT_MODE_PICKUP,
	EDIT_MODE_ACTOR
};

static gsEditMode[MAX_PLAYERS];

SetPlayerEditMode(playerid, mode) {
	gsEditMode[playerid] = mode;
	return 1;
}

GetPlayerEditMode(playerid) {
	return gsEditMode[playerid];
}