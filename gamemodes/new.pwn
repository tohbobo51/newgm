#include <a_samp>
#include <a_mysql>
#include "../include/gl_common.inc"
#include <crashdetect>

//baru
#include <easyDialog>
#include <sscanf2>
#include <Pawn.CMD>

#include <YSI_Data\y_bit>
#include <YSI_Data\y_iterate>
#include <YSI_Coding\y_hooks>

#define MYSQL_LOCALHOST

//
#include "modular/core.pwn"

public OnGameModeInit()
{
	MySQL_SetupConnection();
	// SPECIAL
	total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/trains.txt");
	total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/pilots.txt");

   	// LAS VENTURAS
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/lv_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/lv_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/lv_gen.txt");
    
    // SAN FIERRO
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/sf_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/sf_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/sf_gen.txt");
    
    // LOS SANTOS
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_law.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_airport.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_gen_inner.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/ls_gen_outer.txt");
    
    // OTHER AREAS
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/whetstone.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/bone.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/flint.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/tierra.txt");
    total_vehicles_from_files += LoadStaticVehiclesFromFile("vehicles/red_county.txt");

    printf("Total vehicles from files: %d",total_vehicles_from_files);

	return 1;
}

public OnGameModeExit()
{
	mysql_close(handle);
	return 1;
}

public OnPlayerConnect(playerid)
{
	resertenum(playerid);
	return 1;
}

public OnPlayerRequestClass(playerid)
{
	if(!pInfo[playerid][pLoggedIn])
	{

	 	GetPlayerName(playerid, pInfo[playerid][pUCP], MAX_PLAYER_NAME);
		mysql_format(handle, query, sizeof query, "SELECT * FROM `dataucp` WHERE `ucp` = '%e' LIMIT 1", pInfo[playerid][pUCP]);
		mysql_pquery(handle, query, "OnUserCheck", "d", playerid);
	}
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	if(!pInfo[playerid][pLoggedIn])
	{
		SendClientMessage(playerid, -1, "{FF0000}Anda harus masuk akun terlebih dahulu!");
		return 0;
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	//system menyimpan pemain saat dia meninggalkan server
	SaveUserStats(playerid);
	SetPlayerName(playerid, pInfo[playerid][pUCP]);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	//contoh kode saat mati
	if(killerid != INVALID_PLAYER_ID)
	{
		pInfo[killerid][pKills]++;
		GivePlayerMoney(killerid, 500);
		pInfo[killerid][pMoney] += 10;
		if(pInfo[killerid][pKills] > 3)
		{
			pInfo[killerid][pLevel] = 1;
		}
	}
	pInfo[playerid][pDeaths]++;
	return 1;
}
