#include <YSI_Coding\y_hooks>

hook OnPlayerRequestClass(playerid)
{
	return 1;
}

hook OnPlayerRequestSpawn(playerid)
{
	if(!pInfo[playerid][pLoggedIn])
	{
		SendClientMessage(playerid, -1, "{FF0000}Anda harus masuk akun terlebih dahulu!");
		return 0;
	}
	return 1;
}

hook OnPlayerConnect(playerid)
{
    ResetPlayerData(playerid);
    Player_CheckUCP(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	//system menyimpan pemain saat dia meninggalkan server
	SaveUserStats(playerid);
	SetPlayerName(playerid, pInfo[playerid][pUCP]);
	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
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
