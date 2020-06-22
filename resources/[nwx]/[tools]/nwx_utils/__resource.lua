resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'NWX Utils'

version '1.0'

ui_page 'hack.html'

server_scripts {
  '@es_extended/locale.lua',
  '@mysql-async/lib/MySQL.lua',
  'server/server.lua',
  'config.lua'
}

client_scripts {
  '@es_extended/locale.lua',
  'client/client.lua',
  'config.lua',
  'mhacking.lua',
  'sequentialhack.lua',
  'client/client_zone.lua'
}

files {
  'phone.png',
  'snd/beep.ogg',
  'snd/correct.ogg',
  'snd/fail.ogg', 
  'snd/start.ogg',
  'snd/finish.ogg',
  'snd/wrong.ogg',
  'hack.html'
}

dependencies {
	'es_extended'
}