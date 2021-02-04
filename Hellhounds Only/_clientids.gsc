#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_spawner;
#include maps/mp/zombies/_zm_ai_dogs;
#include maps/mp/_utility;
#include common_scripts/utility;

init()
{
	thread dog_health_increaser();
	level.round_spawn_func = ::hellhound_spawning;
	thread zombiesLeft_hud();
	level.dog_health = 100;
}

hellhound_spawning() //checked changed to match cerberus output
{
	level endon( "intermission" );
	level endon( "end_of_round" );
	level endon( "restart_round" );
	if ( level.intermission )
	{
		return;
	}
	if ( level.zombie_spawn_locations.size < 1 )
	{
		return;
	}
	count = 0;
	players = get_players();
	for ( i = 0; i < players.size; i++ )
	{
		players[ i ].zombification_time = 0;
	}
	max = level.zombie_vars[ "zombie_max_ai" ];
	multiplier = level.round_number / 5;
	if ( multiplier < 1 )
	{
		multiplier = 1;
	}
	if ( level.round_number >= 10 )
	{
		multiplier *= level.round_number * 0.15;
	}
	player_num = get_players().size;
	if ( player_num == 1 )
	{
		max += int( 0.5 * level.zombie_vars[ "zombie_ai_per_player" ] * multiplier );
	}
	else
	{
		max += int( ( player_num - 1 ) * level.zombie_vars[ "zombie_ai_per_player" ] * multiplier );
	}
	if ( !isDefined( level.max_zombie_func ) )
	{
		level.max_zombie_func = ::default_max_zombie_func;
	}
	level.zombie_total = [[ level.max_zombie_func ]]( max );
	if ( isDefined( level.zombie_total_set_func ) )
	{
		level thread [[ level.zombie_total_set_func ]]();
	}
	if ( level.round_number < 10 || level.speed_change_max > 0 )
	{
		level thread zombie_speed_up();
	}
	mixed_spawns = 0;
	old_spawn = undefined;
	while ( 1 )
	{
		while ( get_current_zombie_count() >= level.zombie_ai_limit || level.zombie_total <= 0 )
		{
			wait 0.1;
		}
		while ( get_current_actor_count() >= level.zombie_actor_limit )
		{
			clear_all_corpses();
			wait 0.1;
		}
		flag_wait( "spawn_zombies" );
		while ( level.zombie_spawn_locations.size <= 0 )
		{
			wait 0.1;
		}
		maps\mp\zombies\_zm_ai_dogs::special_dog_spawn( undefined, 1 );
		level.zombie_total--;
		wait level.zombie_vars[ "zombie_spawn_delay" ];
		wait_network_frame();
	}
}

default_max_zombie_func( max_num )
{
	max = max_num;
	if ( level.round_number < 2 )
	{
		max = int( max_num * 0.25 );
	}
	else if ( level.round_number < 3 )
	{
		max = int( max_num * 0.3 );
	}
	else if ( level.round_number < 4 )
	{
		max = int( max_num * 0.5 );
	}
	else if ( level.round_number < 5 )
	{
		max = int( max_num * 0.7 );
	}
	else
	{
		if ( level.round_number < 6 )
		{
			max = int( max_num * 0.9 );
		}
	}
	level.zombie_total = max;
	return max;
}

dog_health_increaser()
{
	level endon( "intermission" );
	while ( 1 )
	{
		level waittill( "start_of_round" );
		for ( i = 0; i < level.round_number; i++ )
		{
			if ( level.dog_health > 1600 )
			{
				break;
			}
			level.dog_health = level.dog_health + 100;
		}
	}
}

zombiesleft_hud()
{   
	level endon( "intermission" );
	Remaining = create_simple_hud();
  	Remaining.horzAlign = "center";
  	Remaining.vertAlign = "middle";
   	Remaining.alignX = "Left";
   	Remaining.alignY = "middle";
   	Remaining.y = -200;
   	Remaining.x = -245;
   	Remaining.foreground = 1;
   	Remaining.fontscale = 2.25;
   	Remaining.alpha = 1;
   	Remaining.color = ( 0.423, 0.004, 0 );

   	ZombiesLeft = create_simple_hud();
   	ZombiesLeft.horzAlign = "center";
   	ZombiesLeft.vertAlign = "middle";
   	ZombiesLeft.alignX = "center";
   	ZombiesLeft.alignY = "middle";
   	ZombiesLeft.y = -200;
   	ZombiesLeft.x = -300;
   	ZombiesLeft.foreground = 1;
   	ZombiesLeft.fontscale = 2.25;
   	ZombiesLeft.alpha = 1;
   	ZombiesLeft.color = ( 0.423, 0.004, 0 );
   	ZombiesLeft SetText("Zombies Left: ");

	while(1)
	{
		remainingZombies = get_current_zombie_count() + level.zombie_total;
		Remaining SetValue( remainingZombies );
		if ( remainingZombies == 0 )
		{
			Remaining.alpha = 0;
			while( 1 )
			{
				remainingZombies = get_current_zombie_count() + level.zombie_total;
				if ( remainingZombies != 0 )
				{
					Remaining.alpha = 1;
					break;
				}
				wait 0.5;
			}
		}
		wait 0.5;
	}		
}





