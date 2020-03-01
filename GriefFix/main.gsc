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
	randomGameSettings();
	level.custom_spectate_permissions = ::setspectatepermissionsgrief;
	level.wait_time = 45; //change this to adjust the start time once the player quota is met
	//this also gives players time to rejoin a game after its ended
	level.player_invulernability_active = 1;
	level.player_quota_active = 1; //set this to 0 to disable player quotas recommended to be 1 for grief
	level.player_quota = 2; //number of players required before the game starts
	level.waiting = 0;
	level.countdown_start = 0;
	level.round_prestart_func =::round_prestart_func; //delays the rounds from starting
	SetDvar( "scr_zm_enable_bots", "1" ); //this is required for the mod to work
	thread add_bots(); //this overrides the typical start time logic
   	level.default_solo_laststandpistol = "m1911_zm"; //prevents players from having the solo pistol when downed in grief
   	thread deleteBuyableDoors();
   	for(;;)
    {
        level waittill("connected", player);
        player thread teamBalancing();
        player thread pregameInvulnerability();
    }
}

randomGameSettings()
{
	level.disable_revive = 0;
	level.disable_jugg = 0;
	level.electric_doors_enabled = 0;
	level.first_room_doors_enabled = 1;
	if ( randomint( 100 ) > 80 )//20% chance of first room only
	{
		level.first_room_doors_enabled = 0; //turn on to close the first room doors
	}
	if ( randomint( 100 ) > 50 )//50% chance of no jugg
	{
		level.disable_jugg = 1;
	}
	if ( randomint( 100 ) > 50 )//50% chance of no revive
	{
		level.disable_revive = 1;
	}
	if ( randomint( 100 ) > 75 )//25% chance of hyper speed
	{
		level.zombie_vars[ "zombie_spawn_delay" ] = 0.08;
		level.zombie_vars["zombie_between_round_time"] = 1;
		level.zombie_move_speed = 105;
		level.speed_change_round = undefined;
		thread walkersDisabledAndAllRunners();
	}
	if ( randomint( 100 ) > 90 )//10% chance of quad drop amount
	{
		level.zombie_vars["zombie_powerup_drop_max_per_round"] = 16;
	}
	if ( randomint( 100 ) > 50 )//50% chance of more zombies
	{
		level.zombie_ai_limit = 32;
		level.zombie_actor_limit = 40;
	} 
	if ( randomint( 100 ) > 80 )//20% chance of shorter rounds
	{
		level.zombie_vars["zombie_ai_per_player"] = 3;
	} 
	if ( randomint( 100 ) > 60 )//40% chance of immovable box
	{
		SetDvar( "magic_chest_movable", "0" );
	} 
	if ( randomint( 100 ) > 90 )//10% chance of deflation
	{
		level.zombie_vars["zombie_score_damage_normal"] = 0;
		level.zombie_vars["zombie_score_damage_light"] = 0;
		level.zombie_vars["zombie_score_bonus_melee"] = 0;
		level.zombie_vars["zombie_score_bonus_head"] = 0;
		level.zombie_vars["zombie_score_bonus_neck"] = 0;
		level.zombie_vars["zombie_score_bonus_torso"] = 0;
		level.zombie_vars["zombie_score_bonus_burn"] = 0;
		level.zombie_vars["penalty_died"] = 0;
		level.zombie_vars["penalty_downed"] = 0;
	} 
	if ( randomint( 100 ) > 50 )//50% chance of more deadly emps
	{
		level.zombie_vars["emp_perk_off_time"] = 240;
	} 
	if ( randomint( 100 ) > 85 && level.script == "zm_prison" )//15% chance of the warden army
	{
		level.brutus_max_count = 20;
		level.brutus_wait_time = 20;
		thread brutusArmy();
	} 
	if ( level.disable_jugg && level.script == "zm_transit" || level.disable_jugg && level.script == "zm_buried" )
	{
		level thread perk_machine_removal( "specialty_armorvest" );
	}
	if ( level.disable_revive && level.script == "zm_transit" || level.disable_revive && level.script == "zm_buried" )
	{
		level thread perk_machine_removal( "specialty_quickrevive" );
	}
}

walkersDisabledAndAllRunners()
{
	while ( 1 )
	{
		level waittill( "start_of_round" );
		level.zombie_move_speed = 105;
		level.speed_change_round = undefined;
		wait 1;
	}
}

brutusArmy()
{
	level waittill( "start_of_round" );
	i = 0;
	while ( i < level.brutus_max_count )
	{
		wait level.brutus_wait_time;
    	level notify( "spawn_brutus", 1 );
    	i++;
	}
	brutusArmy();
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
	flag_clear( "solo_game" );
	flag_clear( "start_zombie_round_logic" );
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

deleteBuyableDoors()
{
    doors_trigs = getentarray( "zombie_door", "targetname" );
    _a41 = doors_trigs;
    _k41 = getFirstArrayKey( _a41 );
    while ( isDefined( _k41 ) )
    {
        door = _a41[ _k41 ];
        //deletes the depot main door trigger
        if (IsDefined(door.target) && door.target == "busstop_doors" && !level.first_room_doors_enabled)
        {
        	door self_delete();
        }
        //deletes the first electric door in depot
        else if (IsDefined(door.target) && door.target == "pf1766_auto2352" && !level.electric_doors_enabled)
        {
        	door self_delete();
        }
        //deletes the second electric door in depot
        else if (IsDefined(door.target) && door.target == "pf1766_auto2353" && !level.electric_doors_enabled)
        {
        	door self_delete();
        }
        //farm electric door
        else if (IsDefined(door.target) && door.target == "pf1766_auto2358" && !level.electric_doors_enabled)
        {
        	door self_delete();
        }
        //farm house door
        else if (IsDefined(door.target) && door.target == "auto2434" && !level.electric_doors_enabled)
        {
        	door self_delete();
        }
        //cellblock starting room door
        else if (IsDefined(door.target) && door.target == "cellblock_start_door" && !level.first_room_doors_enabled)
        {
        	door self_delete();
        }
        //cafeteria door
        else if (IsDefined(door.target) && door.target == "pf3642_auto2546" && !level.first_room_doors_enabled)
        {
        	door self_delete();
        }
        //wardens office door
        else if (IsDefined(door.target) && door.target == "pf3663_auto2547" && !level.first_room_doors_enabled)
        {
        	door self_delete();
        }
        //packapunch door
        else if (IsDefined(door.target) && door.target == "pf3674_auto2555" && !level.first_room_doors_enabled)
        {
        	door self_delete();
        }
        //bar door
        else if (IsDefined(door.target) && door.target == "pf30_auto2282" && !level.first_room_doors_enabled)
        {
        	door self_delete();
        }
        //bank door
        else if (IsDefined(door.target) && door.target == "pf30_auto2174" && !level.first_room_doors_enabled)
        {
        	door self_delete();
        }
        //jugg door
        else if (IsDefined(door.target) && door.target == "pf30_auto_2433" && !level.first_room_doors_enabled)
        {
        	door self_delete();
        }
        _k41 = getNextArrayKey( _a41, _k41 );
    }
}






















