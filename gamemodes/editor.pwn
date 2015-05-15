#include <a_samp>

#undef MAX_PLAYERS
#define MAX_PLAYERS 50

#include <streamer>
#include <zcmd>
//#include <foreach>
#include <p_dialog>
#include <PSI\p_colors>

#include "editor.h"
#include "editor\Utils.pwn"
#include "editor\EditMode.pwn"
#include "editor\FlyMode.pwn"
#include "editor\EditorButtons.pwn"
#include "editor\ProjectFunc.pwn"
#include "editor\ObjectFunc.pwn"
#include "editor\VehicleFunc.pwn"
#include "editor\PickupFunc.pwn"
#include "editor\ActorFunc.pwn"
#include "editor\Teleports.pwn"

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
	ClearPlayerChat(playerid);
	Streamer_ToggleIdleUpdate(playerid, true);
	SetPlayerEditMode(playerid, EDIT_MODE_NONE);
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
	ToggleFlyControls(playerid, true);
	ShowEditorButtons(playerid);
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	// show "select object" mouse
	if (newkeys & KEY_FIRE) {
		// can't select an object while editing
		if (GetPlayerEditMode(playerid) != EDIT_MODE_NONE) {
			SendClientMessage(playerid, COLOR_WHITE, "Please finish your current task first.");
		}
		else {
			CancelSelectTextDraw(playerid);
			SelectObject(playerid);
		}
		return 1;
	}
	// show "select textdraw" mouse
	if (newkeys & KEY_AIM) {
		// can't select a textdraw while editing
		if (GetPlayerEditMode(playerid) != EDIT_MODE_NONE) {
			SendClientMessage(playerid, COLOR_WHITE, "Please finish your current task first.");
		}
		else {
			CancelEdit(playerid);
			SelectTextDraw(playerid, SELECT_TEXTDRAW_COLOR);
		}
		return 1;
	}
	return 1;
}

public OnPlayerClickEditorButton(playerid, buttontype)
{
	CancelSelectTextDraw(playerid);

	// TODO: uncomment project check
	// force the player to create a new project before adding elements
	/*if (!IsProjectActive()) {
		DialogShow(playerid, "manageproject", DIALOG_STYLE_LIST, "Manage project", "New project\nOpen project\nClose project", DIALOG_BUTTON_SELECT, DIALOG_BUTTON_CANCEL);
		return 1;
	}*/

	if (buttontype == EDITOR_BUTTON_OBJECT)	{
		DialogShow(playerid, "createobject", DIALOG_STYLE_INPUT, "Create object", "Please enter the model id for the new object.", DIALOG_BUTTON_CREATE, DIALOG_BUTTON_CANCEL);
	}
	else if (buttontype == EDITOR_BUTTON_VEHICLE) {
		DialogShow(playerid, "createvehicle", DIALOG_STYLE_INPUT, "Create vehicle", "Please enter the model id for the new vehicle.", DIALOG_BUTTON_CREATE, DIALOG_BUTTON_CANCEL);
	}
	else if (buttontype == EDITOR_BUTTON_PICKUP) {
		DialogShow(playerid, "createpickup", DIALOG_STYLE_INPUT, "Create pickup", "Please enter the model id for the new pickup.", DIALOG_BUTTON_CREATE, DIALOG_BUTTON_CANCEL);
	}
	else if (buttontype == EDITOR_BUTTON_ACTOR)	{
		DialogShow(playerid, "createactor", DIALOG_STYLE_INPUT, "Create actor", "Please enter the skin id for the new actor.", DIALOG_BUTTON_CREATE, DIALOG_BUTTON_CANCEL);
	}
	else if (buttontype == EDITOR_BUTTON_EXPORT) {
		SendClientMessage(playerid, COLOR_WHITE, "Export map");
	}
	else if (buttontype == EDITOR_BUTTON_INFO) {
		SendClientMessage(playerid, COLOR_WHITE, "Map info");
	}
	else if (buttontype == EDITOR_BUTTON_SETTINGS) {
		SendClientMessage(playerid, COLOR_WHITE, "Map settings");
	}
	return 1;
}

public OnPlayerSelectEditorObject(playerid, index, objectid, modelid)
{
	new string[50];
	format(string, sizeof(string), "Object ID: %d, Slot: %d", objectid, index);
	SendClientMessage(playerid, COLOR_WHITE, string);

	// hide the mouse
	CancelEdit(playerid);

	// let the player edit the object
	Editor_EditObject(playerid, index);
	ToggleFlyControls(playerid, false);	
	return 1;
}

public OnPlayerSelectEditorVehicle(playerid, vehicleid)
{
	new string[50];
	format(string, sizeof(string), "vehicle ID: %d", vehicleid);
	SendClientMessage(playerid, COLOR_WHITE, string);

	// hide the mouse
	CancelEdit(playerid);

	// let the player edit the vehicle
	Editor_EditVehicle(playerid, vehicleid);	
	//ToggleFlyControls(playerid, false);
	return 1;
}

public OnPlayerSelectEditorPickup(playerid, index, pickupid)
{
	new string[50];
	format(string, sizeof(string), "pickup ID: %d, index: %d", pickupid, index);
	SendClientMessage(playerid, COLOR_WHITE, string);

	// hide the mouse
	CancelEdit(playerid);

	// let the player edit the vehicle
	Editor_EditPickup(playerid, index);	
	//ToggleFlyControls(playerid, false);
	return 1;
}

public OnPlayerSelectEditorActor(playerid, actorid)
{
	new string[50];
	format(string, sizeof(string), "actor ID: %d", actorid);
	SendClientMessage(playerid, COLOR_WHITE, string);

	// hide the mouse
	CancelEdit(playerid);

	// let the player edit the vehicle
	Editor_EditActor(playerid, actorid);	
	return 1;
}

// Temporary command until a button is added
COMMAND:tele(playerid)
{
	ShowLocationsSelectDialog(playerid);
	return 1;
}

Dialog:createobject(playerid, response, listitem, inputtext[])
{
	// TODO: add numeric check
	// TODO: add object validity check
	if (!response) {
		SelectTextDraw(playerid, SELECT_TEXTDRAW_COLOR);
		return 1;
	}

	if (isnull(inputtext)) {
		SendClientMessage(playerid, COLOR_WHITE, "No object has been created - no model was given.");
		return 1;
	}

	new modelid = strval(inputtext);
	new Float:pos_x, Float:pos_y, Float:pos_z;

	GetXYZInfrontOfPlayer(playerid, pos_x, pos_y, pos_z, 20.0);

	Editor_CreateObject(modelid, pos_x, pos_y, pos_z, 0.0, 0.0, 0.0);
	return 1;
}

Dialog:createvehicle(playerid, response, listitem, inputtext[])
{
	if (!response) {
		SelectTextDraw(playerid, SELECT_TEXTDRAW_COLOR);
		return 1;
	}

	if (isnull(inputtext)) {
		SendClientMessage(playerid, COLOR_WHITE, "No vehicle has been created - no model was given.");
		return 1;
	}

	new modelid = strval(inputtext);

	if (modelid < 400 || modelid > 611) {
		SendClientMessage(playerid, COLOR_WHITE, "Invalid vehicle model.");
		return 1;
	}

	new Float:pos_x, Float:pos_y, Float:pos_z;

	GetXYZInfrontOfPlayer(playerid, pos_x, pos_y, pos_z, 10.0);

	Editor_CreateVehicle(modelid, pos_x, pos_y, pos_z, 0.0);
	return 1;
}

Dialog:createpickup(playerid, response, listitem, inputtext[])
{
	if (!response) {
		SelectTextDraw(playerid, SELECT_TEXTDRAW_COLOR);
		return 1;
	}

	if (isnull(inputtext)) {
		SendClientMessage(playerid, COLOR_WHITE, "No pickup has been created - no model was given.");
		return 1;
	}

	new modelid = strval(inputtext);
	new Float:pos_x, Float:pos_y, Float:pos_z;

	GetXYZInfrontOfPlayer(playerid, pos_x, pos_y, pos_z, 5.0);

	Editor_CreatePickup(modelid, pos_x, pos_y, pos_z);
	return 1;
}

Dialog:createactor(playerid, response, listitem, inputtext[])
{
	if (!response) {
		SelectTextDraw(playerid, SELECT_TEXTDRAW_COLOR);
		return 1;
	}

	if (isnull(inputtext)) {
		SendClientMessage(playerid, COLOR_WHITE, "No actor has been created - no skin was given.");
		return 1;
	}

	new skinid = strval(inputtext);

	if (skinid < 0 || skinid > 311) {
		SendClientMessage(playerid, COLOR_WHITE, "Invalid skin.");
		return 1;
	}

	new Float:pos_x, Float:pos_y, Float:pos_z;

	GetXYZInfrontOfPlayer(playerid, pos_x, pos_y, pos_z, 5.0);

	Editor_CreateActor(skinid, pos_x, pos_y, pos_z, 0.0);

	SendClientMessage(playerid, COLOR_WHITE, "Actor created.");
	return 1;
}

Dialog:manageproject(playerid, response, listitem)
{
	if (!response) {
		return 1;
	}

	switch (listitem) {
		// new project
		case 0: {
			DialogShow(playerid, "newproject", DIALOG_STYLE_INPUT, "New project", "Please enter a name for this project.", DIALOG_BUTTON_CREATE, DIALOG_BUTTON_CANCEL);
		}
		// open project
		case 1: {
			DialogShow(playerid, "openproject", DIALOG_STYLE_INPUT, "Open project", "Please enter the name of the project to open.", DIALOG_BUTTON_OPEN, DIALOG_BUTTON_CANCEL);
		}
		// close project
		case 2: {
			if (IsProjectActive()) {
				// save objects
				SetProjectActive(false);
				SendClientMessage(playerid, COLOR_WHITE, "Project closed.");
			}
			else {
				SendClientMessage(playerid, COLOR_WHITE, "No project active.");
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
	if (!response) {
		return 1;
	}

	if (!IsValidProjectName(inputtext)) {
		SendClientMessage(playerid, COLOR_WHITE, "Invalid project name. Only characters 0-9, a-z and A-Z are allowed.");
		return 1;
	}

	new project_created = CreateProjectFile(inputtext);

	if (!project_created) {
		SendClientMessage(playerid, COLOR_WHITE, "Unable to create project. A project with that name may already exist.");
		return 1;	
	}

	SetProjectActive(true);
	SetProjectName(inputtext);

	SendClientMessage(playerid, COLOR_WHITE, "Project created.");
	return 1;
}