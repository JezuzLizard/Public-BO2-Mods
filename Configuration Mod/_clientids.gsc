#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;

init()
{
	//level thread onplayerconnect();
	//Useful zombie_vars, vars, and dvars:
	//Variables:
	//disables the end game check WARNING: make sure to include a spectator respawner and auto revive function
	level.no_end_game_check = getDvarIntDefault( "cmLevelNoEndGameCheck", 0 );
	//sets the round number any value between 1-255
	level.round_number = getDvarIntDefault( "cmLevelRoundNumber", 1 );
	//set afterlives on mob to 1 like a normal coop match and sets the prices of doors on origins to be higher
	level.cmLevelSoloModeDisabled = getDvarIntDefault( "cmLevelSoloModeDisabled", 0 );
	if ( level.cmLevelSoloModeDisabled )
	{
		level.is_forever_solo_game = undefined;
	}
	//sets the maximum number of zombies that can be on the map at once 32 max
	level.zombie_ai_limit = getDvarIntDefault( "cmZombieAiLimit", 24 );
	//sets the number of zombie bodies that can be on the map at once
	level.zombie_actor_limit = getDvarIntDefault( "cmZombieActorLimit", 32 );
	//enables midround hellhounds WARNING: causes permanent round pauses on maps that aren't bus depot, town or farm
	level.mixed_rounds_enabled = getDvarIntDefault( "cmZombieMidroundDogs", 0 );
	//sets all zombies to this speed lower values result in walkers higher values sprinters
	level.zombie_move_speed = getDvarIntDefault( "cmZombieMoveSpeed", 1 );
	//locks the zombie movespeed to the above value
	level.cmZombieMoveSpeedLocked = getDvarIntDefault( "cmZombieMoveSpeedLocked", 0 );
	//sets whether there is a cap to the zombie movespeed active
	level.cmZombieMoveSpeedCap = getDvarIntDefault( "cmZombieMoveSpeedCap", 0 );
	//sets the value to the zombie movespeed cap
	level.cmZombieMoveSpeedCapValue = getDvarIntDefault( "cmZombieMoveSpeedCapValue", 1 );
	//sets the zombies move animation valid inputs are "walk", "run", "sprint", "super_sprint", and tranzit only "chase_bus"
	level.cmZombieMoveAnimation = getDvar( "cmZombieMoveAnimation" );
	//enables the override for zombies per round
	level.cmZombieTotalPermanentOverride = getDvarIntDefault( "cmZombieTotalPermanentOverride", 0 );
	//sets the number of zombies per round to the value indicated
	level.cmZombieTotalPermanentOverrideValue = getDvarIntDefault( "cmZombieTotalPermanentOverrideValue", 6 );
	//enables the override for zombie health
	level.cmZombieHealthPermanentOverride = getDvarIntDefault( "cmZombieHealthPermanentOverride", 0 );
	//sets the health of zombies every round to the value indicated
	level.cmZombieHealthPermanentOverrideValue = getDvarIntDefault( "cmZombieHealthPermanentOverrideValue", 150 );
	//enables the health cap override so zombies health won't grow beyond the value indicated
	level.cmZombieMaxHealthOverride = getDvarIntDefault( "cmZombieMaxHealthOverride", 0 );
	//sets the maximum health zombie health will increase to 
	level.cmZombieMaxHealthOverrideValue = getDvarIntDefault( "cmZombieMaxHealthOverrideValue" , 150 );
	
	
	//sets the players maximum health zombies do 60 damage so 121 would be 3 hits 181 would be 4 and so on
	level.cmPlayerMaxHealth = getDvarIntDefault( "cmPlayerMaxHealth", 100 );
	//sets the players starting points when first joining a server
	level.player_starting_points = getDvarIntDefault( "cmPlayerStartingPoints", 500 );
	//sets the perk limit for all players
	level.perk_purchase_limit = getDvarIntDefault( "cmPlayerPerkLimit", 4 );
	//sets the solo laststand pistol
	level.default_solo_laststandpistol = getDvar( "cmPlayerSoloLaststandWeapon" );
	//the default laststand pistol
	level.default_laststandpistol = getDvar( "cmPlayerCoopLaststandWeapon" );
	//set the starting weapon
	level.start_weapon = getDvar( "cmPlayerStartWeapon" );
	
	//disables walkers 
	level.cmZombieDisableWalkers = getDvarIntDefault( "cmZombieDisableWalkers", 0 );
	if ( level.cmZombieDisableWalkers )
	{
		level.speed_change_round = undefined;
	}
	//disables all drops
	level.cmPowerupNoPowerupDrops = getDvarIntDefault( "cmPowerupNoPowerupDrops", 0 );
	
	//Zombie_Vars:
	//The reason zombie_vars are first set to a var is because they don't reliably set when set directly to the value of a dvar
	//sets whether spectators respawn at the end of the round
	level.cmLevelDoSpectatorsRespawn = getDvarIntDefault( "cmLevelDoSpectatorsRespawn", 1 );
	level.zombie_vars[ "spectators_respawn" ] = level.cmLevelDoSpectatorsRespawn;
	//sets the time that the game takes during the end game intermission
	level.cmLevelIntermissionTime = getDvarIntDefault( "cmLevelIntermissionTime", 20 );
	level.zombie_vars["zombie_intermission_time"] = level.cmLevelIntermissionTime;
	//the time between rounds
	level.cmLevelBetweenRoundTime = getDvarIntDefault( "cmLevelBetweenRoundTime", 15 );
	level.zombie_vars["zombie_between_round_time"] = level.cmLevelBetweenRoundTime;
	//time before the game starts 
	level.cmLevelGameStartDelay = getDvarIntDefault( "cmLevelGameStartDelay", 0 );
	level.zombie_vars[ "game_start_delay" ] = level.cmLevelGameStartDelay;
	//riotshield health 
	level.cmEquipmentRiotshieldHitPoints = getDvarIntDefault( "cmEquipmentRiotshieldHitPoints", 2250 );
	level.zombie_vars[ "riotshield_hit_points" ] = level.cmEquipmentRiotshieldHitPoints;
	//jugg health bonus
	level.cmPerkJuggHealth = getDvarIntDefault( "cmPerkJuggHealth", 250 );
	level.zombie_vars[ "zombie_perk_juggernaut_health" ] = level.cmPerkJuggHealth;	
	//perma jugg health bonus 
	level.cmPerkPermaJuggHealth = getDvarIntDefault( "cmPerkPermaJuggHealth", 190 );
	level.zombie_vars[ "zombie_perk_juggernaut_health_upgrade" ] = level.cmPerkPermaJuggHealth;
	//phd min explosion damage
	level.cmPerkMinPhdExplosionDamage = getDvarIntDefault( "cmPerkMinPhdExplosionDamage", 2000 );
	level.zombie_vars[ "zombie_perk_divetonuke_min_damage" ] = level.cmPerkMinPhdExplosionDamage;
	//phd max explosion damage
	level.cmPerkMaxPhdExplosionDamage = getDvarIntDefault( "cmPerkMaxPhdExplosionDamage", 5000 );
	level.zombie_vars[ "zombie_perk_divetonuke_max_damage" ] = level.cmPerkMaxPhdExplosionDamage;
	//phd explosion radius
	level.cmPerkPhdDamageRadius = getDvarIntDefault( "cmPerkPhdDamageRadius", 300 );
	level.zombie_vars[ "zombie_perk_divetonuke_radius" ] = level.cmPerkPhdDamageRadius;
	//points earned per zombie kill in a 4 player game
	level.cmPlayerFourPlayerScorePerZombieKill = getDvarIntDefault( "cmPlayerFourPlayerScorePerZombieKill", 50 );
	level.zombie_vars[ "zombie_score_kill_4player" ] = level.cmPlayerFourPlayerScorePerZombieKill;
	//points earned per zombie kill in a 3 player game
	level.cmPlayerThreePlayerScorePerZombieKill = getDvarIntDefault( "cmPlayerThreePlayerScorePerZombieKill", 50 );
	level.zombie_vars[ "zombie_score_kill_3player" ] = level.cmPlayerThreePlayerScorePerZombieKill;
	//points earned per zombie kill in a 2 player game
	level.cmPlayerTwoPlayerScorePerZombieKill = getDvarIntDefault( "cmPlayerTwoPlayerScorePerZombieKill", 50 );
	level.zombie_vars[ "zombie_score_kill_2player" ] = level.cmPlayerTwoPlayerScorePerZombieKill;
	//points earned per zombie kill in a 1 player game
	level.cmPlayerOnePlayerScorePerZombieKill = getDvarIntDefault( "cmPlayerOnePlayerScorePerZombieKill", 50 );
	level.zombie_vars[ "zombie_score_kill_1player" ] = level.cmPlayerOnePlayerScorePerZombieKill;
	//points given for a normal attack
	level.cmPlayerPointsPerNormalAttack = getDvarIntDefault( "cmPlayerPointsPerNormalAttack", 10 );
	level.zombie_vars[ "zombie_score_damage_normal" ] = level.cmPlayerPointsPerNormalAttack;
	//points given for a light attack
	level.cmPlayerPointsPerLightAttack = getDvarIntDefault( "cmPlayerPointsPerLightAttack", 10 );
	level.zombie_vars[ "zombie_score_damage_light" ] = level.cmPlayerPointsPerLightAttack;
	//points for melee kills to the powerup increment to a powerup drop
	level.cmPlayerPointsBonusMeleeKill = getDvarIntDefault( "cmPlayerPointsBonusMeleeKill", 80 );
	level.zombie_vars[ "zombie_score_bonus_melee" ] = level.cmPlayerPointsBonusMeleeKill;
	//points for headshot kills to the powerup increment to a powerup drop
	level.cmPlayerPointsBonusHeadshotKill = getDvarIntDefault( "cmPlayerPointsBonusHeadshotKill", 50 );
	level.zombie_vars[ "zombie_score_bonus_head" ] = level.cmPlayerPointsBonusHeadshotKill;
	//points for neck kills to the powerup increment to a powerup drop
	level.cmPlayerPointsBonusNeckKill = getDvarIntDefault( "cmPlayerPointsBonusNeckKill", 20 );
	level.zombie_vars[ "zombie_score_bonus_neck" ] = level.cmPlayerPointsBonusNeckKill;
	//points for torso kills to the powerup increment to a powerup drop
	level.cmPlayerPointsBonusTorsoKill = getDvarIntDefault( "cmPlayerPointsBonusTorsoKill", 10 );
	level.zombie_vars[ "zombie_score_bonus_torso" ] = level.cmPlayerPointsBonusTorsoKill;
	//points all players lose when a player bleeds out %10 default
	level.cmPlayerBleedoutPointsLostAllPlayers = getDvarFloatDefault( "cmPlayerBleedoutPointsLostAllPlayers", 0.1 );
	level.zombie_vars[ "penalty_no_revive" ] = level.cmPlayerBleedoutPointsLostAllPlayers;
	//penalty to the player who died 10% of points by default
	level.cmPlayerBleedoutPointsLostSelf = getDvarFloatDefault( "cmPlayerBleedoutPointsLostSelf", 0.1 );
	level.zombie_vars[ "penalty_died" ] = level.cmPlayerBleedoutPointsLostSelf;
	//points players lose on down %5 by default
	level.cmPlayerDownedPointsLostSelf = getDvarFloatDefault( "cmPlayerDownedPointsLostSelf", 0.05 );
	level.zombie_vars[ "penalty_downed" ] = level.cmPlayerDownedPointsLostSelf;
	//unknown
	level.cmPlayerStartingLives = getDvarIntDefault( "cmPlayerStartingLives", 1 );
	level.zombie_vars[ "starting_lives" ] = level.cmPlayerStartingLives;
	//players turn into a zombie on death WARNING: buggy as can be and is missing assets
	level.cmPlayerShouldZombify = getDvarIntDefault( "cmPlayerShouldZombify", 0 );
	level.zombie_vars[ "zombify_player" ] = level.cmPlayerShouldZombify;
	//sets the maximum number of drops per round
	level.cmPowerupMaxPerRound = getDvarIntDefault( "cmPowerupMaxPerRound", 4 );
	level.zombie_vars["zombie_powerup_drop_max_per_round"] = level.cmPowerupMaxPerRound;
	//sets the powerup drop rate lower is better
	level.cmPowerupDropRate = getDvarIntDefault( "cmPowerupDropRate", 2000 );
	level.zombie_vars["zombie_powerup_drop_increment"] = level.cmPowerupDropRate;
	//makes every zombie drop a powerup
	level.cmPowerupAlwaysDrop = getDvarIntDefault( "cmPowerupAlwaysDrop", 0 );
	level.zombie_vars[ "zombie_drop_item" ] = level.cmPowerupAlwaysDrop;
	//increase these below vars to increase drop rate
	//points to the powerup increment to a powerup drop related to level.zombie_vars["zombie_powerup_drop_increment"]
	level.cmPowerupFourPlayerScore = getDvarIntDefault( "cmPowerupFourPlayerScore", 50 );
	level.zombie_vars[ "zombie_score_kill_4p_team" ] = level.cmPowerupFourPlayerScore;
	//points to the powerup increment to a powerup drop related to level.zombie_vars["zombie_powerup_drop_increment"]
	level.cmPowerupThreePlayerScore = getDvarIntDefault( "cmPowerupThreePlayerScore", 50 );
	level.zombie_vars[ "zombie_score_kill_3p_team" ] = level.cmPowerupThreePlayerScore;
	//points to the powerup increment to a powerup drop related to level.zombie_vars["zombie_powerup_drop_increment"]
	level.cmPowerupTwoPlayerScore = getDvarIntDefault( "cmPowerupTwoPlayerScore", 50 );
	level.zombie_vars[ "zombie_score_kill_2p_team" ] = level.cmPowerupTwoPlayerScore;
	//points to the powerup increment to a powerup drop related to level.zombie_vars["zombie_powerup_drop_increment"]
	level.cmPowerupOnePlayerScore = getDvarIntDefault( "cmPowerupOnePlayerScore", 50 );
	level.zombie_vars[ "zombie_score_kill_1p_team" ] = level.cmPowerupOnePlayerScore;
	//points scalar for allies team
	level.cmTeamAlliesPointsMultiplier = getDvarIntDefault( "cmTeamAlliesPointsMultiplier", 1 );
	level.zombie_vars[ "allies" ][ "zombie_point_scalar" ] = level.cmTeamAlliesPointsMultiplier;
	//points scalar for axis team
	level.cmTeamAxisPointsMultiplier = getDvarIntDefault( "cmTeamAxisPointsMultiplier", 1 );
	level.zombie_vars[ "axis" ][ "zombie_point_scalar" ] = level.cmTeamAxisPointsMultiplier;
	//sets the radius of emps explosion lower this to 1 to render emps useless
	level.cmWeaponEmpPerkExplosionRadius = getDvarIntDefault( "cmWeaponEmpPerkExplosionRadius", 420 );
	level.zombie_vars[ "emp_perk_off_range" ] = level.cmWeaponEmpPerkExplosionRadius;
	//sets the duration of emps on perks set to 0 for infiinite duration
	level.cmWeaponEmpPerkOffDuration = getDvarIntDefault( "cmWeaponEmpPerkOffDuration", 90 );
	level.zombie_vars[ "emp_perk_off_time" ] = level.cmWeaponEmpPerkOffDuration;
	//sets the zombie spawnrate; max is 0.08 this is in seconds
	level.cmZombieSpawnRate = getDvarFloatDefault( "cmZombieSpawnRate", 2 );
	level.zombie_vars[ "zombie_spawn_delay" ] = level.cmZombieSpawnRate;
	//sets the zombie spawnrate multiplier increase
	level.cmZombieSpawnRateMultiplier = getDvarFloatDefault( "cmZombieSpawnRateMultiplier", 0.95 );
	//locks the spawnrate so it does not change throughout gameplay
	level.cmZombieSpawnRateLocked = getDvarIntDefault( "cmZombieSpawnRateLocked", 0 );
	//alters the number of zombies per round formula amount of zombies per round is roughly correlated to this value
	//ie half as many zombies per player is half as many zombies per round
	level.cmZombiePerPlayer = getDvarIntDefault( "cmZombiePerPlayer", 6 );
	level.zombie_vars["zombie_ai_per_player"] = level.cmZombiePerPlayer;
	//sets the flat amount of hp the zombies gain per round not used after round 10
	level.cmZombieHealthIncreaseFlat = getDvarIntDefault( "cmZombieHealthIncreaseFlat", 100 );
	level.zombie_vars[ "zombie_health_increase" ] = level.cmZombieHealthIncreaseFlat;
	//multiplies zombie health by this value every round after round 10
	level.cmZombieHealthIncreaseMultiplier = getDvarFloatDefault( "cmZombieHealthIncreaseMultiplier", 0.1 );
	level.zombie_vars[ "zombie_health_increase_multiplier" ] = level.cmZombieHealthIncreaseMultiplier;
	//base zombie health before any multipliers or additions
	level.cmZombieHealthStart = getDvarIntDefault( "cmZombieHealthStart", 150 );
	level.zombie_vars[ "zombie_health_start" ] = level.cmZombieHealthStart;
	//time before new runners spawn on early rounds
	level.cmZombieNewRunnerInterval = getDvarIntDefault( "cmZombieNewRunnerInterval", 10 );
	level.zombie_vars[ "zombie_new_runner_interval" ] = level.cmZombieNewRunnerInterval;
	//determines level.zombie_move_speed on original
	level.cmZombieMoveSpeedMultiplier = getDvarIntDefault( "cmZombieMoveSpeedMultiplier", 10 );
	level.zombie_vars[ "zombie_move_speed_multiplier" ] = level.cmZombieMoveSpeedMultiplier;
	//determines level.zombie_move_speed on easy
	level.cmZombieMoveSpeedMultiplierEasy = getDvarIntDefault( "cmZombieMoveSpeedMultiplierEasy", 8 );
	level.zombie_vars[ "zombie_move_speed_multiplier_easy"] = level.cmZombieMoveSpeedMultiplierEasy;
	//affects the number of zombies per round formula
	level.cmZombieMaxAi = getDvarIntDefault( "cmZombieMaxAi", 24 );
	level.zombie_vars[ "zombie_max_ai" ] = level.cmZombieMaxAi;
	//cheat protected dvars. these can only be set in gsc so we set the values with a different dvars
	//sets speed colas reload multiplier lower is better WARNING: animation doesn't sync
	level.cmPerkSpeedColaReloadSpeed = getDvarFloatDefault( "cmPerkSpeedColaReloadSpeed", 0.5 );
	setdvar( "perk_weapReloadMultiplier", level.cmPerkSpeedColaReloadSpeed );
	//sets double taps firing speed multiplier lower is better
	level.cmPerkDoubleTapFireRate = getDvarFloatDefault( "cmPerkDoubleTapFireRate", 0.75 );
	setdvar( "perk_weapRateMultiplier", level.cmPerkDoubleTapFireRate );
	//sets deadshot crosshair size multiplier lower is better
	level.cmPerkDeadshotAccuracyModifier = getDvarFloatDefault( "cmPerkDeadshotAccuracyModifier", 0.70 );
	setdvar( "perk_weapSpreadMultiplier", level.cmPerkDeadshotAccuracyModifier );	
	//sets how close players have to be to revive another player
	level.cmPlayerReviveTriggerRadius = getDvarIntDefault( "cmPlayerReviveTriggerRadius", 75 );
	setdvar( "revive_trigger_radius", level.cmPlayerReviveTriggerRadius );
	//sets the amount time before a player will bleedout after going down
	level.cmPlayerLaststandBleedoutTime = getDvarIntDefault( "cmPlayerLaststandBleedoutTime", 45 );
	setdvar( "player_lastStandBleedoutTime", level.cmPlayerLaststandBleedoutTime );
	
	init_custom_zm_powerups_gsc_exclusive_dvars();
	disable_specific_powerups();
	checks();
	thread zombies_always_drop_powerups();
	thread zombies_per_round_override();
	thread zombie_health_override();
	thread zombie_health_cap_override();
	thread zombie_spawn_delay_fix();
	thread zombie_speed_fix();
	level thread onplayerconnect();
}

onplayerconnect()
{
	level endon( "end_game" );
	self endon( "disconnect" );
	while ( 1 )
	{
		level waittill( "connected", player );
		player thread onplayerspawned();
	}
}

onplayerspawned()
{
	self endon( "disconnect" );
	while ( 1 )
	{
		self waittill( "spawned_player" );
		self._retain_perks = getDvarIntDefault( "cmPlayerRetainPerks", 0 );
		if ( !isDefined( self.cmIsFirstSpawn ) || !self.cmIsFirstSpawn )
		{
			self.cmIsFirstSpawn = 1;
			self thread watch_for_respawn();
			self.health = level.cmPlayerMaxHealth;
			self.maxHealth = self.health;
			self setMaxHealth( level.cmPlayerMaxHealth );
		}
	}
}

checks()
{
	if ( level.mixed_rounds_enabled )
	{
		if ( level.script != "zm_transit" || maps/mp/zombies/_zm_utility::is_classic() || level.scr_zm_ui_gametype == "zgrief" )
		{
			level.mixed_rounds_enabled = 0;
		}
	}
	if ( level.start_weapon == "" || level.start_weapon== "m1911_zm" )
	{
		level.start_weapon = "m1911_zm";
		if ( level.script == "zm_tomb" )
		{
			level.start_weapon = "c96_zm";
		}
	}
	if ( level.default_laststandpistol == "" || level.default_laststandpistol == "m1911_zm" )
	{
		level.default_laststandpistol = "m1911_zm";
		if ( level.script == "zm_tomb" )
		{
			level.default_laststandpistol = "c96_zm";
		}
	}
	if ( level.default_solo_laststandpistol == "" || level.default_solo_laststandpistol == "m1911_upgraded_zm" )
	{
		level.default_solo_laststandpistol = "m1911_upgraded_zm";
		if ( level.script == "zm_tomb" )
		{
			level.default_solo_laststandpistol = "c96_upgraded_zm";
		}
	}

}

disable_specific_powerups()
{
	level.cmPowerupNames = array( "nuke", "insta_kill", "full_ammo", "double_points", "fire_sale", "free_perk", "carpenter", "zombie_blood" );
	array = level.cmPowerupNames;
	//all powerups are enabled by default disable them manually
	//remove nukes from the drop cycle and special drops
	level.cmPowerupEnabled = [];
	level.cmPowerupEnabled[ "nuke" ] = spawnstruct();
	level.cmPowerupEnabled[ "nuke" ].name = "nuke";
	level.cmPowerupEnabled[ "nuke" ].active = getDvarIntDefault( "cmPowerupNukeEnabled", 1 );
	//remove insta kills from the drop cycle and special drops
	level.cmPowerupEnabled[ "insta_kill" ] = spawnstruct();
	level.cmPowerupEnabled[ "insta_kill" ].name = "insta_kill";
	level.cmPowerupEnabled[ "insta_kill" ].active = getDvarIntDefault( "cmPowerupInstaKillEnabled", 1 );
	//remove max ammos from the drop cycle and special drops
	level.cmPowerupEnabled[ "full_ammo" ] = spawnstruct();
	level.cmPowerupEnabled[ "full_ammo" ].name = "full_ammo";
	level.cmPowerupEnabled[ "full_ammo" ].active = getDvarIntDefault( "cmPowerupMaxAmmoEnabled", 1 );
	//remove carpenter from the drop cycle and special drops
	level.cmPowerupEnabled[ "double_points" ] = spawnstruct();
	level.cmPowerupEnabled[ "double_points" ].name = "double_points";
	level.cmPowerupEnabled[ "double_points" ].active = getDvarIntDefault( "cmPowerupDoublePointsEnabled", 1 );
	//remove fire sale from the drop cycle and special drops NOTE: fire sale isn't on all maps already this being enabled won't make it spawn
	level.cmPowerupEnabled[ "fire_sale" ] = spawnstruct();
	level.cmPowerupEnabled[ "fire_sale" ].name = "fire_sale";
	level.cmPowerupEnabled[ "fire_sale" ].active = getDvarIntDefault( "cmPowerupFireSaleEnabled", 1 );
	//remove the perk bottle from the drop cycle and special drops
	level.cmPowerupEnabled[ "free_perk" ] = spawnstruct();
	level.cmPowerupEnabled[ "free_perk" ].name = "free_perk";
	level.cmPowerupEnabled[ "free_perk" ].active = getDvarIntDefault( "cmPowerupPerkBottleEnabled", 1 );
	//removes carpenter from the drop cycle and special drops
	level.cmPowerupEnabled[ "carpenter" ] = spawnstruct();
	level.cmPowerupEnabled[ "carpenter" ].name = "carpenter";
	level.cmPowerupEnabled[ "carpenter" ].active = getDvarIntDefault( "cmPowerupCarpenterEnabled", 1 );
	//removes zombie blood from the drop cycle and special drops
	level.cmPowerupEnabled[ "zombie_blood" ] = spawnstruct();
	level.cmPowerupEnabled[ "zombie_blood" ].name = "zombie_blood";
	level.cmPowerupEnabled[ "zombie_blood" ].active = getDvarIntDefault( "cmPowerupZombieBloodEnabled", 1 );
	
	//you can expand this list with custom powerups if you'd like just add a new spawnstruct() and add to the array at the top
	
	for ( i = 0; i < array.size; i++ )
	{	
		if ( !level.cmPowerupEnabled[ array[ i ] ].active )
		{
			name = level.cmPowerupEnabled[ array[ i ] ].name;
			if ( isInArray( level.zombie_include_powerups, name ) )
			{
				arrayremovevalue( level.zombie_include_powerups, name );
			}
			if ( isInArray( level.zombie_powerups, name ) )
			{
				arrayremovevalue( level.zombie_powerups, name );
			}
			if ( isInArray( level.zombie_powerup_array, name ) )
			{
				arrayremovevalue( level.zombie_powerup_array, name );
			}
		}
	}
}

disable_all_powerups()
{
	if ( level.cmPowerupNoPowerupDrops )
	{
		flag_clear( "zombie_drop_powerups" );
	}
}

zombies_always_drop_powerups()
{
	if ( !level.cmPowerupAlwaysDrop )
	{
		return;
	}
	while ( 1 )
	{
		level.zombie_vars[ "zombie_drop_item" ] = level.cmPowerupAlwaysDrop;
		wait 0.05;
	}
}
/*
onplayerconnect()
{
	level waittill( "connected", player );
	player thread onplayerspawned();
}

onplayerspawned()
{
	self waittill( "spawned_player" );
	self iprintln( level.zmPowerupsEnabled[ "full_ammo" ].name );
	self iprintln( level.zmPowerupsEnabled[ "full_ammo" ].active );
}
*/

zombies_per_round_override()
{
	if ( !level.cmZombieTotalPermanentOverride )
	{
		return;
	}
	while ( 1 )
	{
		level waittill( "start_of_round" );
		level.zombie_total = level.cmZombieTotalPermanentOverrideValue;
	}
}

zombie_health_override()
{
	if ( !level.cmZombieHealthPermanentOverride )
	{
		return;
	}
	while ( 1 )
	{
		level waittill( "start_of_round" );
		level.zombie_health = level.cmZombieHealthPermanentOverrideValue;
	}
}

zombie_health_cap_override()
{
	if ( !level.cmZombieMaxHealthOverride )
	{
		return;
	}
	while ( 1 )
	{
		level waittill( "start_of_round" );
		if ( level.zombie_health > level.cmZombieMaxHealthOverrideValue )
		{
			level.zombie_health = level.cmZombieMaxHealthOverrideValue;
		}
	}
}

zombie_spawn_delay_fix()
{
	if ( level.cmZombieSpawnRateLocked )
	{
		return;
	}
	i = 1;
	while ( i <= level.round_number )
	{
		timer = level.cmZombieSpawnRate;
		if ( timer > 0.08 )
		{
			level.cmZombieSpawnRate = timer * level.cmZombieSpawnRateMultiplier;
			i++;
			continue;
		}
		if ( timer < 0.08 )
		{
			level.cmZombieSpawnRate = 0.08;
			break;
		}
		i++;
	}
	while ( 1 )
	{
		level waittill( "start_of_round" );
		if ( level.cmZombieSpawnRate > 0.08 )
		{
			level.cmZombieSpawnRate = level.cmZombieSpawnRate * level.cmZombieSpawnRateMultiplier;
		}
		level.zombie_vars[ "zombie_spawn_delay" ] = level.cmZombieSpawnRate;
	}
}

zombie_speed_fix()
{
	if ( level.cmZombieMoveSpeedLocked )
	{
		return;
	}
	if ( level.gamedifficulty == 0 )
	{
		level.zombie_move_speed = level.round_number * level.zombie_vars[ "zombie_move_speed_multiplier_easy" ];
	}
	else
	{
		level.zombie_move_speed = level.round_number * level.zombie_vars[ "zombie_move_speed_multiplier" ];
	}
}

zombie_speed_override()
{
	if ( !level.cmZombieMoveSpeedLocked )
	{
		return;
	}
	while ( 1 )
	{
		level waittill( "start_of_round" );
		level.zombie_move_speed = getDvarIntDefault( "cmZombieMoveSpeed", 1 );
	}
}

zombie_speed_cap_override()
{
	if ( !level.cmZombieMoveSpeedCap )
	{
		return;
	}
	while ( 1 )
	{
		level waittill( "start_of_round" );
		if ( level.zombie_move_speed > level.cmZombieMoveSpeedCapValue )
		{
			level.zombie_move_speed = level.cmZombieMoveSpeedCapValue;
		}
	}
}

zombie_move_animation_override()
{
	if ( level.cmZombieMoveAnimation == "" )
	{
		return;
	}
	
	while ( 1 )
	{
		zombies = getAiArray( level.zombie_team );
		foreach( zombie in zombies )
		{
			if ( zombie in_enabled_playable_area() )
			{
				zombie maps/mp/zombies/_zm_utility::set_zombie_run_cycle( level.cmZombieMoveAnimation );
			}
		}
		wait 1;
	}
}

watch_for_respawn()
{
	self endon( "disconnect" );
	while ( 1 )
	{
		self waittill_any( "spawned_player", "player_revived" );
		wait_network_frame();
		if ( self._retain_perks && self hasPerk( "specialty_armorvest" ) )
		{
			self setMaxHealth( level.cmPerkJuggHealth );
			self.health = level.cmPerkJuggHealth;
			self.maxHealth = self.health;
		}
		else if ( self.pers_upgrades_awarded[ "jugg" ] && maps/mp/zombies/_zm_utility::is_classic() )
		{
			self setMaxHealth( level.cmPerkPermaJuggHealth );
			self.health = level.cmPerkPermaJuggHealth;
			self.maxHealth = self.health;
		}
		else
		{
			self setMaxHealth( level.cmPlayerMaxHealth );
			self.health = level.cmPlayerMaxHealth;
			self.maxHealth = self.health;
		}
	}
}

init_custom_zm_powerups_gsc_exclusive_dvars()
{
	if ( !isDefined( level.custom_zm_powerups_loaded ) || !level.custom_zm_powerups_loaded )
	{
		return;
	}
	//%chance that a powerup will drop everytime a zombie is killed
	level.cmPowerupRandomDropChance = getDvarIntDefault( "cmPowerupRandomDropChance", 2 );
	//time before a powerup starts to blink and then disappear if not grabbed
	level.cmPowerupFieldLifetime = getDvarIntDefault( "cmPowerupFieldLifetime", 15 );
	//duration of fire sale
	level.cmPowerupFireSaleDuration = getDvarIntDefault( "cmPowerupFireSaleDuration", 30 );
	//duration of double points
	level.cmPowerupDoublePointsDuration = getDvarIntDefault( "cmPowerupDoublePointsDuration", 30 );
	//double points points scalar
	level.cmPowerupDoublePointsScalar = getDvarIntDefault( "cmPowerupDoublePointsScalar", 2 );
	//duration of insta kill
	level.cmPowerupInstaKillDuration = getDvarIntDefault( "cmPowerupInstaKillDuration", 30 );
	
	//points given by carpenter
	level.cmPowerupCarpenterPoints = getDvarIntDefault( "cmPowerupCarpenterPoints", 200 );
	//points given by nuke
	level.cmPowerupNukePoints = getDvarIntDefault( "cmPowerupNukePoints", 400 );
	//whether nukes should take their time killing zombies off
	level.cmPowerupNukeShouldWaitToKillZombies = getDvarIntDefault( "cmPowerupNukeShouldWaitToKillZombies", 1 );
	//minimum time before a nuked zombie dies
	level.cmPowerupNukeMinTimeToKill = getDvarFloatDefault( "cmPowerupNukeMinTimeToKill", 0.1 );
	//maximum time before a nuked zombie dies
	level.cmPowerupNukeMaxTimeToKill = getDvarFloatDefault( "cmPowerupNukeMaxTimeToKill", 0.7 );
	//should max ammo affect players in laststand
	level.cmPowerupMaxAmmoAffectsLaststandPlayers = getDvarIntDefault( "cmPowerupMaxAmmoAffectsLastandPlayers", 0 );
}







