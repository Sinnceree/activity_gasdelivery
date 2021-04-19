Config = {
  playersOnDuty = {}, -- Store any people that started the activity and are waiting for a delivery location
  playerSpawnedTrailers = {}, -- Store the trailers the players spawned to keep track of how much "fuel" they have
  playerAssignedStation = {}, -- Store the player with their assigned zone
  gasStations = {
    { id = "gas_station_1", isBeingFilled = false, fuelLevel = 50 },
    -- { id = "gas_station_2", fullyFilled = false, isBeingFilled = false, fuelLevel = 50 },
  }
  
}