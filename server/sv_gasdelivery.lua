
-- Used to sign on duty and get ready to recieve delivery jobs
RegisterServerEvent("activity_gasdelivery:getOnDuty")
AddEventHandler("activity_gasdelivery:getOnDuty", function()
  -- Lets check if the player is already on duty list so we dont spawn too many trailers
  if (Config.playersOnDuty[source] ~= nil and Config.playersOnDuty[source] == true) then
    return TriggerClientEvent("activity_gasdelivery:notification", source, "You are already on duty and have a trailer")
  end

  -- Lets add the player to on duty list
  Config.playersOnDuty[source] = true

  -- Lets spawn the user gas trailer with values
  local randomFuelLevel = math.random(1, 40) -- Lets generate a random amount of fuel when we create trailer
  Config.playerSpawnedTrailers[source] = { spawned = true, fuelLevel = randomFuelLevel }
  TriggerClientEvent("activity_gasdelivery:spawnTrailer", source, Config.playerSpawnedTrailers[source])

  print(Config.playersOnDuty[source])
end)

-- Called to check user vehicle trailer info
RegisterServerEvent("activity_gasdelivery:getTrailerFuelLevel")
AddEventHandler("activity_gasdelivery:getTrailerFuelLevel", function(cb)
  if Config.playerSpawnedTrailers[source] == nil then
    return nil
  end
   
  print(Config.playerSpawnedTrailers[source].fuelLevel)
  return TriggerClientEvent("activity_gasdelivery:notification", source, Config.playerSpawnedTrailers[source].fuelLevel)
end)

-- Called when a trailer has been refilled to 100%
RegisterServerEvent("activity_gasdelivery:trailerRefilled")
AddEventHandler("activity_gasdelivery:trailerRefilled", function()
  if Config.playerSpawnedTrailers[source] == nil then
    return
  end

  Config.playerSpawnedTrailers[source].fuelLevel = 100
  TriggerClientEvent("activity_gasdelivery:updateTrailerInfo", source, Config.playerSpawnedTrailers[source])
  return 
end)

-- Called when we picked a random person to assign a gas station to fill up.
RegisterServerEvent("activity_gasdelivery:assignGasStation")
AddEventHandler("activity_gasdelivery:assignGasStation", function()
  -- Leta generate a random gas station for them to go too
  local randomStationIndex = math.random(#Config.gasStations)
  local assignedStation = Config.gasStations[randomStationIndex]

  -- Lets store the zone theyre assigned to keep track
  Config.playerAssignedStation[source] = assignedStation.id

  print(Config.playerAssignedStation[source])
  
  TriggerClientEvent("activity_gasdelivery:assignedZone", source, Config.playerAssignedStation[source])
end)


-- Called when the client is in gas station and trying to fill their zone
RegisterServerEvent("activity_gasdelivery:fillStation")
AddEventHandler("activity_gasdelivery:fillStation", function(station)
  for _, gasStation in pairs(Config.gasStations) do
    if gasStation.id == station then

      if gasStation.fuelLevel == 100 then
        return TriggerClientEvent("activity_gasdelivery:notification", source, "This gas station is currently full")
      end
      
      if gasStation.isBeingFilled then
        return TriggerClientEvent("activity_gasdelivery:notification", source, "This gas station is currently being filled")
      end
      
      local fuelNeeded = 100 - gasStation.fuelLevel

      print("fuel needed to fill up " .. fuelNeeded)
      
      if Config.playerSpawnedTrailers[source].fuelLevel < fuelNeeded then
        return TriggerClientEvent("activity_gasdelivery:notification", source, "More fuel in trailer required.")
      end

      gasStation.isBeingFilled = true
      TriggerClientEvent("activity_gasdelivery:startFillingStation", source, station)
    
    end
  end

end)

-- Called when the client is done filling the station
RegisterServerEvent("activity_gasdelivery:completedFillingStation")
AddEventHandler("activity_gasdelivery:completedFillingStation", function(station)
  for _, gasStation in pairs(Config.gasStations) do
    if gasStation.id == station then
      local fueldUsed = Config.playerSpawnedTrailers[source].fuelLevel - gasStation.fuelLevel

      Config.playerSpawnedTrailers[source].fuelLevel = fueldUsed
      gasStation.isBeingFilled = false
      gasStation.fuelLevel = 100
      
      print("Completed filling zone")
    
    end
  end

end)