-- function generateObject(prop, coords)
--   local newRocks = rocks

--   local unused, objectZ = GetGroundZFor_3dCoord(coords["x"], coords["y"], 99999.0, 1)
--   local object = CreateObject(GetHashKey(prop), coords["x"], coords["y"], objectZ, false, true, false)
-- end

-- function spawnTrailerWithPed()
  
--   Citizen.CreateThread(function() 
--     local coords = vector3(268.2094, -2700.703, 5.468769)
--     local vehiclehash = GetHashKey("adder")
--     RequestModel(vehiclehash)

--     while not HasModelLoaded(vehiclehash) do
--       Citizen.Wait(100)
--     end

--     local driverVeh = CreateVehicle(vehiclehash, coords["x"], coords["y"],  coords["z"], 177.77, true, false)
--     local driverPed = CreatePedInsideVehicle(driverVeh, 26, GetHashKey("s_m_y_airworker"), -1, 1, true)

--     TaskVehicleDriveToCoordLongrange(driverPed, driverVeh, 177.4751, -3201.061, 5.620518, 60, 786603, 10)
--     print(veh)
--   end)


-- end


function generateFuelTanker()
  Citizen.CreateThread(function()
    local coords = vector3(660.2506, -2661.789, 6.081177)

    RequestModel(Config.fuelTrailerHashKey)
    while not HasModelLoaded(Config.fuelTrailerHashKey) do
      Citizen.Wait(100)
    end

    local driverVeh = CreateVehicle(Config.fuelTrailerHashKey, coords["x"], coords["y"],  coords["z"], 177.77, true, false)
    SetEntityHeading(driverVeh, 140.338)

    print(driverVeh)

  end)
end
