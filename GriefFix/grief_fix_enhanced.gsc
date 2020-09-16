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
	gameDelayFunctionsAndVars()
	gameSettings();
	randomizedSettings();
	thread setPlayersToSpectator();
	thread gscRestart();
	thread emptyLobbyRestart();
	thread gscMapChange();
}

gameSettings()
{	
	//random game settings options set these to 0 to disable them happening
	level.random_game_settings = getDvarIntDefault( "randomGameSettings", 1 ); //disable this to disable all random settings effects
	
	level.hyper_speed_spawns_chance_active = getDvarIntDefault( "hyperSpeedSpawnsChanceActive", 1 ); //this enables a chance that zombies will have max move speed, max spawnrate, no walkers, and 1 second between rounds
	level.extra_drops_chance_active = getDvarIntDefault( "extraDropsChanceActive", 1 ); //this enables a chance that drops will drop upto 4x as much per round
	level.max_zombies_chance_active = getDvarIntDefault( "maxHordeSizeIncreaseChanceActive", 1 ); //this enables a chance to increase max ai at once to 32
	level.reduced_zombies_per_round_chance_active = getDvarIntDefault( "shorterRoundsChanceActive", 1 ); //enable this for a chance to get to higher rounds quicker
	level.deflation_chance_active = getDvarIntDefault( "deflationChanceActive", 1 ); //this enables a chance that the zombies only give points when killed
	level.deadlier_emps_chance_active = getDvarIntDefault( "deadlierEMPsChanceActive", 1 ); //this enables a chance to make emp duration 4x as long
	level.disable_revive_chance_active = getDvarIntDefault( "disableReviveChanceActive", 1 ); //this enables a chance to disable revive from appearing in games
	level.disable_jugg_chance_active = getDvarIntDefault( "disableJuggChanceActive", 1 ); //this enables a chance to disable jugg from appearing in games
	level.electric_doors_enabled_chance_active = getDvarIntDefault( "electricDoorsDisabledChanceActive", 1 ); //this enables a chance that the electric doors on transit maps will be disabled
	level.first_room_doors_enabled_chance_active = getDvarIntDefault( "firstRoomOnlyChanceActive", 1 ); //this enables a chance that the first room doors on all grief maps will be disabled
	level.disable_box_moving_chance_active = getDvarIntDefault( "disableBoxMoveChanceActive", 1 ); //this enables a chance that the box won't move after too many uses
	
	//chances of something happening setting to 100 makes it always on
	level.hyper_speed_spawns_chance = getDvarIntDefault( "hyperSpeedSpawnsChance", 50 ); //50% default
	level.extra_drops_chance = getDvarIntDefault( "extraDropsChance", 15 ); //15% default
	level.max_zombies_chance = getDvarIntDefault( "maxHordeSizeIncreaseChanceActive", 50 ); //50% default
	level.reduced_zombies_per_round_chance = getDvarIntDefault( "shorterRoundsChanceActive", 20 ); //20% default
	level.deflation_chance = getDvarIntDefault( "deflationChance", 20 ); //20% default
	level.deadlier_emps_chance = getDvarIntDefault( "deadlierEMPsChance", 40 ); //40% default
	level.disable_revive_chance = getDvarIntDefault( "disableReviveChance", 50 ); //50% default
	level.disable_jugg_chance = getDvarIntDefault( "disableJuggChance", 30 ); //30% default
	level.first_room_doors_enabled_chance = getDvarIntDefault( "electricDoorsDisabledChance", 20 ); //20% default
	level.electric_doors_enabled_chance = getDvarIntDefault( "firstRoomOnlyChance", 40 ); //40% default
	level.disable_box_moving_chance = getDvarIntDefault( "disableBoxMoveChance", 10 ); //10% default
	
	//map rotate feature overrides the normal restart if active
	level.map_rotate = getDvarIntDefault( "townFarmBusdepotRotation", 1 );
	return level.random_game_settings;
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

deleteBuyableDoors()
{
    doors_trigs = getentarray( "zombie_door", "targetname" );
	foreach ( door in doors_trigs )
        door self_delete();
    }
}

deleteBuyableDebris()
{
    debris_trigs = getentarray( "zombie_debris", "targetname" );
	foreach ( debris in debris_trigs )
	{
        //deletes the depot main door trigger
        debris self_delete();
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

randomizedSettings()
{
	//level.random_game_settings = 0;
	if ( !gameSettings() )
	{
		return 0;
	}
	
	if ( ( randomint( 100 ) <= level.first_room_doors_enabled_chance ) && level.first_room_doors_enabled_chance_active )
	{
		deleteBuyableDebris();
		deleteBuyableDoors();
	}
	if ( ( randomint( 100 ) <= level.electric_doors_enabled_chance ) && level.electric_doors_enabled_chance_active )
	{
		level.electric_doors_enabled = 0; 
	}
	if ( ( randomint( 100 ) <= level.disable_jugg_chance ) && level.disable_jugg_chance_active )
	{
		disable_jugg = 1;
	}
	if ( ( randomint( 100 ) <= level.disable_revive_chance ) && level.disable_revive_chance_active )
	{
		disable_revive = 1;
	}
	if ( ( randomint( 100 ) <= level.hyper_speed_spawns_chance ) && level.hyper_speed_spawns_chance_active )
	{
		level.zombie_vars[ "zombie_spawn_delay" ] = 0.08;
		level.zombie_vars["zombie_between_round_time"] = 1;
		level.zombie_move_speed = 105;
		level.speed_change_round = undefined;
		thread walkersDisabledAndAllRunners();
	}
	if ( ( randomint( 100 ) <= level.extra_drops_chance ) && level.extra_drops_chance_active )
	{
		level.zombie_vars["zombie_powerup_drop_max_per_round"] = 16;
	}
	if ( ( randomint( 100 ) <= level.max_zombies_chance ) && level.max_zombies_chance_active )
	{
		level.zombie_ai_limit = 32;
		level.zombie_actor_limit = 40;
	} 
	if ( ( randomint( 100 ) <= level.reduced_zombies_per_round_chance ) && level.reduced_zombies_per_round_chance_active)
	{
		level.zombie_vars["zombie_ai_per_player"] = 3;
	} 
	if ( ( randomint( 100 ) <= level.disable_box_moving_chance ) && level.disable_box_moving_chance_active)
	{
		SetDvar( "magic_chest_movable", 0 );
	} 
	if ( ( randomint( 100 ) <= level.deflation_chance ) && level.deflation_chance_active)
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
	if ( ( randomint( 100 ) <= level.deadlier_emps_chance ) && level.deadlier_emps_chance_active )
	{
		level.zombie_vars["emp_perk_off_time"] = 240;
	} 
	if ( disable_jugg && level.script == "zm_transit" || disable_jugg && level.script == "zm_buried" )
	{
		level thread perk_machine_removal( "specialty_armorvest" );
	}
	if ( disable_revive && level.script == "zm_transit" || disable_revive && level.script == "zm_buried" )
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
