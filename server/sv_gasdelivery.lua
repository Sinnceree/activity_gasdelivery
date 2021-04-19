
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
RegisterServerEvent("activity_gasdelivery:getTrailerInfo")
AddEventHandler("activity_gasdelivery:getTrailerInfo", function()
  if Config.playerSpawnedTrailers[source] == nil then
    return nil
  end
   
  print(Config.playerSpawnedTrailers[source])
  return Config.playerSpawnedTrailers[source]
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
  -- if Config.playerSpawnedTrailers[source] == nil then
  --   return
  -- end

  -- Config.playerSpawnedTrailers[source].fuelLevel = 100
  -- TriggerClientEvent("activity_gasdelivery:updateTrailerInfo", source, Config.playerSpawnedTrailers[source])
  -- return 
end)