#include <amxmodx>
#include <reapi>

#define GRAY_FLASHED // Эффект серого ослепления | Gray dazzle effect

#define rg_get_user_team(%0) get_member(%0, m_iTeam)

enum _:flash_type { FLASHED = 0, FULLFLASHED }

new g_szFlashType[flash_type][] = { "Flashed", "Full flashed" };

public plugin_init() {
	register_plugin("HNS Flash Notifier", "1.0.5", "OpenHNS"); // Juice, WessTorn
	
	RegisterHookChain(RG_PlayerBlind, "rgPlayerBlind");
	RegisterHookChain(RG_CBasePlayer_PreThink, "rgPlayerPreThink");
}

public rgPlayerBlind(id, inflictor, attacker, Float:fadeTime, Float:fadeHold, alpha, Float:color[3]) {
	if(!is_entity(attacker) || rg_get_user_team(id) != TEAM_CT || rg_get_user_team(attacker) != TEAM_TERRORIST || rg_get_user_team(id) == TEAM_SPECTATOR)
		return HC_SUPERCEDE;

	#if defined GRAY_FLASHED
		color[0] = 150.0;
		color[1] = 150.0;
		color[2] = 150.0;
	#endif

	if (alpha != 255 || fadeHold < 1.0)
		return HC_CONTINUE;
	
	for(new i = 0; i <= MaxClients; i++) {
		if (!is_user_connected(i))
			continue;
		
		if(rg_get_user_team(i) == TEAM_CT) {
			client_print_color(i, print_team_grey, "^3%n^1 flashed ^3%n", attacker, id);
		} else {
			client_print_color(i, print_team_grey, "^3%n^1 flashed ^3%n^1 for ^3%.2f^1 second", attacker, id, fadeHold);
		}
	}

	return HC_CONTINUE;
}

public rgPlayerPreThink(id) {
	if(rg_get_user_team(id) != TEAM_SPECTATOR) 
		return HC_CONTINUE;

	new iSpecMode = get_member(id, m_iObserverLastMode);

	if(iSpecMode != OBS_CHASE_FREE && iSpecMode != OBS_IN_EYE)
		return HC_CONTINUE;

	new iTarget = get_member(id, m_hObserverTarget);

	if(iTarget == id)
		return HC_CONTINUE;

	if(!is_user_alive(iTarget))
		return HC_CONTINUE;

	if(!IsBlind(iTarget))
		return HC_CONTINUE;

	new Float:g_flGameTime = get_gametime();
	static Float:flHudTime;

	if(flHudTime + 0.1 > g_flGameTime)
		return HC_CONTINUE;

	new iFlashType;

	if (IsBlindFull(iTarget)) {
		set_dhudmessage(250, 0, 0, -1.0, 0.2, 0, 1.0, 0.2, 0.0, 0.0);
		iFlashType = FULLFLASHED;
	} else {
		set_dhudmessage(0, 250, 0, -1.0, 0.2, 0, 1.0, 0.2, 0.0, 0.0);
		iFlashType = FLASHED;
	}

	ScreenFade(id);
	show_dhudmessage(id, "%s", g_szFlashType[iFlashType]);

	flHudTime = g_flGameTime;

	return HC_CONTINUE;
}

public ScreenFade(id){
	static msg_screenfade;
	if(msg_screenfade || (msg_screenfade = get_user_msgid("ScreenFade"))) {
		message_begin(MSG_ONE, msg_screenfade, .player = id);
		write_short(UTIL_FixedUnsigned16(0.0, 1<<12));
		write_short(UTIL_FixedUnsigned16(0.0, 1<<12));
		write_short((1<<0));
		write_byte(0);
		write_byte(0);
		write_byte(0);
		write_byte(0);
		message_end();
	}
}

public UTIL_FixedUnsigned16(Float:Value, Scale)
	return clamp(floatround(Value * Scale), 0, 0xFFFF);

stock bool:IsBlind(pPlayer) {
	return bool:(Float:get_member(pPlayer, m_blindStartTime) + Float:get_member(pPlayer, m_blindFadeTime) >= get_gametime());
}

stock bool:IsBlindFull(pPlayer) {
	return bool:(Float:get_member(pPlayer, m_blindStartTime) + Float:get_member(pPlayer, m_blindHoldTime) >= get_gametime());
}