import * as Cfx from "fivem-js";

interface PolyInfoObject {
  minZ: number;
  maxZ: number;
  heading: number;
  width: number;
  length: number;
}

export default class GasStation {
  id: string;
  name: string;
  assignedTo: string;
  isBeingFilled: boolean;
  fuelLevel: number;
  coords: Cfx.Vector3;
  zoneInfo: PolyInfoObject;

  constructor(name: string, id: string, coords: Cfx.Vector3, zoneInfo: PolyInfoObject) {
    this.id = id;
    this.name = name;
    this.coords = coords;
    this.assignedTo = null;
    this.isBeingFilled = false;
    this.fuelLevel = 40;
    this.zoneInfo = zoneInfo;

    if (!IsDuplicityVersion()) {
      global.exports["nns_polyzone"]["CreateBoxZone"](id, coords, zoneInfo.length, zoneInfo.width, {
        heading: zoneInfo.heading,
        debugPoly: false,
        minZ: zoneInfo.minZ,
        maxZ: zoneInfo.maxZ
      })
    }
  }

  setBeingFilled = (toggle: boolean) => {
    this.isBeingFilled = toggle;
    return this.isBeingFilled;
  }

  setFuelLevel = (amount: number) => {
    this.fuelLevel = amount;
    return this.fuelLevel;
  }

  setAssignedTo = (playerServerId: string) => {
    this.assignedTo = playerServerId;
    return this.assignedTo;
  }

}