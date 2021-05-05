import Player from "./Player"
import Trailer from "./Trailer";

import GasStation from "./GasStation"

export default class GasDelivery {
  playersOnDuty: Player[];
  playersTrailers: Trailer[];
  stations: GasStation[];

  constructor(stations: GasStation[]) {
    this.playersOnDuty = [];
    this.playersTrailers = [];
    this.stations = stations;
    console.log("Initilazing Gas Delivery Activity.")
  }

  // Returns undefined if player is not on duty or the player object
  isPlayerOnDuty = (playerServerId: string) => {
    const index = this.playersOnDuty.findIndex(e => e.source === playerServerId);
    return index !== -1 ? true : false;
  }

  // Adds player to on duty list
  addPlayerOnDuty = (playerServerId: string) => {
    const player = new Player(playerServerId);
    this.playersOnDuty.push(player);
    return player;
  }

  // Adds a new trailer to keep track of
  addPlayerTrailer = (trailer: Trailer) => {
    this.playersTrailers.push(trailer);
  }

  // Get players trailer info
  getPlayerTrailer = (playerServerId: string) => {
    return this.playersTrailers.find(e => e.source == playerServerId);
  }

  // Get player Object
  getPlayer = (playerServerId: string | number) => {
    const index = this.playersOnDuty.findIndex(e => e.source === playerServerId);
    return index !== -1 ? this.playersOnDuty[index] : null;
  }

  // Remove player from on duty
  setOffduty = (playerServerId: string) => {
    const playerIndex = this.playersOnDuty.findIndex(e => e.source === playerServerId);
    if (playerIndex != -1) {
      this.playersOnDuty = this.playersOnDuty.slice(0, playerIndex);
      console.log(this.playersOnDuty)
    }

    return
  }

  // Assign a player a gas station and return it
  assignPlayerStation = (playerServerId: string): GasStation | null => {
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

}