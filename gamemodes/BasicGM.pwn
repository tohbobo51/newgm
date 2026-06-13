#include <a_samp>
#include <a_mysql>
#include <crashdetect>
#include <streamer>
#include <sscanf2>

// eksternal libs
#define EVF_Streamer
#include <EVF>
#include <easyDialog>

#define YSI_NO_HEAP_MALLOC
#include <YSI_Data\y_bit>
#include <YSI_Data\y_iterate>
#include <YSI_Coding\y_hooks>
#include <YSI_Visual\y_commands>
#include <YSI_Coding\y_timers>

// config (ganti MYSQL_LOCALHOST sesuai kebutuhan)
#define MYSQL_LOCALHOST

// LOAD ALL MODULES
#include "modular/loader_core.pwn"

public OnGameModeInit()
{
    MySQL_SetupConnection();
	ManualVehicleEngineAndLights();

    mysql_tquery(handle, "SELECT * FROM vehicles", "LoadVehicles");

    print(">> Basic GM Loaded Successfully");

    return 1;
}

public OnGameModeExit()
{
    mysql_close(handle);
    return 1;
}

CMD:settime(playerid, params[])
{
    new hour, minute;
    if(sscanf(params, "ii", hour, minute))
        return SendClientMessage(playerid, COLOR_YELLOW,
            "USAGE: /settime [jam] [menit]");

    if(hour < 0 || hour > 23 || minute < 0 || minute > 59)
        return SendClientMessage(playerid, COLOR_RED,
            "ERROR: Jam 0-23, menit 0-59.");

    SetWorldTime(hour);
    SetPlayerTime(playerid, hour, minute);

    new msg[64];
    format(msg, sizeof msg,
        "Waktu game di-set ke %02d:%02d", hour, minute);
    SendClientMessageToAll(COLOR_GREEN, msg);

    return 1;
}

CMD:setfuel(playerid, params[])
{
    new veh = GetTargetVehicle(playerid);
    if(veh == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, COLOR_RED,
            "ERROR: Tidak ada kendaraan milikmu.");

    if(IsNoEngineVehicle(veh))
        return SendClientMessage(playerid, COLOR_YELLOW,
            "Kendaraan ini tidak menggunakan bahan bakar.");

    if(!params[0])
        return SendClientMessage(playerid, COLOR_YELLOW,
            "USAGE: /setfuel [jumlah | full]");

    // FULL
    if(!strcmp(params, "full", true))
    {
        Vehicle[veh][vFuel] = 100.0;
        SetVehicleFuel(veh, 100);
        Vehicle[veh][vSave] = true;

        return SendClientMessage(playerid, COLOR_GREEN,
            "Fuel diisi penuh (100%).");
    }

    // ANGKA
    new fuel;
    if(sscanf(params, "i", fuel))
        return SendClientMessage(playerid, COLOR_RED,
            "ERROR: Masukkan angka atau 'full'.");

    if(fuel < 0 || fuel > 100)
        return SendClientMessage(playerid, COLOR_RED,
            "ERROR: Fuel 0 - 100.");

    Vehicle[veh][vFuel] = float(fuel);
    SetVehicleFuel(veh, fuel);
    Vehicle[veh][vSave] = true;

    new msg[64];
    format(msg, sizeof msg, "Fuel di-set ke %d%%", fuel);
    SendClientMessage(playerid, COLOR_GREEN, msg);

    return 1;
}

