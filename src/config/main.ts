import * as Cfx from "fivem-js";
import GasStation from "../server/classes/GasStation";

export const useNopixelExports = false; // To use np-activies
export const timeBetweenQueueCheck = 30000; // How long to wait between chekcing players in queue
export const refuelTrailerTime = 10000; // How long it takes to fuel trailer with fuel
export const payoutPerPecent = 11; // Payment $ per percent of fuel
export const fuelTrailerHashKey = -730904777 // Fuel trailer hash
export const timeToComplete = 0; // how long they have to complete activity
export const pumpFuelTime = 10000 // How long it takes to pump fuel in station
export const activityName = "activity_gasdelivery"; // Name of the activity used to call events
export const formatEventName = (event: string) => `${activityName}:${event}`; // Format to "activity_gasdelivery:event"
export const blipInfo = { icon: 1, color: 5, scale: 1.0 } // Blip info on map

export const stations: GasStation[] = [
  new GasStation("Gas Station 1", "gas_station_1", new Cfx.Vector3(266.84, -1258.97, 29.18), {
    heading: 0,
    minZ: 28.18,
    maxZ: 34.98,
    length: 34.2,
    width: 35.2,
  }),

  new GasStation("Gas Station 2", "gas_station_2", new Cfx.Vector3(-322.2, -1475.44, 36.72), {
    heading: 350,
    minZ: 29.52,
    maxZ: 35.12,
    length: 32.6,
    width: 34.2,
  }),

  new GasStation("Gas Station 3", "gas_station_3", new Cfx.Vector3(-523.57, -1206.34, 20.0), {
    heading: 334,
    minZ: 17,
    maxZ: 22,
    length: 29.2,
    width: 23.0,
  }),

  new GasStation("Gas Station 4", "gas_station_4", new Cfx.Vector3(621.17, 271.09, 102.41), {
    heading: 350,
    minZ: 100.01,
    maxZ: 107.81,
    length: 42.6,
    width: 34.4,
  }),

  new GasStation("Gas Station 5", "gas_station_5", new Cfx.Vector3(1181.28, -326.99, 68.98), {
    heading: 100,
    minZ: 67.58,
    maxZ: 74.38,
    length: 25.8,
    width: 31.2,
  }),

  new GasStation("Gas Station 6", "gas_station_6", new Cfx.Vector3(1206.08, -1402.81, 35.28), {
    heading: 24,
    minZ: 33.28,
    maxZ: 40.68,
    length: 21.2,
    width: 26.2,
  }),

  new GasStation("Gas Station 7", "gas_station_7", new Cfx.Vector3(-2093.63, -319.2, 13.78), {
    heading: 355,
    minZ: 11.78,
    maxZ: 18.38,
    length: 44.4,
    width: 41.4,
  }),

  new GasStation("Gas Station 8", "gas_station_8", new Cfx.Vector3(2685.81, 3271.25, 55.34), {
    heading: 240,
    minZ: 53.94,
    maxZ: 59.14,
    length: 14.8,
    width: 34.6,
  }),
];

let trailerFillZone: any;
if (!IsDuplicityVersion()) {

  trailerFillZone = global.exports["nns_polyzone"]["CreateBoxZone"]("trailer_fill_zone", new Cfx.Vector3(594.79, -2803.04, 6.06), 7.6, 22.8, {
    heading: 59,
    debugPoly: true,
    minZ: 4.06,
    maxZ: 10.06
  })
}

export {
  trailerFillZone,
}
