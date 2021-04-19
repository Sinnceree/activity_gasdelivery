
RegisterCommand("startgas", function(source, args)
  -- generateFuelTanker()
  TriggerServerEvent("activity_gasdelivery:getOnDuty")
end, false)