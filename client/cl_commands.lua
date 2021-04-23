
RegisterCommand("startgas", function(source, args)
  TriggerEvent(("%s:attemptSignOnDuty"):format(Config.activityName))
end, false)

RegisterCommand("forceassign", function(source, args)
  local playerServerId = GetPlayerServerId(PlayerId())
  TriggerServerEvent(("%s:assignGasStation"):format(Config.activityName), playerServerId)
end, false)

RegisterCommand("stopgas", function(source, args)
  TriggerEvent(("%s:attemptSignOffDuty"):format(Config.activityName))
end, false)

RegisterCommand("trailerfuel", function(source, args)
  TriggerServerEvent(("%s:getTrailerFuelLevel"):format(Config.activityName), function(trailer)
    print(trailer)
  end)
end, false)