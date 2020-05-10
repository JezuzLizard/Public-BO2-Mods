# Configuration Mod

*** Instructions ***

Merge inits with your current mod or compile as _clientids.gsc.

Install _clientids.gsc in maps/mp/gametypes_zm

All dvars are included in the config and descriptions are in the code itself.

Added dvars should be working but not all have been tested, also dvar names should not conflict.

Weapon names can be found in the included black ops 2 names.

*** Optional ***

Compile _zm_powerups.gsc as _zm_powerups.gsc DO NOT ATTEMPT TO MERGE THEM INTO ONE FILE IT WILL DEFINITELY CRASH

Install _zm_powerups.gsc in in maps/mp/zombies

This will add support for changing a few aspects of the vanilla powerups

# Update 5/10/20

## Main Changes

Organized variables by type so its easier for mod developers to find whats there

Removed zombie below world check value since it can interfere with MoTD

Fixed the nuke points dvar having the same name as the carpenter points dvar

Changed some powerup dvars to player type dvars since they deal with points earned by players

Added another check for the _zm_powerups.gsc exclusive dvars

# Update 5/9/20

## Main Changes

Refactored all the variables to standardize their naming

Added support for _zm_powerups allowing you control more aspects for vanilla powerups

### Zombie Dvars

Added a new dvar to control the zombie move animation so you can force them to be super sprinters or bus sprinters

### Player dvars

Added a new dvar allowing you to control the players health

Added a new dvar allowing you to control whether a player keeps their perks on down notes: does not work on MoTD

### Cheat protected dvars

Moved the cheat protected dvars in script so hopefully they can changed using other dvars

### Powerups dvars - requires _zm_powerups to be installed

Added a dvar allowing you to control the random drop chance of powerups

Added a dvar allowing you to control length of time a powerup will last on the field before starting to blink

Added a dvar allowing you to control the duration of fire sale

Added a dvar allowing you to control the duration of double points

Added a dvar allowing you to control the points multiplier granted by double points

Added a dvar allowing you to control the duration of insta kill

Added a dvar allowing you to control the amount of points granted by a carpenter

Added a dvar allowing you to control the amount of points granted by a nuke

Added a dvar allowing you to control whether nukes instantly kill zombies

Added dvars which allow you to control the minimum and maximum time it takes for a zombie to die to a nuke

Added a dvar that allows max ammo to apply to downed players

# Update 4/10/20

### Powerups

Added support for disabling individual powerups

Added the ability to disable all powerup drops

Added the ability to make all zombies drop a powerup

### Spawnrate

Added the ability to set the zombie spawn rate

Added the ability to lock the zombie spawn rate

Added the ability to change the spawn rate multiplier

Added the ability for the zombie spawn rate to automatically adjust if the roundNumber dvar was used

### Zombie Movespeed

Added the ability to lock the zombie movespeed

Added the ability to set a cap to the zombie movespeed

### Zombie Health

Added the ability to set a health cap

Added tha ability to lock the zombie health

### Zombies Per Round

Added the ability to lock the zombies per round
