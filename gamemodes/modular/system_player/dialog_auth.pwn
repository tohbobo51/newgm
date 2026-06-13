// ======================================
// DIALOG AUTH SISTEM LOGIN & REGISTER
// ======================================

// Register Akun
Dialog:DIALOG_REGISTER(playerid, response, listitem, inputtext[])
{
    if(!response) return KickEx(playerid);

    if(strlen(inputtext) < 3)
        return Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,
        "Registrasi", "{FF0000}Minimal 3 karakter!\nSilakan masukan ulang.", "Lanjut", "Batal");

    // bcrypt hash password
    bcrypt_hash(playerid, "EnkripsiKataSandi", inputtext, BCRYPT_COST);

    Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,
    "Login", "Silahkan masuk ke akun anda:", "Masuk", "Batal");

    return 1;
}


// Login
Dialog:DIALOG_LOGIN(playerid, response, listitem, inputtext[])
{
    if(!response) return KickEx(playerid);

    if(strlen(inputtext) < 3)
    {
        return Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,
        "Login", "Silahkan masuk ke akun anda:\n{FF0000}Minimal 3 karakter!", "Masuk", "Batal");
    }

    bcrypt_verify(playerid, "OnPasswordVerify", inputtext, pInfo[playerid][pPassword]);
    return 1;
}


// Verifikasi Kode UCP
Dialog:DIALOG_VERIFIKASI(playerid, response, listitem, inputtext[])
{
    if(!response) return KickEx(playerid);

    if(!IsNumeric(inputtext))
        return Dialog_Show(playerid, DIALOG_VERIFIKASI, DIALOG_STYLE_PASSWORD,
        "Kode Verifikasi", "{FF0000}Kode harus angka!\nSilakan masukan ulang:", "Input", "Keluar");

    if(strval(inputtext) != pInfo[playerid][pVerifyCode])
        return Dialog_Show(playerid, DIALOG_VERIFIKASI, DIALOG_STYLE_PASSWORD,
        "Kode Verifikasi", "{FF0000}Kode salah! Coba lagi.", "Input", "Keluar");

    // Berhasil verifikasi
    SendClientMessage(playerid, -1, "{00FF00}Kode berhasil diverifikasi!");
    Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,
    "Registrasi", "Silakan buat password untuk akun Anda:", "Daftar", "Batal");

    return 1;
}
