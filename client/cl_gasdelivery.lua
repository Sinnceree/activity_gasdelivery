local isInRefillZone = false
Config.refillTrailerZone:onPlayerInOut(function(isPointInside, point)
  isInRefillZone = isPointInside
end)

local trailerObj = nil
local trailerInfo = nil

Citizen.CreateThread(function()
  while true do 
    Citizen.Wait(1)
    
    -- If the user is in the refill zone with their trailer start refilling
    if isInRefillZone and IsControlJustPressed(1, 86) then
      TriggerEvent("activity_gasdelivery:attemptRefill")
    end

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

  print(" trailer obj " .. trailerObj)

  print(isTrailerInside)

  -- local playerServerId = GetPlayerServerId(PlayerId())
  -- sendNotification(message, playerServerId)
end)

-- Called when the server is ready to let us spawn a trailer
RegisterNetEvent("activity_gasdelivery:spawnTrailer")
AddEventHandler("activity_gasdelivery:spawnTrailer", function(info)
  print("okay we're allowed to spawn trailer")

  local coords = vector3(660.2506, -2661.789, 6.081177)
  RequestModel(Config.fuelTrailerHashKey)
  while not HasModelLoaded(Config.fuelTrailerHashKey) do
    Citizen.Wait(100)
  end

  trailerObj = CreateVehicle(Config.fuelTrailerHashKey, coords["x"], coords["y"],  coords["z"], 177.77, true, false)
  SetEntityHeading(trailerObj, 140.338)

  print(trailerObj)
  trailerInfo = info
end)

-- Called when server wants to send user a notification
RegisterNetEvent("activity_gasdelivery:notification")
AddEventHandler("activity_gasdelivery:notification", function(message)
  local playerServerId = GetPlayerServerId(PlayerId())
  sendNotification(message, playerServerId)
end)