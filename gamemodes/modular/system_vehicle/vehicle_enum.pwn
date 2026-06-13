// ======================================
// VEHICLE ENUM
// Struktur data kendaraan (in-memory)
// ======================================

enum E_VEHICLE_DATA
{
    vExists,                // bool: kendaraan aktif
    vDBID,                  // id kendaraan di database (PRIMARY KEY)
    vModel,                 // model kendaraan
    vOwner,                 // owner_id (pInfo[playerid][p_id])

    Float:vPos[4],          // x, y, z, angle
    vInt,                   // interior
    vVW,                    // virtual world
    vLock,                  // 0 = unlock, 1 = lock

    Float:vFuel,            // bahan bakar
    Float:vHealth,          // health kendaraan
    Float:vMileage,         // jarak tempuh

    vColor1,                // warna 1
    vColor2,                // warna 2
    vPlate[PLATE_LEN],      // nomor plat

    vStatusUsable,          // 1 aktif, 0 rusak/disita
    vImpound,               // status impound
    vRental,                // status rental

    vCreatedAt,             // timestamp dibuat
    vLastUsed,               // terakhir digunakan

    bool:vSave              // buat status auto save
};

// Array kendaraan (index = vehicleid SA-MP)
new Vehicle[MAX_VEHICLES][E_VEHICLE_DATA];


// ======================================
// VEHICLE CACHE ENUM
#define MAX_VEH_CACHE 5000

enum E_VEHICLE_CACHE
{
    bool:vcExists,
    vcDBID,
    vcModel,
    vcOwner,

    Float:vcPos[4],
    vcInt,
    vcVW,
    vcLock,

    Float:vcFuel,
    Float:vcHealth,
    Float:vcMileage,

    vcColor1,
    vcColor2,
    vcPlate[PLATE_LEN],

    bool:vcStored,  // ✅ dari DB veh_stored
    vcVehID // ✅ tambah ini (SA-MP vehicleid kalau sedang spawn, kalau tidak = INVALID)
};

new VehicleCache[MAX_VEH_CACHE][E_VEHICLE_CACHE];
new VehCacheLoaded = 0;
