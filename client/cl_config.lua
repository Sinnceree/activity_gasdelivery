Config = {
  enableNopixelExports = false,
  fuelTrailerHashKey = -730904777,

  -- trailerSpawningZone = BoxZone:Create(vector3(661.72, -2662.53, 10.34), 16.2, 16.0, {
  --   name="trailer_spawn_zone",
  --   heading=0,
  --   debugPoly=true
  -- })

  refillTrailerZone = BoxZone:Create(vector3(594.79, -2803.04, 6.06), 7.6, 22.8, {
    name="trailer_fill_zone",
    heading=59,
    debugPoly=true,
    minZ=4.06,
    maxZ=10.06
  }),

  gasStations = {
    { id = "gas_station_1", fullyFilled = false, fillLevel = 50 },
    { id = "gas_station_2", fullyFilled = false, fillLevel = 50 },
  }

}