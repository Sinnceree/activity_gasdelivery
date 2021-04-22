Config = {
  activityName = "activity_gasdelivery",
  debugEnabled = true,
  playersOnDuty = {}, -- Store any people that started the activity and are waiting for a delivery location
  playerSpawnedTrailers = {}, -- Store the trailers the players spawned to keep track of how much "fuel" they have
  playerAssignedStation = {}, -- Store the player with their assigned zone
  enableNopixelExports = false,
  fuelTrailerHashKey = -730904777,
  gasStations = {
    { id = "gas_station_1", isBeingFilled = false, fuelLevel = 50 },
    { id = "gas_station_2", isBeingFilled = false, fuelLevel = 50 },
    { id = "gas_station_3", isBeingFilled = false, fuelLevel = 50 },
    { id = "gas_station_4", isBeingFilled = false, fuelLevel = 50 },
    { id = "gas_station_5", isBeingFilled = false, fuelLevel = 50 },
    { id = "gas_station_6", isBeingFilled = false, fuelLevel = 50 },
  },
}

Config.zones = {}

if (not IsDuplicityVersion()) then
  Config.zones = {}

  Config.zones = {
    refillTrailerZone = BoxZone:Create(vector3(594.79, -2803.04, 6.06), 7.6, 22.8, {
      name="trailer_fill_zone",
      heading=59,
      debugPoly=true,
      minZ=4.06,
      maxZ=10.06
    }),
  
    gasStationZones = ComboZone:Create({
      -- gas_station_1
      BoxZone:Create(vector3(266.84, -1258.97, 29.18), 34.2, 35.2, {
        name="gas_station_1",
        heading=0,
        -- debugPoly=true,
        minZ=28.18,
        maxZ=34.98
      }),
  
      -- gas_station_2
      BoxZone:Create(vector3(-322.2, -1475.44, 36.72), 32.6, 34.2, {
        name="gas_station_2",
        heading=350,
        --debugPoly=true,
        minZ=29.52,
        maxZ=35.12
      }),
  
      -- gas_station_3
      BoxZone:Create(vector3(-523.57, -1206.34, 20.0), 29.2, 23.0, {
        name="gas_station_3",
        heading=334,
        minZ=17,
        maxZ=22,
        --debugPoly=true
      }),

      -- gas_station_4
      BoxZone:Create(vector3(-720.14, -932.92, 18.46), 25.8, 33.8, {
        name="gas_station_4",
        heading=0,
        --debugPoly=true,
        minZ=17.46,
        maxZ=22.46
      }),

      -- gas_station_5
      BoxZone:Create(vector3(621.17, 271.09, 102.41), 42.6, 34.4, {
        name="gas_station_5",
        heading=350,
        --debugPoly=true,
        minZ=100.01,
        maxZ=107.81
      }),

      -- gas_station_6
      BoxZone:Create(vector3(1181.28, -326.99, 68.98), 25.8, 31.2, {
        name="gas_station_6",
        heading=100,
        --debugPoly=true,
        minZ=67.58,
        maxZ=74.38
      })
      
      
      
      
      
    }, { name="combo", debugPoly=Config.debugEnabled })
  
  }
end
