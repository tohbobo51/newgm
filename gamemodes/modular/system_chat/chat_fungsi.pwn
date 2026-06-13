stock SendProximityMessage(playerid, Float:radius, color, const text[])
{
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    foreach(new i : Player)
    {
        if(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid)) continue;
        if(GetPlayerInterior(i) != GetPlayerInterior(playerid)) continue;

        new Float:ix, Float:iy, Float:iz;
        GetPlayerPos(i, ix, iy, iz);

        if(GetDistanceBetweenPoints3D(px, py, pz, ix, iy, iz) <= radius)
            SendClientMessage(i, color, text);
    }
    return 1;
}

stock GetRPName(playerid, out[], len)
{
    if(pInfo[playerid][pMaskOn]) // NANTI AKTIF
        format(out, len, "Masked Person");
    else
        GetPlayerName(playerid, out, len);

    return 1;
}


// ======================================
// CHAT ANIMATION HELPER
// ======================================

new LastAnimTick[MAX_PLAYERS];

stock PlayChatAnimation(playerid, const text[])
{
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        return 1;

    // anti spam
    if(GetTickCount() - LastAnimTick[playerid] < 800)
        return 1;

    LastAnimTick[playerid] = GetTickCount();

    // durasi sesuai panjang teks
    new len = strlen(text);
    new duration = len * 35; // 35ms per char (bisa kamu atur)

    if(duration < 800) duration = 800;
    if(duration > 4000) duration = 4000;

    // loop ON + freeze OFF -> lebih enak (bisa jalan)
    ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.1, 1, 0, 0, 0, 0);

    SetTimerEx("StopChatAnim", duration, false, "d", playerid);
    return 1;
}

Fungsi:StopChatAnim(playerid)
{
    if(!IsPlayerConnected(playerid))
        return 0;

    ClearAnimations(playerid);
    return 1;
}
