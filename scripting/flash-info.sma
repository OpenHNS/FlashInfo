#include <amxmodx>
#include <reapi>

#define rg_get_user_team(%0) get_member(%0, m_iTeam)

public plugin_init() {
    register_plugin("Flash Info", "1.0", "OpenHNS"); // Juice
    RegisterHookChain(RG_PlayerBlind, "rgPlayerBlind", true);
}

public rgPlayerBlind(id, inflictor, attacker, Float:fadeTime, Float:fadeHold, alpha) {
	if(alpha != 255 || fadeHold < 0.1 || !is_entity(attacker) || rg_get_user_team(id) != TEAM_CT || rg_get_user_team(attacker) != TEAM_TERRORIST) {
		return;
	}
	
	for(new i = 1; i <= MaxClients; i++) {
		if(!is_user_connected(i)) {
			continue;
		}
		
		if(rg_get_user_team(i) == TEAM_CT) {
			client_print_color(i, print_team_grey, "Player ^3%n^1 flashed ^3%n", attacker, id);
		} else {
			client_print_color(i, print_team_grey, "Player ^3%n^1 flashed ^3%n^1 for ^3%.1f^1 second", attacker, id, fadeHold);
		}
	}
}
