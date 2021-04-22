fxversion "cerulean"
fx_version "1.0.0"
game "gta5"

client_script {
  '@PolyZone/client.lua',
  '@PolyZone/BoxZone.lua',
  '@PolyZone/EntityZone.lua',
  '@PolyZone/CircleZone.lua',
  '@PolyZone/ComboZone.lua',
  "config.lua",
  "client/*.lua",
}

server_script {
  "config.lua",
  "server/*.lua"
}
