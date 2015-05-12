#include <a_samp>
#include <streamer>
#include <p_dialog>
#include <PSI\p_colors>

#include "editor.h"
#include "editor\EditMode.pwn"
#include "editor\FlyMode.pwn"
#include "editor\EditorButtons.pwn"
#include "editor\ObjectFunc.pwn"
#include "editor\ProjectFunc.pwn"

main()
{
	
}

public OnGameModeInit()
{
	SetGravity(0.0);
	return 1;
}

public OnPlayerConnect(playerid)
{
	Streamer_ToggleIdleUpdate(playerid, true);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	ToggleFlyMode(playerid, false);
	HideEditorButtons(playerid);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetSpawnInfo(playerid, NO_TEAM, 0, 0.0, 0.0, 75.0, 0.0, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	ToggleFlyMode(playerid, true);
	ShowEditorButtons(playerid);
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (newkeys & KEY_FIRE)
	{
		SelectObject(playerid);
		return 1;
	}
	if (newkeys & KEY_AIM)
	{
		SelectTextDraw(playerid, SELECT_TEXTDRAW_COLOR);
		return 1;
	}
	return 1;
}

public OnPlayerClickEditorButton(playerid, buttontype)
{
	CancelSelectTextDraw(playerid);
	if (!IsProjectActive())
	{
		DialogShow(playerid, "manageproject", DIALOG_STYLE_LIST, "Manage project", "Close project\nOpen project\nNew project", DIALOG_BUTTON_SELECT, DIALOG_BUTTON_CANCEL);
		return 1;
	}
	if (buttontype == EDITOR_BUTTON_OBJECT)
	{
		DialogShow(playerid, "createobject", DIALOG_STYLE_INPUT, "Create object", "Please enter the model id of the new object.", DIALOG_BUTTON_CREATE, DIALOG_BUTTON_CANCEL);
	}
	else if (buttontype == EDITOR_BUTTON_VEHICLE)
	{
		SendClientMessage(playerid, COLOR_WHITE, "Create new vehicle");
	}
	else if (buttontype == EDITOR_BUTTON_PICKUP)
	{
		SendClientMessage(playerid, COLOR_WHITE, "Create new pickup");
	}
	else if (buttontype == EDITOR_BUTTON_CLASS)
	{
		SendClientMessage(playerid, COLOR_WHITE, "Create new class");
	}
	else if (buttontype == EDITOR_BUTTON_EXPORT)
	{
		SendClientMessage(playerid, COLOR_WHITE, "Export map");
	}
	else if (buttontype == EDITOR_BUTTON_INFO)
	{
		SendClientMessage(playerid, COLOR_WHITE, "Map info");
	}
	else if (buttontype == EDITOR_BUTTON_SETTINGS)
	{
		SendClientMessage(playerid, COLOR_WHITE, "Map settings");
	}
	return 1;
}

Dialog:createobject(playerid, response, listitem, inputtext[])
{
	// TODO: add numeric check
	// TODO: add object validity check
	if (response)
	{
		if (!isnull(inputtext))
		{
			new modelid = strval(inputtext);
			new Float:pos_x, Float:pos_y, Float:pos_z;

			GetPlayerPos(playerid, pos_x, pos_y, pos_z);
			Editor_CreateObject(modelid, pos_x, pos_y, pos_z, 0.0, 0.0, 0.0);
		}
		else
		{
			SendClientMessage(playerid, COLOR_WHITE, "No object has been created - no model was given.");
		}
	}
	else
	{
		SelectTextDraw(playerid, SELECT_TEXTDRAW_COLOR);
	}
	return 1;
}

Dialog:manageproject(playerid, response, listitem)
{
	if (response)
	{
		switch (listitem)
		{
			// Close project
			case 0:
			{
				if (IsProjectActive())
				{
					// save objects
					SetProjectActive(false);
					SendClientMessage(playerid, COLOR_WHITE, "Project closed.");
				}
				else
				{
					SendClientMessage(playerid, COLOR_WHITE, "No project active.");
				}
			}
			// Open project
			case 1:
			{
				DialogShow(playerid, "openproject", DIALOG_STYLE_INPUT, "Open project", "Please enter the name of the project to open.", DIALOG_BUTTON_OPEN, DIALOG_BUTTON_CANCEL);
			}
			// New project
			case 2:
			{
				DialogShow(playerid, "newproject", DIALOG_STYLE_INPUT, "New project", "Please enter a name for this project.", DIALOG_BUTTON_CREATE, DIALOG_BUTTON_CANCEL);
			}
		}
	}
	return 1;
}

Dialog:openproject(playerid, response, listitem, inputtext[])
{
	return 1;
}

Dialog:newproject(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		if (!isnull(inputtext))
		{
			if (IsValidProjectName(inputtext))
			{
				new project_created = CreateProjectFile(inputtext);

				if (project_created)
				{
					SetProjectActive(true);
					SetProjectName(inputtext);

					SendClientMessage(playerid, COLOR_WHITE, "Project created.");
				}
				else
				{
					SendClientMessage(playerid, COLOR_WHITE, "Unable to create project. A project with that name may already exist.");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_WHITE, "Invalid project name. Only characters 0-9, a-z and A-Z are allowed.");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_WHITE, "No project has been created - no name was given.");
		}
	}
	return 1;
}