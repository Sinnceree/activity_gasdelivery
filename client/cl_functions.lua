
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

-- Create a blip
local createdBlip = {}
function createStationBlip(station)
  AddTextEntry(station.id, "Assigned Station - " .. station.name)
  createdBlip[station.id] = AddBlipForCoord(station.coords["x"], station.coords["y"], station.coords["z"])
  SetBlipSprite(createdBlip[station.id], Config.blipInfo.icon)
  SetBlipDisplay(createdBlip[station.id], 2)
  SetBlipScale(createdBlip[station.id], Config.blipInfo.scale)
  SetBlipColour(createdBlip[station.id], Config.blipInfo.color)
  SetBlipAsShortRange(createdBlip[station.id], true)
  BeginTextCommandSetBlipName(station.id)
  AddTextComponentString(station.name)
  EndTextCommandSetBlipName(createdBlip[station.id])
end

function removeStationBlip(station)
  RemoveBlip(createdBlip[station.id])
end

-- Exported function
function setActivityStatus(toggle)
  TriggerEvent(("%s:setActivityStatus"):format(Config.activityName), toggle)
end

function startActivity(playerServerId)
  TriggerEvent(("%s:attemptSignOnDuty"):format(Config.activityName))
end

