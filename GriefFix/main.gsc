/*
*	 Black Ops 2 - GSC Studio by iMCSx
*
*	 Creator : JezuzLizard
*	 Project : grieffix2
*    Mode : Zombies
*	 Date : 2020/01/31 - 03:36:03	
*
*/	

#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/gametypes_zm/zgrief;
#include maps/mp/zombies/_zm_perks;

init()
{
	level.disable_perks = 0;
	if ( level.disable_perks == 1 && level.script == "zm_transit" || level.disable_perks == 1 && level.script == "zm_buried" )
	{
		level thread perk_machine_removal( "specialty_quickrevive" );
		level thread perk_machine_removal( "specialty_armorvest" );
	}
	thread turn_power_on_and_open_doors();
	level.custom_spectate_permissions = ::setspectatepermissionsgrief;
	level.wait_time = 30; //change this to adjust the start time once the player quota is met
	//this also gives players time to rejoin a game after its ended
	level.player_invulernability_active = 1;
	level.player_quota_active = 0; //set this to 0 to disable player quotas recommended to be 1 for grief
	level.player_quota = 2; //number of players required before the game starts
	level.waiting = 0;
	level.countdown_start = 0;
	level.round_prestart_func =::round_prestart_func; //delays the rounds from starting
	SetDvar( "scr_zm_enable_bots", "1" ); //this is required for the mod to work
	thread add_bots(); //this overrides the typical start time logic
   	level.default_solo_laststandpistol = "m1911_zm"; //prevents players from having the solo pistol when downed in grief
   	
   	level.zombie_ai_limit = 32;
	level.zombie_actor_limit = 40;
	level.zombie_vars["zombie_intermission_time"] = 5;
	level.zombie_vars["zombie_between_round_time"] = 10;
	level.zombie_vars["zombie_powerup_drop_max_per_round"] = 8;
	level.zombie_vars[ "zombie_spawn_delay" ] = 0.08;
   	
   	for(;;)
    {
        level waittill("connected", player);
        player thread teamBalancing();
        player thread pregameInvulnerability();
    }
}

pregameInvulnerability()
{
	while ( level.player_invulernability_active == 1 )
	{
		i = 0;
		while ( i < players.size )
		{	
			players = get_players();
			wait 0.05;
			player = players[ i ];
			player enableinvulnerability();
			i++;
		}
	}
	while ( level.player_invulernability_active == 0 )
	{
		i = 0;
		while ( i < players.size )
		{	
			players = get_players();
			wait 0.05;
			player = players[ i ];
			player disableinvulnerability();
			i++;
		}
		break;
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

add_bots()
{
	flag_clear( "start_zombie_round_logic" );
    players = get_players();
    level.waiting = 1;
    thread waitMessage();
	while ( players.size < level.player_quota && level.player_quota_active == 1 || players.size < 1)
	{
		wait 0.5;
		players = get_players();
	}
	level.waiting = 0;
	level.countdown_start = 1;
	thread countdownTimer();
	wait level.wait_time;
	level.player_invulernability_active = 0;
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
   	Remaining.alignX = "Left";
   	Remaining.alignY = "middle";
   	Remaining.y = 0;
   	Remaining.x = 135;
   	Remaining.foreground = 1;
   	Remaining.fontscale = 3.0;
   	Remaining.alpha = 1;
   	Remaining.color = ( 1.000, 1.000, 1.000 );

   	Countdown = create_simple_hud();
   	Countdown.horzAlign = "center"; 
   	Countdown.vertAlign = "middle";
   	Countdown.alignX = "center";
   	Countdown.alignY = "middle";
   	Countdown.y = 0;
   	Countdown.x = -1;
   	Countdown.foreground = 1;
   	Countdown.fontscale = 3.0;
   	Countdown.alpha = 1;
   	Countdown.color = ( 1.000, 1.000, 1.000 );
   	Countdown SetText( "Time until game starts:" );
   	
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

setspectatepermissionsgrief()
{
	self allowspectateteam( "allies", 1 );
	self allowspectateteam( "axis", 1 );
	self allowspectateteam( "freelook", 1 );
	self allowspectateteam( "none", 1 );
}

depot_close_local_electric_doors()
{
    if(!(level.scr_zm_ui_gametype == "zgrief" && level.scr_zm_map_start_location == "transit"))
    {
        return;
    }

    zombie_doors = getentarray( "zombie_door", "targetname" );
    _a144 = zombie_doors;
    _k144 = getFirstArrayKey( _a144 );
    while ( isDefined( _k144 ) )
    {
        door = _a144[ _k144 ];

        if ( isDefined( door.script_noteworthy ) && door.script_noteworthy == "local_electric_door" )
        {
            door maps/mp/zombies/_zm_blockers::door_block();
            door maps/mp/zombies/_zm_blockers::door_opened( 0, 1 );
        }
        _k144 = getNextArrayKey( _a144, _k144 );
    }
}

turn_power_on_and_open_doors()
{
	level.local_doors_stay_open = 0;
	level.power_local_doors_globally = 0;
	//flag_set( "power_on" );
	//level setclientfield( "zombie_power_on", 1 );
	zombie_doors = getentarray( "zombie_door", "targetname" );
	_a144 = zombie_doors;
	_k144 = getFirstArrayKey( _a144 );
	while ( isDefined( _k144 ) )
	{
		door = _a144[ _k144 ];
		if ( isDefined( door.script_noteworthy ) && door.script_noteworthy == "electric_door" )
		{
			//door notify( "power_on" );
		}
		else
		{
			if ( isDefined( door.script_noteworthy ) && door.script_noteworthy == "local_electric_door" )
			{
				//door notify( "local_power_on" );
			}
		}
		_k144 = getNextArrayKey( _a144, _k144 );
	}
}




















