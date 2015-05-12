enum {
	EDIT_MODE_OBJECT,
};

static gsEditMode[MAX_PLAYERS];

SetPlayerEditMode(playerid, mode) {
	gsEditMode[playerid] = mode;
	return 1;
}

GetPlayerEditMode(playerid) {
	return gsEditMode[playerid];
}