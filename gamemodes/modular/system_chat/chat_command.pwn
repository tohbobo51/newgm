#include <YSI_Coding\y_hooks>

// ======================================
// CHAT COMMAND
hook OnPlayerText(playerid, text[])
{
    if(!pInfo[playerid][pLoggedIn]) return 0;

    new name[MAX_PLAYER_NAME], msg[144];
    GetPlayerNameEx(playerid, name);

    format(msg, sizeof msg, "%s says: %s", name, text);
    SendProximityMessage(playerid, CHAT_RADIUS_IC, COLOR_IC, msg);

    PlayChatAnimation(playerid, text);
    return 0;
}

CMD:me(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, -1, "USAGE: /me [aksi]");

    new name[MAX_PLAYER_NAME], msg[144];
    GetPlayerNameEx(playerid, name);

    format(msg, sizeof msg, "* %s %s", name, params);
    SendProximityMessage(playerid, CHAT_RADIUS_ME, COLOR_ME, msg);

    PlayChatAnimation(playerid, params);
    return 1;
}

CMD:do(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, -1, "USAGE: /do [deskripsi]");

    new name[MAX_PLAYER_NAME], msg[144];
    GetPlayerNameEx(playerid, name);

    format(msg, sizeof msg, "* %s (( %s ))", params, name);
    SendProximityMessage(playerid, CHAT_RADIUS_DO, COLOR_DO, msg);
    PlayChatAnimation(playerid, params);
    return 1;
}

CMD:try(playerid, params[])
{
    if(isnull(params))
        return SendClientMessage(playerid, -1, "USAGE: /try [aksi]");

    new name[MAX_PLAYER_NAME], msg[144];
    new bool:success = (random(2) == 1);

    GetPlayerNameEx(playerid, name);

    format(msg, sizeof msg,
        "* %s %s (%s)",
        name, params, success ? "success" : "failed"
    );

    SendProximityMessage(playerid, CHAT_RADIUS_TRY, COLOR_TRY, msg);
    PlayChatAnimation(playerid, params);
    return 1;
}

CMD:shout(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, -1, "USAGE: /shout [pesan]");

    new name[MAX_PLAYER_NAME], msg[144];
    GetPlayerNameEx(playerid, name);

    format(msg, sizeof msg, "%s shouts: %s!", name, params);
    SendProximityMessage(playerid, CHAT_RADIUS_SHOUT, COLOR_SHOUT, msg);
    ApplyAnimation(playerid, "PED", "SHOUT_01", 4.1, 0, 0, 0, 0, 0);
    return 1;
}

CMD:low(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, -1, "USAGE: /low [pesan]");

    new name[MAX_PLAYER_NAME], msg[144];
    GetPlayerNameEx(playerid, name);

    format(msg, sizeof msg, "%s says (low): %s", name, params);
    SendProximityMessage(playerid, CHAT_RADIUS_LOW, COLOR_LOW, msg);
    PlayChatAnimation(playerid, params);
    return 1;
}

CMD:w(playerid, params[])
{
    new target, text[128];
    if(sscanf(params, "us[128]", target, text))
        return SendClientMessage(playerid, -1, "USAGE: /w [player] [pesan]");

    if(!IsPlayerConnected(target))
        return SendClientMessage(playerid, -1, "Player tidak valid.");

    if(target == playerid)
        return SendClientMessage(playerid, -1, "ERROR: Tidak bisa whisper ke diri sendiri.");

    // ✅ cek VW + Interior
    if(GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(target) ||
       GetPlayerInterior(playerid) != GetPlayerInterior(target))
        return SendClientMessage(playerid, -1, "ERROR: Target tidak berada di tempat yang sama.");

    // ✅ cek jarak
    new Float:x1, Float:y1, Float:z1;
    new Float:x2, Float:y2, Float:z2;
    GetPlayerPos(playerid, x1, y1, z1);
    GetPlayerPos(target, x2, y2, z2);

    if(GetDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) > CHAT_RADIUS_WHISPER)
        return SendClientMessage(playerid, -1, "ERROR: Target terlalu jauh untuk whisper (maks 3 meter).");

    new name1[MAX_PLAYER_NAME], msg[160];
    GetPlayerNameEx(playerid, name1);

    format(msg, sizeof msg, "(Whisper) %s: %s", name1, text);

    SendClientMessage(target, COLOR_W, msg);
    SendClientMessage(playerid, COLOR_W, msg);

    PlayChatAnimation(playerid, text);
    return 1;
}



CMD:mask(playerid, params[])
{
    pInfo[playerid][pMaskOn] = bool:!pInfo[playerid][pMaskOn];

    ApplyAnimation(playerid, "PED", "GANG_SIGN1", 4.0, 0, 0, 0, 0, 0);

    SendClientMessage(
        playerid,
        -1,
        pInfo[playerid][pMaskOn] ?
            "Anda memakai masker." :
            "Anda melepas masker."
    );
    return 1;
}

