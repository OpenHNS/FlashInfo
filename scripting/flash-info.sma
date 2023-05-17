#include <amxmodx>
#include <reapi>

#define rg_get_user_team(%0) get_member(%0, m_iTeam)

new const Source[3] = {0, 255, 0};  // green
new const Target[3] = {255, 0, 0};  // red

new Float:g_flFlashUntil[MAX_PLAYERS + 1];
new Float:g_flFlashHoldTime[MAX_PLAYERS + 1];

public plugin_init() {
	register_plugin("Flash Info", "1.0.2", "OpenHNS"); // Juice, WessTorn
	
	RegisterHookChain(RG_PlayerBlind, "rgPlayerBlind", false);
	RegisterHookChain(RG_CBasePlayer_PreThink, "rgPlayerPreThink", false);
}

public client_putinserver(id) {
	g_flFlashUntil[id] = g_flFlashHoldTime[id] = 0.0;
}

public client_disconnected(id) {
	g_flFlashUntil[id] = g_flFlashHoldTime[id] = 0.0;
}

public rgPlayerBlind(id, inflictor, attacker, Float:fadeTime, Float:fadeHold, alpha, Float:color[3]) {
	if(!is_entity(attacker) || rg_get_user_team(id) != TEAM_CT || rg_get_user_team(attacker) != TEAM_TERRORIST) {
		return HC_SUPERCEDE;
	}

	g_flFlashUntil[id] = get_gametime() + fadeTime;
	g_flFlashHoldTime[id] = get_gametime() + fadeHold;
	
	for(new i = 1; i <= MaxClients; i++) {
		if ((fadeHold < 1.0 && fadeTime < 6.0 && alpha != 255) || !is_user_connected(i))
			continue
		
		if(rg_get_user_team(i) == TEAM_CT) {
			client_print_color(i, print_team_grey, "^3%n^1 flashed ^3%n", attacker, id);
		} else {
			client_print_color(i, print_team_grey, "^3%n^1 flashed ^3%n^1 for ^3%.2f^1 second", attacker, id, fadeHold);
		}
	}
	
	color[0] = 150.0;
	color[1] = 150.0;
	color[2] = 150.0;

	return HC_CONTINUE;
}

public rgPlayerPreThink(id) {
	if(!is_user_alive(id) || rg_get_user_team(id) != TEAM_CT) 
		return HC_CONTINUE;

	static Float:g_flGameTime;
	g_flGameTime = get_gametime();

	if(g_flFlashUntil[id] > g_flGameTime) {
		new percent;
		if(g_flFlashHoldTime[id] > g_flGameTime) {
			percent = 100;
		} else {
			percent = floatround(((g_flFlashUntil[id] - g_flGameTime) / (g_flFlashUntil[id] - g_flFlashHoldTime[id])) * 100, floatround_tozero);
		}

		new MyColour[3];

		MyColour = rgb_color(MyColour, percent);

		set_dhudmessage(MyColour[0], MyColour[1], MyColour[2], -1.0, 0.2, 0, 6.0, 0.1, 0.0, 0.0);

		new is_spec_user[MAX_PLAYERS + 1];
		for (new i = 1; i <= MaxClients; i++) {
			is_spec_user[i] = is_user_spectating_player(i, id);
		}

		for (new i = 1; i <= MaxClients; i++) {
			if (is_spec_user[i]) {
				ScreenFade(i);
				show_dhudmessage(i, "Flashed: %d%", percent);
			}
		}
	}
	return HC_CONTINUE;
}

stock ScreenFade(id, Float:duration = 0.0, Float:holdtime = 0.0, flags = (1<<0), r = 0, g = 0, b = 0, alpha = 0){
	static msg_screenfade; 
	if(msg_screenfade || (msg_screenfade = get_user_msgid("ScreenFade"))){
		message_begin(MSG_ONE, msg_screenfade, .player = id);
		write_short(UTIL_FixedUnsigned16(duration, 1<<12));
		write_short(UTIL_FixedUnsigned16(holdtime, 1<<12));
		write_short(flags);
		write_byte(r);
		write_byte(g);
		write_byte(b);
		write_byte(alpha);
		message_end();
	}
}

stock UTIL_FixedUnsigned16(Float:Value, Scale)
    return clamp(floatround(Value * Scale), 0, 0xFFFF);

stock rgb_color(color[3], percent) {
	color = Source;
	color[0] = Source[0] + (((Target[0] - Source[0]) * percent) / 100);
	color[1] = Source[1] + (((Target[1] - Source[1]) * percent) / 100);
	color[2] = Source[2] + (((Target[2] - Source[2]) * percent) / 100);
	return color;
}

stock is_user_spectating_player(spectator, player) {
	if(is_user_alive(spectator))
		return 0;

	static iSpecMode;
	iSpecMode = get_entvar(spectator, var_iuser1);

	if(iSpecMode == 3)
		return 0;
	   
	if(get_entvar(spectator, var_iuser2) == player)
		return 1;
	   
	return 0;
}