#include maps\mp\_utility;
#include common_scripts\utility;
//these map specific includes are all required for give_team_characters(), and give_personality_characters to work
#include maps\mp\zm_alcatraz_grief_cellblock;
#include maps\mp\zm_prison;
#include maps\mp\zm_highrise;
#include maps\mp\zm_transit;
#include maps\mp\zm_buried;
#include maps\mp\zm_tomb;

init()
{
    thread gscRestart();
    thread setPlayersToSpectator();
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
		players[ i ] setToSpectator();
		i++;
	}
	wait 5; 
	spawnAllPlayers();
}

setToSpectator()
{
    self.sessionstate = "spectator"; 
    if (isDefined(self.is_playing))
    {
        self.is_playing = false;
    }
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
			thread maps\mp\zombies\_zm::refresh_player_navcard_hud();
		}
		i++;
	}
	level.no_end_game_check = 0;
}
