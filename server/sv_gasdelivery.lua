
-- Used to sign on duty and get ready to recieve delivery jobs
RegisterServerEvent("activity_gasdelivery:getOnDuty")
AddEventHandler("activity_gasdelivery:getOnDuty", function()
  -- Lets add the player to on duty list
  Config.playersOnDuty[source] = true

  -- Lets spawn the user gas trailer with values
  Config.playerSpawnedTrailers[source] = { spawned = true, fuelLevel = 10 }
  TriggerClientEvent("activity_gasdelivery:spawnTrailer", source)

  print(Config.playersOnDuty[source])
end)

-- Called to check user vehicle trailer info
RegisterServerEvent("activity_gasdelivery:getTrailerFuelLevel")
AddEventHandler("activity_gasdelivery:getTrailerFuelLevel", function()
  -- -- Lets add the player to on duty list
  -- Config.playersOnDuty[source] = true

  -- -- Lets spawn the user gas trailer with values
  -- Config.playerSpawnedTrailers[source] = { spawned = true, fuelLevel = 10 }

  print(Config.playersOnDuty[source])
end)