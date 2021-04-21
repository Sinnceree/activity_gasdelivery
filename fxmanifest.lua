fxversion "cerulean"
fx_version "1.0.0"
game "gta5"

shared_script "config.lua"

client_script {
  '@PolyZone/client.lua',
  '@PolyZone/BoxZone.lua',
  '@PolyZone/EntityZone.lua',
  '@PolyZone/CircleZone.lua',
  '@PolyZone/ComboZone.lua',
  "client/*.lua",
}

server_script {
  "server/*.lua"
}
