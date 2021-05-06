import Player from "./Player"
import Trailer from "./Trailer";
import { formatEventName, payoutPerPecent } from "../../config/main";
import GasStation from "./GasStation"

export default class GasDelivery {
  playersOnDuty: Player[];
  playersTrailers: Trailer[];
  stations: GasStation[];

  constructor(stations: GasStation[]) {
    this.playersOnDuty = [];
    this.playersTrailers = [];
    this.stations = stations;
    console.log("Initilazing Gas Delivery Activity.");
  }

  // Returns undefined if player is not on duty or the player object
  isPlayerOnDuty = (playerServerId: number) => {
    const index = this.playersOnDuty.findIndex(e => e.source === playerServerId);
    return index !== -1 ? true : false;
  }

  // Adds player to on duty list
  addPlayerOnDuty = (playerServerId: number) => {
    // Lets check if the player is on duty already or not
    const isPlayerOnDuty = this.isPlayerOnDuty(playerServerId);

    if (isPlayerOnDuty) {
      return TriggerClientEvent(formatEventName("notification"), playerServerId, "You are already on duty!")
    }

    // Add player to on duty list for queue
    const player = new Player(playerServerId);
    this.playersOnDuty.push(player);

    // Lets generate this users trailer
    const trailer: Trailer = new Trailer(playerServerId);
    this.addPlayerTrailer(trailer);

    console.log("Added player to on duty queue.", playerServerId);
    TriggerClientEvent(formatEventName("spawnTrailer"), playerServerId, trailer);
  }

  // Adds a new trailer to keep track of
  addPlayerTrailer = (trailer: Trailer) => {
    this.playersTrailers.push(trailer);
  }

  // Get players trailer info
  getPlayerTrailer = (playerServerId: number) => {
    return this.playersTrailers.find(e => e.source == playerServerId);
  }

  // Get player Object
  getPlayer = (playerServerId: number) => {
    const index = this.playersOnDuty.findIndex(e => e.source === playerServerId);
    return index !== -1 ? this.playersOnDuty[index] : null;
  }

  // Remove player from on duty
  setOffduty = (playerServerId: number) => {
    const isOnDuty = this.isPlayerOnDuty(playerServerId);
    if (isOnDuty) {
      TriggerClientEvent(formatEventName("notification"), playerServerId, `You have signed off duty`);
      TriggerClientEvent(formatEventName("signedOffDuty"), playerServerId);
      return
    }

    const playerIndex = this.playersOnDuty.findIndex(e => e.source === playerServerId);
    if (playerIndex != -1) {
      this.playersOnDuty = this.playersOnDuty.slice(0, playerIndex);
      console.log(this.playersOnDuty)
    }

    return
  }

  // Assign a player a gas station and return it
  assignPlayerStation = (playerServerId: number): GasStation | null => {
    const filteredStations = this.stations.filter(e => !e.assignedTo && !e.isBeingFilled);

    if (filteredStations.length < 1) {
      return null
    }

    const randomIndex = this.randomNumber(0, filteredStations.length - 1);
    const randomStation = filteredStations[randomIndex];

    const stationIndex = this.stations.findIndex(e => e.id === randomStation.id);
    this.stations[stationIndex].assignedTo = playerServerId;
    this.stations[stationIndex].setFuelLevel(this.randomNumber(1, 70))
    return this.stations[stationIndex];
  }

  // Get a specific gas station
  getStation = (stationId: string) => {
    return this.stations.find(e => e.id === stationId)
  }

  // get all players on duty
  getPlayers = () => {
    return this.playersOnDuty
  }

  randomNumber = (min: number, max: number) => {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  // Collect users paycheck from NPC
  collectPlayerPaycheck = (playerServerId: number) => {
    const player = this.getPlayer(playerServerId);
    const paycheck = player.collectPaycheck();

    if (player) {
      TriggerClientEvent(formatEventName("notification"), playerServerId, `You have collected your paycheck! ${paycheck}`);
    }
  }

  // Fill this specific `gas station`
  fillStation = (fillStation: GasStation, playerServerId: number) => {
    const station = this.getStation(fillStation.id);

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

    const trailer = this.getPlayerTrailer(playerServerId);
    if (trailer.fuelLevel < fuelNeeded) {
      return TriggerClientEvent(formatEventName("notification"), playerServerId, `"More fuel in trailer required!`);
    }

    station.setBeingFilled(true)
    station.setAssignedTo(playerServerId)
    TriggerClientEvent(formatEventName("startFillingStation"), playerServerId, station)
  }


  assignGasStation = (playerServerId: number) => {
    const isPlayerOnDuty = this.isPlayerOnDuty(playerServerId);

    if (!isPlayerOnDuty) {
      return TriggerClientEvent(formatEventName("notification"), playerServerId, "You're not on duty but trying to be assigned a station.")
    }

    const player = this.getPlayer(playerServerId)

    if (player.assignedStation) {
      return TriggerClientEvent(formatEventName("notification"), playerServerId, "You're already assigned to a gas station.")
    }

    // Assign station
    const assignedStation = this.assignPlayerStation(playerServerId);

    if (assignedStation === null) {
      return TriggerClientEvent(formatEventName("notification"), playerServerId, `No open stations at the moment skip.`)
    }
    player.setAssignedStation(assignedStation);

    TriggerClientEvent(formatEventName("notification"), playerServerId, `You have been assigned station - ${assignedStation.name}`)
    return TriggerClientEvent(formatEventName("assignedZone"), playerServerId, assignedStation)
  }

  // Called when a trailer has refueled
  trailerRefilled = (playerServerId: number) => {
    const isPlayerOnDuty = this.isPlayerOnDuty(playerServerId);

    if (!isPlayerOnDuty) {
      return TriggerClientEvent(formatEventName("notification"), playerServerId, "Some reason you dont have a trailer?")
    }

    const trailer = this.getPlayerTrailer(playerServerId);
    trailer.setTrailerFuel(100)

    TriggerClientEvent(formatEventName("updateTrailerInfo"), playerServerId, trailer)
  }

  // Get a trailers fuel level
  getTrailerFuelLevel = (playerServerId: number) => {
    const isPlayerOnDuty = this.isPlayerOnDuty(playerServerId);

    if (!isPlayerOnDuty) {
      return TriggerClientEvent(formatEventName("notification"), playerServerId, "You are not on duty, you don't have a trailer.")
    }

    const trailer = this.getPlayerTrailer(playerServerId);
    return TriggerClientEvent(formatEventName("notification"), playerServerId, `Trailer Fuel Level: ${trailer.fuelLevel}%`)
  }

  // Called when completed pumping fuel at `station`
  completedFillingStation = (fillStation: GasStation, playerServerId: number) => {
    const player = this.getPlayer(playerServerId);
    const station = this.getStation(fillStation.id);
    const trailer = this.getPlayerTrailer(playerServerId);

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
  }

}