// ======================================
// VEHICLE TASK
// Task berkala kendaraan
// ======================================

// Jalan tiap 1 detik
task Mileage_Tick[1000]()
{
    static const Float:DT = 0.00027778; // 1 / 3600

    foreach (new veh : Veh)
    {
        if(!Vehicle[veh][vExists])
            continue;

        if(GetVehicleParams(veh, VEHICLE_TYPE_ENGINE))
        {
            new Float:speed = EVF::GetVehicleSpeed(veh); // km/h
            if(speed > 1.0)
            {
                Vehicle[veh][vMileage] += (speed * DT);
                Vehicle[veh][vSave] = true;
            }
        }
    }
}

task Vehicle_Autosave[30000]()
{
    foreach (new veh : Veh)
    {
        if(Vehicle[veh][vExists] &&
           Vehicle[veh][vSave] &&
           Vehicle[veh][vDBID])
        {
            SaveVehicleToDB(veh);
            Vehicle[veh][vSave] = false;
        }
    }
}

task Vehicle_SpeedUI_Update[500]()
{
    foreach(new i : Player)
     {
        if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
            SpeedUI_Update(i);
    }
}