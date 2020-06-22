Config = {}

Config.DrawDistance = 15.0
Config.MarkerType = 1
Config.MarkerSize = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor = { r = 50, g = 50, b = 204 }
Config.EnablePlayerManagement = true
Config.EnableArmoryManagement = true
Config.EnableESXIdentity = true -- enable if you're using esx_identity
Config.EnableNonFreemodePeds = false -- turn this on if you want custom peds
Config.EnableLicenses = true -- enable if you're using esx_license
Config.EnableHandcuffTimer = false -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer = 10 * 60000 -- 10 mins
Config.EnableJobBlip = false -- enable blips for colleagues, requires esx_society
Config.MaxInService = -1
Config.Locale = 'fr' 

Config.suicidsquadStations = {

--[[
	['Suicid Squad'] = {
		Blip = {
			Coords = vector3(425.1, -979.5, 30.7),
			Sprite = 60,
			Display = 4,
			Scale = 0.0,
			Colour = 29
		},
		Cloakrooms = {
			vector3(-1107.7, -818.1, -42.8)
		},
		Armories = {
			vector3(-1120.0, -819.66, -42.87)
		},
		Vehicles = {
			{
				Spawner = vector3(1915.0, 577.2, 176.3),
				InsideShop = vector3(228.5, -993.5, -99.5),
				SpawnPoints = {
					{ coords = vector3(1908.6, 573.1, 175.7), heading = 244.4, radius = 6.0 },
					{ coords = vector3(1906.4, 569.4, 175.7), heading = 246.0, radius = 6.0 }
				}
			}
		},
	  Helicopters = {
			{
				Spawner = vector3(1927.7, 591.6, 178.8),
			    InsideShop = vector3(477.0, -1106.4, 43.0),
				SpawnPoints = {
					{ coords = vector3(1937.52, 595.98, 175.61), heading = 326.28, radius = 10.0 }
				}
			}
		}
		BossActions = {
			vector3(-1115.3, -814.4, -42.8)
		}
	}
	]]
['Suicid Squad'] = {
		Blip = {
			Coords = vector3(425.1, -979.5, 30.7),
			Sprite = 60,
			Display = 4,
			Scale = 0.0,
			Colour = 29
		},
		Cloakrooms = {
			vector3(-1107.7, -818.1, -42.8)
		},
		Armories = {
			vector3(-1120.0, -819.66, -42.87)
		},
		Vehicles = {
			{
				Spawner = vector3(1915.0, 577.2, 176.3),
				InsideShop = vector3(228.5, -993.5, -99.5),
				SpawnPoints = {
				{ coords = vector3(1908.6, 573.1, 175.7), heading = 244.4, radius = 6.0 },
					{ coords = vector3(1906.4, 569.4, 175.7), heading = 246.0, radius = 6.0 }
				}
			}
		},
		Helicopters = {
			{
				Spawner = vector3(1927.7, 591.6, 178.8),
				InsideShop =  vector3(477.0, -1106.4, 43.0),
				SpawnPoints = {
						{ coords = vector3(1937.52, 595.98, 175.61), heading = 326.28, radius = 10.0 }
				}
			}
		},
		BossActions = {
			vector3(448.4, -973.2, 30.6)
		}
	}
}

Config.AuthorizedWeapons = {
	boss = {
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 0 },
		{ weapon = 'WEAPON_CARBINERIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	},
	membre = {
		{ weapon = 'WEAPON_COMBATPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 0 },
		{ weapon = 'WEAPON_CARBINERIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 0 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 0 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 0 },
		{ weapon = 'WEAPON_STUNGUN', price = 0 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 0 }
	}
}

Config.AuthorizedVehicles = {
	Shared = {
	},
	boss = {
		{ model = 'baller6', label = '4x4 Blindée', price = 0 },
		{ model = 'baller3', label = '4x4 non Blindée', price = 0 },
		{ model = 'schafter4', label = 'Schafter V12', price = 0 }
	},
	membre = {
		{ model = 'baller6', label = '4x4 Blindée', price = 0 },
		{ model = 'baller3', label = '4x4 non Blindée', price = 0 },
		{ model = 'schafter4', label = 'Schafter V12', price = 0 }
	}
}

Config.AuthorizedHelicopters = {
	recruit = {},
	officer = {},
	sergeant = {},
	intendent = {},
	boss = {
		{ model = 'frogger', label = 'Hélicoptère', livery = 0, price = 0 }
	},
	membre = {
		{ model = 'frogger', label = 'Hélicoptère', livery = 0, price = 0 }
	}
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements
Config.Uniforms = {

	bullet_wear = {
		male = {
			['bproof_1'] = 11, ['bproof_2'] = 1
		},
		female = {
			['bproof_1'] = 13, ['bproof_2'] = 1
		}
	},
	gilet_wear = {
		male = {
			['bproof_1'] = 11, ['bproof_2'] = 1
		},
		female = {
			['bproof_1'] = 13, ['bproof_2'] = 1
		}
	}
}