// ======================================
// VEHICLE COMMAND
// Command dasar kendaraan
// ======================================


// /createvehicle [model]
CMD:createvehicle(playerid, params[])
{
    if(pInfo[playerid][pAdminLevel] < 4)
        return SendClientMessage(playerid, COLOR_RED, "Kamu tidak punya izin.");

    new model;
    if(sscanf(params, "d", model))
        return SendClientMessage(playerid, COLOR_YELLOW, "Usage: /createvehicle [modelid]");

    if(model < 400 || model > 611)
        return SendClientMessage(playerid, COLOR_RED, "Model kendaraan tidak valid.");

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    new vw = GetPlayerVirtualWorld(playerid);
    new interior = GetPlayerInterior(playerid);

    new vehicleid = CreateVehicle(model, x, y, z, a, 0, 0, -1);
    if(vehicleid == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, COLOR_RED, "Gagal membuat kendaraan.");

    Vehicle[vehicleid][vExists]  = 1;
    Vehicle[vehicleid][vDBID]    = 0;
    Vehicle[vehicleid][vModel]   = model;
    Vehicle[vehicleid][vOwner]   = pInfo[playerid][p_id];

    Vehicle[vehicleid][vPos][0]  = x;
    Vehicle[vehicleid][vPos][1]  = y;
    Vehicle[vehicleid][vPos][2]  = z;
    Vehicle[vehicleid][vPos][3]  = a;

    Vehicle[vehicleid][vInt]     = interior;
    Vehicle[vehicleid][vVW]      = vw;
    Vehicle[vehicleid][vLock]    = 0;

    Vehicle[vehicleid][vFuel]    = 100.0;
    Vehicle[vehicleid][vHealth]  = 1000.0;
    Vehicle[vehicleid][vMileage] = 0.0;

    Vehicle[vehicleid][vColor1]  = 0;
    Vehicle[vehicleid][vColor2]  = 0;
    format(Vehicle[vehicleid][vPlate], PLATE_LEN, "KONTEN");

    Vehicle[vehicleid][vStatusUsable] = 1;
    Vehicle[vehicleid][vImpound]      = 0;
    Vehicle[vehicleid][vRental]       = 0;

    LinkVehicleToInterior(vehicleid, interior);
    SetVehicleVirtualWorld(vehicleid, vw);
    SetVehicleNumberPlate(vehicleid, Vehicle[vehicleid][vPlate]);
    SetVehicleHealth(vehicleid, Vehicle[vehicleid][vHealth]);

    Iter_Add(Veh, vehicleid);

    new posStr[64];
    format(posStr, sizeof posStr, "%f|%f|%f|%f", x, y, z, a);

    // ✅ FIX: insert langsung veh_stored = 0
    mysql_format(handle, query, sizeof query,
        "INSERT INTO vehicles \
        (model, owner_id, veh_pos, veh_int, veh_vw, veh_lock, fuel, health, mileage, color1, color2, plate, veh_stored, created_at) \
        VALUES (%d, %d, '%s', %d, %d, 0, %f, %f, 0, %d, %d, '%s', 0, UNIX_TIMESTAMP())",
        model,
        pInfo[playerid][p_id],
        posStr,
        interior,
        vw,
        Vehicle[vehicleid][vFuel],
        Vehicle[vehicleid][vHealth],
        Vehicle[vehicleid][vColor1],
        Vehicle[vehicleid][vColor2],
        Vehicle[vehicleid][vPlate]
    );

    mysql_tquery(handle, query, "OnVehicleInserted", "dd", playerid, vehicleid);

    SendClientMessage(playerid, COLOR_GREEN, "Kendaraan berhasil dibuat.");
    return 1;
}


// Callback setelah INSERT kendaraan
Fungsi:OnVehicleInserted(playerid, vehicleid)
{
    new insert_id = cache_insert_id();
    if(vehicleid == INVALID_VEHICLE_ID || insert_id <= 0)
        return 1;

    Vehicle[vehicleid][vDBID] = insert_id;

    // ✅ cari slot kosong di cache
    new idx = -1;
    for(new i = 0; i < VehCacheLoaded; i++)
    {
        if(!VehicleCache[i][vcExists])
        {
            idx = i;
            break;
        }
    }

    // ✅ tambah cache baru kalau masih muat
    if(idx == -1)
    {
        if(VehCacheLoaded < MAX_VEH_CACHE)
        {
            idx = VehCacheLoaded;
            VehCacheLoaded++;
        }
    }

    if(idx == -1)
    {
        printf("[VEHICLE CACHE] FULL! tidak bisa add kendaraan baru ke cache.");
        return 1;
    }

    VehicleCache[idx][vcExists]  = true;
    VehicleCache[idx][vcVehID]   = vehicleid;
    VehicleCache[idx][vcStored]  = false;

    VehicleCache[idx][vcDBID]    = Vehicle[vehicleid][vDBID];
    VehicleCache[idx][vcModel]   = Vehicle[vehicleid][vModel];
    VehicleCache[idx][vcOwner]   = Vehicle[vehicleid][vOwner];

    VehicleCache[idx][vcPos][0]  = Vehicle[vehicleid][vPos][0];
    VehicleCache[idx][vcPos][1]  = Vehicle[vehicleid][vPos][1];
    VehicleCache[idx][vcPos][2]  = Vehicle[vehicleid][vPos][2];
    VehicleCache[idx][vcPos][3]  = Vehicle[vehicleid][vPos][3];

    VehicleCache[idx][vcInt]     = Vehicle[vehicleid][vInt];
    VehicleCache[idx][vcVW]      = Vehicle[vehicleid][vVW];
    VehicleCache[idx][vcLock]    = Vehicle[vehicleid][vLock];

    VehicleCache[idx][vcFuel]    = Vehicle[vehicleid][vFuel];
    VehicleCache[idx][vcHealth]  = Vehicle[vehicleid][vHealth];
    VehicleCache[idx][vcMileage] = Vehicle[vehicleid][vMileage];

    VehicleCache[idx][vcColor1]  = Vehicle[vehicleid][vColor1];
    VehicleCache[idx][vcColor2]  = Vehicle[vehicleid][vColor2];

    format(VehicleCache[idx][vcPlate], PLATE_LEN, "%s", Vehicle[vehicleid][vPlate]);

    printf("[VEHICLE CACHE] Added new vehicle dbid=%d vehid=%d owner=%d",
        insert_id, vehicleid, Vehicle[vehicleid][vOwner]
    );

    return 1;
}

// /parkveh - simpan posisi kendaraan
CMD:parkveh(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_RED, "Kamu tidak berada di kendaraan.");

    if(GetPlayerVehicleSeat(playerid) != 0)
        return SendClientMessage(playerid, COLOR_RED, "Kamu harus menjadi driver.");

    new veh = GetPlayerVehicleID(playerid);
    return ParkVehicle(playerid, veh);
}

CMD:vcp(playerid, params[])
{
    return VCP_Open(playerid);
}
