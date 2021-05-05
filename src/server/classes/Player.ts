import GasStation from "./GasStation";

export default class Player {
  source: string;
  paycheck: number;
  assignedStation: GasStation | null;

  constructor(source: string) {
    this.source = source;
    this.assignedStation = null;
    this.paycheck = 0;
  }

  getAssignedStation = () => {
    return this.assignedStation;
  }

  setAssignedStation = (station: GasStation | null) => {
    this.assignedStation = station;
  }

  addMoneyToPaycheck = (amount: number) => {
    this.paycheck += amount;
  }

  collectPaycheck = (): number => {
    console.log("Collected paycheck"); // Only logs for now
    const paycheck = this.paycheck;
    this.paycheck = 0;
    return paycheck;
  }
}