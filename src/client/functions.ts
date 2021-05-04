import { useNopixelExports, blipInfo } from "../config/main";
import GasStation from "../server/classes/GasStation";
import { Vector3 } from "fivem-js";

export const sendNotification = (message: string, playerServerId: number) => {
  if (useNopixelExports) {
    return global.exports["np-activities"].notifyPlayer(playerServerId, message)
  }
  console.log(message)
}

let createdBlip: any = null;
export const createStationBlip = (station: GasStation) => {
  createdBlip = AddBlipForCoord(station.coords["x"], station.coords["y"], station.coords["z"])
  AddTextEntry(station.id, `Assigned Station - ${station.name}`)
  SetBlipSprite(createdBlip, blipInfo.icon)
  SetBlipDisplay(createdBlip, 2)
  SetBlipScale(createdBlip, blipInfo.scale)
  SetBlipColour(createdBlip, blipInfo.color)
  SetBlipAsShortRange(createdBlip, true)
  BeginTextCommandSetBlipName(station.id)
  AddTextComponentString(station.name)
  EndTextCommandSetBlipName(createdBlip)
}

export const removeStationBlip = () => {
  RemoveBlip(createdBlip)
}

export const createPed = (ped: string, coords: Vector3, heading: number): number => {
  const pedModel = GetHashKey(ped);
  RequestModel(pedModel);

  const loadingInterval = setInterval(() => {
    if (HasModelLoaded(pedModel)) {
      return clearInterval(loadingInterval);
    }
  }, 10);

  return CreatePed(0, ped, coords.x, coords.y, coords.z, heading, true, false);
}