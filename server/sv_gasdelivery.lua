
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(Config.timeBetweenQueueCheck)
    if #Config.playersOnDuty > 0 then
      assignPlayerStation()
    end
  end
end)


-- Used to sign on duty and get ready to recieve delivery jobs
RegisterServerEvent(("%s:getOnDuty"):format(Config.activityName))
AddEventHandler(("%s:getOnDuty"):format(Config.activityName), function()
  -- Lets check if the player is already on duty list so we dont spawn too many trailers
  if (Config.playersOnDuty[source] ~= nil and Config.playersOnDuty[source] == true) then
    return TriggerClientEvent("activity_gasdelivery:notification", source, "You are already on duty and have a trailer")
  end

  -- Lets add the player to on duty list
  Config.playersOnDuty[source] = { id = source, assignedStation = nil }

  -- Lets spawn the user gas trailer with values
  local randomFuelLevel = math.random(1, 40) -- Lets generate a random amount of fuel when we create trailer
  Config.playerSpawnedTrailers[source] = { spawned = true, fuelLevel = randomFuelLevel }
  TriggerClientEvent(("%s:spawnTrailer"):format(Config.activityName), source, Config.playerSpawnedTrailers[source])


  print(Config.playersOnDuty[source])
end)

-- Called to check user vehicle trailer info
RegisterServerEvent(("%s:getTrailerFuelLevel"):format(Config.activityName))
AddEventHandler(("%s:getTrailerFuelLevel"):format(Config.activityName), function(cb)
  if Config.playerSpawnedTrailers[source] == nil then
    return nil
  end
   
  print(Config.playerSpawnedTrailers[source].fuelLevel)
  return TriggerClientEvent(("%s:notification"):format(Config.activityName), source, Config.playerSpawnedTrailers[source].fuelLevel)
end)

-- Called when a trailer has been refilled to 100%
RegisterServerEvent(("%s:trailerRefilled"):format(Config.activityName))
AddEventHandler(("%s:trailerRefilled"):format(Config.activityName), function()
  if Config.playerSpawnedTrailers[source] == nil then
    print("Trailer is null for some reason")
    return
  end

  Config.playerSpawnedTrailers[source].fuelLevel = 100
  TriggerClientEvent(("%s:updateTrailerInfo"):format(Config.activityName), source, Config.playerSpawnedTrailers[source])
  return 
end)

-- Called when we picked a random person to assign a gas station to fill up.
RegisterServerEvent(("%s:assignGasStation"):format(Config.activityName))
AddEventHandler(("%s:assignGasStation"):format(Config.activityName), function(playerServerId)
  -- Check if theyre on duty before trying to assign them a station
  if Config.playersOnDuty[playerServerId] == nil then
    return TriggerClientEvent(("%s:notification"):format(Config.activityName), playerServerId, "You're not currently on duty but some how trying to be assigned station")
  end

  -- Lets check if theyre already assigned one before doing it again
  if Config.playerAssignedStation[playerServerId] ~= nil then
    return TriggerClientEvent(("%s:notification"):format(Config.activityName), playerServerId, "You're already assigned a station")
  end

  -- Leta generate a random gas station for them to go too
  local availableStations = {}
  for v, station in pairs(Config.gasStations) do
    if station.assignedTo == nil then
      table.insert(availableStations, station.id)
    end
  end

  -- We have no available zones so just skip them this run
  if #availableStations == 0 then
    return
  end

  local randomStationIndex = math.random(#availableStations)
  local assignedStationId = availableStations[randomStationIndex]

  for v, station in pairs(Config.gasStations) do
    if station.id == assignedStationId then
      -- -- Lets store the zone theyre assigned to keep track
      Config.playerAssignedStation[playerServerId] = station
      Config.playerAssignedStation[playerServerId].fuelLevel = math.random(1, 40)
      
      -- Update their status in the duty table
      Config.playersOnDuty[playerServerId].assignedStation = assignedStationId
      
      station.assignedTo = playerServerId
      TriggerClientEvent(("%s:assignedZone"):format(Config.activityName), playerServerId, Config.playerAssignedStation[playerServerId])
    end
  end
end)


-- Called when the client is in gas station and trying to fill their zone
RegisterServerEvent(("%s:fillStation"):format(Config.activityName))
AddEventHandler(("%s:fillStation"):format(Config.activityName), function(station)
  for _, gasStation in pairs(Config.gasStations) do
    if gasStation.id == station.id then

      if gasStation.fuelLevel == 100 then
        return TriggerClientEvent(("%s:notification"):format(Config.activityName), source, "This gas station is currently full")
      end
      
      if gasStation.isBeingFilled then
        return TriggerClientEvent(("%s:notification"):format(Config.activityName), source, "This gas station is currently being filled")
      end
      
      local fuelNeeded = 100 - gasStation.fuelLevel

      print("fuel needed to fill up " .. fuelNeeded)
      
      if Config.playerSpawnedTrailers[source].fuelLevel < fuelNeeded then
        return TriggerClientEvent(("%s:notification"):format(Config.activityName), source, "More fuel in trailer required.")
      end

      gasStation.isBeingFilled = true
      TriggerClientEvent(("%s:startFillingStation"):format(Config.activityName), source, station)
    end
  end

end)

-- Called when the client is done filling the station
RegisterServerEvent(("%s:completedFillingStation"):format(Config.activityName))
AddEventHandler(("%s:completedFillingStation"):format(Config.activityName), function(station)
  for _, gasStation in pairs(Config.gasStations) do
    if gasStation.id == station.id then
      local remainingFuel = Config.playerSpawnedTrailers[source].fuelLevel - gasStation.fuelLevel

      Config.playerSpawnedTrailers[source].fuelLevel = remainingFuel
      gasStation.isBeingFilled = false
      gasStation.fuelLevel = 100
      gasStation.assignedTo = nil
      Config.playerAssignedStation[source] = nil -- Set player back to nil because they finished filling their station

      -- Update their status in the duty table
      Config.playersOnDuty[source].assignedStation = nil

      TriggerClientEvent(("%s:updateTrailerInfo"):format(Config.activityName), source, Config.playerSpawnedTrailers[source])

      -- Calculate how much to payout the player
      local fuelUsed = 100 - remainingFuel
      local payout = Config.payoutPerPecent * fuelUsed
      print("Completed filling station - Payout was - " .. payout)
      return TriggerClientEvent(("%s:notification"):format(Config.activityName), source, "Completed! Payout is $" .. payout)
    
    end
  end

end)

-- Called when the client is signing off duty
RegisterServerEvent(("%s:signOffDuty"):format(Config.activityName))
AddEventHandler(("%s:signOffDuty"):format(Config.activityName), function()
  
  Config.playerSpawnedTrailers[source] = nil
  Config.playersOnDuty[source] = nil
end)