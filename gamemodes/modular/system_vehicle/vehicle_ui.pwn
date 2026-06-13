// ======================================
// VEHICLE UI - SPEEDOMETER
// ======================================
new PlayerText:SpeedTD[MAX_PLAYERS][10];
new bool:SpeedTDShown[MAX_PLAYERS];

stock SpeedUI_Create(playerid)
{
    SpeedTD[playerid][0] = CreatePlayerTextDraw(playerid, 215.599945, 345.306762, "box");
    PlayerTextDrawLetterSize(playerid, SpeedTD[playerid][0], 0.000000, 10.319998);
    PlayerTextDrawTextSize(playerid, SpeedTD[playerid][0], 417.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, SpeedTD[playerid][0], 1);
    PlayerTextDrawColor(playerid, SpeedTD[playerid][0], -1);
    PlayerTextDrawUseBox(playerid, SpeedTD[playerid][0], 1);
    PlayerTextDrawBoxColor(playerid, SpeedTD[playerid][0], 150);
    PlayerTextDrawSetShadow(playerid, SpeedTD[playerid][0], 0);
    PlayerTextDrawBackgroundColor(playerid, SpeedTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, SpeedTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, SpeedTD[playerid][0], 1);

    SpeedTD[playerid][1] = CreatePlayerTextDraw(playerid, 215.599960, 326.640045, "Sultan");
    PlayerTextDrawLetterSize(playerid, SpeedTD[playerid][1], 0.593600, 2.443732);
    PlayerTextDrawAlignment(playerid, SpeedTD[playerid][1], 1);
    PlayerTextDrawColor(playerid, SpeedTD[playerid][1], -1);
    PlayerTextDrawSetShadow(playerid, SpeedTD[playerid][1], 0);
    PlayerTextDrawSetOutline(playerid, SpeedTD[playerid][1], 2);
    PlayerTextDrawBackgroundColor(playerid, SpeedTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, SpeedTD[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, SpeedTD[playerid][1], 1);

    SpeedTD[playerid][2] = CreatePlayerTextDraw(playerid, 217.200012, 352.026611, "SpeedTD_:_100km");
    PlayerTextDrawLetterSize(playerid, SpeedTD[playerid][2], 0.400000, 1.600000);
    PlayerTextDrawAlignment(playerid, SpeedTD[playerid][2], 1);
    PlayerTextDrawColor(playerid, SpeedTD[playerid][2], -1);
    PlayerTextDrawSetShadow(playerid, SpeedTD[playerid][2], 0);
    PlayerTextDrawBackgroundColor(playerid, SpeedTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, SpeedTD[playerid][2], 2);
    PlayerTextDrawSetProportional(playerid, SpeedTD[playerid][2], 1);

    SpeedTD[playerid][3] = CreatePlayerTextDraw(playerid, 218.099990, 368.453277, "Fuel___:_100L");
    PlayerTextDrawLetterSize(playerid, SpeedTD[playerid][3], 0.415200, 1.585066);
    PlayerTextDrawAlignment(playerid, SpeedTD[playerid][3], 1);
    PlayerTextDrawColor(playerid, SpeedTD[playerid][3], -1);
    PlayerTextDrawSetShadow(playerid, SpeedTD[playerid][3], 0);
    PlayerTextDrawBackgroundColor(playerid, SpeedTD[playerid][3], 255);
    PlayerTextDrawFont(playerid, SpeedTD[playerid][3], 2);
    PlayerTextDrawSetProportional(playerid, SpeedTD[playerid][3], 1);

    SpeedTD[playerid][4] = CreatePlayerTextDraw(playerid, 217.349807, 382.393157, "health_:_100");
    PlayerTextDrawLetterSize(playerid, SpeedTD[playerid][4], 0.336800, 1.801599);
    PlayerTextDrawAlignment(playerid, SpeedTD[playerid][4], 1);
    PlayerTextDrawColor(playerid, SpeedTD[playerid][4], -1);
    PlayerTextDrawSetShadow(playerid, SpeedTD[playerid][4], 0);
    PlayerTextDrawBackgroundColor(playerid, SpeedTD[playerid][4], 255);
    PlayerTextDrawFont(playerid, SpeedTD[playerid][4], 2);
    PlayerTextDrawSetProportional(playerid, SpeedTD[playerid][4], 1);

    SpeedTD[playerid][5] = CreatePlayerTextDraw(playerid, 217.349807, 398.073211, "Mileage:_100KM");
    PlayerTextDrawLetterSize(playerid, SpeedTD[playerid][5], 0.336800, 1.801599);
    PlayerTextDrawAlignment(playerid, SpeedTD[playerid][5], 1);
    PlayerTextDrawColor(playerid, SpeedTD[playerid][5], -1);
    PlayerTextDrawSetShadow(playerid, SpeedTD[playerid][5], 0);
    PlayerTextDrawBackgroundColor(playerid, SpeedTD[playerid][5], 255);
    PlayerTextDrawFont(playerid, SpeedTD[playerid][5], 2);
    PlayerTextDrawSetProportional(playerid, SpeedTD[playerid][5], 1);

    SpeedTD[playerid][6] = CreatePlayerTextDraw(playerid, 239.549896, 422.960083, "Engine");
    PlayerTextDrawLetterSize(playerid, SpeedTD[playerid][6], 0.400000, 1.600000);
    PlayerTextDrawTextSize(playerid, SpeedTD[playerid][6], 0.000000, 43.000000);
    PlayerTextDrawAlignment(playerid, SpeedTD[playerid][6], 2);
    PlayerTextDrawColor(playerid, SpeedTD[playerid][6], -1);
    PlayerTextDrawUseBox(playerid, SpeedTD[playerid][6], 1);
    PlayerTextDrawBoxColor(playerid, SpeedTD[playerid][6], 8388863);
    PlayerTextDrawSetShadow(playerid, SpeedTD[playerid][6], 0);
    PlayerTextDrawBackgroundColor(playerid, SpeedTD[playerid][6], -2147483393);
    PlayerTextDrawFont(playerid, SpeedTD[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, SpeedTD[playerid][6], 1);

    SpeedTD[playerid][7] = CreatePlayerTextDraw(playerid, 291.351623, 423.103790, "Lights");
    PlayerTextDrawLetterSize(playerid, SpeedTD[playerid][7], 0.400000, 1.600000);
    PlayerTextDrawTextSize(playerid, SpeedTD[playerid][7], 0.000000, 43.000000);
    PlayerTextDrawAlignment(playerid, SpeedTD[playerid][7], 2);
    PlayerTextDrawColor(playerid, SpeedTD[playerid][7], -1);
    PlayerTextDrawUseBox(playerid, SpeedTD[playerid][7], 1);
    PlayerTextDrawBoxColor(playerid, SpeedTD[playerid][7], -2147483393);
    PlayerTextDrawSetShadow(playerid, SpeedTD[playerid][7], 0);
    PlayerTextDrawBackgroundColor(playerid, SpeedTD[playerid][7], -2147483393);
    PlayerTextDrawFont(playerid, SpeedTD[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, SpeedTD[playerid][7], 1);

    SpeedTD[playerid][8] = CreatePlayerTextDraw(playerid, 341.351501, 423.250610, "Door");
    PlayerTextDrawLetterSize(playerid, SpeedTD[playerid][8], 0.400000, 1.600000);
    PlayerTextDrawTextSize(playerid, SpeedTD[playerid][8], 0.000000, 39.000000);
    PlayerTextDrawAlignment(playerid, SpeedTD[playerid][8], 2);
    PlayerTextDrawColor(playerid, SpeedTD[playerid][8], -1);
    PlayerTextDrawUseBox(playerid, SpeedTD[playerid][8], 1);
    PlayerTextDrawBoxColor(playerid, SpeedTD[playerid][8], -2147483393);
    PlayerTextDrawSetShadow(playerid, SpeedTD[playerid][8], 0);
    PlayerTextDrawBackgroundColor(playerid, SpeedTD[playerid][8], -2147483393);
    PlayerTextDrawFont(playerid, SpeedTD[playerid][8], 1);
    PlayerTextDrawSetProportional(playerid, SpeedTD[playerid][8], 1);

    SpeedTD[playerid][9] = CreatePlayerTextDraw(playerid, 392.550323, 423.297393, "Trunk");
    PlayerTextDrawLetterSize(playerid, SpeedTD[playerid][9], 0.400000, 1.600000);
    PlayerTextDrawTextSize(playerid, SpeedTD[playerid][9], 0.000000, 47.000000);
    PlayerTextDrawAlignment(playerid, SpeedTD[playerid][9], 2);
    PlayerTextDrawColor(playerid, SpeedTD[playerid][9], -1);
    PlayerTextDrawUseBox(playerid, SpeedTD[playerid][9], 1);
    PlayerTextDrawBoxColor(playerid, SpeedTD[playerid][9], -2147483393);
    PlayerTextDrawSetShadow(playerid, SpeedTD[playerid][9], 0);
    PlayerTextDrawBackgroundColor(playerid, SpeedTD[playerid][9], -2147483393);
    PlayerTextDrawFont(playerid, SpeedTD[playerid][9], 1);
    PlayerTextDrawSetProportional(playerid, SpeedTD[playerid][9], 1);

    return 1;
}

stock SpeedUI_Show(playerid)
{
    if(SpeedTDShown[playerid]) return 1;
    new veh = GetPlayerVehicleID(playerid);
    new str[64];
    format(str, sizeof str, "%s", GetVehicleName(veh));
    PlayerTextDrawSetString(playerid, SpeedTD[playerid][1], str);
    if(IsNoEngineVehicle(veh))
    {
        for(new i; i < 6; i++)
            PlayerTextDrawShow(playerid, SpeedTD[playerid][i]);
    }else{

        PlayerTextDrawBoxColor(
            playerid,
            SpeedTD[playerid][6],
            GetVehicleParams(veh, VEHICLE_TYPE_ENGINE) ? 8388863 : -2147483393
        );
        PlayerTextDrawBoxColor(
            playerid,
            SpeedTD[playerid][7],
            GetVehicleParams(veh, VEHICLE_TYPE_LIGHTS) ? 8388863 : -2147483393
        );
        PlayerTextDrawBoxColor(
            playerid,
            SpeedTD[playerid][8],
            GetVehicleParams(veh, VEHICLE_TYPE_DOORS) ? 8388863 : -2147483393
        );
        PlayerTextDrawBoxColor(
            playerid,
            SpeedTD[playerid][9],
            GetVehicleParams(veh, VEHICLE_TYPE_BOOT) ? 8388863 : -2147483393
        );
        for(new i; i < 10; i++)
            PlayerTextDrawShow(playerid, SpeedTD[playerid][i]);
    }
    SpeedTDShown[playerid] = true;
    return 1;
}

stock SpeedUI_Hide(playerid)
{
    if(!SpeedTDShown[playerid]) return 1;

    for(new i; i < 10; i++)
        PlayerTextDrawHide(playerid, SpeedTD[playerid][i]);

    SpeedTDShown[playerid] = false;
    return 1;
}

stock SpeedUI_Update(playerid)
{
    if(!SpeedTDShown[playerid]) return 1;

    new veh = GetPlayerVehicleID(playerid);
    if(veh == INVALID_VEHICLE_ID) return 1;

    new str[64];

    format(str, sizeof str, "%s", GetVehicleName(veh));
    PlayerTextDrawSetString(playerid, SpeedTD[playerid][1], str);

    format(str, sizeof str, "Speed: %.0f km/h", EVF::GetVehicleSpeed(veh));
    PlayerTextDrawSetString(playerid, SpeedTD[playerid][2], str);

    if(IsNoEngineVehicle(veh))
    {
        PlayerTextDrawSetString(playerid, SpeedTD[playerid][3], "Fuel: N/A");
        PlayerTextDrawSetString(playerid, SpeedTD[playerid][4], "Health: N/A");
    }else{
        format(str, sizeof str, "Fuel: %.0f%%", Vehicle[veh][vFuel]);
        PlayerTextDrawSetString(playerid, SpeedTD[playerid][3], str);

        format(str, sizeof str, "Health: %.0f", Vehicle[veh][vHealth]);
        PlayerTextDrawSetString(playerid, SpeedTD[playerid][4], str);
    }

    format(str, sizeof str, "Mileage: %.1f KM", Vehicle[veh][vMileage]);
    PlayerTextDrawSetString(playerid, SpeedTD[playerid][5], str);

    return 1;
}

// =====================================================
// VEHICLE CONTROL PANEL (UI)
// Menggunakan dialog
// =====================================================

new VCP_CurrentVeh[MAX_PLAYERS];
new VCP_NeonColorSel[MAX_PLAYERS];


// =====================================================
// OPEN CONTROL PANEL
// =====================================================
stock VCP_Open(playerid)
{
    new veh = GetTargetVehicle(playerid);
    if(veh == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, COLOR_RED, "ERROR: Tidak ada kendaraan milikmu di sekitar.");

    VCP_CurrentVeh[playerid] = veh;

    new dlg[256];
    format(dlg, sizeof dlg,
        "Engine\n\
        Lock\n\
        Lights\n\
        Hood\n\
        Boot\n\
        Speed Cap\n\
        Neon\n\
        Park"
    );

    Dialog_Show(playerid, VCP_Main, DIALOG_STYLE_LIST,
        "Vehicle Control Panel",
        dlg,
        "Select",
        "Close"
    );
    return 1;
}


// =====================================================
// MAIN DIALOG HANDLER
// =====================================================
Dialog:VCP_Main(playerid, response, listitem, inputtext[])
{
    if(!response) return 1;

    new veh = VCP_CurrentVeh[playerid];
    if(veh == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, COLOR_RED, "ERROR: Kendaraan tidak valid.");

    switch(listitem)
    {
        // ================= ENGINE =================
        case 0:
        {
            if(!IsNoEngineVehicle(veh))
            {
                if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                    ToggleParam(veh, VEHICLE_TYPE_ENGINE);
                    SendClientMessage(playerid, COLOR_GREEN, "Engine toggled.");

                    PlayerTextDrawBoxColor(
                        playerid,
                        SpeedTD[playerid][6],
                        GetVehicleParams(veh, VEHICLE_TYPE_ENGINE) ? 8388863 : -2147483393
                    );
                    PlayerTextDrawShow(playerid, SpeedTD[playerid][6]);

                    Vehicle[veh][vSave] = true;

                }
                else
                {
                    SendClientMessage(playerid, COLOR_RED, "ERROR: Kamu harus mengemudi kendaraan.");
                }
            }
            else
            {
                SendClientMessage(playerid, COLOR_YELLOW, "Kendaraan ini tidak menggunakan mesin.");
            }
            VCP_Open(playerid);
        }

        // ================= LOCK =================
        case 1:
        {
            new st = ToggleParam(veh, VEHICLE_TYPE_DOORS);
            Vehicle[veh][vLock] = st;
            Vehicle[veh][vSave] = true;

            SendClientMessage(playerid, COLOR_GREEN,
                st ? "Locked." : "Unlocked."
            );

            if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && !IsNoEngineVehicle(veh))
            {
                PlayerTextDrawBoxColor(
                    playerid,
                    SpeedTD[playerid][8],
                    GetVehicleParams(veh, VEHICLE_TYPE_DOORS) ? 8388863 : -2147483393
                );
                PlayerTextDrawShow(playerid, SpeedTD[playerid][8]);
            }

            VCP_Open(playerid);
        }

        // ================= LIGHTS =================
        case 2:
        {
            ToggleParam(veh, VEHICLE_TYPE_LIGHTS);
            SendClientMessage(playerid, COLOR_GREEN, "Lights toggled.");
            if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && !IsNoEngineVehicle(veh))
            {
                PlayerTextDrawBoxColor(
                    playerid,
                    SpeedTD[playerid][7],
                    GetVehicleParams(veh, VEHICLE_TYPE_LIGHTS) ? 8388863 : -2147483393
                );
                PlayerTextDrawShow(playerid, SpeedTD[playerid][7]);
            }
            VCP_Open(playerid);
        }

        // ================= HOOD =================
        case 3:
        {
            ToggleParam(veh, VEHICLE_TYPE_BONNET);
            VCP_Open(playerid);
        }

        // ================= BOOT =================
        case 4:
        {
            ToggleParam(veh, VEHICLE_TYPE_BOOT);
            if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && !IsNoEngineVehicle(veh))
            {
                PlayerTextDrawBoxColor(
                    playerid,
                    SpeedTD[playerid][9],
                    GetVehicleParams(veh, VEHICLE_TYPE_BOOT) ? 8388863 : -2147483393
                );
                PlayerTextDrawShow(playerid, SpeedTD[playerid][9]);
            }
            VCP_Open(playerid);
        }

        // ================= SPEED CAP =================
        case 5:
        {
            Dialog_Show(playerid, VCP_SpeedCap, DIALOG_STYLE_INPUT,
                "Speed Cap",
                "Masukkan km/h atau 'off':",
                "Set",
                "Kembali"
            );
        }

        // ================= NEON =================
        case 6:
        {
            Dialog_Show(playerid, VCP_NeonOnOff, DIALOG_STYLE_LIST,
                "Neon",
                "ON\nOFF",
                "OK",
                "Kembali"
            );
        }

        // ================= PARK =================
        case 7:
        {
            if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
                return SendClientMessage(playerid, COLOR_RED, "ERROR: Kamu harus mengemudi kendaraan untuk park.");

            new curVeh = GetPlayerVehicleID(playerid);

            if(curVeh != veh)
                return SendClientMessage(playerid, COLOR_RED, "ERROR: Kamu harus berada di kendaraan itu untuk park.");

            ParkVehicle(playerid, curVeh);
            return 1;

        }
    }
    return 1;
}

Dialog:VCP_SpeedCap(playerid, response, listitem, inputtext[])
{
    if(!response)
        return VCP_Open(playerid);

    new veh = VCP_CurrentVeh[playerid];

    if(!strcmp(inputtext, "off", true))
    {
        DisableVehicleSpeedCap(veh);
        SendClientMessage(playerid, COLOR_GREEN, "Speed Cap: OFF");
    }
    else
    {
        new cap;
        if(sscanf(inputtext, "i", cap) || cap <= 0)
        {
            SendClientMessage(playerid, COLOR_RED,
                "ERROR: Masukkan angka km/h atau 'off'.");
        }
        else
        {
            SetVehicleSpeedCap(veh, float(cap));

            new msg[64];
            format(msg, sizeof msg, "Speed Cap: %d km/h", cap);
            SendClientMessage(playerid, COLOR_GREEN, msg);
        }
    }

    VCP_Open(playerid);
    return 1;
}

Dialog:VCP_NeonOnOff(playerid, response, listitem, inputtext[])
{
    if(!response)
        return VCP_Open(playerid);

    new veh = VCP_CurrentVeh[playerid];

    // OFF
    if(listitem == 1)
    {
        for(new s = 0; s < 3; s++)
            SetVehicleNeonLights(veh, false, 0, s);

        SendClientMessage(playerid, COLOR_GREEN, "Neon: OFF");
        return VCP_Open(playerid);
    }

    if(!VehicleSupportsNeonLights(Vehicle[veh][vModel]))
    {
        SendClientMessage(playerid, COLOR_RED,
            "Model tidak mendukung neon.");
        return VCP_Open(playerid);
    }

    Dialog_Show(playerid, VCP_NeonColor, DIALOG_STYLE_LIST,
        "Neon - Pilih Warna",
        "Red\nBlue\nGreen\nYellow\nPink\nWhite",
        "Pilih",
        "Kembali"
    );
    return 1;
}

Dialog:VCP_NeonColor(playerid, response, listitem, inputtext[])
{
    if(!response)
        return VCP_Open(playerid);

    VCP_NeonColorSel[playerid] = listitem;

    Dialog_Show(playerid, VCP_NeonSlot, DIALOG_STYLE_LIST,
        "Neon - Pilih Slot",
        "Left\nRight\nFront",
        "Pilih",
        "Kembali"
    );
    return 1;
}

Dialog:VCP_NeonSlot(playerid, response, listitem, inputtext[])
{
    if(!response)
        return VCP_Open(playerid);

    new veh = VCP_CurrentVeh[playerid];
    new color = EVF_NeonColorFromIndex(VCP_NeonColorSel[playerid]);

    SetVehicleNeonLights(veh, true, color, listitem);

    new cname[16];
    EVF_NeonColorName(
        VCP_NeonColorSel[playerid],
        cname,
        sizeof cname
    );

    new msg[64];
    format(msg, sizeof msg,
        "Neon: ON (%s) slot %d",
        cname,
        listitem
    );
    SendClientMessage(playerid, COLOR_GREEN, msg);

    VCP_Open(playerid);
    return 1;
}
