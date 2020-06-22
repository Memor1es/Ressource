resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'esx_base - Nawax'

version '1.0'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/classes/addonaccount.lua',
	'server/classes/addoninventory.lua',
	'server/classes/datastore.lua',
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'es_extended',
	'esx_skin',
}