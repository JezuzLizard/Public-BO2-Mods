#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_perks;


init()
{
	thread griefFunctionsAndVars();
	gameDelayFunctionsAndVars();
	thread setPlayersToSpectator();
	thread gscRestart();
	thread emptyLobbyRestart();
	thread gscMapChange();
}

gameDelayFunctionsAndVars()
{
	//game delay functions options
	level.wait_time = getDvarIntDefault( "waitTime", 30 ); //change this to adjust the start time once the player quota is met
	level.player_quota_active = getDvarIntDefault( "playerQuotaActive", 1 ); //set this to 0 to disable player quotas recommended to be 1 for grief
	level.player_quota = getDvarIntDefault( "playerQuota", 2 ); //number of players required before the game starts
	level.waiting = 0; //don't change this 
	level.countdown_start = 0; //don't change this
	
	level.round_prestart_func =::round_prestart_func; //delays the rounds from starting
	SetDvar( "scr_zm_enable_bots", 1 ); //this is required for the mod to work
	thread flag_clearer();
	thread add_bots(); //this overrides the typical start time logic
}

griefFunctionsAndVars()
{
	if ( level.scr_zm_ui_gametype_group != "zencounter" )
	{
		return;
	}
   	level.default_solo_laststandpistol = "m1911_zm"; //prevents players from having the solo pistol when downed in grief
   	for(;;)
    {
    	level waittill("connected", player);
       	player teamBalancing();
		player [[ level.givecustomcharacters ]]();
    }
}

round_prestart_func()
{
	players = get_players();
	while ( players.size < level.player_quota && level.player_quota_active == 1 || players.size < 1)
	{
		wait 0.5;
		players = get_players();
	}	
	wait level.wait_time;
}

teamBalancing()
{
	teamplayersallies = countplayers( "allies");
	teamplayersaxis = countplayers( "axis");
	if (teamplayersallies > teamplayersaxis && !level.isresetting_grief)
	{
		self.team = "axis";
		self.sessionteam = "axis";
		self [[level.axis]]();
	 	self.pers["team"] = "axis";
		self._encounters_team = "A";
	}
	else if (teamplayersallies < teamplayersaxis && !level.isresetting_grief)
	{
		self.team = "allies";
		self.sessionteam = "allies";
		self [[level.allies]]();
		self.pers["team"] = "allies";
		self._encounters_team = "B";
	}
	else if (teamplayersallies == teamplayersaxis && !level.isresetting_grief)
	{
		self.team = "allies";
		self.sessionteam = "allies";
		self [[level.allies]]();
		self.pers["team"] = "allies";
		self._encounters_team = "B";
	}
}

flag_clearer()
{
	//hopefully keep the game from starting prematurely on map_restart
	while ( 1 )
	{
		flag_clear( "solo_game" );
		flag_clear( "start_zombie_round_logic" );
		wait 0.1;
		if ( !level.waiting )
		{
			break;
		}
	}
}

add_bots()
{
    players = get_players();
   	level.waiting = 1;
    thread waitMessage();
	while ( players.size < level.player_quota && level.player_quota_active || players.size < 1)
	{
		wait 0.5;
		players = get_players();
	}
	level.waiting = 0;
	level.countdown_start = 1;
	thread countdownTimer();
	wait level.wait_time;
    flag_set( "start_zombie_round_logic" );
}

waitMessage()
{   
	level endon("game_ended");
	self endon("disconnect");
	if( level.waiting == 0 )
	{
		return;
	}

   	Waiting = create_simple_hud();
   	Waiting.horzAlign = "center"; //valid inputs: center, top, bottom, left, right, top_right, top_left, topcenter, bottom_right, bottom_left
   	Waiting.vertAlign = "middle";
   	Waiting.alignX = "center";
   	Waiting.alignY = "middle";
   	Waiting.y = 0; //- is top 0 is middle + is bottom
   	Waiting.x = -1;
   	Waiting.foreground = 1;
   	Waiting.fontscale = 3.0;
   	Waiting.alpha = 1; //transparency
   	Waiting.color = ( 1.000, 1.000, 1.000 ); //RGB
   	Waiting SetText( "Waiting for 1 more player" );
   	
   	while ( 1 )
   	{
		if ( level.waiting == 0 )
		{
			Waiting destroy();
			break;
		}
		wait 1;
	}
}

countdownTimer()
{   
	level endon("game_ended");
	self endon("disconnect");
	if ( level.countdown_start == 0 )
	{
		return;
	}
	
	Remaining = create_simple_hud();
  	Remaining.horzAlign = "center";
  	Remaining.vertAlign = "middle";
   	Remaining.alignX = "center";
   	Remaining.alignY = "middle";
   	Remaining.y = 20;
   	Remaining.x = 0;
   	Remaining.foreground = 1;
   	Remaining.fontscale = 2.0;
   	Remaining.alpha = 1;
   	Remaining.color = ( 0.98, 0.549, 0 );

   	Countdown = create_simple_hud();
   	Countdown.horzAlign = "center"; 
   	Countdown.vertAlign = "middle";
   	Countdown.alignX = "center";
   	Countdown.alignY = "middle";
   	Countdown.y = -20;
   	Countdown.x = 0;
   	Countdown.foreground = 1;
   	Countdown.fontscale = 2.0;
   	Countdown.alpha = 1;
   	Countdown.color = ( 1.000, 1.000, 1.000 );
   	Countdown SetText( "Match begins in" );
   	
   	timer = level.wait_time;
	while ( level.countdown_start == 1 )
	{
		Remaining SetValue( timer ); 
		wait 1;
		timer--;
		if ( timer <= 0 )
		{
			Countdown destroy();
			Remaining destroy();
			break;
		}
	}
}

gscRestart()
{
	if ( level.map_rotate && level.script == "zm_transit" )
	{
		return;
	}
	level waittill( "end_game" );
	wait 12;
	map_restart( false );
}

//grief games don't end if no players remain in the server so this will force a restart to reset the map
emptyLobbyRestart()
{
	while ( 1 )
	{
		players = get_players();
		if (players.size > 0 )
		{
			while ( 1 )
			{
				players = get_players();
				if ( players.size < 1  )
				{
					map_restart( false );
				}
				wait 1;
			}
		}
		wait 1;
	}
}

gscMapChange()
{
	if ( !level.map_rotate || level.script != "zm_transit" )
	{
		return;
	}
	level waittill( "end_game" );
	wait 20;
	mapChange( location() );
	map_restart( false );
}

location()
{	
	//move the order of the if statements to change the order of the rotation
	if ( getDvarIntDefault( "farm", 1 ) )
	{
		setDvar( "farm", 0 );
		return "farm";
	}
	if ( getDvarIntDefault( "town", 1 ) )
	{
		setDvar( "town", 0 );
		return "town";
	}
	if ( getDvarIntDefault( "transit", 1 ) )
	{
		setDvar( "transit", 0 );
		return "transit";
	}
	setDvar( "farm", 1 );
	setDvar( "transit", 1 );
	setDvar( "town", 1 );
}

mapChange( startlocation )
{
	setDvar( "ui_zm_mapstartlocation", startlocation );
	makedvarserverinfo( "ui_zm_mapstartlocation", startlocation );
}

setPlayersToSpectator()
{
	level.no_end_game_check = 1;
	wait 3;
	players = get_players();
	i = 0;
	while ( i < players.size )
	{
		if ( i == 0 )
		{
			i++;
		}
		players[ i ] kill();
		i++;
	}
	wait 10; 
	spawnAllPlayers();
}

kill()
{
	self.maxhealth = 100;
	self.health = self.maxhealth;
	self disableInvulnerability();
	self dodamage( self.health * 2, self.origin );
	self.bleedout_time = 0;
}

spawnAllPlayers()
{
	players = get_players();
	i = 0;
	while ( i < players.size )
	{
		if ( players[ i ].sessionstate == "spectator" && isDefined( players[ i ].spectator_respawn ) )
		{
			players[ i ] [[ level.spawnplayer ]]();
			thread refresh_player_navcard_hud();
		}
		i++;
	}
}
