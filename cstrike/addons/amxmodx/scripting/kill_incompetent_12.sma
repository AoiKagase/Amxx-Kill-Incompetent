/*
* Kill Incompetent Ver1.2
* by p00h
* http://p00h.web.infoseek.co.jp <= DEAD URL.
*/

#include <amxmodx>
#include <amxmisc>
#include <cstrike>

#pragma semicolon 1
#pragma tabsize 4

#define TASK_ID_KILL_PLAYERS	2210001
new g_cvar;
//======================================
// Plugin Initialize
//======================================
public plugin_init() 
{
	register_plugin("Kill Incompetent", "1.2", "p00h");
	register_event("SendAudio", "round_end", "a", "2=%!MRAD_terwin", "2=%!MRAD_ctwin", "2=%!MRAD_rounddraw");

	// 1 = ON, 0 = OFF.
	bind_pcvar_num(create_cvar("amx_kill_incompetent", "1"), g_cvar);
	return PLUGIN_CONTINUE;
}

//======================================
// Round End Event
//======================================
public round_end()
{
	if (!g_cvar)
		return PLUGIN_CONTINUE;

	new params[16];
	// Get the second SendAudio event parameters. (%!MRAD_terwin, %!MRAD_ctwin, %!MRAD_rounddraw)
	read_data(2, params, charsmax(params));

	// Counter-Terrorist Win.
	if (equali(params[7], "ct", 2)) 
		// The loser dies one second after the decision is made. (TERRORIST)
		set_task_ex(1.0, "kill_players", TASK_ID_KILL_PLAYERS, "TERRORIST", 9, SetTask_Once, 0);
	// Terrorist Win.
	else if (equali(params[7], "ter", 3))
		// The loser dies one second after the decision is made. (CT)
		set_task_ex(1.0, "kill_players", TASK_ID_KILL_PLAYERS, "CT", 2, SetTask_Once, 0);

	return PLUGIN_CONTINUE;
}

//======================================
// Kill players.
//======================================
public kill_players(s_team[]) 
{
	new iPlayers[MAX_PLAYERS], iNum;
	// Get players id for loser team.
	get_players_ex(iPlayers, iNum, GetPlayers_ExcludeDead | GetPlayers_MatchTeam | GetPlayers_ExcludeHLTV, s_team);

	for(new i = 0; i < iNum; i++)
		user_kill(iPlayers[i], 1);
} 