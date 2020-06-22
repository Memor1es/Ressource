resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_script {
  '@es_extended/locale.lua',
  'locales/fr.lua',
  'config.lua',
  'client/3dme_client.lua',
  'client/weapons.lua',
  'client/npc.lua',
  'client/drift.lua',
  'client/parachute_client.lua',
  'client/ufo.lua',
  'client/wheelchair.lua'
}

server_script {
  '@es_extended/locale.lua',
  'locales/fr.lua',
  'config.lua',
  'server/3dme_server.lua'
}