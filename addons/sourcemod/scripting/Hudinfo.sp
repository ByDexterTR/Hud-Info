#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "Yaşayan oyuncu sayısını gösterme", 
	author = "ByDexter", 
	description = "", 
	version = "1.0", 
	url = "https://steamcommunity.com/id/ByDexterTR - ByDexter#5494"
};

#define Color 66, 135, 245, 255
#define LoopClients(%1) for (int %1 = 1; %1 <= MaxClients; %1++) if (IsClientInGame(%1))

Handle Hud = null;
bool Info[65] =  { true, ... };
bool Block = false;

public void OnPluginStart()
{
	RegConsoleCmd("sm_hud", Command_Hud, "");
	CreateTimer(2.0, ShowHud, _, TIMER_REPEAT);
	Hud = CreateHudSynchronizer();
	HookEvent("round_start", RoundStart);
	HookEvent("round_end", RoundEnd);
}

public Action Command_Hud(int client, int args)
{
	Info[client] = !Info[client];
	PrintToChat(client, "[SM] %s", Info[client] ? "Yaşayan oyuncu Hud'u \x07kapatıldı.":"Yaşayan oyuncu Hud'u \x04açıldı.");
	return Plugin_Handled;
}

public Action ShowHud(Handle timer)
{
	if (!Block)
	{
		int TCount = GetAlivePlayersCount(2);
		int CTCount = GetAlivePlayersCount(3);
		char HudFormat[128];
		LoopClients(client)
		{
			if (Info[client])
			{
				Format(HudFormat, 128, "- Canlı Oyuncu -\nCT : %d\nT   : %d", CTCount, TCount);
				SetHudTextParams(0.0, 0.45, 2.0, Color, 0, 0.00, 0.1, 0.9);
				ShowSyncHudText(client, Hud, HudFormat);
			}
		}
	}
}

public Action RoundStart(Event event, const char[] name, bool dB) { Block = false; }
public Action RoundEnd(Event event, const char[] name, bool dB) { Block = true; }

int GetAlivePlayersCount(int team)
{
	int Count = 0;
	LoopClients(client)
	{
		if (IsPlayerAlive(client) && GetClientTeam(client) == team)
			Count++;
	}
	return Count;
} 