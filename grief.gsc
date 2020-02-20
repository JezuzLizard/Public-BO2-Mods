#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/gametypes_zm/zgrief;

init()
{
	level.pap_grab_by_anyone = true;
	level.magic_box_grab_by_anyone = true;
	level.perk_purchase_limit = 9;
	level.wait_time = 30;
	level.player_quota_active = 1;
	level.player_quota = 2;
	level.waiting = 0;
	level.countdown_start = 0;
	level.round_prestart_func =::round_prestart_func;
	SetDvar( "scr_zm_enable_bots", "1" );
	thread add_bots();
   	level.default_solo_laststandpistol = "m1911_zm";
   	for(;;)
    {
        level waittill("connected", player);
        player thread teamBalancing();
    }
}

round_prestart_func()
{
	players = get_players();
	while ( players.size < level.player_quota && level.player_quota_active == 1 || players.size < 1)
	{
		wait 0.5;
		players = get_players();
	}	
	wait level.wait_time;
}

teamBalancing()
{
		teamplayersallies = countplayers( "allies");
		teamplayersaxis = countplayers( "axis");
		if (teamplayersallies > teamplayersaxis && !level.isresetting_grief)
		{
			self.team = "axis";
			self.sessionteam = "axis";
			self [[level.axis]]();
			self.pers["team"] = "axis";
			self._encounters_team = "A";
		}
		else if (teamplayersallies < teamplayersaxis && !level.isresetting_grief)
		{
			self.team = "allies";
			self.sessionteam = "allies";
			self [[level.allies]]();
			self.pers["team"] = "allies";
			self._encounters_team = "B";
		}
		else if (teamplayersallies == teamplayersaxis && !level.isresetting_grief)
		{
			self.team = "allies";
			self.sessionteam = "allies";
			self [[level.allies]]();
			self.pers["team"] = "allies";
			self._encounters_team = "B";
		}
}

add_bots()
{
    players = get_players();
    level.waiting = 1;
    thread waitMessage();
	while ( players.size < level.player_quota && level.player_quota_active == 1 || players.size < 1)
	{
		wait 0.5;
		players = get_players();
	}
	level.waiting = 0;
	level.countdown_start = 1;
	thread countdownTimer();
	wait level.wait_time;
    flag_set( "start_zombie_round_logic" );
}

waitMessage()
{   
	level endon("game_ended");
	self endon("disconnect");
	if( level.waiting == 0 )
	{
		return;
	}

   	Waiting = create_simple_hud();
   	Waiting.horzAlign = "center";
   	Waiting.vertAlign = "middle";
   	Waiting.alignX = "center";
   	Waiting.alignY = "middle";
   	Waiting.y = -130; 
   	Waiting.x = 0;
   	Waiting.foreground = 1;
   	Waiting.fontscale = 2.0;
   	Waiting.alpha = 1;
   	Waiting.color = ( 1.000, 1.000, 1.000 );
   	Waiting.hideWhenInMenu = true;
   	Waiting SetText( "Waiting for 1 more player" );
   	
   	while ( 1 )
   	{
		if ( level.waiting == 0 )
		{
			Waiting destroy();
			break;
		}
		wait 1;
	}
}

countdownTimer()
{   
	level endon("game_ended");
	self endon("disconnect");
	if ( level.countdown_start == 0 )
	{
		return;
	}
	
	Remaining = create_simple_hud();
  	Remaining.horzAlign = "center";
  	Remaining.vertAlign = "middle";
   	Remaining.alignX = "center";
   	Remaining.alignY = "middle";
   	Remaining.y = 20;
   	Remaining.x = 0;
   	Remaining.foreground = 1;
   	Remaining.fontscale = 2.0;
   	Remaining.alpha = 1;
   	Remaining.color = ( 0.98, 0.549, 0 );

   	Countdown = create_simple_hud();
   	Countdown.horzAlign = "center"; 
   	Countdown.vertAlign = "middle";
   	Countdown.alignX = "center";
   	Countdown.alignY = "middle";
   	Countdown.y = -20;
   	Countdown.x = 0;
   	Countdown.foreground = 1;
   	Countdown.fontscale = 2.0;
   	Countdown.alpha = 1;
   	Countdown.color = ( 1.000, 1.000, 1.000 );
   	Countdown SetText( "Match begins in" );
   	
   	timer = level.wait_time;
	while ( level.countdown_start == 1 )
	{
		Remaining SetValue( timer ); 
		wait 1;
		timer--;
		if ( timer <= 0 )
		{
			Countdown destroy();
			Remaining destroy();
			break;
		}
	}
}
