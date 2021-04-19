
RegisterCommand("startgas", function(source, args)
  -- generateFuelTanker()
  TriggerServerEvent("activity_gasdelivery:getOnDuty")
end, false)

RegisterCommand("forceassign", function(source, args)
  TriggerServerEvent("activity_gasdelivery:assignGasStation")
end, false)