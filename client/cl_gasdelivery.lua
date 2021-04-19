
-- Status/assigned station
local status = "Not signed on"
local assignedStation = nil

-- Refill zone variable and listening handler
local isInRefillZone = false
Config.refillTrailerZone:onPlayerInOut(function(isPointInside, point)
  isInRefillZone = isPointInside
end)

-- is inside assigned station zone
local insideAssignedStation = false
Config.gasStationZones:onPlayerInOut(function(isPointInside, point, zone)
  if assignedStation ~= nil and zone.name == assignedStation and isPointInside then
    insideAssignedStation = true
    status = "Inside zone start pumping gas into tank."
  elseif assignedStation ~= nil and zone.name == assignedStation and not isPointInside then
    status = "Please enter your assigned gas station to fill"
    insideAssignedStation = false
  end
end)

-- Trailer variables
local trailerObj = nil
local trailerInfo = nil

Citizen.CreateThread(function()
  while true do 
    Citizen.Wait(1)
    
    -- If the user is in the refill zone with their trailer start refilling
    if isInRefillZone and IsControlJustPressed(1, 86) then
      TriggerEvent("activity_gasdelivery:attemptRefill")
    end

    -- If has an assigned zone and inside it while clicking "E" then
    if assignedStation ~= nil and insideAssignedStation and IsControlJustPressed(1, 86) then
      TriggerEvent("activity_gasdelivery:attemptFillStation")
    end

    showText(status)
  end
end)

-- Called when user is potentially trying to refill their trailer
RegisterNetEvent("activity_gasdelivery:attemptRefill")
AddEventHandler("activity_gasdelivery:attemptRefill", function(message)
  local playerServerId = GetPlayerServerId(PlayerId())

  if trailerInfo == nil then
    return sendNotification("You don't have an assign trailer to refill.", playerServerId)
  end

  local trailerCoords = GetEntityCoords(trailerObj)
  local isTrailerInside = Config.refillTrailerZone:isPointInside(trailerCoords)

  if isTrailerInside then
    if trailerInfo.fuelLevel == 100 then
      return sendNotification("Your trailer is already full!", playerServerId)
    end

    TriggerEvent("activity_gasdelivery:startRefillingTrailer")
  end

end)

-- Called when the server is ready to let us spawn a trailer
RegisterNetEvent("activity_gasdelivery:spawnTrailer")
AddEventHandler("activity_gasdelivery:spawnTrailer", function(info)
  local coords = vector3(660.2506, -2661.789, 6.081177)
  RequestModel(Config.fuelTrailerHashKey)
  while not HasModelLoaded(Config.fuelTrailerHashKey) do
    Citizen.Wait(100)
  end

  trailerObj = CreateVehicle(Config.fuelTrailerHashKey, coords["x"], coords["y"],  coords["z"], 177.77, true, false)
  SetEntityHeading(trailerObj, 140.338)
  SetEntityInvincible(trailerObj, true)

  status = "Please pickup assigned trailer and wait for a call!w"
  trailerInfo = info
end)

-- Called to start refilling this truck
RegisterNetEvent("activity_gasdelivery:startRefillingTrailer")
AddEventHandler("activity_gasdelivery:startRefillingTrailer", function()
  Citizen.CreateThread(function()
    print("Filling trailer with fuel...")
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 0.5, "pumping", 0.005)

    
    Citizen.Wait(5000)
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 0.5, "pumping", 0)

    print("completed filling lets let the server know...")
    TriggerServerEvent("activity_gasdelivery:trailerRefilled")
  end)
end)

-- Called when server wants to send user a notification
RegisterNetEvent("activity_gasdelivery:notification")
AddEventHandler("activity_gasdelivery:notification", function(message)
  local playerServerId = GetPlayerServerId(PlayerId())
  sendNotification(message, playerServerId)
end)

-- Called when server updates any trailer values and need to update on client
RegisterNetEvent("activity_gasdelivery:updateTrailerInfo")
AddEventHandler("activity_gasdelivery:updateTrailerInfo", function(info)
  trailerInfo = info
end)


-- Called when server sent us an assigned zone
RegisterNetEvent("activity_gasdelivery:assignedZone")
AddEventHandler("activity_gasdelivery:assignedZone", function(station)
  status = "Assigned to fill gas station " .. station
  assignedStation = station
end)

-- Called when user is trying to refill gas station
RegisterNetEvent("activity_gasdelivery:attemptFillStation")
AddEventHandler("activity_gasdelivery:attemptFillStation", function(message)
  local playerServerId = GetPlayerServerId(PlayerId())
  local pedVehicle = GetVehiclePedIsIn(PlayerPedId(), false)

  if pedVehicle ~= 0 then
    return sendNotification("You can't start pumping fuel while in vehicle.", playerServerId)
  end


  if trailerInfo == nil then
    return sendNotification("You don't have an assign trailer to refill.", playerServerId)
  end

  local trailerCoords = GetEntityCoords(trailerObj)
  local isInside, insideZone = Config.gasStationZones:isPointInside(trailerCoords)
  local canFuelZone = false
  
  if insideZone ~= nil and insideZone.name == assignedStation then
    canFuelZone = true
  end

  if not canFuelZone then
    return
  end

  TriggerServerEvent("activity_gasdelivery:fillStation", assignedStation)
end)

-- Called when server allows us to actually refill the station
RegisterNetEvent("activity_gasdelivery:startFillingStation")
AddEventHandler("activity_gasdelivery:startFillingStation", function(station)
  Citizen.CreateThread(function()
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 0.5, "pumping", 0.005)
    FreezeEntityPosition(trailerObj, true)
    
    print("Starting to pump fuel")
    Citizen.Wait(20000)
    FreezeEntityPosition(trailerObj, false)
    TriggerServerEvent("activity_gasdelivery:completedFillingStation", assignedStation)
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 0.5, "pumping", 0)

  end)
end)