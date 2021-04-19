local isInRefillZone = false
Config.refillTrailerZone:onPlayerInOut(function(isPointInside, point)
  isInRefillZone = isPointInside
end)

Citizen.CreateThread(function()
  while true do 
    Citizen.Wait(1)
    
    -- If the user is in the refill zone with their trailer start refilling
    if isInRefillZone and IsControlJustPressed(1, 86) then
      print(isInRefillZone)
    end

  end
end)

-- Called when the server is ready to let us spawn a trailer
RegisterNetEvent("activity_gasdelivery:spawnTrailer")
AddEventHandler("activity_gasdelivery:spawnTrailer", function()
  print("okay we're allowed to spawn trailer")
end)