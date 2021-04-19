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

  gasStationZones = ComboZone:Create({
    BoxZone:Create(vector3(266.84, -1258.97, 29.18), 34.2, 35.2, {
      name="gas_station_1",
      heading=0,
      -- debugPoly=true,
      minZ=28.18,
      maxZ=34.98
    }),
    -- BoxZone:Create(vector3(-322.2, -1475.44, 36.72), 32.6, 34.2, {
    --   name="gas_station_2",
    --   heading=350,
    --   --debugPoly=true,
    --   minZ=29.52,
    --   maxZ=35.12
    -- })
  }, { name="combo", debugPoly=true })

}