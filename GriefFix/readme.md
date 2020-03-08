GriefFix Features:

Added team balancing

Added game start delay and quota 

Added randomized game settings

Added map_restart 

Added map change option (only for farm, town, and bus depot)

Added empty lobby restart 

Team Balancing:

Picks a team for a player on join based on how many players are on each team

CIA/Inmates are the default team if teams are equal

Game Start Delay and Quota:

adjustable wait time

adjustable quota

either the wait time and quota can be fully disabled by changing the value of 1 variable each

Randomized Game Settings:

can be turned off by disabling the corresponding variables

defaults:

50% chance of disabling quick revive

30% chance of diabling jugg

20% chance of first room only

30% chance of hyper speed spawns (max move speed, max spawnrate, no walkers, 1 second between rounds)

15% chance of 4x max drops per round

10% chance of box moving disabled

50% chance of max zombies set to 32

40% chance of deadlier emps (4x duration)

20% chance of deflation (points only earned from kills)

20% chance of shorter rounds

40% chance of electric doors being disabled

Map Restart

after intermission the map restarts using map_restart instead of a normal restart

this fixes the no sound bug on respawn

but requires all other players except 1 player to be killed and respawned

Map Rotate

the map can rotate between 3 locations 

town, farm and bus depot
