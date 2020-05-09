## Map Restart Workaround

This is a mod that gets around the clientside errors that happen after a zombies game ends.
When a zombies game ends and the clients remain in the server after the intermission restart, clients may experience several different clientside only bugs.
Some examples of these errors include:

-No sound except music

-Barriers are glitched

-Mystery box is glitched

-A few more minor bugs

These are only clientside so have no effect on the server itself and can be fixed by simply leaving and rejoining.
However, I created a workaround that allows players to remain in the lobby after it ends and not experience any of these clientside issues.

## The Workaround

Compile main.gsc as _clientids.gsc

## Explanation

Basically, what I did was utilize map_restart in the GSC and I call it around 20 seconds after level.intermission is set to 1.
What happens is the game uses a map_restart instead of the normal method Plutonium servers use.
There is a reason this is a workaround though. That is because when map_restart occurs the game reparses all the scripts its supposed to load in the first place,
and as a result it reads a certain function in _zm.gsc. This only a part of the function but its the only part that matters
to this fix.
```
onallplayersready()
{
	timeout = getTime() + 5000;
	while ( getnumexpectedplayers() == 0 && getTime() < timeout )
	{
		wait 0.1;
	}
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

		wait 0.1;
	}
```

So in this function there is a while loop that has 2 potential conditions and it will end on either of them being met. getnumconnectedplayers()
outputs the current number of players in the lobby. getnumexpectedplayers() outputs the expected number of players to join the game, this is determined at 
map launch. Servers always launch the map assuming only 1 player will join; which is why tombstone doesn't spawn in without mods, why players have 3 afterlives
on MoTD, and why doors are cheaper on Origins. Therefore, getnumexpectedplayers() will always output 1 since its value is predetermined and will not change.
The first condition in the while loop will terminate immediately as soon as there is more than 1 player in the lobby when the function is ran. The second condition 
is based on a counter that counts the number of players currently in the sessionstate "playing". Since player_count_actual will exceed the value of getnumexpectedplayers()
it will never meet its end condition of player_count_actual being equal to getnumexpectedplayers(). This results in an infinite loop since as long as there are more than
1 player in the lobby the loop will ever end preventing the blackscreen from passing, and rendering map_restart useless.

However, player_count_actual only counts players that are spawned in and in "playing" state so the solution is to kill all players except player[0], and respawn them after a short delay.
Not exactly ideal, but it does mean all players can remain in the lobby and all players can have sound.

#### Extras
-Players keep all points

-End game check is disabled just in case player[0] leaves during the respawn function its reenabled when players are respawned

-Fixed invisible player glitch hopefully for good

-Players are now directly set into spectator status instead being killed

-Changed how give_team_characters() and give_personality_characters() is called -credit X3RX35
