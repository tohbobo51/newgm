// ======================================
// VEHICLE SAVE
// Simpan data kendaraan ke database
// ======================================

stock SaveVehicleToDB(vehicleid, bool:park = false)
{
    if(vehicleid == INVALID_VEHICLE_ID) return 0;
    if(!Vehicle[vehicleid][vExists]) return 0;
    if(Vehicle[vehicleid][vDBID] <= 0) return 0;

    new Float:x, Float:y, Float:z, Float:a;
    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, a);

    Vehicle[vehicleid][vPos][0] = x;
    Vehicle[vehicleid][vPos][1] = y;
    Vehicle[vehicleid][vPos][2] = z;
    Vehicle[vehicleid][vPos][3] = a;

    new Float:vh;
    GetVehicleHealth(vehicleid, vh);
    Vehicle[vehicleid][vHealth] = vh;

    Vehicle[vehicleid][vFuel] = GetVehicleFuel(vehicleid);

    new posStr[64];
    format(posStr, sizeof posStr, "%f|%f|%f|%f", x, y, z, a);

    if(park)
    {
        mysql_format(handle, query, sizeof query,
            "UPDATE vehicles SET veh_pos='%s', veh_int=%d, veh_vw=%d, veh_lock=%d,\
            fuel=%f, health=%f, mileage=%f, veh_stored=1, last_used=UNIX_TIMESTAMP()\
            WHERE id=%d",
            posStr,
            Vehicle[vehicleid][vInt],
            Vehicle[vehicleid][vVW],
            Vehicle[vehicleid][vLock],
            Vehicle[vehicleid][vFuel],
            Vehicle[vehicleid][vHealth],
            Vehicle[vehicleid][vMileage],
            Vehicle[vehicleid][vDBID]
        );
    }
    else
    {
        mysql_format(handle, query, sizeof query,
            "UPDATE vehicles SET veh_pos='%s', veh_int=%d, veh_vw=%d, veh_lock=%d,\
            fuel=%f, health=%f, mileage=%f, last_used=UNIX_TIMESTAMP()\
            WHERE id=%d",
            posStr,
            Vehicle[vehicleid][vInt],
            Vehicle[vehicleid][vVW],
            Vehicle[vehicleid][vLock],
            Vehicle[vehicleid][vFuel],
            Vehicle[vehicleid][vHealth],
            Vehicle[vehicleid][vMileage],
            Vehicle[vehicleid][vDBID]
        );
    }

    mysql_pquery(handle, query);
    return 1;
}
