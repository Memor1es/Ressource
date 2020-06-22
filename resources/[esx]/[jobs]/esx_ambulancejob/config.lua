Config = {}

Config.DrawDistance = 15.0
Config.Marker = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}
Config.ReviveReward = 125  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog = true -- enable anti-combat logging?
Config.LoadIpl = false -- disable if you're using fivem-ipl or other IPL loaders
Config.Locale = 'fr'

local second = 1000
local minute = 60 * second

Config.EarlyRespawnTimer = 15 * minute  -- Time til respawn is available
Config.BleedoutTimer = 30 * minute -- Time til the player bleeds out
Config.EnablePlayerManagement = true
Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath = true
Config.RemoveItemsAfterRPDeath = true
-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine = true
Config.EarlyRespawnFineAmount = 500
Config.RespawnPoint = {coords = vector3(366.268, -570.1329, 28.791), heading = 71.763}

Config.Hospitals = {

	CentralLosSantos = {
		Blip = {
			coords = vector3(357.3, -584.3, 28.7),
			sprite = 489,
			scale = 1.0,
			color = 49
		},
		AmbulanceActions = {vector3(336.478,-580.19,27.791)},
		Pharmacies = {vector3(354.426,-577.054,27.791)},
		Vehicles = {
			{
				Spawner = vector3(334.0, -561.3, 28.7),
				InsideShop = vector3(471.3, -580.2, 28.2),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(318.19, -547.70, 27.70), heading = 270.0, radius = 4.0 },
					{ coords = vector3(326.79, -542.12, 27.70), heading = 182.1, radius = 4.0 }
				}
			}
		},
		Helicopters = {
			{
				Spawner = vector3(340.1, -581.8, 74.1),
				InsideShop = vector3(-745.5, -1468.5 ,5.0001),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true },
				SpawnPoints = {{ coords = vector3(351.8, -587.7, 74.2), heading = 190.1, radius = 10.0 }}
			}
		},
	}
} 

Config.AuthorizedVehicles = {
	ambulance = {
		{ model = 'ambulance2', label = 'Ambulance', price = 1},
		{ model = 'emscar2', label = 'Voiture service', price = 1},
		{ model = 'emssuv', label = 'SUV service', price = 1}
	},
	doctor = {
		{ model = 'ambulance2', label = 'Ambulance', price = 1},
		{ model = 'emscar2', label = 'Voiture service', price = 1},
		{ model = 'emssuv', label = 'SUV service', price = 1}
	},
	chief_doctor = {
		{ model = 'ambulance2', label = 'Ambulance', price = 1},
		{ model = 'emscar2', label = 'Voiture service', price = 1},
		{ model = 'emssuv', label = 'SUV service', price = 1}
	},
	boss = {
		{ model = 'ambulance2', label = 'Ambulance', price = 1},
		{ model = 'emscar2', label = 'Voiture service', price = 1},
		{ model = 'emssuv', label = 'SUV service', price = 1}
	}
}

Config.AuthorizedHelicopters = {
	ambulance = {},
	doctor = {{ model = 'polmav', label = 'Maverick', price = 1}},
	chief_doctor = {{ model = 'polmav', label = 'Maverick', price = 1}},
	boss = {{ model = 'polmav', label = 'Maverick', price = 1}}
}