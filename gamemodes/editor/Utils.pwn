ClearPlayerChat(playerid)
{
	if (!IsPlayerConnected(playerid)) {
		return 0;
	}

	for(new i; i < 50; i++) {
		SendClientMessage(playerid, COLOR_WHITE, "\n");
	}
	return 1;
}

GetXYZInfrontOfPlayer(playerid, &Float:pos_x, &Float:pos_y, &Float:pos_z, Float:distance = 20.0)
{
	//new Float:pos_x, Float:pos_y, Float:pos_z;
	new Float:vec_x, Float:vec_y, Float:vec_z;
	new Float:cam_x, Float:cam_y, Float:cam_z;

	GetPlayerPos(playerid, pos_x, pos_y, pos_z);
	GetPlayerCameraPos(playerid, cam_x, cam_y, cam_z);
    GetPlayerCameraFrontVector(playerid, vec_x, vec_y, vec_z);

    pos_x = cam_x + (vec_x * distance);
    pos_y = cam_y + (vec_y * distance);
    pos_z = cam_z + (vec_z * distance);

    return 1;
}