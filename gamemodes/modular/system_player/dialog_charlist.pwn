// ======================================
// DIALOG PEMILIHAN & PEMBUATAN KARAKTER
// ======================================

// Menampilkan list karakter atau "+ Karakter Baru"
Dialog:DIALOG_ClIST(playerid, response, listitem, inputtext[])
{
    if(!response) return 1;

    // Slot kosong / buat karakter baru
    if(PlayerChar[playerid][listitem][0] == EOS)
    {
        return Dialog_Show(playerid, DIALOG_BUATCHAR, DIALOG_STYLE_INPUT,
        "Pembuatan Karakter", "Masukan nama karakter:\nContoh: Rudi_Tebudi", "Input", "");
    }

    // Pilih karakter & lanjut login char
    pInfo[playerid][pChar] = listitem;
    SetPlayerName(playerid, PlayerChar[playerid][listitem]);

    format(query, sizeof(query),
    "SELECT * FROM `users` WHERE `name`='%s' LIMIT 1;",
    PlayerChar[playerid][pInfo[playerid][pChar]]);

    mysql_tquery(handle, query, "LOAD_CHAR", "d", playerid);

    return 1;
}


// Membuat karakter baru
Dialog:DIALOG_BUATCHAR(playerid, response, listitem, inputtext[])
{
    if(!response) return 1;

    if(strlen(inputtext) < 1 || strlen(inputtext) > 24)
        return Dialog_Show(playerid, DIALOG_BUATCHAR, DIALOG_STYLE_INPUT,
        "Pembuatan Karakter", "{FF0000}Nama tidak valid!\nContoh: Rudi_Tebudi", "Input", "");

    if(!CekSimbol(inputtext))
        return Dialog_Show(playerid, DIALOG_BUATCHAR, DIALOG_STYLE_INPUT,
        "Pembuatan Karakter", "{FF0000}Format nama salah!\nHarus: Nama_Depan", "Input", "");

    new characterQuery[180];
    mysql_format(handle, characterQuery, sizeof characterQuery,
        "SELECT * FROM `users` WHERE `name`='%s'", inputtext);

    mysql_tquery(handle, characterQuery, "MemasukanDataPemain", "ds", playerid, inputtext);

    return 1;
}

