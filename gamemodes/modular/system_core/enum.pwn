// ======================================
// ENUM DATA PLAYER
// ======================================

enum pDataEnum
{
    p_id,
    bool:pLoggedIn,
    
    // akun
    pUCP[MAX_PLAYER_NAME],
    pVerifyCode,
    pPassword[BCRYPT_HASH_LENGTH],

    // karakter aktif
    pChar,
    pName[MAX_PLAYER_NAME],

    // info kesehatan
    Float:pHealth,
    Float:pArmour,

    // posisi & tampilan
    Float:pPosX,
    Float:pPosY,
    Float:pPosZ,
    Float:pAngle,
    pVW,
    pInt,
    pSkin,

    // progress pemain
    pLevel,
    pMoney,
    pKills,
    pDeaths,

    //staus masker
    bool:pMaskOn,

    //admin
    pAdminLevel,
    pPendingAdminLevel,
    bool:pAdminDuty,
    //spectate
    bool:pSpectating,
    pSpecTarget,
    Float:pSpecLastX,
    Float:pSpecLastY,
    Float:pSpecLastZ,
    Float:pSpecLastA,
    pSpecLastInt,
    pSpecLastVW

}

// ======================================
// VARIABEL ENUM PLAYER
// ======================================
new pInfo[MAX_PLAYERS][pDataEnum];