import GasStation from "./GasStation";

export default class Player {
  source: string;
  assignedStation: GasStation | null;

  constructor(source: string) {
    this.source = source;
    this.assignedStation = null;
  }

  getAssignedStation = () => {
    return this.assignedStation;
  }

  setAssignedStation = (station: GasStation | null) => {
    this.assignedStation = station;
  }
}