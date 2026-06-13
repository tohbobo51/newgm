// vehicle_loader.pwn

Fungsi:LoadVehicles()
{
    new rows = cache_num_rows();
    if(!rows)
    {
        printf("[VEHICLE CACHE] No vehicles found.");
        VehCacheLoaded = 0;
        return 1;
    }

    if(rows > MAX_VEH_CACHE)
    {
        printf("[VEHICLE CACHE] WARNING: rows=%d > MAX_VEH_CACHE=%d (dipotong).", rows, MAX_VEH_CACHE);
        rows = MAX_VEH_CACHE;
    }

    for(new i = 0; i < rows; i++)
    {
        cache_get_value_name_int(i, "id",       VehicleCache[i][vcDBID]);
        cache_get_value_name_int(i, "model",    VehicleCache[i][vcModel]);
        cache_get_value_name_int(i, "owner_id", VehicleCache[i][vcOwner]);

        new posData[64];
        cache_get_value_name(i, "veh_pos", posData);

        if(sscanf(posData, "p<|>ffff",
            VehicleCache[i][vcPos][0],
            VehicleCache[i][vcPos][1],
            VehicleCache[i][vcPos][2],
            VehicleCache[i][vcPos][3]
        ))
        {
            VehicleCache[i][vcPos][0] = 0.0;
            VehicleCache[i][vcPos][1] = 0.0;
            VehicleCache[i][vcPos][2] = 5.0;
            VehicleCache[i][vcPos][3] = 0.0;
        }

        cache_get_value_name_int(i, "veh_int",  VehicleCache[i][vcInt]);
        cache_get_value_name_int(i, "veh_vw",   VehicleCache[i][vcVW]);
        cache_get_value_name_int(i, "veh_lock", VehicleCache[i][vcLock]);

        cache_get_value_name_float(i, "fuel",    VehicleCache[i][vcFuel]);
        cache_get_value_name_float(i, "health",  VehicleCache[i][vcHealth]);
        cache_get_value_name_float(i, "mileage", VehicleCache[i][vcMileage]);

        cache_get_value_name_int(i, "color1", VehicleCache[i][vcColor1]);
        cache_get_value_name_int(i, "color2", VehicleCache[i][vcColor2]);

        cache_get_value_name(i, "plate", VehicleCache[i][vcPlate], PLATE_LEN);

        cache_get_value_name_int(i, "veh_stored", VehicleCache[i][vcStored]);

        VehicleCache[i][vcExists] = true;

        VehicleCache[i][vcVehID] = INVALID_VEHICLE_ID;
    }

    VehCacheLoaded = rows;
    printf("[VEHICLE CACHE] Loaded %d vehicles to memory (NO SPAWN).", VehCacheLoaded);
    return 1;
}
