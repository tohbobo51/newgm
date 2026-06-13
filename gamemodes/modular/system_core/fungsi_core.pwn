// ======================================
//  FUNGSI INTI SERVER (CORE FUNCTIONS)
//  Sistem dasar yang berjalan global di server
// ======================================


// --------------------------------------
// CORE: Startup Configuration (server info)
// --------------------------------------
main()
{
    new szCmd[64];

    format(szCmd, sizeof(szCmd), "hostname %s", NamaServer);
    SendRconCommand(szCmd);

    format(szCmd, sizeof(szCmd), "gamemodetext %s(%s)", GM_NAME, Versi);
    SendRconCommand(szCmd);

    format(szCmd, sizeof(szCmd), "language %s", Bahasa);
    SendRconCommand(szCmd);

    format(szCmd, sizeof(szCmd), "weburl %s", WEB);
    SendRconCommand(szCmd);

    return 1;
}


// --------------------------------------
// CORE: MySQL Connection Handler
// --------------------------------------
stock MySQL_SetupConnection(ttl = 3)
{
    print("[MySQL] Menghubungkan ke database...");

    handle = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DBSE);

    if(mysql_errno(handle) != 0)
    {
        if(ttl > 1)
        {
            print("[MySQL] Sambungan gagal, mencoba ulang...");
            printf("[MySQL] TTL tersisa: %d", ttl-1);
            return MySQL_SetupConnection(ttl-1);
        }
        print("[MySQL] Koneksi gagal total! Server dimatikan.");
        return SendRconCommand("exit");
    }

    printf("[MySQL] Koneksi berhasil. Handle: %d", _:handle);
    return 1;
}


// --------------------------------------
// UTIL UMUM SERVER
// --------------------------------------
stock GetName(playerid)
{
    GetPlayerName(playerid, pInfo[playerid][pName], MAX_PLAYER_NAME);
    return pInfo[playerid][pName];
}

stock KickEx(playerid, time = 500)
{
    SetTimerEx("_KickPlayerDelayed", time, false, "i", playerid);
    return 1;
}

Fungsi:_KickPlayerDelayed(playerid)
{
    Kick(playerid);
    return 1;
}

stock Float:GetDistanceBetweenPoints3D(
    Float:x1, Float:y1, Float:z1,
    Float:x2, Float:y2, Float:z2
)
{
    return VectorSize(
        x1 - x2,
        y1 - y2,
        z1 - z2
    );
}
