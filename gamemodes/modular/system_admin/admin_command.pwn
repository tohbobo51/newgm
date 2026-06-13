CMD:setadmin(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))
        return SendClientMessage(playerid, -1, "{FF0000}ERROR: Hanya RCON Admin.");

    new targetid, level;
    if(sscanf(params, "ui", targetid, level))
        return SendClientMessage(playerid, -1, "USAGE: /setadmin [playerid] [0-4]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Player tidak ditemukan.");

    if(level < ADMIN_NONE || level > ADMIN_DEV)
        return SendClientMessage(playerid, -1, "Level admin 0 - 4.");

    // ✅ update memory (aktif sekarang)
    pInfo[targetid][pAdminLevel] = level;

    // ✅ update DB UCP (permanen)
    mysql_format(handle, query, sizeof(query),
        "UPDATE dataucp SET admin_level=%d WHERE ucp='%e' LIMIT 1",
        level,
        pInfo[targetid][pUCP]
    );
    mysql_pquery(handle, query);

    new aIdent[64], tIdent[64], msg[180];
    FormatPlayerIdentity(playerid, aIdent, sizeof(aIdent));
    FormatPlayerIdentity(targetid, tIdent, sizeof(tIdent));

    format(msg, sizeof msg,
        "RCON %s menetapkan %s sebagai %s (Level %d)",
        aIdent, tIdent, GetAdminName(level), level
    );

    SendClientMessageToAll(0xFF9900FF, msg);
    return 1;
}

CMD:checkadmin(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))
        return SendClientMessage(playerid, -1, "{FF0000}ERROR: Hanya RCON Admin.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, -1, "USAGE: /checkadmin [playerid]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Player tidak ditemukan.");

    new tIdent[64], msg[144];
    FormatPlayerIdentity(targetid, tIdent, sizeof(tIdent));

    format(msg, sizeof msg,
        "%s adalah %s (Level %d)",
        tIdent,
        GetAdminName(pInfo[targetid][pAdminLevel]),
        pInfo[targetid][pAdminLevel]
    );

    SendClientMessage(playerid, 0x00FFFFFF, msg);
    return 1;
}

CMD:adminduty(playerid, params[])
{
    if(!IsAdmin(playerid))
        return SendClientMessage(playerid, -1, "ERROR: Kamu bukan admin.");

    pInfo[playerid][pAdminDuty] = bool:!pInfo[playerid][pAdminDuty];

    SendClientMessage(playerid, -1,
        pInfo[playerid][pAdminDuty] ?
        "{00FF00}Admin duty ON." :
        "{FF0000}Admin duty OFF."
    );
    return 1;
}

CMD:a(playerid, params[])
{
    if(!IsAdmin(playerid))
        return 1;

    if(isnull(params))
        return SendClientMessage(playerid, -1, "USAGE: /a [text]");

    new ident[64], msg[200];
    FormatPlayerIdentity(playerid, ident, sizeof(ident));

    format(msg, sizeof msg,
        "[ADMIN %s] %s: %s",
        GetAdminName(pInfo[playerid][pAdminLevel]),
        ident,
        params
    );

    foreach(new i : Player)
    {
        if(IsAdmin(i))
            SendClientMessage(i, 0xFF6600FF, msg);
    }
    return 1;
}

CMD:kick(playerid, params[])
{
    if(!IsAdmin(playerid, ADMIN_HELPER))
        return SendClientMessage(playerid, -1, "ERROR: Admin only.");

    new targetid;
    new reason[64];

    if(sscanf(params, "us[64]", targetid, reason))
        return SendClientMessage(playerid, -1, "USAGE: /kick [playerid] [reason]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Player tidak ditemukan.");

    new aIdent[64], tIdent[64], msg[200];
    FormatPlayerIdentity(playerid, aIdent, sizeof(aIdent));
    FormatPlayerIdentity(targetid, tIdent, sizeof(tIdent));

    format(msg, sizeof msg,
        "Admin %s menendang %s. Alasan: %s",
        aIdent, tIdent, reason
    );

    SendClientMessageToAll(0xFF0000FF, msg);
    Kick(targetid);
    return 1;
}

CMD:spec(playerid, params[])
{
    if(!IsAdmin(playerid, ADMIN_HELPER))
        return SendClientMessage(playerid, -1, "ERROR: Admin only.");

    // ✅ pencegahan: admin tidak boleh spec saat di kendaraan
    if(IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, -1, "ERROR: Turun dari kendaraan dulu sebelum spectate.");

    // ✅ pencegahan: admin tidak boleh spec saat sudah spectator
    if(pInfo[playerid][pSpectating])
        return SendClientMessage(playerid, -1, "ERROR: Kamu sedang spectate, gunakan /specoff dulu.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, -1, "USAGE: /spec [playerid]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Player tidak ditemukan.");

    if(targetid == playerid)
        return SendClientMessage(playerid, -1, "ERROR: Tidak bisa spectate diri sendiri.");

    // ✅ pencegahan: tidak boleh spectate admin yang sedang spectator juga
    if(pInfo[targetid][pSpectating])
        return SendClientMessage(playerid, -1, "ERROR: Target sedang spectator, tidak bisa di-spectate.");

    // ✅ simpan posisi admin sebelum spectate
    GetPlayerPos(playerid,
        pInfo[playerid][pSpecLastX],
        pInfo[playerid][pSpecLastY],
        pInfo[playerid][pSpecLastZ]
    );
    GetPlayerFacingAngle(playerid, pInfo[playerid][pSpecLastA]);
    pInfo[playerid][pSpecLastInt] = GetPlayerInterior(playerid);
    pInfo[playerid][pSpecLastVW]  = GetPlayerVirtualWorld(playerid);

    // set status
    pInfo[playerid][pSpectating] = true;
    pInfo[playerid][pSpecTarget] = targetid;

    TogglePlayerSpectating(playerid, true);

    // target di kendaraan -> spectate kendaraan, kalau tidak -> spectate player
    if(IsPlayerInAnyVehicle(targetid))
        PlayerSpectateVehicle(playerid, GetPlayerVehicleID(targetid));
    else
        PlayerSpectatePlayer(playerid, targetid);

    new tname[MAX_PLAYER_NAME], msg[128];
    GetPlayerNameEx(targetid, tname);

    format(msg, sizeof msg, "Kamu sekarang spectate: %s (ID: %d)", tname, targetid);
    SendClientMessage(playerid, 0x00FF00FF, msg);

    return 1;
}



CMD:specoff(playerid, params[])
{
    if(!IsAdmin(playerid, ADMIN_HELPER))
        return SendClientMessage(playerid, -1, "ERROR: Admin only.");

    if(!pInfo[playerid][pSpectating])
        return SendClientMessage(playerid, -1, "Kamu tidak sedang spectate.");

    // keluar spectate mode
    TogglePlayerSpectating(playerid, false);

    // reset status
    pInfo[playerid][pSpectating] = false;
    pInfo[playerid][pSpecTarget] = INVALID_PLAYER_ID;

    // ✅ BALIKIN POSISI
    SetPlayerInterior(playerid, pInfo[playerid][pSpecLastInt]);
    SetPlayerVirtualWorld(playerid, pInfo[playerid][pSpecLastVW]);

    SetPlayerPos(playerid,
        pInfo[playerid][pSpecLastX],
        pInfo[playerid][pSpecLastY],
        pInfo[playerid][pSpecLastZ]
    );
    SetPlayerFacingAngle(playerid, pInfo[playerid][pSpecLastA]);

    SendClientMessage(playerid, 0x00FF00FF, "Spectate dimatikan & posisi dikembalikan.");
    return 1;
}

CMD:goto(playerid, params[])
{
    if(!IsAdmin(playerid, ADMIN_HELPER))
        return SendClientMessage(playerid, -1, "ERROR: Admin only.");

    if(pInfo[playerid][pSpectating])
        return SendClientMessage(playerid, -1, "ERROR: Matikan spectate dulu (/specoff).");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, -1, "USAGE: /goto [playerid]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Player tidak ditemukan.");

    if(targetid == playerid)
        return SendClientMessage(playerid, -1, "ERROR: Tidak bisa goto diri sendiri.");

    if(pInfo[targetid][pSpectating])
        return SendClientMessage(playerid, -1, "ERROR: Target sedang spectate.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);

    SetPlayerInterior(playerid, GetPlayerInterior(targetid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));

    SetPlayerPos(playerid, x + 1.0, y, z);

    new aIdent[64], tIdent[64], msg[180];
    FormatPlayerIdentity(playerid, aIdent, sizeof aIdent);
    FormatPlayerIdentity(targetid, tIdent, sizeof tIdent);

    format(msg, sizeof msg, "[ADMIN] %s goto ke %s", aIdent, tIdent);
    SendClientMessage(playerid, 0x00FF00FF, msg);
    return 1;
}

CMD:gethere(playerid, params[])
{
    if(!IsAdmin(playerid, ADMIN_HELPER))
        return SendClientMessage(playerid, -1, "ERROR: Admin only.");

    if(pInfo[playerid][pSpectating])
        return SendClientMessage(playerid, -1, "ERROR: Matikan spectate dulu (/specoff).");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, -1, "USAGE: /gethere [playerid]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Player tidak ditemukan.");

    if(targetid == playerid)
        return SendClientMessage(playerid, -1, "ERROR: Tidak bisa gethere diri sendiri.");

    if(pInfo[targetid][pSpectating])
        return SendClientMessage(playerid, -1, "ERROR: Target sedang spectate.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    SetPlayerInterior(targetid, GetPlayerInterior(playerid));
    SetPlayerVirtualWorld(targetid, GetPlayerVirtualWorld(playerid));

    if(IsPlayerInAnyVehicle(targetid))
        RemovePlayerFromVehicle(targetid);

    SetPlayerPos(targetid, x + 1.0, y, z);

    new aIdent[64], tIdent[64], msg[180];
    FormatPlayerIdentity(playerid, aIdent, sizeof aIdent);
    FormatPlayerIdentity(targetid, tIdent, sizeof tIdent);

    format(msg, sizeof msg, "[ADMIN] %s menarik %s ke lokasi.", aIdent, tIdent);
    SendClientMessage(playerid, 0x00FF00FF, msg);
    SendClientMessage(targetid, 0xFF9900FF, "Kamu dipindahkan oleh admin.");
    return 1;
}

CMD:freeze(playerid, params[])
{
    if(!IsAdmin(playerid, ADMIN_MOD))
        return SendClientMessage(playerid, -1, "ERROR: Minimal Moderator.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, -1, "USAGE: /freeze [playerid]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Player tidak ditemukan.");

    TogglePlayerControllable(targetid, false);

    new aIdent[64], tIdent[64], msg[180];
    FormatPlayerIdentity(playerid, aIdent, sizeof aIdent);
    FormatPlayerIdentity(targetid, tIdent, sizeof tIdent);

    format(msg, sizeof msg, "[ADMIN] %s membekukan %s", aIdent, tIdent);
    SendClientMessage(playerid, 0xFF9900FF, msg);
    SendClientMessage(targetid, 0xFF0000FF, "Kamu dibekukan oleh admin.");
    return 1;
}

CMD:unfreeze(playerid, params[])
{
    if(!IsAdmin(playerid, ADMIN_MOD))
        return SendClientMessage(playerid, -1, "ERROR: Minimal Moderator.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, -1, "USAGE: /unfreeze [playerid]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Player tidak ditemukan.");

    TogglePlayerControllable(targetid, true);

    new aIdent[64], tIdent[64], msg[180];
    FormatPlayerIdentity(playerid, aIdent, sizeof aIdent);
    FormatPlayerIdentity(targetid, tIdent, sizeof tIdent);

    format(msg, sizeof msg, "[ADMIN] %s melepas freeze %s", aIdent, tIdent);
    SendClientMessage(playerid, 0xFF9900FF, msg);
    SendClientMessage(targetid, 0x00FF00FF, "Freeze kamu dilepas oleh admin.");
    return 1;
}
