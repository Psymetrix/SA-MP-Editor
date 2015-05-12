enum
{
	EDITOR_BUTTON_OBJECT,
	EDITOR_BUTTON_VEHICLE,
	EDITOR_BUTTON_PICKUP,
	EDITOR_BUTTON_CLASS,
	EDITOR_BUTTON_EXPORT,
	EDITOR_BUTTON_INFO,
	EDITOR_BUTTON_SETTINGS
};

static
		Text:		gsEditorButtons[15],
		PlayerText: gsEditorKeyInfo[MAX_PLAYERS],
	bool:			gsHasEditorButtons[MAX_PLAYERS];

forward OnPlayerClickEditorButton(playerid, buttontype);

ShowEditorButtons(playerid)
{
	if (!gsHasEditorButtons[playerid])
	{
		for (new i; i < sizeof(gsEditorButtons); i++)
		{
			TextDrawShowForPlayer(playerid, gsEditorButtons[i]);
		}

		gsEditorKeyInfo[playerid] = CreatePlayerTextDraw(playerid, 492.007843, 388.916656, "~w~Press ~y~LMB ~w~to select an object. Press ~y~RMB ~w~to enable the menu.");
		PlayerTextDrawLetterSize(playerid, gsEditorKeyInfo[playerid], 0.139451, 0.876666);
		PlayerTextDrawTextSize(playerid, gsEditorKeyInfo[playerid], 0.039999, 283.845397);
		PlayerTextDrawAlignment(playerid, gsEditorKeyInfo[playerid], 2);
		PlayerTextDrawColor(playerid, gsEditorKeyInfo[playerid], -1);
		PlayerTextDrawUseBox(playerid, gsEditorKeyInfo[playerid], 1);
		PlayerTextDrawBoxColor(playerid, gsEditorKeyInfo[playerid], 255);
		PlayerTextDrawSetShadow(playerid, gsEditorKeyInfo[playerid], 1);
		PlayerTextDrawSetOutline(playerid, gsEditorKeyInfo[playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, gsEditorKeyInfo[playerid], 255);
		PlayerTextDrawFont(playerid, gsEditorKeyInfo[playerid], 2);
		PlayerTextDrawSetProportional(playerid, gsEditorKeyInfo[playerid], 1);
		PlayerTextDrawSetShadow(playerid, gsEditorKeyInfo[playerid], 1);
		PlayerTextDrawShow(playerid, gsEditorKeyInfo[playerid]);

		gsHasEditorButtons[playerid] = true;
		return 1;
	}
	return 0;
}

HideEditorButtons(playerid)
{
	if (gsHasEditorButtons[playerid])
	{
		for (new i; i < sizeof(gsEditorButtons); i++)
		{
			TextDrawHideForPlayer(playerid, gsEditorButtons[i]);
		}

		PlayerTextDrawHide(playerid, gsEditorKeyInfo[playerid]);
		PlayerTextDrawDestroy(playerid, gsEditorKeyInfo[playerid]);

		gsHasEditorButtons[playerid] = false;
		return 1;
	}
	return 0;
}

public OnGameModeInit()
{
	gsEditorButtons[0] = TextDrawCreate(349.000000, 400.000000, "_");
	TextDrawLetterSize(gsEditorButtons[0], 1.021551, 4.492496);
	TextDrawTextSize(gsEditorButtons[0], 635.500000, 0.000000);
	TextDrawAlignment(gsEditorButtons[0], 1);
	TextDrawColor(gsEditorButtons[0], -1);
	TextDrawUseBox(gsEditorButtons[0], 1);
	TextDrawBoxColor(gsEditorButtons[0], 255);
	TextDrawSetShadow(gsEditorButtons[0], 0);
	TextDrawSetOutline(gsEditorButtons[0], 0);
	TextDrawBackgroundColor(gsEditorButtons[0], 120);
	TextDrawFont(gsEditorButtons[0], 1);
	TextDrawSetProportional(gsEditorButtons[0], 1);
	TextDrawSetShadow(gsEditorButtons[0], 0);

	gsEditorButtons[1] = TextDrawCreate(349.000000, 400.000000, "");
	TextDrawLetterSize(gsEditorButtons[1], 0.000000, 0.000000);
	TextDrawTextSize(gsEditorButtons[1], 40.000000, 40.000000);
	TextDrawAlignment(gsEditorButtons[1], 1);
	TextDrawColor(gsEditorButtons[1], -1);
	TextDrawSetShadow(gsEditorButtons[1], 0);
	TextDrawSetOutline(gsEditorButtons[1], 0);
	TextDrawBackgroundColor(gsEditorButtons[1], 623191516);
	TextDrawFont(gsEditorButtons[1], 5);
	TextDrawSetProportional(gsEditorButtons[1], 1);
	TextDrawSetShadow(gsEditorButtons[1], 0);
	TextDrawSetSelectable(gsEditorButtons[1], true);
	TextDrawSetPreviewModel(gsEditorButtons[1], 1221);
	TextDrawSetPreviewRot(gsEditorButtons[1], -10.000000, 0.000000, 45.000000, 0.899999);

	gsEditorButtons[2] = TextDrawCreate(390.000000, 400.000000, "");
	TextDrawLetterSize(gsEditorButtons[2], 0.000000, 0.000000);
	TextDrawTextSize(gsEditorButtons[2], 40.000000, 40.000000);
	TextDrawAlignment(gsEditorButtons[2], 1);
	TextDrawColor(gsEditorButtons[2], -1);
	TextDrawSetShadow(gsEditorButtons[2], 0);
	TextDrawSetOutline(gsEditorButtons[2], 0);
	TextDrawBackgroundColor(gsEditorButtons[2], 623191516);
	TextDrawFont(gsEditorButtons[2], 5);
	TextDrawSetProportional(gsEditorButtons[2], 1);
	TextDrawSetShadow(gsEditorButtons[2], 0);
	TextDrawSetSelectable(gsEditorButtons[2], true);
	TextDrawSetPreviewModel(gsEditorButtons[2], 411);
	TextDrawSetPreviewRot(gsEditorButtons[2], -25.000000, 0.000000, -45.000000, 0.899999);
	TextDrawSetPreviewVehCol(gsEditorButtons[2], 1, 1);

	gsEditorButtons[3] = TextDrawCreate(431.000000, 400.000000, "");
	TextDrawLetterSize(gsEditorButtons[3], 0.000000, 0.000000);
	TextDrawTextSize(gsEditorButtons[3], 40.000000, 40.000000);
	TextDrawAlignment(gsEditorButtons[3], 1);
	TextDrawColor(gsEditorButtons[3], -1);
	TextDrawSetShadow(gsEditorButtons[3], 0);
	TextDrawSetOutline(gsEditorButtons[3], 0);
	TextDrawBackgroundColor(gsEditorButtons[3], 623191516);
	TextDrawFont(gsEditorButtons[3], 5);
	TextDrawSetProportional(gsEditorButtons[3], 1);
	TextDrawSetShadow(gsEditorButtons[3], 0);
	TextDrawSetSelectable(gsEditorButtons[3], true);
	TextDrawSetPreviewModel(gsEditorButtons[3], 1240);
	TextDrawSetPreviewRot(gsEditorButtons[3], 0.000000, 0.000000, 0.000000, 0.899999);

	gsEditorButtons[4] = TextDrawCreate(472.000000, 400.000000, "");
	TextDrawLetterSize(gsEditorButtons[4], 0.000000, 0.000000);
	TextDrawTextSize(gsEditorButtons[4], 40.000000, 40.000000);
	TextDrawAlignment(gsEditorButtons[4], 1);
	TextDrawColor(gsEditorButtons[4], -1);
	TextDrawSetShadow(gsEditorButtons[4], 0);
	TextDrawSetOutline(gsEditorButtons[4], 0);
	TextDrawBackgroundColor(gsEditorButtons[4], 623191516);
	TextDrawFont(gsEditorButtons[4], 5);
	TextDrawSetProportional(gsEditorButtons[4], 1);
	TextDrawSetShadow(gsEditorButtons[4], 0);
	TextDrawSetSelectable(gsEditorButtons[4], true);
	TextDrawSetPreviewModel(gsEditorButtons[4], 7);
	TextDrawSetPreviewRot(gsEditorButtons[4], 0.000000, 0.000000, 180.000000, 1.000000);

	gsEditorButtons[5] = TextDrawCreate(513.000000, 400.000000, "");
	TextDrawLetterSize(gsEditorButtons[5], 0.000000, 0.000000);
	TextDrawTextSize(gsEditorButtons[5], 40.000000, 40.000000);
	TextDrawAlignment(gsEditorButtons[5], 1);
	TextDrawColor(gsEditorButtons[5], -1);
	TextDrawSetShadow(gsEditorButtons[5], 0);
	TextDrawSetOutline(gsEditorButtons[5], 0);
	TextDrawBackgroundColor(gsEditorButtons[5], 623191516);
	TextDrawFont(gsEditorButtons[5], 5);
	TextDrawSetProportional(gsEditorButtons[5], 1);
	TextDrawSetShadow(gsEditorButtons[5], 0);
	TextDrawSetSelectable(gsEditorButtons[5], true);
	TextDrawSetPreviewModel(gsEditorButtons[5], 1277);
	TextDrawSetPreviewRot(gsEditorButtons[5], 0.000000, 0.000000, 0.000000, 0.800000);

	gsEditorButtons[6] = TextDrawCreate(554.000000, 400.000000, "");
	TextDrawLetterSize(gsEditorButtons[6], 0.000000, 0.000000);
	TextDrawTextSize(gsEditorButtons[6], 40.000000, 40.000000);
	TextDrawAlignment(gsEditorButtons[6], 1);
	TextDrawColor(gsEditorButtons[6], -1);
	TextDrawSetShadow(gsEditorButtons[6], 0);
	TextDrawSetOutline(gsEditorButtons[6], 0);
	TextDrawBackgroundColor(gsEditorButtons[6], 623191516);
	TextDrawFont(gsEditorButtons[6], 5);
	TextDrawSetProportional(gsEditorButtons[6], 1);
	TextDrawSetShadow(gsEditorButtons[6], 0);
	TextDrawSetSelectable(gsEditorButtons[6], true);
	TextDrawSetPreviewModel(gsEditorButtons[6], 1239);
	TextDrawSetPreviewRot(gsEditorButtons[6], 0.000000, 0.000000, 180.000000, 0.800000);

	gsEditorButtons[7] = TextDrawCreate(595.000000, 400.000000, "");
	TextDrawLetterSize(gsEditorButtons[7], 0.000000, 0.000000);
	TextDrawTextSize(gsEditorButtons[7], 40.000000, 40.000000);
	TextDrawAlignment(gsEditorButtons[7], 1);
	TextDrawColor(gsEditorButtons[7], -1);
	TextDrawSetShadow(gsEditorButtons[7], 0);
	TextDrawSetOutline(gsEditorButtons[7], 0);
	TextDrawBackgroundColor(gsEditorButtons[7], 623191516);
	TextDrawFont(gsEditorButtons[7], 5);
	TextDrawSetProportional(gsEditorButtons[7], 1);
	TextDrawSetShadow(gsEditorButtons[7], 0);
	TextDrawSetSelectable(gsEditorButtons[7], true);
	TextDrawSetPreviewModel(gsEditorButtons[7], 3096);
	TextDrawSetPreviewRot(gsEditorButtons[7], 0.000000, 0.000000, 180.000000, 0.800000);

	gsEditorButtons[8] = TextDrawCreate(369.000000, 422.000000, "CREATE~n~OBJECT");
	TextDrawLetterSize(gsEditorButtons[8], 0.147698, 0.853333);
	TextDrawAlignment(gsEditorButtons[8], 2);
	TextDrawColor(gsEditorButtons[8], -1);
	TextDrawSetShadow(gsEditorButtons[8], 0);
	TextDrawSetOutline(gsEditorButtons[8], 1);
	TextDrawBackgroundColor(gsEditorButtons[8], 255);
	TextDrawFont(gsEditorButtons[8], 2);
	TextDrawSetProportional(gsEditorButtons[8], 1);
	TextDrawSetShadow(gsEditorButtons[8], 0);

	gsEditorButtons[9] = TextDrawCreate(410.000000, 422.000000, "CREATE~n~VEHICLE");
	TextDrawLetterSize(gsEditorButtons[9], 0.147698, 0.853333);
	TextDrawAlignment(gsEditorButtons[9], 2);
	TextDrawColor(gsEditorButtons[9], -1);
	TextDrawSetShadow(gsEditorButtons[9], 0);
	TextDrawSetOutline(gsEditorButtons[9], 1);
	TextDrawBackgroundColor(gsEditorButtons[9], 255);
	TextDrawFont(gsEditorButtons[9], 2);
	TextDrawSetProportional(gsEditorButtons[9], 1);
	TextDrawSetShadow(gsEditorButtons[9], 0);

	gsEditorButtons[10] = TextDrawCreate(451.000000, 422.000000, "CREATE~n~PICKUP");
	TextDrawLetterSize(gsEditorButtons[10], 0.147698, 0.853333);
	TextDrawAlignment(gsEditorButtons[10], 2);
	TextDrawColor(gsEditorButtons[10], -1);
	TextDrawSetShadow(gsEditorButtons[10], 0);
	TextDrawSetOutline(gsEditorButtons[10], 1);
	TextDrawBackgroundColor(gsEditorButtons[10], 255);
	TextDrawFont(gsEditorButtons[10], 2);
	TextDrawSetProportional(gsEditorButtons[10], 1);
	TextDrawSetShadow(gsEditorButtons[10], 0);

	gsEditorButtons[11] = TextDrawCreate(493.000000, 422.000000, "CREATE~n~CLASS");
	TextDrawLetterSize(gsEditorButtons[11], 0.147698, 0.853333);
	TextDrawAlignment(gsEditorButtons[11], 2);
	TextDrawColor(gsEditorButtons[11], -1);
	TextDrawSetShadow(gsEditorButtons[11], 0);
	TextDrawSetOutline(gsEditorButtons[11], 1);
	TextDrawBackgroundColor(gsEditorButtons[11], 255);
	TextDrawFont(gsEditorButtons[11], 2);
	TextDrawSetProportional(gsEditorButtons[11], 1);
	TextDrawSetShadow(gsEditorButtons[11], 0);

	gsEditorButtons[12] = TextDrawCreate(533.000000, 422.000000, "EXPORT~n~MAP");
	TextDrawLetterSize(gsEditorButtons[12], 0.147698, 0.853333);
	TextDrawAlignment(gsEditorButtons[12], 2);
	TextDrawColor(gsEditorButtons[12], -1);
	TextDrawSetShadow(gsEditorButtons[12], 0);
	TextDrawSetOutline(gsEditorButtons[12], 1);
	TextDrawBackgroundColor(gsEditorButtons[12], 255);
	TextDrawFont(gsEditorButtons[12], 2);
	TextDrawSetProportional(gsEditorButtons[12], 1);
	TextDrawSetShadow(gsEditorButtons[12], 0);

	gsEditorButtons[13] = TextDrawCreate(574.000000, 422.000000, "MAP INFO");
	TextDrawLetterSize(gsEditorButtons[13], 0.147698, 0.853333);
	TextDrawAlignment(gsEditorButtons[13], 2);
	TextDrawColor(gsEditorButtons[13], -1);
	TextDrawSetShadow(gsEditorButtons[13], 0);
	TextDrawSetOutline(gsEditorButtons[13], 1);
	TextDrawBackgroundColor(gsEditorButtons[13], 255);
	TextDrawFont(gsEditorButtons[13], 2);
	TextDrawSetProportional(gsEditorButtons[13], 1);
	TextDrawSetShadow(gsEditorButtons[13], 0);

	gsEditorButtons[14] = TextDrawCreate(615.000000, 422.000000, "MAP~n~SETTINGS");
	TextDrawLetterSize(gsEditorButtons[14], 0.147698, 0.853333);
	TextDrawAlignment(gsEditorButtons[14], 2);
	TextDrawColor(gsEditorButtons[14], -1);
	TextDrawSetShadow(gsEditorButtons[14], 0);
	TextDrawSetOutline(gsEditorButtons[14], 1);
	TextDrawBackgroundColor(gsEditorButtons[14], 255);
	TextDrawFont(gsEditorButtons[14], 2);
	TextDrawSetProportional(gsEditorButtons[14], 1);
	TextDrawSetShadow(gsEditorButtons[14], 0);

    #if defined EB_OnGameModeInit
        EB_OnGameModeInit();
    #endif
    return 1;
}

public OnGameModeExit()
{
	for (new i; i < sizeof(gsEditorButtons); i++)
	{
		TextDrawHideForAll(gsEditorButtons[i]);
		TextDrawDestroy(gsEditorButtons[i]);
	}

    #if defined EB_OnGameModeExit
        EB_OnGameModeExit();
    #endif
    return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if (gsHasEditorButtons[playerid])
	{
		// Create object
		if (clickedid == gsEditorButtons[1])
		{
			OnPlayerClickEditorButton(playerid, EDITOR_BUTTON_OBJECT);
			return 1;
		}
		// Create vehicle
		if (clickedid == gsEditorButtons[2])
		{
			OnPlayerClickEditorButton(playerid, EDITOR_BUTTON_VEHICLE);
			return 1;
		}
		// Create pickup
		if (clickedid == gsEditorButtons[3])
		{
			OnPlayerClickEditorButton(playerid, EDITOR_BUTTON_PICKUP);
			return 1;
		}
		// Create class
		if (clickedid == gsEditorButtons[4])
		{
			OnPlayerClickEditorButton(playerid, EDITOR_BUTTON_CLASS);
			return 1;
		}
		// Export
		if (clickedid == gsEditorButtons[5])
		{
			OnPlayerClickEditorButton(playerid, EDITOR_BUTTON_EXPORT);
			return 1;
		}
		// Information
		if (clickedid == gsEditorButtons[6])
		{
			OnPlayerClickEditorButton(playerid, EDITOR_BUTTON_INFO);
			return 1;
		}
		// Settings
		if (clickedid == gsEditorButtons[7])
		{
			OnPlayerClickEditorButton(playerid, EDITOR_BUTTON_SETTINGS);
			return 1;
		}
	}

    #if defined EB_OnPlayerClickTextDraw
        EB_OnPlayerClickTextDraw(playerid, Text:clickedid);
    #endif
    return 1;
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit EB_OnGameModeInit
#if defined EB_OnGameModeInit
    forward EB_OnGameModeInit();
#endif

#if defined _ALS_OnGameModeExit
    #undef OnGameModeExit
#else
    #define _ALS_OnGameModeExit
#endif
#define OnGameModeExit EB_OnGameModeExit
#if defined EB_OnGameModeExit
    forward EB_OnGameModeExit();
#endif

#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw EB_OnPlayerClickTextDraw
#if defined EB_OnPlayerClickTextDraw
    forward EB_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif