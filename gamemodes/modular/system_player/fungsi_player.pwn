// SYSTEM PLAYER FUNCTIONS
// Fungsi inti sistem akun & karakter
// -----------------------------------
#include <samp_bcrypt>
#include <YSI_Coding\y_hooks>

stock ResetPlayerData(playerid)
{
    pInfo[playerid][p_id]        = 0;
    pInfo[playerid][pLoggedIn]   = false;
    pInfo[playerid][pLevel]      = 0;
    pInfo[playerid][pMoney]      = 0;
    pInfo[playerid][pKills]      = 0;
    pInfo[playerid][pDeaths]     = 0;
    pInfo[playerid][pInt]        = 0;
    pInfo[playerid][pVW]         = 0;
    pInfo[playerid][pSkin]       = 0;
    pInfo[playerid][pVerifyCode] = 0;

    // admin
    pInfo[playerid][pAdminLevel]    = 0;
    pInfo[playerid][pPendingAdminLevel] = 0;
    pInfo[playerid][pAdminDuty]     = false;
    pInfo[playerid][pSpectating]    = false;
    pInfo[playerid][pSpecTarget]    = INVALID_PLAYER_ID;
    return 1;
}

stock Player_CheckUCP(playerid)
{
    GetPlayerName(playerid, pInfo[playerid][pUCP], MAX_PLAYER_NAME);

    mysql_format(handle, query, sizeof query,
        "SELECT * FROM dataucp WHERE ucp = '%e' LIMIT 1",
        pInfo[playerid][pUCP]);

    mysql_pquery(handle, query, "OnUserCheck", "d", playerid);
    return 1;
}

Fungsi:EnkripsiKataSandi(playerid, hashid)
{
    bcrypt_get_hash(
        pInfo[playerid][pPassword],
        BCRYPT_HASH_LENGTH
    );

    mysql_format(handle, query, sizeof query,
        "UPDATE dataucp SET katasandi='%e', aktivasi=1 WHERE ucp='%e'",
        pInfo[playerid][pPassword],
        pInfo[playerid][pUCP]
    );

    mysql_pquery(handle, query);
    return 1;
}

// Verifikasi password login
Fungsi:OnPasswordVerify(playerid, bool:success)
{
    if(success)
    {
        pInfo[playerid][pAdminLevel] = pInfo[playerid][pPendingAdminLevel];
        CheckPemainChar(playerid);
    }
    else
    {
        Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,
        "Login", "Silahkan masuk ke akun anda:\n{FF0000}Kata sandi salah!", "Masuk", "Batal");
    }
    return 1;
}

// Mengecek apakah akun UCP terdaftar
Fungsi:OnUserCheck(playerid)
{
    new rows;
    cache_get_row_count(rows);

    if(rows == 0)
        return KickEx(playerid),
        Dialog_Show(playerid, DIALOG_NONE_UCP, DIALOG_STYLE_MSGBOX,
        "Akun tidak terdaftar", "Silakan daftarkan diri Anda di UCP", "Tutup", "");

    new aktivasi;
    cache_get_value_name_int(0, "aktivasi", aktivasi);
    // ✅ LOAD ADMIN LEVEL DARI dataucp
    cache_get_value_name_int(0, "admin_level", pInfo[playerid][pPendingAdminLevel]);

    if(aktivasi == 1)
    {
        cache_get_value_name(0, "katasandi", pInfo[playerid][pPassword], 65);
        Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,
        "Login", "Silahkan masuk ke akun anda:", "Masuk", "Batal");
    }
    else
    {
        cache_get_value_name_int(0, "verifikasi", pInfo[playerid][pVerifyCode]);

        new str[256];
        format(str, sizeof(str),
        "{FFFFFF}Halo, {FFFF00}%s{FFFFFF}!\n\
        Kami membutuhkan kode verifikasi.\n\
        Silakan cek kode verifikasi di Discord.",
        pInfo[playerid][pUCP]);

        Dialog_Show(playerid, DIALOG_VERIFIKASI, DIALOG_STYLE_PASSWORD,
        "Kode Verifikasi", str, "Input", "Keluar");
    }
    return 1;
}

// Cek daftar karakter dan proses login char
Fungsi:CheckPemainChar(playerid)
{
    format(query, sizeof(query),
    "SELECT `name`, `level` FROM `users` WHERE `ucp`='%s' LIMIT %d;",
    pInfo[playerid][pUCP], MAX_CHARS);

    mysql_tquery(handle, query, "LoadChar", "d", playerid);
    return 1;
}

// Load karakter dari database
Fungsi:LoadChar(playerid)
{
    for(new i = 0; i < MAX_CHARS; i++)
        PlayerChar[playerid][i][0] = EOS;

    for(new i = 0; i < cache_num_rows(); i++)
        cache_get_value_name(i, "name", PlayerChar[playerid][i]);

    ShowCharacterList(playerid);
    return 1;
}

// List karakter player
ShowCharacterList(playerid)
{
    new name[256], count, sgstr[128];

    for(new i; i < MAX_CHARS; i++)
    {
        if(PlayerChar[playerid][i][0] != EOS)
        {
            format(sgstr, sizeof(sgstr), "%s\n", PlayerChar[playerid][i]);
            strcat(name, sgstr);
            count++;
        }
    }
    if(count < MAX_CHARS) strcat(name, "+ Karakter Baru");

    Dialog_Show(playerid, DIALOG_ClIST, DIALOG_STYLE_LIST,
    "Characters List", name, "Select", "Quit");

    return 1;
}

// Validasi nama karakter (pakai underscore & huruf kapital)
stock CekSimbol(const player[])
{
    for(new n = 0; n < strlen(player); n++)
    {
        if(player[n] == '_' && player[n+1] >= 'A' && player[n+1] <= 'Z') return 1;
        if(player[n] == ']' || player[n] == '[') return 0;
    }
    return 0;
}

// Membuat karakter baru
Fungsi:MemasukanDataPemain(playerid, name[])
{
    new count = cache_num_rows(), Cache:execute;

    if(count > 0)
        return Dialog_Show(playerid, DIALOG_BUATCHAR, DIALOG_STYLE_INPUT,
        "Pembuatan Karakter", "Nama tidak valid / sudah digunakan!", "Input", "");

    mysql_format(handle, query, sizeof(query),
    "INSERT INTO `users` (`name`,`ucp`) VALUES('%s','%s')",
    name, pInfo[playerid][pUCP]);

    execute = mysql_query(handle, query);
    pInfo[playerid][p_id] = cache_insert_id();
    cache_delete(execute);

    format(pInfo[playerid][pName], MAX_PLAYER_NAME, name);
    SetPlayerName(playerid, name);

    pInfo[playerid][pLoggedIn] = true;
    SendClientMessage(playerid, -1, "[Account] Pendaftaran berhasil.");
    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);

    SetSpawnInfo(playerid, 0, 98, 1682.6084, -2327.8940, 13.5469, 3.4335, 0, 0, 0, 0, 0, 0);
    SpawnPlayer(playerid);

    return 1;
}

// ======================================
// LOAD DATA KARAKTER DARI DATABASE
// Dipanggil setelah karakter dipilih di dialog list
// ======================================
Fungsi:LOAD_CHAR(playerid)
{
    // Ambil ID karakter (wajib)
    cache_get_value_name_int(0, "id", pInfo[playerid][p_id]);
    if(pInfo[playerid][p_id] < 1)
    {
        SendClientMessage(playerid, -1, "Database player not found!");
        KickEx(playerid);
        return 1;
    }

    // Data utama karakter
    cache_get_value_name_float(0, "health", pInfo[playerid][pHealth]);
    cache_get_value_name_float(0, "armour", pInfo[playerid][pArmour]);
    cache_get_value_name_float(0, "posx", pInfo[playerid][pPosX]);
    cache_get_value_name_float(0, "posy", pInfo[playerid][pPosY]);
    cache_get_value_name_float(0, "posz", pInfo[playerid][pPosZ]);
    cache_get_value_name_float(0, "angel", pInfo[playerid][pAngle]);

    // Interior / dunia / skin / level
    cache_get_value_name_int(0, "interior", pInfo[playerid][pInt]);
    cache_get_value_name_int(0, "virtualworld", pInfo[playerid][pVW]);
    cache_get_value_name_int(0, "skin", pInfo[playerid][pSkin]);
    cache_get_value_name_int(0, "level", pInfo[playerid][pLevel]);
    cache_get_value_name_int(0, "money", pInfo[playerid][pMoney]);
    cache_get_value_name_int(0, "kills", pInfo[playerid][pKills]);
    cache_get_value_name_int(0, "deaths", pInfo[playerid][pDeaths]);

    // Set login
    pInfo[playerid][pLoggedIn] = true;
    SendClientMessage(playerid, -1, "[Account] Masuk berhasil!");

    // Apply data ke player di in-game
    SetPlayerHealth(playerid, pInfo[playerid][pHealth]);
    SetPlayerArmour(playerid, pInfo[playerid][pArmour]);
    GivePlayerMoney(playerid, pInfo[playerid][pMoney]);

    SetSpawnInfo(playerid, 0,
        pInfo[playerid][pSkin],
        pInfo[playerid][pPosX], pInfo[playerid][pPosY], pInfo[playerid][pPosZ], pInfo[playerid][pAngle],
        -1, -1, -1, -1, -1, -1
    );

    SpawnPlayer(playerid);
    GetName(playerid);
    SetPlayerInterior(playerid, pInfo[playerid][pInt]);
    SetPlayerVirtualWorld(playerid, pInfo[playerid][pVW]);

    // Spawn kendaraan player
    SpawnPlayerVehicles(playerid);
    return 1;
}

// simpan data player saat logout / exit
Fungsi:SaveUserStats(playerid)
{
    if(!pInfo[playerid][pLoggedIn]) return 1;

    GetPlayerHealth(playerid, pInfo[playerid][pHealth]);
    GetPlayerArmour(playerid, pInfo[playerid][pArmour]);
    GetPlayerPos(playerid, pInfo[playerid][pPosX], pInfo[playerid][pPosY], pInfo[playerid][pPosZ]);
    GetPlayerFacingAngle(playerid, pInfo[playerid][pAngle]);
    pInfo[playerid][pMoney] = GetPlayerMoney(playerid);
    pInfo[playerid][pInt]   = GetPlayerInterior(playerid);
    pInfo[playerid][pVW]    = GetPlayerVirtualWorld(playerid);
    pInfo[playerid][pSkin]  = GetPlayerSkin(playerid);

    mysql_format(handle, query, sizeof(query),
    "UPDATE users SET health='%f', armour='%f', posx='%f', posy='%f', posz='%f',\
    angel='%f', interior='%d', virtualworld='%d', skin='%d', level='%d', money='%d',\
    kills='%d', deaths='%d' WHERE id='%d'",
    pInfo[playerid][pHealth], pInfo[playerid][pArmour],
    pInfo[playerid][pPosX], pInfo[playerid][pPosY], pInfo[playerid][pPosZ], pInfo[playerid][pAngle],
    pInfo[playerid][pInt], pInfo[playerid][pVW], pInfo[playerid][pSkin],
    pInfo[playerid][pLevel], pInfo[playerid][pMoney], pInfo[playerid][pKills], pInfo[playerid][pDeaths],
    pInfo[playerid][p_id]);

    mysql_pquery(handle, query);
    return 1;
}

stock GetPlayerNameEx(playerid, name[], len = sizeof(name))
{
    // jika pakai sistem masker
    if(pInfo[playerid][pMaskOn])
    {
        format(name, len, "Orang Bertopeng");
        return 1;
    }

    // pakai nama karakter jika sudah login
    if(pInfo[playerid][pLoggedIn])
    {
        format(name, len, "%s", pInfo[playerid][pName]);
        return 1;
    }

    // fallback (belum login)
    GetPlayerName(playerid, name, len);
    return 1;
}

stock FormatPlayerIdentity(playerid, out[], len)
{
    new cname[MAX_PLAYER_NAME];

    GetPlayerNameEx(playerid, cname, sizeof cname);

    if(!pInfo[playerid][pUCP][0])
    {
        format(out, len, "%s", cname);
        return 1;
    }

    format(out, len, "(UCP:%s) %s", pInfo[playerid][pUCP], cname);
    return 1;
}