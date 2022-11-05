#include maps\mp\zombies\_zm_utility;
#include maps\mp\_utility;
#include common_scripts\utility;

main()
{
	gametype = getDvar( "g_gametype" );
	location = getDvar( "ui_zm_mapstartlocation" );
	if ( gametype == "zstandard" || gametype == "zgrief" )
	{
		if ( location == "farm" || location == "transit" )
		{
			replaceFunc( common_scripts\utility::struct_class_init, ::struct_class_init_o );
			replaceFunc( maps\mp\zm_transit_utility::solo_tombstone_removal, ::solo_tombstone_removal );
			replaceFunc( maps\mp\zombies\_zm_perks::perk_machine_removal, ::perk_machine_removal );
			level thread turn_perks_on();
		}
	}
}

turn_perks_on()
{
	flag_wait( "start_zombie_round_logic" );
	wait 1;
	level notify( "revive_on" );
	wait_network_frame();
	level notify( "doubletap_on" );
	wait_network_frame();
	level notify( "marathon_on" );
	wait_network_frame();
	level notify( "juggernog_on" );
	wait_network_frame();
	level notify( "sleight_on" );
	wait_network_frame();
	level notify( "tombstone_on" );
	wait_network_frame();
	level notify( "Pack_A_Punch_on" );
}

struct_class_init_o()
{
	level.struct_class_names = [];
	level.struct_class_names[ "target" ] = [];
	level.struct_class_names[ "targetname" ] = [];
	level.struct_class_names[ "script_noteworthy" ] = [];
	level.struct_class_names[ "script_linkname" ] = [];
	level.struct_class_names[ "script_unitrigger_type" ] = [];
	foreach ( s_struct in level.struct )
	{
		if ( isDefined( s_struct.targetname ) )
		{
			if ( !isDefined( level.struct_class_names[ "targetname" ][ s_struct.targetname ] ) )
			{
				level.struct_class_names[ "targetname" ][ s_struct.targetname ] = [];
			}
			size = level.struct_class_names[ "targetname" ][ s_struct.targetname ].size;
			level.struct_class_names[ "targetname" ][ s_struct.targetname ][ size ] = s_struct;
		}
		if ( isDefined( s_struct.target ) )
		{
			if ( !isDefined( level.struct_class_names[ "target" ][ s_struct.target ] ) )
			{
				level.struct_class_names[ "target" ][ s_struct.target ] = [];
			}
			size = level.struct_class_names[ "target" ][ s_struct.target ].size;
			level.struct_class_names[ "target" ][ s_struct.target ][ size ] = s_struct;
		}
		if ( isDefined( s_struct.script_noteworthy ) )
		{
			if ( !isDefined( level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ] ) )
			{
				level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ] = [];
			}
			size = level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ].size;
			level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ][ size ] = s_struct;
		}
		if ( isDefined( s_struct.script_linkname ) )
		{
			level.struct_class_names[ "script_linkname" ][ s_struct.script_linkname ][ 0 ] = s_struct;
		}
		if ( isDefined( s_struct.script_unitrigger_type ) )
		{
			if ( !isDefined( level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ] ) )
			{
				level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ] = [];
			}
			size = level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ].size;
			level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ][ size ] = s_struct;
		}
	}
	location = getDvar( "ui_zm_mapstartlocation" );
	if ( location == "farm" )
	{
		register_perk_struct( "specialty_weapupgrade", "p6_anim_zm_buildable_pap_on", ( 0, 120, 0 ), ( 7764, -6322, 117 ) );
		register_perk_struct( "specialty_scavenger", "zombie_vending_tombstone", ( 0, 3, 0 ), ( 8517, -5599, 50 ) );
		register_perk_struct( "specialty_longersprint", "zombie_vending_marathon", ( 0, 38, 0 ), ( 7057, -5631, -48 ) );
	}
	else if ( location == "transit" )
	{
		register_perk_struct( "specialty_armorvest", "zombie_vending_jugg", ( 0, 180, 0 ), ( -6663, 4592, -55 ) );
		register_perk_struct( "specialty_rof", "zombie_vending_doubletap2", ( 0, 227, 0 ), ( -6026, 4188, -41 ) );
		register_perk_struct( "specialty_longersprint", "zombie_vending_marathon", ( 0, 175, 0 ), ( -7426, 4147, -63 ) );
		register_perk_struct( "specialty_scavenger", "zombie_vending_tombstone", ( 0, 136, 0 ), ( -8098, 4467, -48 ) );
		register_perk_struct( "specialty_weapupgrade", "p6_anim_zm_buildable_pap_on", ( 0, 213, 0), ( 9960, -1288, -217 ) );
		register_perk_struct( "specialty_quickrevive", "zombie_vending_quickrevive", ( 0, 175, 0 ), ( -6719, 4996, -55 ) );
		register_perk_struct( "specialty_fastreload", "zombie_vending_sleight", ( 0, 85, 0 ), ( -6304, 5470, -55 ) );
	}
}

register_perk_struct( perk_name, perk_model, perk_angles, perk_coordinates )
{
	if ( getDvar( "g_gametype" ) == "zgrief" && perk_name == "specialty_scavenger" )
	{
		return;
	}
	perk_struct = spawnStruct();
	perk_struct.script_noteworthy = perk_name;
	perk_struct.model = perk_model;
	perk_struct.angles = perk_angles;
	perk_struct.origin = perk_coordinates;
	perk_struct.targetname = "zm_perk_machine";
	if ( perk_name == "specialty_weapupgrade" )
	{
		flag_struct = spawnStruct();
		flag_struct.targetname = "weapupgrade_flag_targ";
		flag_struct.model = "zombie_sign_please_wait";
		flag_struct.angles = perk_angles + ( 0, 180, 180 );
		flag_struct.origin = perk_coordinates + ( anglesToForward( perk_angles ) * 29 ) + ( anglesToRight( perk_angles ) * -13.5 ) + ( anglesToUp( perk_angles ) * 49.5 );
		perk_struct.target = flag_struct.targetname;
		add_struct( flag_struct );
	}
	add_struct( perk_struct );
}

add_struct( s_struct )
{
	if ( isDefined( s_struct.targetname ) )
	{
		if ( !isDefined( level.struct_class_names[ "targetname" ][ s_struct.targetname ] ) )
		{
			level.struct_class_names[ "targetname" ][ s_struct.targetname ] = [];
		}
		size = level.struct_class_names[ "targetname" ][ s_struct.targetname ].size;
		level.struct_class_names[ "targetname" ][ s_struct.targetname ][ size ] = s_struct;
	}
	if ( isDefined( s_struct.script_noteworthy ) )
	{
		if ( !isDefined( level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ] ) )
		{
			level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ] = [];
		}
		size = level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ].size;
		level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ][ size ] = s_struct;
	}
	if ( isDefined( s_struct.target ) )
	{
		if ( !isDefined( level.struct_class_names[ "target" ][ s_struct.target ] ) )
		{
			level.struct_class_names[ "target" ][ s_struct.target ] = [];
		}
		size = level.struct_class_names[ "target" ][ s_struct.target ].size;
		level.struct_class_names[ "target" ][ s_struct.target ][ size ] = s_struct;
	}
	if ( isDefined( s_struct.script_linkname ) )
	{
		level.struct_class_names[ "script_linkname" ][ s_struct.script_linkname ][ 0 ] = s_struct;
	}
	if ( isDefined( s_struct.script_unitrigger_type ) )
	{
		if ( !isDefined( level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ] ) )
		{
			level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ] = [];
		}
		size = level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ].size;
		level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ][ size ] = s_struct;
	}
}

solo_tombstone_removal()
{
	return;
}

perk_machine_removal( perk )
{
	return;
}
