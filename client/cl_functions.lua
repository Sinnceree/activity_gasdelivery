
-- Send user a notification
function sendNotification(message, playerServerId)
  if not Config.enableNopixelExports then
    print(message) -- Just log it if its not enabled
  else
    exports["np-activities"]:notifyPlayer(playerServerId, message) -- Use nopixel exported notification
  end
end

-- Show text on top left screen (debug only)
function showText(message)
  SetTextFont(0)
  SetTextProportional(1)
  SetTextScale(0.0, 0.5)
  SetTextColour(0, 128, 255, 255)
  SetTextDropshadow(0, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(message)
  DrawText(100, 100)
end