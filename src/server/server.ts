
import { formatEventName, stations, timeBetweenQueueCheck } from "../config/main"
import { assignPlayerStation } from "./functions"
import GasDelivery from "./classes/GasDelivery";
import GasStation from "./classes/GasStation";

const Activity = new GasDelivery(stations)

setInterval(() => {
  assignPlayerStation(Activity)
}, timeBetweenQueueCheck);

// Called when the user is requests to get on duty from client
onNet(formatEventName("getOnDuty"), (playerServerId: number) => {
  Activity.addPlayerOnDuty(playerServerId);
});

// Used to get assigned trailer fuel levels
onNet(formatEventName("getTrailerFuelLevel"), (playerServerId: number) => {
  Activity.getTrailerFuelLevel(playerServerId);
});

// Called when a trailer has been refilled to 100%
onNet(formatEventName("trailerRefilled"), (playerServerId: number) => {
  Activity.trailerRefilled(playerServerId);
});

// Called when we picked a random person to assign a gas station to fill up.
onNet(formatEventName("assignGasStation"), (playerServerId: number) => {
  Activity.assignGasStation(playerServerId);
})

// Called when client is trying to fuel station
onNet(formatEventName("fillStation"), (fillStation: GasStation, playerServerId: number) => {
  Activity.fillStation(fillStation, playerServerId);
});

// Called when the client is done filling the station
onNet(formatEventName("completedFillingStation"), (fillStation: GasStation, playerServerId: number) => {
  Activity.completedFillingStation(fillStation, playerServerId);
});

// Called when the client is done filling the station
onNet(formatEventName("signOffDuty"), (playerServerId: number) => {
  Activity.setOffduty(playerServerId);
});

onNet(formatEventName("collectPaycheck"), (playerServerId: number) => {
  Activity.collectPlayerPaycheck(playerServerId);
});
