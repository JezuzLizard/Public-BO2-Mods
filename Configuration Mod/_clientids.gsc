#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;

init()
{

	//Useful zombie_vars, vars, and dvars:
	//Variables:
	//sets the players starting points when first joining a server
	level.player_starting_points = getDvarIntDefault( "playerStartingPoints", 500 );
	//sets the perk limit for all players
	level.perk_purchase_limit = getDvarIntDefault( "perkLimit", 4 );
	//sets the maximum number of zombies that can be on the map at once 32 max
	level.zombie_ai_limit = getDvarIntDefault( "zombieAiLimit", 24 );
	//sets the number of zombie bodies that can be on the map at once
	level.zombie_actor_limit = getDvarIntDefault( "zombieActorLimit", 32 );
	//enables midround hellhounds WARNING: causes permanent round pauses on maps that aren't bus depot, town or farm
	level.mixed_rounds_enabled = getDvarIntDefault( "midroundDogs", 0 );
	//disables the end game check WARNING: make sure to include a spectator respawner and auto revive function
	level.no_end_game_check = getDvarIntDefault( "noEndGameCheck", 0 );
	//sets the solo laststand pistol
	level.default_solo_laststandpistol = getDvar( "soloLaststandWeapon" );
	//the default laststand pistol
	level.default_laststandpistol = getDvar( "coopLaststandWeapon" );
	//set the starting weapon
	level.start_weapon = getDvar( "startWeaponZm" );
	if ( level.mixed_rounds_enabled )
	{
		if ( level.script != "zm_transit" || is_classic() || level.scr_zm_ui_gametype == "zgrief" )
		{
			level.mixed_rounds_enabled = 0;
		}
	}
	//disables walkers 
	level.disableWalkers = getDvarIntDefault( "disableWalkers", 0 );
	if ( level.disableWalkers )
	{
		level.speed_change_round = undefined;
	}
	//sets all zombies to this speed lower values result in walkers and runners
	level.zombie_move_speed = getDvarIntDefault( "zombieMoveSpeed", 1 );
	//sets the round number any value between 1-255
	level.round_number = getDvarIntDefault( "roundNumber", 1 );
	//sets the zombies health //changed every round
	level.zombie_health = getDvarIntDefault( "currentZombieHealth", 100 );
	//sets the number of zombies in reserve changes every round
	level.zombie_total = getDvarIntDefault( "currentZombieTotal", 6 );
	
	//Zombie_Vars:
	//The reason zombie_vars are first set to a var is because they don't reliably set when set directly to the value of a dvar
	//sets the maximum number of drops per round
	level.maxPowerupsPerRound = getDvarIntDefault( "maxPowerupsPerRound", 4 );
	level.zombie_vars["zombie_powerup_drop_max_per_round"] = level.maxPowerupsPerRound;
	//sets the powerup drop rate lower is better
	level.powerupDropRate = getDvarIntDefault( "powerupDropRate", 2000 );
	level.zombie_vars["zombie_powerup_drop_increment"] = level.powerupDropRate;
	//makes every zombie drop a powerup
	level.zombiesAlwaysDropPowerups = getDvarIntDefault( "zombiesAlwaysDropPowerups", 0 );
	level.zombie_vars[ "zombie_drop_item" ] = level.zombiesAlwaysDropPowerups;
	//increase these below vars to increase drop rate
	//points to the powerup increment to a powerup drop related to level.zombie_vars["zombie_powerup_drop_increment"]
	level.fourPlayerPowerupScore = getDvarIntDefault( "fourPlayerPowerupScore", 50 );
	level.zombie_vars[ "zombie_score_kill_4p_team" ] = level.fourPlayerPowerupScore;
	//points to the powerup increment to a powerup drop related to level.zombie_vars["zombie_powerup_drop_increment"]
	level.threePlayerPowerupScore = getDvarIntDefault( "threePlayerPowerupScore", 50 );
	level.zombie_vars[ "zombie_score_kill_3p_team" ] = level.threePlayerPowerupScore;
	//points to the powerup increment to a powerup drop related to level.zombie_vars["zombie_powerup_drop_increment"]
	level.twoPlayerPowerupScore = getDvarIntDefault( "twoPlayerPowerupScore", 50 );
	level.zombie_vars[ "zombie_score_kill_2p_team" ] = level.twoPlayerPowerupScore;
	//points to the powerup increment to a powerup drop related to level.zombie_vars["zombie_powerup_drop_increment"]
	level.onePlayerPowerupScore = getDvarIntDefault( "onePlayerPowerupScore", 50 );
	level.zombie_vars[ "zombie_score_kill_1p_team" ] = level.onePlayerPowerupScore;
	//points for melee kills to the powerup increment to a powerup drop
	level.powerupScoreMeleeKill = getDvarIntDefault( "powerupScoreMeleeKill", 80 );
	level.zombie_vars[ "zombie_score_bonus_melee" ] = level.powerupScoreMeleeKill;
	//points for headshot kills to the powerup increment to a powerup drop
	level.powerupScoreHeadshotKill = getDvarIntDefault( "powerupScoreHeadshotKill", 50 );
	level.zombie_vars[ "zombie_score_bonus_head" ] = level.powerupScoreHeadshotKill;
	//points for neck kills to the powerup increment to a powerup drop
	level.powerupScoreNeckKill = getDvarIntDefault( "powerupScoreNeckKill", 20 );
	level.zombie_vars[ "zombie_score_bonus_neck" ] = level.powerupScoreNeckKill;
	//points for torso kills to the powerup increment to a powerup drop
	level.powerupScoreTorsoKill = getDvarIntDefault( "powerupScoreTorsoKill", 10 );
	level.zombie_vars[ "zombie_score_bonus_torso" ] = level.powerupScoreTorsoKill;
	//sets the zombie spawnrate; max is 0.08 WARNING: won't change midgame by itself anymore once set from the config or console
	level.zombieSpawnRate = getDvarFloatDefault( "zombieSpawnRate", 2 );
	level.zombie_vars[ "zombie_spawn_delay" ] = level.zombieSpawnRate;
	//alters the number of zombies per round formula amount of zombies per round is roughly correlated to this value
	//ie half as many zombies per player is half as many zombies per round
	level.zombiesPerPlayer = getDvarIntDefault( "zombiesPerPlayer", 6 );
	level.zombie_vars["zombie_ai_per_player"] = level.zombiesPerPlayer;
	//sets the flat amount of hp the zombies gain per round not used after round 10
	level.zombieHealthIncreaseFlat = getDvarIntDefault( "zombieHealthIncreaseFlat", 100 );
	level.zombie_vars[ "zombie_health_increase" ] = level.zombieHealthIncreaseFlat;
	//multiplies zombie health by this value every round after round 10
	level.zombieHealthIncreaseMultiplier = getDvarFloatDefault( "zombieHealthIncreaseMultiplier", 0.1 );
	level.zombie_vars[ "zombie_health_increase_multiplier" ] = level.zombieHealthIncreaseMultiplier;
	//base zombie health before any multipliers or additions
	level.zombieHealthStart = getDvarIntDefault( "zombieHealthStart", 150 );
	level.zombie_vars[ "zombie_health_start" ] = level.zombieHealthStart;
	//time before new runners spawn on early rounds
	level.zombieNewRunnerInterval = getDvarIntDefault( "zombieNewRunnerInterval", 10 );
	level.zombie_vars[ "zombie_new_runner_interval" ] = level.zombieNewRunnerInterval;
	//determines level.zombie_move_speed on original
	level.zombieMoveSpeedMultiplier = getDvarIntDefault( "zombieMoveSpeedMultiplier", 10 );
	level.zombie_vars[ "zombie_move_speed_multiplier" ] = level.zombieMoveSpeedMultiplier;
	//determines level.zombie_move_speed on easy
	level.zombieMoveSpeedMultiplierEasy = getDvarIntDefault( "zombieMoveSpeedMultiplierEasy", 8 );
	level.zombie_vars[ "zombie_move_speed_multiplier_easy"] = level.zombieMoveSpeedMultiplierEasy;
	//affects the number of zombies per round formula
	level.zombieMaxAi = getDvarIntDefault( "zombieMaxAi", 24 );
	level.zombie_vars[ "zombie_max_ai" ] = level.zombieMaxAi;
	//affects the check for zombies that have fallen thru the map
	level.belowWorldCheck = getDvarIntDefault( "belowWorldCheck", -1000 );
	level.zombie_vars[ "below_world_check" ] = level.belowWorldCheck;
	//sets whether spectators respawn at the end of the round
	level.customSpectatorsRespawn = getDvarIntDefault( "customSpectatorsRespawn", 1 );
	level.zombie_vars[ "spectators_respawn" ] = level.customSpectatorsRespawn;
	//sets the time that the game takes during the end game intermission
	level.zombieIntermissionTime = getDvarIntDefault( "zombieIntermissionTime", 20 );
	level.zombie_vars["zombie_intermission_time"] = level.zombieIntermissionTime;
	//the time between rounds
	level.zombieBetweenRoundTime = getDvarIntDefault( "zombieBetweenRoundTime", 15 );
	level.zombie_vars["zombie_between_round_time"] = level.zombieBetweenRoundTime;
	//time before the game starts 
	level.roundStartDelay = getDvarIntDefault( "roundStartDelay", 0 );
	level.zombie_vars[ "game_start_delay" ] = level.roundStartDelay;
	//points all players lose when a player bleeds out %10 default
	level.bleedoutPointsLostAllPlayers = getDvarFloatDefault( "bleedoutPointsLostAllPlayers", 0.1 );
	level.zombie_vars[ "penalty_no_revive" ] = level.bleedoutPointsLostAllPlayers;
	//penalty to the player who died 10% of points by default
	level.bleedoutPointsLostSelf = getDvarFloatDefault( "bleedoutPointsLostSelf", 0.1 );
	level.zombie_vars[ "penalty_died" ] = level.bleedoutPointsLostSelf;
	//points players lose on down %5 by default
	level.downedPointsLostSelf = getDvarFloatDefault( "downedPointsLostSelf", 0.05 );
	level.zombie_vars[ "penalty_downed" ] = level.downedPointsLostSelf;
	//unknown
	level.playerStartingLives = getDvarIntDefault( "playerStartingLives", 1 );
	level.zombie_vars[ "starting_lives" ] = level.playerStartingLives;
	//points earned per zombie kill in a 4 player game
	level.fourPlayerScorePerZombieKill = getDvarIntDefault( "fourPlayerScorePerZombieKill", 50 );
	level.zombie_vars[ "zombie_score_kill_4player" ] = level.fourPlayerScorePerZombieKill;
	//points earned per zombie kill in a 3 player game
	level.threePlayerScorePerZombieKill = getDvarIntDefault( "threePlayerScorePerZombieKill", 50 );
	level.zombie_vars[ "zombie_score_kill_3player" ] = level.threePlayerScorePerZombieKill;
	//points earned per zombie kill in a 2 player game
	level.twoPlayerScorePerZombieKill = getDvarIntDefault( "twoPlayerScorePerZombieKill", 50 );
	level.zombie_vars[ "zombie_score_kill_2player" ] = level.twoPlayerScorePerZombieKill;
	//points earned per zombie kill in a 1 player game
	level.onePlayerScorePerZombieKill = getDvarIntDefault( "onePlayerScorePerZombieKill", 50 );
	level.zombie_vars[ "zombie_score_kill_1player" ] = level.onePlayerScorePerZombieKill;
	//points given for a normal attack
	level.pointsPerNormalAttack = getDvarIntDefault( "pointsPerNormalAttack", 10 );
	level.zombie_vars[ "zombie_score_damage_normal" ] = level.pointsPerNormalAttack;
	//points given for a light attack
	level.pointsPerLightAttack = getDvarIntDefault( "pointsPerLightAttack", 10 );
	level.zombie_vars[ "zombie_score_damage_light" ] = level.pointsPerLightAttack;
	//players turn into a zombie on death WARNING: buggy as can be and is missing assets
	level.shouldZombifyPlayer = getDvarIntDefault( "shouldZombifyPlayer", 0 );
	level.zombie_vars[ "zombify_player" ] = level.shouldZombifyPlayer;
	//points scalar for allies team
	level.alliesPointsMultiplier = getDvarIntDefault( "alliesPointsMultiplier", 1 );
	level.zombie_vars[ "allies" ][ "zombie_point_scalar" ] = level.alliesPointsMultiplier;
	//points scalar for axis team
	level.axisPointsMultiplier = getDvarIntDefault( "axisPointsMultiplier", 1 );
	level.zombie_vars[ "axis" ][ "zombie_point_scalar" ] = level.axisPointsMultiplier;
	//sets the radius of emps explosion lower this to 1 to render emps useless
	level.empPerkExplosionRadius = getDvarIntDefault( "empPerkExplosionRadius", 420 );
	level.zombie_vars[ "emp_perk_off_range" ] = level.empPerkExplosionRadius;
	//sets the duration of emps on perks set to 0 for infiinite emps
	level.empPerkOffDuration = getDvarIntDefault( "empPerkOffDuration", 90 );
	level.zombie_vars[ "emp_perk_off_time" ] = level.empPerkOffDuration;
	//riotshield health 
	level.riotshieldHitPoints = getDvarIntDefault( "riotshieldHitPoints", 2250 );
	level.zombie_vars[ "riotshield_hit_points" ] = level.riotshieldHitPoints;
	//jugg health bonus
	level.juggHealthBonus = getDvarIntDefault( "juggHealthBonus", 160 );
	level.zombie_vars[ "zombie_perk_juggernaut_health" ] = level.juggHealthBonus;	
	//perma jugg health bonus 
	level.permaJuggHealthBonus = getDvarIntDefault( "permaJuggHealthBonus", 190 );
	level.zombie_vars[ "zombie_perk_juggernaut_health_upgrade" ] = level.permaJuggHealthBonus;
	//phd min explosion damage
	level.minPhdExplosionDamage = getDvarIntDefault( "minPhdExplosionDamage", 1000 );
	level.zombie_vars[ "zombie_perk_divetonuke_min_damage" ] = level.minPhdExplosionDamage;
	//phd max explosion damage
	level.maxPhdExplosionDamage = getDvarIntDefault( "maxPhdExplosionDamage", 5000 );
	level.zombie_vars[ "zombie_perk_divetonuke_max_damage" ] = level.maxPhdExplosionDamage;
	//phd explosion radius
	level.phdDamageRadius = getDvarIntDefault( "phdDamageRadius", 300 );
	level.zombie_vars[ "zombie_perk_divetonuke_radius" ] = level.phdDamageRadius;
}

