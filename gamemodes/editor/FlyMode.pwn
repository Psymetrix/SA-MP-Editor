/*---------------------------------------------------------
	FlyMode by Psymetrix, 2015.

	Originally written by h02 as flymode.pwn from the
	SA-MP server package.
---------------------------------------------------------*/

// Players Move Speed
#define MOVE_SPEED              100.0
#define ACCEL_RATE              0.03

// Key state definitions
#define MOVE_FORWARD    		1
#define MOVE_BACK       		2
#define MOVE_LEFT       		3
#define MOVE_RIGHT      		4
#define MOVE_FORWARD_LEFT       5
#define MOVE_FORWARD_RIGHT      6
#define MOVE_BACK_LEFT          7
#define MOVE_BACK_RIGHT         8

enum E_FLY_INFO
{
	bool:  eIsFlying,
		   eFlyObject,
		   eMoveDirection,
		   eUdOld,
		   eLrOld,
	Float: eAccelMul,
		   eLastMoveTick
};

static gFlyInfo[MAX_PLAYERS][E_FLY_INFO];

IsPlayerInFlyMode(playerid)
{
	return gFlyInfo[playerid][eIsFlying];
}

ToggleFlyMode(playerid, bool:toggle)
{
	if (toggle)
	{
		if (!IsPlayerInFlyMode(playerid))
		{
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			gFlyInfo[playerid][eFlyObject] = CreatePlayerObject(playerid, 19300, X, Y, Z, 0.0, 0.0, 0.0);

			TogglePlayerSpectating(playerid, true);
			AttachCameraToPlayerObject(playerid, gFlyInfo[playerid][eFlyObject]);

			gFlyInfo[playerid][eIsFlying] = true;
		}
	}
	else
	{
		if (IsPlayerInFlyMode(playerid))
		{
			TogglePlayerSpectating(playerid, false);
			DestroyPlayerObject(playerid, gFlyInfo[playerid][eFlyObject]);

			gFlyInfo[playerid][eIsFlying] = false;
		}
	}
	return 1;
}

GetMoveDirectionFromKeys(ud, lr)
{
	new direction = 0;
	
    if(lr < 0)
	{
		if(ud < 0) 		direction = MOVE_FORWARD_LEFT; 	// Up & Left key pressed
		else if(ud > 0) direction = MOVE_BACK_LEFT; 	// Back & Left key pressed
		else            direction = MOVE_LEFT;          // Left key pressed
	}
	else if(lr > 0) 	// Right pressed
	{
		if(ud < 0)      direction = MOVE_FORWARD_RIGHT;  // Up & Right key pressed
		else if(ud > 0) direction = MOVE_BACK_RIGHT;     // Back & Right key pressed
		else			direction = MOVE_RIGHT;          // Right key pressed
	}
	else if(ud < 0) 	direction = MOVE_FORWARD; 	// Up key pressed
	else if(ud > 0) 	direction = MOVE_BACK;		// Down key pressed
	
	return direction;
}

MoveCamera(playerid)
{
	new Float:FV[3], Float:CP[3];
	GetPlayerCameraPos(playerid, CP[0], CP[1], CP[2]);          // 	Cameras position in space
    GetPlayerCameraFrontVector(playerid, FV[0], FV[1], FV[2]);  //  Where the camera is looking at

	// Increases the acceleration multiplier the longer the key is held
	if(gFlyInfo[playerid][eAccelMul] <= 1) gFlyInfo[playerid][eAccelMul] += ACCEL_RATE;

	// Determine the speed to move the camera based on the acceleration multiplier
	new Float:speed = MOVE_SPEED * gFlyInfo[playerid][eAccelMul];

	// Calculate the cameras next position based on their current position and the direction their camera is facing
	new Float:X, Float:Y, Float:Z;
	GetNextCameraPosition(gFlyInfo[playerid][eMoveDirection], CP, FV, X, Y, Z);
	MovePlayerObject(playerid, gFlyInfo[playerid][eFlyObject], X, Y, Z, speed);

	// Store the last time the camera was moved as now
	gFlyInfo[playerid][eLastMoveTick] = GetTickCount();
	return 1;
}

stock GetNextCameraPosition(move_mode, Float:CP[3], Float:FV[3], &Float:X, &Float:Y, &Float:Z)
{
    // Calculate the cameras next position based on their current position and the direction their camera is facing
    #define OFFSET_X (FV[0]*6000.0)
	#define OFFSET_Y (FV[1]*6000.0)
	#define OFFSET_Z (FV[2]*6000.0)
	switch(move_mode)
	{
		case MOVE_FORWARD:
		{
			X = CP[0]+OFFSET_X;
			Y = CP[1]+OFFSET_Y;
			Z = CP[2]+OFFSET_Z;
		}
		case MOVE_BACK:
		{
			X = CP[0]-OFFSET_X;
			Y = CP[1]-OFFSET_Y;
			Z = CP[2]-OFFSET_Z;
		}
		case MOVE_LEFT:
		{
			X = CP[0]-OFFSET_Y;
			Y = CP[1]+OFFSET_X;
			Z = CP[2];
		}
		case MOVE_RIGHT:
		{
			X = CP[0]+OFFSET_Y;
			Y = CP[1]-OFFSET_X;
			Z = CP[2];
		}
		case MOVE_BACK_LEFT:
		{
			X = CP[0]+(-OFFSET_X - OFFSET_Y);
 			Y = CP[1]+(-OFFSET_Y + OFFSET_X);
		 	Z = CP[2]-OFFSET_Z;
		}
		case MOVE_BACK_RIGHT:
		{
			X = CP[0]+(-OFFSET_X + OFFSET_Y);
 			Y = CP[1]+(-OFFSET_Y - OFFSET_X);
		 	Z = CP[2]-OFFSET_Z;
		}
		case MOVE_FORWARD_LEFT:
		{
			X = CP[0]+(OFFSET_X  - OFFSET_Y);
			Y = CP[1]+(OFFSET_Y  + OFFSET_X);
			Z = CP[2]+OFFSET_Z;
		}
		case MOVE_FORWARD_RIGHT:
		{
			X = CP[0]+(OFFSET_X  + OFFSET_Y);
			Y = CP[1]+(OFFSET_Y  - OFFSET_X);
			Z = CP[2]+OFFSET_Z;
		}
	}
}

public OnPlayerUpdate(playerid)
{
	if (IsPlayerInFlyMode(playerid))
	{
		new keys,ud,lr;
		GetPlayerKeys(playerid,keys,ud,lr);

		if(gFlyInfo[playerid][eMoveDirection] && (GetTickCount() - gFlyInfo[playerid][eLastMoveTick] > 100))
		{
		    // If the last move was > 100ms ago, process moving the object the players camera is attached to
		    MoveCamera(playerid);
		}

		// Is the players current key state different than their last keystate?
		if(gFlyInfo[playerid][eUdOld] != ud || gFlyInfo[playerid][eLrOld] != lr)
		{
			if((gFlyInfo[playerid][eUdOld] != 0 || gFlyInfo[playerid][eLrOld] != 0) && ud == 0 && lr == 0)
			{   // All keys have been released, stop the object the camera is attached to and reset the acceleration multiplier
				StopPlayerObject(playerid, gFlyInfo[playerid][eFlyObject]);
				gFlyInfo[playerid][eMoveDirection]      = 0;
				gFlyInfo[playerid][eAccelMul]  = 0.0;
			}
			else
			{   // Indicates a new key has been pressed

			    // Get the direction the player wants to move as indicated by the keys
				gFlyInfo[playerid][eMoveDirection] = GetMoveDirectionFromKeys(ud, lr);

				// Process moving the object the players camera is attached to
				MoveCamera(playerid);
			}
		}
		// Store current keys pressed for comparison next update
		gFlyInfo[playerid][eUdOld] = ud;
		gFlyInfo[playerid][eLrOld] = lr;
		return 0;						
	}

	#if defined FM_OnPlayerUpdate
        FM_OnPlayerUpdate(playerid);
    #endif	
	return 1;
}


#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate FM_OnPlayerUpdate
#if defined FM_OnPlayerUpdate
    forward FM_OnPlayerUpdate(playerid);
#endif