export default class Trailer {
  source: number;
  fuelLevel: number;

  constructor(source: number) {
    this.source = source;
    this.fuelLevel = this.randomNumber(1, 40);
  }

  randomNumber = (min: number, max: number) => {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  public setTrailerFuel = (amount: number) => {
    this.fuelLevel = amount;
    return true
  }
}