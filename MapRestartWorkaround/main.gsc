#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zm_alcatraz_grief_cellblock;
#include maps\mp\zm_prison;
#include maps\mp\zm_highrise;
#include maps\mp\zm_transit;
#include maps\mp\zm_buried;
#include maps\mp\zm_tomb;

init()
{
    thread gscRestart();
    thread killAllPlayers();
    for(;;)
    {
        level waittill("connected", player);
        if ( level.scr_zm_ui_gametype_group == "zencounter" || level.scr_zm_ui_gametype_group == "zsurvival" )
        {
       		player thread give_team_characters(); //the real cause of the invisible player glitch these 2 functions aren't always called on map_restart so call them here
       	}
       	else 
      	{
      	 	player thread give_personality_characters();
      	 }	
    }
}


gscRestart()
{
	level waittill( "end_game" );
      	wait 20; //20 is ideal
        map_restart( false );
}

killAllPlayers()
{
	level.no_end_game_check = 1; //disable end game check just in case player[0] leaves before all players are respawned
	level.zombie_vars["penalty_no_revive"] = 0;
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
	wait 5; 
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
	level.zombie_vars["penalty_no_revive"] = 0.1;
	players = get_players();
	i = 0;
	while ( i < players.size )
	{
		if ( players[ i ].sessionstate == "spectator" && isDefined( players[ i ].spectator_respawn ) )
		{
			players[ i ] [[ level.spawnplayer ]]();
			thread maps\mp\zombies\_zm::refresh_player_navcard_hud();
			players[ i ].score = 500;
			players[ i ].downs = 0; //set player downs to 0 since they didn't actually die during gameplay
		}
		i++;
	}
	level.no_end_game_check = 0;
}
