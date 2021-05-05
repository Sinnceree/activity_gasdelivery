import { Vector3 } from "fivem-js";
import "./commands"
import { activityName, formatEventName, fuelTrailerHashKey, refuelTrailerTime, useNopixelExports, pumpFuelTime, timeToComplete } from "../config/main"
import { createPed, sendNotification, createStationBlip, removeStationBlip } from "./functions";
import Trailer from "../server/classes/Trailer"
import GasStation from "../server/classes/GasStation";

let signOnDutyPed = null;
let inRefillZone = false;
let activityEnabled = true;
let assignedStation: GasStation | null = null;
let insideAssignedZone = false;
let trailerObj: null | number = null;
let trailerInfo: Trailer | null = null;

on("nns_polyzone:zoneChange", (name: string, isPointInside: boolean, point: any) => {
  if (name === "trailer_fill_zone") {
    inRefillZone = isPointInside;
  }

  if (assignedStation && name === assignedStation.id) {
    insideAssignedZone = isPointInside
  }
  // console.log(`zone change - ${name} inside - ${isPointInside}`)
});


// Called when resource is started we spawn ped and setup stuff here
const handleResourceStart = (): void => {
  const coords = new Vector3(676.2888, -2731.244, 6.018764);
  signOnDutyPed = createPed("s_m_y_construct_02", coords, 126.935);

  // Register sign on duty npc
  const options = [
    { text: "Sign On", eventName: formatEventName("attemptSignOnDuty") },
    { text: "Sign Off", eventName: formatEventName("signOffDuty") },
    { text: "Collect Paycheck", eventName: formatEventName("attemptCollectPaycheck") },
  ];
  global.exports["fivem-inspect"].registerInspectEntity(signOnDutyPed, options);

}

const handleResourceStop = (): void => {
  global.exports["fivem-inspect"].unregister();
}

on("onResourceStart", (resourceName: string) => {
  if (resourceName !== GetCurrentResourceName()) return;
  handleResourceStart();
});

on("onResourceStop", (resourceName: string) => {
  if (resourceName !== GetCurrentResourceName()) return;
  handleResourceStop();
});

// Called when user clicks interaction button
onNet(formatEventName("interaction"), () => {
  // if (inRefillZone) {
  //   return TriggerEvent(formatEventName("attemptRefill"))
  // }

  // if (assignedStation && insideAssignedZone) {
  //   return TriggerEvent(formatEventName("attemptFillStation"))
  // }
});

// Called when user tries to go on duty
onNet(formatEventName("attemptSignOnDuty"), () => {
  const playerServerId = GetPlayerServerId(PlayerId());

  if (!activityEnabled) {
    return sendNotification("Activity Disabled", playerServerId)
  }

  let canDoActivity = false;

  if (useNopixelExports) {
    canDoActivity = global.exports["np-activities"].canDoActivity(activityName, playerServerId);
  } else {
    canDoActivity = true;
  }

  if (canDoActivity) {
    emitNet(formatEventName("getOnDuty"), playerServerId)

    if (useNopixelExports) {
      global.exports["np-activities"].activityInProgress(activityName, playerServerId, timeToComplete)

    }
  }
});

// Called when user is potentially trying to refill their trailer
onNet(formatEventName("attemptRefill"), () => {
  if (!inRefillZone) return

  const playerServerId = GetPlayerServerId(PlayerId());

  if (!trailerInfo) {
    return sendNotification("You don't have an assigned trailer to fuel.", playerServerId);
  }

  const ped = PlayerPedId()
  const playerCoord = GetEntityCoords(ped, true)
  const trailerCoords = GetEntityCoords(trailerObj, false)
  const dist = GetDistanceBetweenCoords(playerCoord[0], playerCoord[1], playerCoord[2], trailerCoords[0], trailerCoords[1], trailerCoords[2], false)

  if (dist > 5) return; // If the trailer is further than 2.5 distance dont try fueling it

  if (trailerInfo.fuelLevel >= 100) {
    return sendNotification("Your trailer is already full!", playerServerId)
  }

  // Check if ped is in a vehicle before trying to fuel
  const vehicle = GetVehiclePedIsIn(ped, false);

  if (vehicle != 0) {
    return sendNotification("Can't fuel trailer while in vehicle.", playerServerId)
  }


  // Okay lets start fueling the trailer then
  FreezeEntityPosition(trailerObj, true);
  console.log("Filling trailer with fuel");
  TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 0.5, "pumping", 0.005);

  setTimeout(() => {
    console.log("Done fueling truck.");
    FreezeEntityPosition(trailerObj, false);
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 0.5, "pumping", 0);
    TriggerServerEvent(formatEventName("trailerRefilled"))
  }, refuelTrailerTime)
});

// Called when the server is ready to let us spawn a trailer
onNet(formatEventName("spawnTrailer"), (info: Trailer) => {
  const coords = new Vector3(660.2506, -2661.789, 6.081177)
  RequestModel(fuelTrailerHashKey)

  trailerObj = CreateVehicle(fuelTrailerHashKey, coords["x"], coords["y"], coords["z"], 177.77, true, false)
  SetEntityHeading(trailerObj, 140.338)
  SetEntityInvincible(trailerObj, true)
  trailerInfo = info

  // Register sign on duty npc
  const options = [
    { text: "Fuel Trailer", eventName: formatEventName("attemptRefill") },
    { text: "Fuel Level", eventName: formatEventName("attemptGetTrailerFuelLevel") },
    { text: "Pump Fuel", eventName: formatEventName("attemptFillStation") },
  ];
  global.exports["fivem-inspect"].registerInspectEntity(trailerObj, options);
});

// This is just here because `fivem-inspect` only triggers client events
onNet(formatEventName("attemptGetTrailerFuelLevel"), () => {
  TriggerServerEvent(formatEventName("getTrailerFuelLevel"))
});

// Called when server sent us an assigned zone
onNet(formatEventName("assignedZone"), (station: GasStation) => {
  const playerServerId = GetPlayerServerId(PlayerId());
  let canDoTask = false;

  if (useNopixelExports) {
    canDoTask = global.exports["np-activities"].canDoTask(activityName, playerServerId, station.id);
  } else {
    canDoTask = true;
  }

  if (!canDoTask) {
    return sendNotification("Can't do that task.", playerServerId)
  }

  assignedStation = station;
  createStationBlip(station);

  if (useNopixelExports) {
    global.exports["np-activities"].taskInProgress(activityName, playerServerId, station.id, `Go refill ${station.name}`);
  } else {
    sendNotification(`Go refill ${station.name}`, playerServerId)
  }
});

// Called when user is trying to refill gas station
onNet(formatEventName("attemptFillStation"), (station: GasStation) => {
  const playerServerId = GetPlayerServerId(PlayerId());
  const pedVehicle = GetVehiclePedIsIn(PlayerPedId(), false)

  if (pedVehicle != 0) {
    return sendNotification("You can't start pumping fuel while in vehicle.", playerServerId)
  }

  if (!trailerInfo) {
    return sendNotification("You don't have an assign trailer to refill.", playerServerId)
  }


  const ped = PlayerPedId()
  const playerCoord = GetEntityCoords(ped, true)
  const trailerCoords = GetEntityCoords(trailerObj, false)
  const dist = GetDistanceBetweenCoords(playerCoord[0], playerCoord[1], playerCoord[2], trailerCoords[0], trailerCoords[1], trailerCoords[2], false)

  if (dist > 5) return; // If the trailer is further than 2.5 distance dont try pumping fuel

  TriggerServerEvent(formatEventName("fillStation"), assignedStation)
});

// Called when server allows us to actually refill the station
onNet(formatEventName("startFillingStation"), (station: GasStation) => {
  const playerServerId = GetPlayerServerId(PlayerId());

  TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 0.5, "pumping", 0.005)
  FreezeEntityPosition(trailerObj, true)

  console.log("Starting to pump fuel");

  setTimeout(() => {

    FreezeEntityPosition(trailerObj, false)
    TriggerServerEvent(formatEventName("completedFillingStation"), assignedStation)
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 0.5, "pumping", 0)

    removeStationBlip() // remove the blip we created
    assignedStation = null

    if (useNopixelExports) {
      global.exports["np-activities"].taskCompleted(activityName, playerServerId, station.id, true, "Completed filling up station")
    }

  }, pumpFuelTime);


});


// Called when server updates any trailer values and need to update on client
onNet(formatEventName("updateTrailerInfo"), (trailer: Trailer) => {
  trailerInfo = trailer;
  console.log("Trailer info updated!")
});

// Called when user is trying to refill gas station
onNet(formatEventName("setActivityStatus"), (toggle: boolean) => {
  activityEnabled = toggle
});

// Handle notification from server
onNet(formatEventName("notification"), (message: string) => {
  const playerServerId = GetPlayerServerId(PlayerId());
  sendNotification(message, playerServerId)
});

// Handle user signed off duty
onNet(formatEventName("signedOffDuty"), (message: string) => {
  assignedStation = null;
  trailerInfo = null;
  trailerObj = null;
});

// Called when user wants to collect paycheck from NPC
onNet(formatEventName("attemptCollectPaycheck"), () => {
  TriggerServerEvent(formatEventName("collectPaycheck"))
});