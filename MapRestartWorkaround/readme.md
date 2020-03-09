#**Map Restart Workaround**

This is a mod that gets around the clientside errors that happen after a zombies game ends.
When a zombies game ends and the clients remain in the server after the intermission restart, clients may experience several different clientside only bugs.
Some examples of these errors include:
-No sound except music
-Barriers are glitched
-Mystery box is glitched
-A few more minor bugs
These are only clientside so have no effect on the server itself and can be fixed by simply leaving and rejoining.

However, I created a workaround that allows players to remain in the lobby after it ends and not experience any of these clientside issues.

#**The Workaround**

Basically, what I did was utilize map_restart in the GSC and I call it around 20 seconds after level.intermission is set to 1.
What happens is the game uses a map_restart instead of the normal method Plutonium servers use.
There is a reason this is a workaround though. That is because when map_restart occurs the game reparses all the scripts its supposed to load in the first place,
and as a result it reads a certain function in _zm.gsc.

onallplayersready()
{
	timeout = getTime() + 5000;
	while ( getnumexpectedplayers() == 0 && getTime() < timeout )
	{
		wait 0,1;
	}
/#
	println( "ZM >> player_count_expected=" + getnumexpectedplayers() );
#/
	player_count_actual = 0;
	while ( getnumconnectedplayers() < getnumexpectedplayers() || player_count_actual != getnumexpectedplayers() )
	{
		players = get_players();
		player_count_actual = 0;
		i = 0;
		while ( i < players.size )
		{
			players[ i ] freezecontrols( 1 );
			if ( players[ i ].sessionstate == "playing" )
			{
				player_count_actual++;
			}
			i++;
		}
/#
		println( "ZM >> Num Connected =" + getnumconnectedplayers() + " Expected : " + getnumexpectedplayers() );
#/
		wait 0,1;
	}
	setinitialplayersconnected();
/#
	println( "ZM >> We have all players - START ZOMBIE LOGIC" );
#/
	if ( getnumconnectedplayers() == 1 && getDvarInt( "scr_zm_enable_bots" ) == 1 )
	{
		level thread add_bots();
		flag_set( "initial_players_connected" );
	}
	else
	{
		players = get_players();
		if ( players.size == 1 )
		{
			flag_set( "solo_game" );
			level.solo_lives_given = 0;
			_a379 = players;
			_k379 = getFirstArrayKey( _a379 );
			while ( isDefined( _k379 ) )
			{
				player = _a379[ _k379 ];
				player.lives = 0;
				_k379 = getNextArrayKey( _a379, _k379 );
			}
			level maps/mp/zombies/_zm::set_default_laststand_pistol( 1 );
		}
		flag_set( "initial_players_connected" );
		while ( !aretexturesloaded() )
		{
			wait 0,05;
		}
		thread start_zombie_logic_in_x_sec( 3 );
	}
	fade_out_intro_screen_zm( 5, 1,5, 1 );
}
