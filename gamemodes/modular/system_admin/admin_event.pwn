#include <YSI_Coding\y_hooks>

hook OnRconLoginAttempt(ip[], password[], success)
{
    if(!success) return 1;

    foreach(new i : Player)
    {
        new pip[16];
        GetPlayerIp(i, pip, sizeof pip);

        if(!strcmp(pip, ip))
        {
            pInfo[i][pAdminLevel] = ADMIN_DEV;
            SendClientMessage(i, COLOR_ADMIN,
                "[ADMIN] Kamu login sebagai Developer (RCON).");
        }
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    foreach(new i : Player)
    {
        if(pInfo[i][pSpectating] && pInfo[i][pSpecTarget] == playerid)
        {
            TogglePlayerSpectating(i, false);

            pInfo[i][pSpectating] = false;
            pInfo[i][pSpecTarget] = INVALID_PLAYER_ID;

            // ✅ Balikin posisi admin
            SetPlayerInterior(i, pInfo[i][pSpecLastInt]);
            SetPlayerVirtualWorld(i, pInfo[i][pSpecLastVW]);
            SetPlayerPos(i, pInfo[i][pSpecLastX], pInfo[i][pSpecLastY], pInfo[i][pSpecLastZ]);
            SetPlayerFacingAngle(i, pInfo[i][pSpecLastA]);

            SendClientMessage(i, 0xFF0000FF, "Spectate dihentikan (target disconnect).");
        }
    }

    pInfo[playerid][pAdminLevel]    = ADMIN_NONE;
    pInfo[playerid][pPendingAdminLevel] = ADMIN_NONE;
    pInfo[playerid][pAdminDuty]     = false;
    pInfo[playerid][pSpectating]    = false;
    pInfo[playerid][pSpecTarget]    = INVALID_PLAYER_ID;
    return 1;
}
