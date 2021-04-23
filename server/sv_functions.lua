function assignPlayerStation()
  -- Lets create a list of players that arnt on a "call" currently to choose from
  local availablePlayers = {}
  for v, player in pairs(Config.playersOnDuty) do
    if player.assignedStation == nil then
      table.insert(availablePlayers, player)
    end
  end

  if #availablePlayers == 0 then
    return
  end
  
  -- Lets choose a random person from this list to assign a "job" too
  local randomPlayerIndex = math.random(#availablePlayers)
  local player = availablePlayers[randomPlayerIndex]

  -- Okay we have the person we want to give the job too lets assign them the zone
  if player ~= nil then
    TriggerEvent(("%s:assignGasStation"):format(Config.activityName), player.id)
  end
  

end