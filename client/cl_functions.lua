
-- Send user a notification
function sendNotification(message, playerServerId)
  if not Config.enableNopixelExports then
    print(message) -- Just log it if its not enabled
  else
    exports["np-activities"]:notifyPlayer(playerServerId, message) -- Use nopixel exported notification
  end
end