#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
    thread gscRestart();
    thread setPlayersToSpectator();
    for(;;)
    {
        level waittill("connected", player);
		player thread [[level.givecustomcharacters]]();
		//The real cause of the invisible player glitch is that this function isn't always called on map_restart so call it here.
		//This will just call the method the map uses for give_personality_characters or give_team_characters without all the includes and it workes on NukeTown as well.
		//We don't need to check the game mode since each game mode's init function does set level.givecustomcharacters with an pointer to the correct method.
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
			if ( level.script != "zm_tomb" || level.script != "zm_prison" || !is_classic() )
			{
				thread maps\mp\zombies\_zm::refresh_player_navcard_hud();
			}
		}
		i++;
	}
	level.no_end_game_check = 0;
}
