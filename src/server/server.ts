
import { formatEventName, stations, payoutPerPecent, timeBetweenQueueCheck } from "../config/main"
import { assignPlayerStation } from "./functions"
import Trailer from "./classes/Trailer";
import GasDelivery from "./classes/GasDelivery";
import GasStation from "./classes/GasStation";

const Activity = new GasDelivery(stations)

setInterval(() => {
  assignPlayerStation(Activity)
}, timeBetweenQueueCheck);

// Called when the user is requests to get on duty from client
onNet(formatEventName("getOnDuty"), () => {
  // Lets check if the player is on duty already or not
  const playerServerId = global.source;
  const isPlayerOnDuty = Activity.isPlayerOnDuty(playerServerId);

  if (isPlayerOnDuty) {
    return TriggerClientEvent(formatEventName("notification"), playerServerId, "You are already on duty!")
  }

  // Add player to on duty list for queue
  Activity.addPlayerOnDuty(playerServerId)

  // Lets generate this users trailer
  const trailer: Trailer = new Trailer(playerServerId)
  Activity.addPlayerTrailer(trailer)

  console.log("Added player to on duty queue.", playerServerId)
  TriggerClientEvent(formatEventName("spawnTrailer"), playerServerId, trailer)
});

// Used to get assigned trailer fuel levels
onNet(formatEventName("getTrailerFuelLevel"), () => {
  const playerServerId = global.source;
  const isPlayerOnDuty = Activity.isPlayerOnDuty(playerServerId);

  if (!isPlayerOnDuty) {
    return TriggerClientEvent(formatEventName("notification"), playerServerId, "You are not on duty, you don't have a trailer.")
  }

  const trailer = Activity.getPlayerTrailer(playerServerId);
  return TriggerClientEvent(formatEventName("notification"), playerServerId, `Trailer Fuel Level: ${trailer.fuelLevel}%`)
});

// Called when a trailer has been refilled to 100%
onNet(formatEventName("trailerRefilled"), () => {
  const playerServerId = global.source;
  const isPlayerOnDuty = Activity.isPlayerOnDuty(playerServerId);

  if (!isPlayerOnDuty) {
    return TriggerClientEvent(formatEventName("notification"), playerServerId, "Some reason you dont have a trailer?")
  }

  const trailer = Activity.getPlayerTrailer(playerServerId);
  trailer.setTrailerFuel(100)

  // return TriggerClientEvent(formatEventName("updateTrailerInfo"), playerServerId, trailer)
})

// Called when we picked a random person to assign a gas station to fill up.
onNet(formatEventName("assignGasStation"), (playerServerId: string) => {
  const isPlayerOnDuty = Activity.isPlayerOnDuty(playerServerId);

  if (!isPlayerOnDuty) {
    return TriggerClientEvent(formatEventName("notification"), playerServerId, "You're not on duty but trying to be assigned a station.")
  }

  const player = Activity.getPlayer(playerServerId)

  if (player.assignedStation) {
    return TriggerClientEvent(formatEventName("notification"), playerServerId, "You're already assigned to a gas station.")
  }

  // Assign station
  const assignedStation = Activity.assignPlayerStation(playerServerId);

  if (assignedStation === null) {
    return TriggerClientEvent(formatEventName("notification"), playerServerId, `No open stations at the moment skip.`)
  }
  player.setAssignedStation(assignedStation);

  TriggerClientEvent(formatEventName("notification"), playerServerId, `You have been assigned station - ${assignedStation.name}`)
  return TriggerClientEvent(formatEventName("assignedZone"), playerServerId, assignedStation)
})

// Called when client is trying to fuel station
onNet(formatEventName("fillStation"), (fillStation: GasStation) => {
  const playerServerId = global.source;
  const station = Activity.getStation(fillStation.id);

  if (station === undefined) {
    return console.log("Station returned undefined for sopme reason");
  }

  if (station.fuelLevel >= 100) {
    return TriggerClientEvent(formatEventName("notification"), playerServerId, `This gas station is currently full!`);
  }

  if (station.isBeingFilled) {
    return TriggerClientEvent(formatEventName("notification"), playerServerId, `This gas station is currently being filled!`);
  }

  const fuelNeeded = 100 - station.fuelLevel;
  console.log(`Fuel needed to fill up is ${fuelNeeded}`);

  const trailer = Activity.getPlayerTrailer(playerServerId);
  if (trailer.fuelLevel < fuelNeeded) {
    return TriggerClientEvent(formatEventName("notification"), playerServerId, `"More fuel in trailer required!`);
  }

  station.setBeingFilled(true)
  station.setAssignedTo(playerServerId)
  TriggerClientEvent(formatEventName("startFillingStation"), playerServerId, station)
});

// Called when the client is done filling the station
onNet(formatEventName("completedFillingStation"), (fillStation: GasStation) => {
  const playerServerId = global.source;
  const player = Activity.getPlayer(playerServerId);
  const station = Activity.getStation(fillStation.id);
  const trailer = Activity.getPlayerTrailer(playerServerId);

  // Calcualte remaining fuel
  const fuelNeeded = 100 - station.fuelLevel;
  const remainingFuel = trailer.fuelLevel - fuelNeeded;

  // Update trailer fuel level
  trailer.setTrailerFuel(remainingFuel);

  // Update station info
  station.setBeingFilled(false);
  station.setAssignedTo(null);
  station.setFuelLevel(100)

  player.setAssignedStation(null)

  // TriggerClientEvent(formatEventName("updateTrailerInfo"), playerServerId, trailer);

  // Calculate payout for the player
  const fuelUsed = 100 - remainingFuel;
  const payout = payoutPerPecent * fuelUsed;
  player.addMoneyToPaycheck(payout);
  return TriggerClientEvent(formatEventName("notification"), playerServerId, `Completed filling station - payout was $${payout}`);
});

// Called when the client is done filling the station
onNet(formatEventName("signOffDuty"), () => {
  const playerServerId = global.source;
  const isOnDuty = Activity.isPlayerOnDuty(playerServerId);

  if (isOnDuty) {
    Activity.setOffduty(playerServerId)
    TriggerClientEvent(formatEventName("notification"), playerServerId, `You have signed off duty`);
    return TriggerClientEvent(formatEventName("signedOffDuty"), playerServerId);
  }
});

onNet(formatEventName("collectPaycheck"), () => {
  const playerServerId = global.source;
  const player = Activity.getPlayer(playerServerId);
  const paycheck = player.collectPaycheck();

  if (player) {
    TriggerClientEvent(formatEventName("notification"), playerServerId, `You have collected your paycheck! ${paycheck}`);
  }
});


