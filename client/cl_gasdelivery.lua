
local activityEnabled = true
local activityInProgress = false


-- Status/assigned station
local status = "Not signed on"
local assignedStation = nil

-- Refill zone variable and listening handler
local isInRefillZone = false
Config.zones.refillTrailerZone:onPlayerInOut(function(isPointInside, point)
  isInRefillZone = isPointInside
end)

-- is inside assigned station zone
local insideAssignedStation = false
Config.zones.gasStationZones:onPlayerInOut(function(isPointInside, point, zone)
  if assignedStation ~= nil and zone.name == assignedStation.id and isPointInside then
    insideAssignedStation = true
    status = "Inside zone start pumping gas into tank."
  elseif assignedStation ~= nil and zone.name == assignedStation.id and not isPointInside then
    status = "Please enter your assigned gas station - " .. assignedStation.name
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
      TriggerEvent(("%s:attemptRefill"):format(Config.activityName))
    end

    -- If has an assigned zone and inside it while clicking "E" then
    if assignedStation ~= nil and insideAssignedStation and IsControlJustPressed(1, 86) then
      TriggerEvent(("%s:attemptFillStation"):format(Config.activityName))
    end

    showText(status)
  end
end)

-- Called when user is potentially trying to refill their trailer
RegisterNetEvent(("%s:attemptRefill"):format(Config.activityName))
AddEventHandler(("%s:attemptRefill"):format(Config.activityName), function(message)
  local playerServerId = GetPlayerServerId(PlayerId())

  if trailerInfo == nil then
    return sendNotification("You don't have an assign trailer to refill.", playerServerId)
  end

  local trailerCoords = GetEntityCoords(trailerObj)
  local isTrailerInside = Config.zones.refillTrailerZone:isPointInside(trailerCoords)

  if isTrailerInside then
    if trailerInfo.fuelLevel == 100 then
      return sendNotification("Your trailer is already full!", playerServerId)
    end

    TriggerEvent(("%s:startRefillingTrailer"):format(Config.activityName))
  end

end)

-- Called when the server is ready to let us spawn a trailer
RegisterNetEvent(("%s:spawnTrailer"):format(Config.activityName))
AddEventHandler(("%s:spawnTrailer"):format(Config.activityName), function(info)
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
    FreezeEntityPosition(trailerObj, true)
    print("Filling trailer with fuel...")
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 0.5, "pumping", 0.005)

    
    Citizen.Wait(Config.refuelTrailerTime)
    FreezeEntityPosition(trailerObj, false)
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 0.5, "pumping", 0)

    print("completed filling lets let the server know...")
    TriggerServerEvent(("%s:trailerRefilled"):format(Config.activityName))
  end)
end)

-- Called when server wants to send user a notification
RegisterNetEvent(("%s:notification"):format(Config.activityName))
AddEventHandler(("%s:notification"):format(Config.activityName), function(message)
  local playerServerId = GetPlayerServerId(PlayerId())
  sendNotification(message, playerServerId)
end)

-- Called when server updates any trailer values and need to update on client
RegisterNetEvent(("%s:updateTrailerInfo"):format(Config.activityName))
AddEventHandler(("%s:updateTrailerInfo"):format(Config.activityName), function(info)
  trailerInfo = info
  print("trailer info updated")
end)


-- Called when server sent us an assigned zone
RegisterNetEvent(("%s:assignedZone"):format(Config.activityName))
AddEventHandler(("%s:assignedZone"):format(Config.activityName), function(station)
  local playerServerId = GetPlayerServerId(PlayerId())
  local canDoTask = false

  -- Lets check if they can do this "station"/"task"
  if Config.enableNopixelExports then
    canDoTask = exports["np-activities"]:canDoTask(Config.activityName, playerServerId, station.id)
  else
    canDoTask = true
  end

  if canDoTask then
    status = "Assigned to fill gas station " .. station.name
    assignedStation = station
    createStationBlip(station)
    
    if Config.enableNopixelExports then
      exports["np-activities"]:taskInProgress(Config.activityName, playerServerId, station.id, (Config.taskDescription):format(station.name))
    end
    
  else
    sendNotification("Can't do that task.", playerServerId)
  end
  

end)

-- Called when user is trying to refill gas station
RegisterNetEvent(("%s:attemptFillStation"):format(Config.activityName))
AddEventHandler(("%s:attemptFillStation"):format(Config.activityName), function(message)
  local playerServerId = GetPlayerServerId(PlayerId())
  local pedVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
  
  if pedVehicle ~= 0 then
    return sendNotification("You can't start pumping fuel while in vehicle.", playerServerId)
  end
  
  
  if trailerInfo == nil then
    return sendNotification("You don't have an assign trailer to refill.", playerServerId)
  end

  
  local trailerCoords = GetEntityCoords(trailerObj)
  local isInside, insideZone = Config.zones.gasStationZones:isPointInside(trailerCoords)
  local canFuelZone = false
  
  if insideZone ~= nil and insideZone.name == assignedStation.id then
    canFuelZone = true
  end
  
  if not canFuelZone then
    return
  end
  
  TriggerServerEvent(("%s:fillStation"):format(Config.activityName), assignedStation)
end)

-- Called when server allows us to actually refill the station
RegisterNetEvent(("%s:startFillingStation"):format(Config.activityName))
AddEventHandler(("%s:startFillingStation"):format(Config.activityName), function(station)
  local playerServerId = GetPlayerServerId(PlayerId())

  Citizen.CreateThread(function()
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 0.5, "pumping", 0.005)
    FreezeEntityPosition(trailerObj, true)
    
    print("Starting to pump fuel")
    Citizen.Wait(Config.pumpFuelTime)

    FreezeEntityPosition(trailerObj, false)
    TriggerServerEvent(("%s:completedFillingStation"):format(Config.activityName), assignedStation)
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 0.5, "pumping", 0)

    removeStationBlip(station) -- remove the blip we created
    status = "Waiting to be assigned another station"
    assignedStation = nil

    if Config.enableNopixelExports then
      exports["np-activities"]:taskCompleted(Config.activityName, playerServerId, station.id, true, "Completed filling up station")
    end


  end)
end)

-- Called when user tries to go on duty
RegisterNetEvent(("%s:attemptSignOnDuty"):format(Config.activityName))
AddEventHandler(("%s:attemptSignOnDuty"):format(Config.activityName), function(message)
  -- Check if activity is enabled
  if not activityEnabled then
    return 
  end

  local playerServerId = GetPlayerServerId(PlayerId())
  local canDoActivity = false

  if Config.enableNopixelExports then
    canDoActivity = exports["np-activities"]:canDoActivity(Config.activityName, playerServerId)
  else
    canDoActivity = true
  end

  if canDoActivity then
    TriggerServerEvent(("%s:getOnDuty"):format(Config.activityName))
    activityInProgress = true

    if Config.enableNopixelExports then
      exports["np-activities"]:activityInProgress(Config.activityName, playerServerId, Config.timeToComplete)
    end
    
  else
    sendNotification("You cant do this task at the moment", playerServerId)
  end
end)


-- Called when user is trying to refill gas station
RegisterNetEvent(("%s:setActivityStatus"):format(Config.activityName))
AddEventHandler(("%s:setActivityStatus"):format(Config.activityName), function(toggle)
  activityEnabled = toggle
end)


-- Called when user is trying to sign off duty
RegisterNetEvent(("%s:attemptSignOffDuty"):format(Config.activityName))
AddEventHandler(("%s:attemptSignOffDuty"):format(Config.activityName), function()
  local playerServerId = GetPlayerServerId(PlayerId())


  assignedStation = nil
  trailerObj = nil
  TriggerServerEvent(("%s:signOffDuty"):format(Config.activityName))

  if Config.enableNopixelExports then
    exports["np-activities"]:activityCompleted(Config.activityName, playerServerId, true, "Player signed off duty")
  end

end)
