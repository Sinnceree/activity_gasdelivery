
RegisterCommand("startgas", function(source, args)
  TriggerServerEvent("activity_gasdelivery:getOnDuty")
end, false)

RegisterCommand("forceassign", function(source, args)
  TriggerServerEvent("activity_gasdelivery:assignGasStation")
end, false)

RegisterCommand("trailerfuel", function(source, args)
  TriggerServerEvent("activity_gasdelivery:getTrailerFuelLevel", function(trailer)
    print(trailer)
  end)
end, false)