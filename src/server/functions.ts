import GasDelivery from "./classes/GasDelivery";
import { formatEventName } from "../config/main"


export const assignPlayerStation = (Activity: GasDelivery) => {
  const players = Activity.getPlayers();
  const availablePlayers = players.filter(e => e.assignedStation === null);

  if (availablePlayers.length < 1) {
    return
  }

  // Lets choose a random player to give the job too
  const randomPlayerIndex = Activity.randomNumber(0, availablePlayers.length - 1);
  const player = availablePlayers[randomPlayerIndex]

  // Okay we have the person we want to give the job too lets assign them the zone
  if (player) {
    TriggerEvent(formatEventName("assignGasStation"), player.source)
  }
}