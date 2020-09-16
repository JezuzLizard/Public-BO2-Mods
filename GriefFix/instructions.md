# Instructions 

## Installing the correct version 

If you want to host a public grief server you need to include this fix otherwise teams don't balance.
I've decided to offer up two versions of the grieffix mod so if you don't want to use the version with bonus settings you can use the basic version.

### Installing the basic fix

Compile grief_fix_basic.gsc as _clientids.gsc and place it in maps/mp/gametypes_zm

### Installing the enhanced version

Compile grief_fix_enhanced.gsc as _clientids.gsc and place it maps/mp/gametypes_zm

### Loading up Grief

Make sure you have the dedicated_zm.cfg and the grief.cfg in gamesettings added from here:
https://github.com/xerxes-at/T6ServerConfigs
Next make an sv_maprotation in the dedicated_zm.cfg with only 1 map loading up the grief map of your choice.
It should look like this 
```
sv_maprotation "exec zgrief.cfg gametype zgrief loc town map zm_transit"
map_rotate
```
Double check if you have another sv_maprotation set already since that can cause errors.

Feel free to modify the zgrief.cfg to change a few settings like start round or magic