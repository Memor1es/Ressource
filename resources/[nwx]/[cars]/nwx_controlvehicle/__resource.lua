resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'nwx_controlvehicle - NAWAX'

version '1.2'

server_scripts {
  '@async/async.lua',
  '@mysql-async/lib/MySQL.lua',
  'config/config.lua',
  'server/main.lua'
}

client_scripts {
  'config/config.lua',
  'client/main_inventory.lua',
  'client/main.lua',
  'client/client_vehcontrol.lua'
}