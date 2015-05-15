#define MAX_LOCATION_NAME 23

enum E_LOCATION_INFO {
	eName[MAX_LOCATION_NAME],
	Float:ePosX,
	Float:ePosY,
	Float:ePosZ
}

static gsLocation[16][E_LOCATION_INFO] =
{
	{"Abandoned Airfield",     384.4786,   2542.5271,  90.1149},
	{"Area 51",                233.1414,   1831.8746,  125.1994},
	{"Grove Street",           2507.3965,  -1669.2634, 58.4799},
	{"Hunter Quarry",          582.5833,   858.6106,   160.9603},
	{"Los Santos Airport",     1870.0021,  -2307.7720, 96.0180},
	{"Las Venturas Airport",   1426.2722,  1214.7404,  98.7523},
	{"Las Venturas Gold Club", 1389.6287,  2830.2505,  103.9387},
	{"Las Venturas P.D",       2300.9304,  2383.1643,  74.3871},
	{"Mad Dogg's Mansion",     1269.6549,  -781.8633,  177.5925},
	{"Mount Chiliad",          -2354.0195, -1622.8557, 578.4946},
	{"San Fierro Airport",     -1206.1982, -92.9422,   92.9390},
	{"San Fierro P.D",         -1528.5138, 765.4888,   88.5556},
	{"San Fierro Stadium",     -2078.8386, -443.8607,  197.0229},
	{"The Big Ear",            -441.5031,  1493.6389,  149.1684},
	{"The Visage",             2067.4482,  1928.5006,  140.3176},
	{"Wang Cars",              -1994.0660, 238.8976,   82.0562}
};

ShowLocationsSelectDialog(playerid)
{
	DialogShow(playerid, "locationtype", DIALOG_STYLE_LIST, "Teleport locations", "Locations\nInteriors", DIALOG_BUTTON_SELECT, DIALOG_BUTTON_CANCEL);
	return 1;
}

ShowMapLocationsDialog(playerid)
{
	new string[(MAX_LOCATION_NAME * sizeof(gsLocation)) + 60];

	for (new i; i < sizeof(gsLocation); i++) {
		format(string, sizeof(string), "%s%s\n", string, gsLocation[i][eName]);
	}
	DialogShow(playerid, "locationnormal", DIALOG_STYLE_LIST, "Teleport locations - Map", string, DIALOG_BUTTON_SELECT, DIALOG_BUTTON_CANCEL);
	return 1;
}

Dialog:locationtype(playerid, response, listitem)
{
	if (!response) {
		return 1;
	}

	// Non-interior locations
	if (listitem == 0) {
		ShowMapLocationsDialog(playerid);
	}
	return 1;
}

Dialog:locationnormal(playerid, response, listitem)
{
	if (!response) {
		return 1;
	}

	if (0 <= listitem < sizeof(gsLocation)) {
		SetFlyModePos(playerid, gsLocation[listitem][ePosX], gsLocation[listitem][ePosY], gsLocation[listitem][ePosZ]);
		SetPlayerInterior(playerid, 0);
		SendClientMessage(playerid, COLOR_WHITE, "Position set.");
	}
	return 1;
}