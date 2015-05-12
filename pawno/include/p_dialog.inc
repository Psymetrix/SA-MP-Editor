/*-------------------------------------------------------*-
	p_dialog by Psymetrix, 2015.

	This script was thrown together in a hurry and should NOT be
	used on public servers.

	Natives:
		native DialogShow(playerid, dialogname[], style, caption[], info[], button1[], button2[]);
		native DialogHide(playerid);
		native bool:IsDialogOpen(playerid);

	Hooked callbacks:
		OnDialogResponse
-*-------------------------------------------------------*/
#if !defined isnull
	#define isnull(%1) \
			((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

#if !defined strcpy
	#define strcpy(%0,%1) strcat((%0[0] = '\0', %0), %1)
#endif

#define Dialog:%0(%1) \
        forward dialog_%0(%1); public dialog_%0(%1)

#define DialogRecieved:%0(%1) \
        forward dialogr_%0(%1); public dialogr_%0(%1)

// Global dialog id used for all dialogs used through-out this include.
#if !defined GLOBAL_DIALOG_ID
	#define GLOBAL_DIALOG_ID 12000
#endif

// Maximum length of dialog names.
#if !defined MAX_DIALOG_NAME
	#define MAX_DIALOG_NAME 32
#endif

static stock gpDialogName[MAX_PLAYERS][MAX_DIALOG_NAME];
static stock bool:gpDialogOpen[MAX_PLAYERS];

stock DialogShow(playerid, dialogname[], style, caption[], info[], button1[], button2[])
{
	strcpy(gpDialogName[playerid], dialogname, MAX_DIALOG_NAME);
	
	new string[MAX_DIALOG_NAME + 8];

	strcat(string, "dialogr_");
	strcat(string, gpDialogName[playerid]);

	if (funcidx(string) != -1 && !CallLocalFunction(string, "i", playerid))
	{
		return 0;
	}

	ShowPlayerDialog(playerid, GLOBAL_DIALOG_ID, style, caption, info, button1, button2);
	gpDialogOpen[playerid] = true;
	return 1;
}

stock DialogHide(playerid)
{
	ShowPlayerDialog(playerid, -1, DIALOG_STYLE_LIST, " ", " ", " ", " ");
	gpDialogOpen[playerid = false;
	return 1;
}

stock bool:IsDialogOpen(playerid)
{
	return gpDialogOpen[playerid];
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if (dialogid == GLOBAL_DIALOG_ID)
	{
		new string[MAX_DIALOG_NAME + 8];

		strcat(string, "dialog_");
		strcat(string, gpDialogName[playerid]);

		if (!isnull(inputtext))
		{
			CallLocalFunction(string, "iiis", playerid, response, listitem, inputtext);
		}
		else
		{
			CallLocalFunction(string, "iiis", playerid, response, listitem, "\1");
		}
	}

	#if defined PD_OnDialogResponse
		PD_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	#endif
	return 1;
}
#if defined _ALS_OnDialogResponse
	#undef OnDialogResponse
#else
	#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse PD_OnDialogResponse
#if defined PD_OnDialogResponse
	forward PD_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif