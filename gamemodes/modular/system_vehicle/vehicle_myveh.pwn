// vehicle_myveh2.pwn
#include <YSI_Coding\y_hooks>

new MyVeh_CacheIndex[MAX_PLAYERS][MAX_VEH_CACHE];
new MyVeh_Count[MAX_PLAYERS];
new MyVeh_SelectedIndex[MAX_PLAYERS];

// ================================
// COMMAND
// ================================
CMD:myveh(playerid, params[])
{
    return MyVeh_Open(playerid);
}

// ================================
// OPEN LIST
// ================================
stock MyVeh_Open(playerid)
{
    if(pInfo[playerid][p_id] <= 0)
        return SendClientMessage(playerid, COLOR_RED, "ERROR: Kamu belum login.");

    static list[4096];
    list[0] = '\0';

    MyVeh_Count[playerid] = 0;

    // Header kolom
    format(list, sizeof list, "ID\tVehicle\tPlate\tStatus\n");

    for(new i = 0; i < VehCacheLoaded; i++)
    {
        if(!VehicleCache[i][vcExists]) continue;
        if(VehicleCache[i][vcOwner] != pInfo[playerid][p_id]) continue;

        // ✅ BATAS dialog (anti out of bounds)
        if(MyVeh_Count[playerid] >= MAX_MYVEH_DIALOG)
            break;

        //new vehid = VehicleCache[i][vcVehID];
        new carid = MyVeh_Count[playerid] + 1;

        format(list, sizeof list,
            "%s%d\t%s\t%s\t%s\n",
            list,
            carid,
            GetVehicleModelName(VehicleCache[i][vcModel]),
            VehicleCache[i][vcPlate],
            (VehicleCache[i][vcStored]) ? ("STORED") :
            (VehicleCache[i][vcVehID] != INVALID_VEHICLE_ID) ? ("ACTIVE") : ("READY")
        );


        MyVeh_CacheIndex[playerid][MyVeh_Count[playerid]] = i;
        MyVeh_Count[playerid]++;
    }

    if(!MyVeh_Count[playerid])
        return SendClientMessage(playerid, COLOR_YELLOW, "Kamu belum memiliki kendaraan.");

    Dialog_Show(playerid, DIALOG_MYVEH_LIST, DIALOG_STYLE_TABLIST_HEADERS,
        "My Vehicles",
        list,
        "Select",
        "Close"
    );
    return 1;
}


// ================================
// DIALOG LIST
// ================================
Dialog:DIALOG_MYVEH_LIST(playerid, response, listitem, inputtext[])
{
    if(!response) return 1;

    if(listitem < 0 || listitem >= MyVeh_Count[playerid])
        return 1;

    MyVeh_SelectedIndex[playerid] = MyVeh_CacheIndex[playerid][listitem];

    new idx = MyVeh_SelectedIndex[playerid];
    if(idx < 0 || idx >= VehCacheLoaded)
        return 1;

    new vehid = VehicleCache[idx][vcVehID];

    new info[256];
    format(info, sizeof info,
        "Plate: %s\nDBID: %d\nStatus: %s\n\nPilih aksi:",
        VehicleCache[idx][vcPlate],
        VehicleCache[idx][vcDBID],
        (vehid != INVALID_VEHICLE_ID) ? ("SPAWNED") : ("NOT SPAWNED")
    );

    Dialog_Show(playerid, DIALOG_MYVEH_ACTION, DIALOG_STYLE_LIST,
        "Vehicle Actions",
        "Spawn / Despawn\nGPS\nPark (Despawn)",
        "OK",
        "Back"
    );
    return 1;
}


// ================================
// DIALOG ACTION
// ================================
Dialog:DIALOG_MYVEH_ACTION(playerid, response, listitem, inputtext[])
{
    if(!response) return MyVeh_Open(playerid);

    new idx = MyVeh_SelectedIndex[playerid];
    if(idx < 0 || idx >= VehCacheLoaded) return 1;
    if(!VehicleCache[idx][vcExists]) return 1;

    new vehid = VehicleCache[idx][vcVehID];

    switch(listitem)
    {
        // ================= Spawn / Despawn =================
        case 0:
        {
            // kalau belum spawn -> spawn
            if(vehid == INVALID_VEHICLE_ID)
            {
                new newVeh = CreateVehicle(
                    VehicleCache[idx][vcModel],
                    VehicleCache[idx][vcPos][0],
                    VehicleCache[idx][vcPos][1],
                    VehicleCache[idx][vcPos][2],
                    VehicleCache[idx][vcPos][3],
                    VehicleCache[idx][vcColor1],
                    VehicleCache[idx][vcColor2],
                    -1
                );

                if(newVeh == INVALID_VEHICLE_ID)
                {
                    SendClientMessage(playerid, COLOR_RED, "ERROR: Gagal spawn kendaraan (slot penuh?).");
                    return MyVeh_Open(playerid);
                }

                // apply ke Vehicle[]
                Vehicle[newVeh][vExists]  = 1;
                Vehicle[newVeh][vDBID]    = VehicleCache[idx][vcDBID];
                Vehicle[newVeh][vModel]   = VehicleCache[idx][vcModel];
                Vehicle[newVeh][vOwner]   = VehicleCache[idx][vcOwner];

                Vehicle[newVeh][vPos][0]  = VehicleCache[idx][vcPos][0];
                Vehicle[newVeh][vPos][1]  = VehicleCache[idx][vcPos][1];
                Vehicle[newVeh][vPos][2]  = VehicleCache[idx][vcPos][2];
                Vehicle[newVeh][vPos][3]  = VehicleCache[idx][vcPos][3];

                Vehicle[newVeh][vInt]     = VehicleCache[idx][vcInt];
                Vehicle[newVeh][vVW]      = VehicleCache[idx][vcVW];
                Vehicle[newVeh][vLock]    = VehicleCache[idx][vcLock];

                Vehicle[newVeh][vFuel]    = VehicleCache[idx][vcFuel];
                Vehicle[newVeh][vHealth]  = VehicleCache[idx][vcHealth];
                Vehicle[newVeh][vMileage] = VehicleCache[idx][vcMileage];

                Vehicle[newVeh][vColor1]  = VehicleCache[idx][vcColor1];
                Vehicle[newVeh][vColor2]  = VehicleCache[idx][vcColor2];

                format(Vehicle[newVeh][vPlate], PLATE_LEN, "%s", VehicleCache[idx][vcPlate]);

                LinkVehicleToInterior(newVeh, Vehicle[newVeh][vInt]);
                SetVehicleVirtualWorld(newVeh, Vehicle[newVeh][vVW]);
                SetVehicleNumberPlate(newVeh, Vehicle[newVeh][vPlate]);
                SetVehicleHealth(newVeh, Vehicle[newVeh][vHealth]);
                SetVehicleParams(newVeh, VEHICLE_TYPE_DOORS, Vehicle[newVeh][vLock] ? 1 : 0);

                if(!IsNoEngineVehicle(newVeh))
                {
                    SetVehicleFuel(newVeh, floatround(Vehicle[newVeh][vFuel]));
                    ToggleVehicleFuel(newVeh, true);
                }
                else
                {
                    SetVehicleParams(newVeh, VEHICLE_TYPE_ENGINE, 1);
                    Vehicle[newVeh][vFuel] = 0.0;
                    ToggleVehicleFuel(newVeh, false);
                }

                Iter_Add(Veh, newVeh);

                // simpan vehicleid ke cache
                VehicleCache[idx][vcStored] = false;
                VehicleCache[idx][vcVehID] = newVeh;


                mysql_format(handle, query, sizeof query,
                    "UPDATE vehicles SET veh_stored=0 WHERE id=%d",
                    VehicleCache[idx][vcDBID]
                );
                mysql_pquery(handle, query);

                SendClientMessage(playerid, COLOR_GREEN, "Kendaraan berhasil di-spawn.");

                return MyVeh_Open(playerid);
            }

            // kalau sedang spawn -> despawn (jadi STORED)
            if(vehid != INVALID_VEHICLE_ID)
            {
                // save dulu biar aman (pos, health, fuel, dll)
                SaveVehicleToDB(vehid, true); // park = true

                // update cache status
                VehicleCache[idx][vcStored] = true;
                VehicleCache[idx][vcVehID]  = INVALID_VEHICLE_ID;

                // despawn entity
                Iter_Remove(Veh, vehid);
                Vehicle[vehid][vExists] = 0;
                DestroyVehicle(vehid);

                SendClientMessage(playerid, COLOR_GREEN, "Kendaraan disimpan ke garasi (STORED).");
                return MyVeh_Open(playerid);
            }


        }

        // ================= GPS =================
        case 1:
        {
            new Float:x, Float:y, Float:z;

            // kalau sudah spawn, ambil posisi real
            if(vehid != INVALID_VEHICLE_ID)
            {
                GetVehiclePos(vehid, x, y, z);
            }
            else
            {
                // kalau belum spawn, pakai posisi terakhir dari cache
                x = VehicleCache[idx][vcPos][0];
                y = VehicleCache[idx][vcPos][1];
                z = VehicleCache[idx][vcPos][2];
            }

            SetPlayerCheckpoint(playerid, x, y, z, 5.0);

            SendClientMessage(playerid, COLOR_GREEN, "GPS diarahkan ke lokasi kendaraan.");
            return MyVeh_Open(playerid);
        }

        // ================= Park (Despawn) =================
        case 2:
        {
            if(vehid == INVALID_VEHICLE_ID)
                return SendClientMessage(playerid, COLOR_YELLOW, "Kendaraan belum spawn.");

            // park = save + despawn, tapi harus driver kendaraan itu
            if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleID(playerid) != vehid)
                return SendClientMessage(playerid, COLOR_RED, "ERROR: Kamu harus berada di kendaraan itu.");

            if(GetPlayerVehicleSeat(playerid) != 0)
                return SendClientMessage(playerid, COLOR_RED, "ERROR: Kamu harus menjadi driver.");

            ParkVehicle(playerid, vehid);
            return MyVeh_Open(playerid);
        }
    }

    return 1;
}
