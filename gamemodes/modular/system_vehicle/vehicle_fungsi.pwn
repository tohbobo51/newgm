// ======================================
// VEHICLE FUNGSI
// Helper & utilitas kendaraan
// ======================================

// String helper ON / OFF
stock const PSTR_ON[]  = "ON";
stock const PSTR_OFF[] = "OFF";


// Cek model sepeda (tanpa mesin)
stock bool:IsBicycleModel(model)
{
    return (model == 481 || model == 509 || model == 510);
}

// Kendaraan tanpa mesin
stock bool:IsNoEngineVehicle(vehicleid)
{
    if(vehicleid == INVALID_VEHICLE_ID)
        return false;

    new model = Vehicle[vehicleid][vModel];
    if(model == 0)
        model = GetVehicleModel(vehicleid);

    return IsBicycleModel(model);
}


// Cek kepemilikan kendaraan
stock bool:IsOwner(playerid, vehicleid)
{
    if(vehicleid == INVALID_VEHICLE_ID)
        return false;

    return Vehicle[vehicleid][vExists] &&
           Vehicle[vehicleid][vOwner] == pInfo[playerid][p_id];
}


// Ambil kendaraan target milik player
stock GetTargetVehicle(playerid)
{
    // Jika player sedang mengemudi
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new veh = GetPlayerVehicleID(playerid);
        if(IsOwner(playerid, veh))
            return veh;
    }

    // Cari kendaraan terdekat (EVF)
    new veh2 = GetNearestVehicleToPlayer(playerid, 7.0, true);
    if(veh2 != INVALID_VEHICLE_ID && IsOwner(playerid, veh2))
        return veh2;

    return INVALID_VEHICLE_ID;
}


// ================================
// PARAM HELPER (ENGINE / LOCK / dll)
// ================================

// Ambil status param → "ON" / "OFF"
stock ParamStr(vehicleid, EVF_ParamTypes:type)
{
    return (GetVehicleParams(vehicleid, type) ? PSTR_ON : PSTR_OFF);
}


// Toggle param (return 1 = ON, 0 = OFF)
stock ToggleParam(vehicleid, EVF_ParamTypes:type)
{
    new cur = GetVehicleParams(vehicleid, type);
    new nxt = (cur == 0) ? 1 : 0;

    SetVehicleParams(vehicleid, type, nxt);
    return nxt;
}

// ======================================
// NEON HELPER
// ======================================

// Ambil neon color dari index
stock EVF_NeonColorFromIndex(idx)
{
    switch(idx)
    {
        case 0: return RED_NEON;
        case 1: return BLUE_NEON;
        case 2: return GREEN_NEON;
        case 3: return YELLOW_NEON;
        case 4: return PINK_NEON;
        case 5: return WHITE_NEON;
    }
    return RED_NEON;
}


// Ambil nama neon dari index
stock EVF_NeonColorName(idx, out[], outlen)
{
    static const n[][] =
    {
        "Red",
        "Blue",
        "Green",
        "Yellow",
        "Pink",
        "White"
    };

    format(out, outlen, "%s", n[idx]);
}


stock ParkVehicle(playerid, vehicleid)
{
    if(vehicleid == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, COLOR_RED, "ERROR: Kendaraan tidak valid.");

    if(!Vehicle[vehicleid][vExists])
        return SendClientMessage(playerid, COLOR_RED, "ERROR: Kendaraan tidak aktif.");

    if(Vehicle[vehicleid][vOwner] != pInfo[playerid][p_id])
        return SendClientMessage(playerid, COLOR_RED, "ERROR: Kendaraan ini bukan milikmu.");

    if(Vehicle[vehicleid][vDBID] <= 0)
        return SendClientMessage(playerid, COLOR_RED, "ERROR: Kendaraan belum tersimpan di database.");

    // harus driver kendaraan itu
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleID(playerid) != vehicleid)
        return SendClientMessage(playerid, COLOR_RED, "ERROR: Kamu harus berada di kendaraan itu.");

    if(GetPlayerVehicleSeat(playerid) != 0)
        return SendClientMessage(playerid, COLOR_RED, "ERROR: Kamu harus menjadi driver.");

    new dbid = Vehicle[vehicleid][vDBID];

    // update posisi terbaru
    GetVehiclePos(
        vehicleid,
        Vehicle[vehicleid][vPos][0],
        Vehicle[vehicleid][vPos][1],
        Vehicle[vehicleid][vPos][2]
    );
    GetVehicleZAngle(vehicleid, Vehicle[vehicleid][vPos][3]);

    // simpan vw/int
    Vehicle[vehicleid][vInt] = GetPlayerInterior(playerid);
    Vehicle[vehicleid][vVW]  = GetPlayerVirtualWorld(playerid);

    // save data kendaraan ke DB (pos, health, fuel, dll)
    SaveVehicleToDB(vehicleid, true); // park = true

    // update CACHE biar data terakhir ikut tersimpan juga
    new idx = GetVehCacheIndexByDBID(dbid);
    if(idx != -1)
    {
        VehicleCache[idx][vcStored] = true;

        VehicleCache[idx][vcPos][0] = Vehicle[vehicleid][vPos][0];
        VehicleCache[idx][vcPos][1] = Vehicle[vehicleid][vPos][1];
        VehicleCache[idx][vcPos][2] = Vehicle[vehicleid][vPos][2];
        VehicleCache[idx][vcPos][3] = Vehicle[vehicleid][vPos][3];

        VehicleCache[idx][vcInt]     = Vehicle[vehicleid][vInt];
        VehicleCache[idx][vcVW]      = Vehicle[vehicleid][vVW];
        VehicleCache[idx][vcLock]    = Vehicle[vehicleid][vLock];
        VehicleCache[idx][vcFuel]    = Vehicle[vehicleid][vFuel];
        VehicleCache[idx][vcHealth]  = Vehicle[vehicleid][vHealth];
        VehicleCache[idx][vcMileage] = Vehicle[vehicleid][vMileage];

        // status NOT SPAWNED (karena kita mau despawn)
        VehicleCache[idx][vcVehID] = INVALID_VEHICLE_ID;
    }

    // DESPAWN kendaraan (menghilang)
    Iter_Remove(Veh, vehicleid);
    Vehicle[vehicleid][vExists] = 0;
    DestroyVehicle(vehicleid);

    return SendClientMessage(playerid, COLOR_GREEN, "Kendaraan berhasil diparkir (STORED) dan disimpan.");
}

stock SpawnPlayerVehicles(playerid)
{
    if(pInfo[playerid][p_id] <= 0)
        return 0;

    new ownerid = pInfo[playerid][p_id];
    new spawned = 0;

    for(new i = 0; i < VehCacheLoaded; i++)
    {
        if(!VehicleCache[i][vcExists]) continue;
        if(VehicleCache[i][vcOwner] != ownerid) continue;

        // ✅ anti dobel spawn
        if(VehicleCache[i][vcVehID] != INVALID_VEHICLE_ID)
            continue;

        if(VehicleCache[i][vcStored])
            continue; // kendaraan di garasi, jangan spawn

        new vehid = CreateVehicle(
            VehicleCache[i][vcModel],
            VehicleCache[i][vcPos][0],
            VehicleCache[i][vcPos][1],
            VehicleCache[i][vcPos][2],
            VehicleCache[i][vcPos][3],
            VehicleCache[i][vcColor1],
            VehicleCache[i][vcColor2],
            -1
        );

        if(vehid == INVALID_VEHICLE_ID)
        {
            printf("[SpawnPlayerVehicles] FAILED dbid=%d model=%d",
                VehicleCache[i][vcDBID],
                VehicleCache[i][vcModel]
            );
            continue;
        }

        spawned++;

        Vehicle[vehid][vExists]  = 1;
        Vehicle[vehid][vDBID]    = VehicleCache[i][vcDBID];
        Vehicle[vehid][vModel]   = VehicleCache[i][vcModel];
        Vehicle[vehid][vOwner]   = VehicleCache[i][vcOwner];

        Vehicle[vehid][vPos][0]  = VehicleCache[i][vcPos][0];
        Vehicle[vehid][vPos][1]  = VehicleCache[i][vcPos][1];
        Vehicle[vehid][vPos][2]  = VehicleCache[i][vcPos][2];
        Vehicle[vehid][vPos][3]  = VehicleCache[i][vcPos][3];

        Vehicle[vehid][vInt]     = VehicleCache[i][vcInt];
        Vehicle[vehid][vVW]      = VehicleCache[i][vcVW];
        Vehicle[vehid][vLock]    = VehicleCache[i][vcLock];

        Vehicle[vehid][vFuel]    = VehicleCache[i][vcFuel];
        Vehicle[vehid][vHealth]  = VehicleCache[i][vcHealth];
        Vehicle[vehid][vMileage] = VehicleCache[i][vcMileage];

        Vehicle[vehid][vColor1]  = VehicleCache[i][vcColor1];
        Vehicle[vehid][vColor2]  = VehicleCache[i][vcColor2];

        format(Vehicle[vehid][vPlate], PLATE_LEN, "%s", VehicleCache[i][vcPlate]);

        // ✅ status SPAWNED
        VehicleCache[i][vcVehID] = vehid;

        LinkVehicleToInterior(vehid, Vehicle[vehid][vInt]);
        SetVehicleVirtualWorld(vehid, Vehicle[vehid][vVW]);
        SetVehicleNumberPlate(vehid, Vehicle[vehid][vPlate]);
        SetVehicleHealth(vehid, Vehicle[vehid][vHealth]);

        SetVehicleParams(vehid, VEHICLE_TYPE_DOORS, Vehicle[vehid][vLock] ? 1 : 0);

        if(!IsNoEngineVehicle(vehid))
        {
            SetVehicleFuel(vehid, floatround(Vehicle[vehid][vFuel]));
            ToggleVehicleFuel(vehid, true);
        }
        else
        {
            SetVehicleParams(vehid, VEHICLE_TYPE_ENGINE, 1);
            Vehicle[vehid][vFuel] = 0.0;
            ToggleVehicleFuel(vehid, false);
        }

        Iter_Add(Veh, vehid);
    }
    return spawned;
}


stock DespawnPlayerVehicles(playerid)
{
    if(pInfo[playerid][p_id] <= 0)
        return 0;

    new ownerid = pInfo[playerid][p_id];

    new list[MAX_VEHICLES];
    new count = 0;

    foreach(new vehid : Veh)
    {
        if(vehid <= 0 || vehid >= MAX_VEHICLES) continue;
        if(!Vehicle[vehid][vExists]) continue;
        if(Vehicle[vehid][vOwner] != ownerid) continue;

        list[count++] = vehid;
    }

    for(new i = 0; i < count; i++)
    {
        new vehid = list[i];

        if(vehid <= 0 || vehid >= MAX_VEHICLES) continue;
        if(!Vehicle[vehid][vExists]) continue;

        // simpan dbid dulu buat update cache
        new dbid = Vehicle[vehid][vDBID];

        SaveVehicleToDB(vehid);

        Iter_Remove(Veh, vehid);
        Vehicle[vehid][vExists] = 0;

        // update cache
        new idx = GetVehCacheIndexByDBID(dbid);
        if(idx != -1)
            VehicleCache[idx][vcVehID] = INVALID_VEHICLE_ID;

        DestroyVehicle(vehid);
    }

    return count;
}

stock GetVehCacheIndexByDBID(dbid)
{
    for(new i = 0; i < VehCacheLoaded; i++)
    {
        if(!VehicleCache[i][vcExists]) continue;
        if(VehicleCache[i][vcDBID] == dbid)
            return i;
    }
    return -1;
}
