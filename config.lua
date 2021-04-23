Config = {
  activityName = "activity_gasdelivery",
  debugEnabled = false,
  timeBetweenQueueCheck = 30000, -- Check and assign a player to a station every 30 seconds 
  payoutPerPecent = 11, -- How much money to payout per % of fuel ex ($11 x 40) if a station only need 40% to fill up their tank
  playersOnDuty = {}, -- Store any people that started the activity and are waiting for a delivery location
  playerSpawnedTrailers = {}, -- Store the trailers the players spawned to keep track of how much "fuel" they have
  playerAssignedStation = {}, -- Store the player with their assigned zone
  enableNopixelExports = true, -- Either use nopixel exports or not
  fuelTrailerHashKey = -730904777, -- Trailer vehicle hash key
  timeToComplete = 0, -- How long to complete activity
  pumpFuelTime = 10000, -- How long it takes to pump fuel at a station in MS
  refuelTrailerTime = 10000, -- How long it takes to refuel trailer in MS
  taskDescription = "Refill %s", -- Task description for gas stations
  gasStations = { 
    { name = "Gas Station 1" , id = "gas_station_1",  assignedTo = nil, isBeingFilled = false, fuelLevel = math.random(1, 32), coords = vector3(266.84, -1258.97, 29.18), },
    { name = "Gas Station 2" , id = "gas_station_2",  assignedTo = nil, isBeingFilled = false, fuelLevel = math.random(1, 32), coords = vector3(-322.2, -1475.44, 36.72) },
    { name = "Gas Station 3" , id = "gas_station_3",  assignedTo = nil, isBeingFilled = false, fuelLevel = math.random(1, 32), coords = vector3(-523.57, -1206.34, 20.0) },
    { name = "Gas Station 4" , id = "gas_station_4",  assignedTo = nil, isBeingFilled = false, fuelLevel = math.random(1, 32), coords = vector3(621.17, 271.09, 102.41) },
    { name = "Gas Station 5" , id = "gas_station_5",  assignedTo = nil, isBeingFilled = false, fuelLevel = math.random(1, 32), coords = vector3(1181.28, -326.99, 68.98) },
    { name = "Gas Station 6" , id = "gas_station_6",  assignedTo = nil, isBeingFilled = false, fuelLevel = math.random(1, 32), coords = vector3(1206.08, -1402.81, 35.28) },
    { name = "Gas Station 7" , id = "gas_station_7",  assignedTo = nil, isBeingFilled = false, fuelLevel = math.random(1, 32), coords = vector3(-2093.63, -319.2, 13.78) },
    { name = "Gas Station 8" , id = "gas_station_8",  assignedTo = nil, isBeingFilled = false, fuelLevel = math.random(1, 32), coords = vector3(2685.81, 3271.25, 55.34) },
    { name = "Gas Station 9" , id = "gas_station_9",  assignedTo = nil, isBeingFilled = false, fuelLevel = math.random(1, 32), coords = vector3(2002.13, 3768.66, 32.18) },
  },
  zones = {},
  blipInfo = {
    icon = 1,
    color = 5,
    scale = 1.0,
  }
}




if (not IsDuplicityVersion()) then
  Config.zones = {}

  Config.zones = {
    refillTrailerZone = BoxZone:Create(vector3(594.79, -2803.04, 6.06), 7.6, 22.8, {
      name="trailer_fill_zone",
      heading=59,
      -- debugPoly=true,
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

      -- gas_station_5
      BoxZone:Create(vector3(621.17, 271.09, 102.41), 42.6, 34.4, {
        name="gas_station_4",
        heading=350,
        --debugPoly=true,
        minZ=100.01,
        maxZ=107.81
      }),

      -- gas_station_6
      BoxZone:Create(vector3(1181.28, -326.99, 68.98), 25.8, 31.2, {
        name="gas_station_5",
        heading=100,
        --debugPoly=true,
        minZ=67.58,
        maxZ=74.38
      }),
      
      -- gas_station_7
      BoxZone:Create(vector3(1206.08, -1402.81, 35.28), 21.2, 26.2, {
        name="gas_station_6",
        heading=24,
        --debugPoly=true,
        minZ=33.28,
        maxZ=40.68
      }),

      -- gas_station_8
      BoxZone:Create(vector3(-2093.63, -319.2, 13.78), 44.4, 41.4, {
        name="gas_station_7",
        heading=355,
        --debugPoly=true,
        minZ=11.78,
        maxZ=18.38
      }),

      -- gas_station_9
      BoxZone:Create(vector3(2685.81, 3271.25, 55.34), 14.8, 34.6, {
        name="gas_station_8",
        heading=240,
        --debugPoly=true,
        minZ=53.94,
        maxZ=59.14
      }),

      -- gas_station_10
      BoxZone:Create(vector3(2002.13, 3768.66, 32.18), 23.8, 41.4, {
        name="gas_station_9",
        heading=30,
        --debugPoly=true
      })
      
      
      
      
    }, { name="combo", debugPoly=Config.debugEnabled })
  
  }
end
