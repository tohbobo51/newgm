// ======================================
// VEHICLE EVENT
// Handler event kendaraan
// ======================================
#include <YSI_Coding\y_hooks>

hook OnPlayerConnect(playerid)
{
    SpeedUI_Create(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    DespawnPlayerVehicles(playerid);
    return 1;
}

hook OnVehicleSpawn(vehicleid)
{
    if(!Vehicle[vehicleid][vExists])
        return 1;

    ChangeVehicleColor(
        vehicleid,
        Vehicle[vehicleid][vColor1],
        Vehicle[vehicleid][vColor2]
    );

    LinkVehicleToInterior(vehicleid, Vehicle[vehicleid][vInt]);
    SetVehicleVirtualWorld(vehicleid, Vehicle[vehicleid][vVW]);
    SetVehicleNumberPlate(vehicleid, Vehicle[vehicleid][vPlate]);
    SetVehicleHealth(vehicleid, Vehicle[vehicleid][vHealth]);
    return 1;
}
hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER)
        SpeedUI_Show(playerid);
    else if(oldstate == PLAYER_STATE_DRIVER)
        SpeedUI_Hide(playerid);
    return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid)
{
    if(Vehicle[vehicleid][vExists] &&
       Vehicle[vehicleid][vOwner] == pInfo[playerid][p_id])
    {
        Vehicle[vehicleid][vSave] = true;
    }
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid)
{
    if(!Vehicle[vehicleid][vExists])
        return 1;

    Vehicle[vehicleid][vHealth] = 250.0;
    Vehicle[vehicleid][vSave]   = true;

    // nanti bisa ditambah:
    // insurance / impound / respawn delay
    return 1;
}

// ================================
// CHECKPOINT EVENT
// ================================

hook OnPlayerEnterCheckpoint(playerid)
{
    DisablePlayerCheckpoint(playerid);
    SendClientMessage(playerid, COLOR_GREEN,
        "Kamu telah sampai di lokasi kendaraan.");
    return 1;
}
