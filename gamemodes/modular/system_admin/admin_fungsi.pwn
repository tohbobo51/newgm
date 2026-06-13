#if defined _ADMIN_FUNC_INCLUDED
    #endinput
#endif
#define _ADMIN_FUNC_INCLUDED

stock bool:IsAdmin(playerid, level = ADMIN_HELPER)
{
    return (pInfo[playerid][pAdminLevel] >= level);
}

stock bool:IsDev(playerid)
{
    return pInfo[playerid][pAdminLevel] == ADMIN_DEV;
}

stock GetAdminName(level)
{
    static name[16];
    switch(level)
    {
        case ADMIN_HELPER: name = "Helper";
        case ADMIN_MOD:    name = "Moderator";
        case ADMIN_ADMIN:  name = "Administrator";
        case ADMIN_DEV:    name = "Developer";
        default:           name = "Player";
    }
    return name;
}

