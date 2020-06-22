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
Config.GouvStations = {

	Gouv = {
		Blip = {
			Coords = vector3(-536.7, -216.2, 37.6),
			Sprite = 419,
			Display = 4,
			Scale = 0.8,
			Colour = 0
		},
		Cloakrooms = {
			vector3(118.599, -729.022, 242.15)
		},
		Armories = {
			vector3(119.393, -731.337, 242.151)
		},
		Vehicles = {
			{
				Spawner = vector3(-522.7638, -262.4464, 35.484),
				InsideShop = vector3(228.5, -993.5, -99.5),
				SpawnPoints = {
					{ coords = vector3(-519.169, -265.073, 35.03), heading = 112.71, radius = 6.0 },
					{ coords = vector3(-532.231, -270.564, 34.895), heading = 112.71, radius = 6.0 }
				}
			}
		},
		Helicopters = {
			{
				Spawner = vector3(-540.65, -237.82, 36.722),
				InsideShop = vector3(-745.5, -1468.5 ,5.0001),
				SpawnPoints = {
					{ coords = vector3(-539.5, -251.88, 36.005), heading =302.65 , radius = 10.0 }
				}
			}
		},
		BossActions = {
			vector3(122.99, -768.97, 242.15)
		}
	}
}

Config.AuthorizedWeapons = {
	stagiaire = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 1 },
		{ weapon = 'WEAPON_STUNGUN', price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 1 }
	},
	gardedc = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 1 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 1 },
		{ weapon = 'WEAPON_STUNGUN', price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 1 }
	},
	secretaire = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 1 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 1 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 1 },
		{ weapon = 'WEAPON_STUNGUN', price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 1 }
	},
	intendent = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 1 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 1 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 1 },
		{ weapon = 'WEAPON_STUNGUN', price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 1 }
	},
	coboss = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 1 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 1 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 1 },
		{ weapon = 'WEAPON_STUNGUN', price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 1 }
	},
	chef = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 1 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 1 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 1 },
		{ weapon = 'WEAPON_STUNGUN', price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 1 }
	},
	boss = {
		{ weapon = 'WEAPON_APPISTOL', components = { 0, 0, 1000, 4000, nil }, price = 1 },
		{ weapon = 'WEAPON_ADVANCEDRIFLE', components = { 0, 6000, 1000, 4000, 8000, nil }, price = 1 },
		{ weapon = 'WEAPON_PUMPSHOTGUN', components = { 2000, 6000, nil }, price = 1 },
		{ weapon = 'WEAPON_NIGHTSTICK', price = 1 },
		{ weapon = 'WEAPON_STUNGUN', price = 1 },
		{ weapon = 'WEAPON_FLASHLIGHT', price = 1 }
	}
}

Config.AuthorizedVehicles = {
	Shared = {
		{model = 'baller6', label = 'Baller LWB', price = 1},
		{model = 'voltic', label = 'Véhicule Présidentiel', price = 1}
	},
	stagiaire = {},
	gardedc = {{model = 'cognoscenti2', label = 'Cognoscenti Blindé', price = 1}},
	secretaire = {},
	coboss = {
		{model = 'cognoscenti2', label = 'Cognoscenti Blindé', price = 1},
		{model = 'stretch', label = 'Limousine', price = 1}
	},
	boss = {
		{model = 'cognoscenti2', label = 'Cognoscenti Blindé', price = 1},
		{model = 'stretch', label = 'Limousine', price = 1}

	}
}

Config.AuthorizedHelicopters = {
	stagiaire = {{model = 'supervolito2', label = 'Hélicoptere', livery = 0, price = 1}},
	gardedc = {{model = 'supervolito2', label = 'Hélicoptere', livery = 0, price = 1}},
	secretaire = {{model = 'supervolito2', label = 'Hélicoptere', livery = 0, price = 1}},
	coboss = {{model = 'supervolito2', label = 'Hélicoptere', livery = 0, price = 1}},
	boss = {{model = 'supervolito2', label = 'Hélicoptere', livery = 0, price = 1}}
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements
Config.Uniforms = {
	stagiaire_wear = {
		male = {
			['tshirt_1'] = 59, ['tshirt_2'] = 1,
			['torso_1'] = 55, ['torso_2'] = 0,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 25, ['pants_2'] = 0,
			['shoes_1'] = 25, ['shoes_2'] = 0,
			['helmet_1'] = 46, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = 2, ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 36, ['tshirt_2'] = 1,
			['torso_1'] = 48, ['torso_2'] = 0,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34, ['pants_2'] = 0,
			['shoes_1'] = 27, ['shoes_2'] = 0,
			['helmet_1'] = 45, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = 2, ['ears_2'] = 0
		}
	},
	gardedc_wear = {
		male = {
			['tshirt_1'] = 58, ['tshirt_2'] = 0,
			['torso_1'] = 55, ['torso_2'] = 0,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 25, ['pants_2'] = 0,
			['shoes_1'] = 25, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = 2, ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35, ['tshirt_2'] = 0,
			['torso_1'] = 48, ['torso_2'] = 0,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34, ['pants_2'] = 0,
			['shoes_1'] = 27, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = 2, ['ears_2'] = 0
		}
	},
	secretaire_wear = {
		male = {
			['tshirt_1'] = 58, ['tshirt_2'] = 0,
			['torso_1'] = 55, ['torso_2'] = 0,
			['decals_1'] = 8, ['decals_2'] = 1,
			['arms'] = 41,
			['pants_1'] = 25, ['pants_2'] = 0,
			['shoes_1'] = 25, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = 2, ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 23, ['tshirt_2'] = 1,
			['torso_1'] = 25, ['torso_2'] = 2,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 6,
			['pants_1'] = 6, ['pants_2'] = 0,
			['shoes_1'] = 0, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 6, ['chain_2'] = 0,
			['ears_1'] = 2, ['ears_2'] = 0
		}
	},
	intendent_wear = {
		male = {
			['tshirt_1'] = 58, ['tshirt_2'] = 0,
			['torso_1'] = 55, ['torso_2'] = 0,
			['decals_1'] = 8, ['decals_2'] = 2,
			['arms'] = 41,
			['pants_1'] = 25, ['pants_2'] = 0,
			['shoes_1'] = 25, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = 2, ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35, ['tshirt_2'] = 0,
			['torso_1'] = 48, ['torso_2'] = 0,
			['decals_1'] = 7, ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 34, ['pants_2'] = 0,
			['shoes_1'] = 27, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = 2, ['ears_2'] = 0
		}
	},
	coboss_wear = { -- currently the same as intendent_wear
		male = {
			['tshirt_1'] = 58, ['tshirt_2'] = 0,
			['torso_1'] = 55, ['torso_2'] = 0,
			['decals_1'] = 8, ['decals_2'] = 2,
			['arms'] = 41,
			['pants_1'] = 25, ['pants_2'] = 0,
			['shoes_1'] = 25, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = 2, ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35, ['tshirt_2'] = 0,
			['torso_1'] = 48, ['torso_2'] = 0,
			['decals_1'] = 7, ['decals_2'] = 2,
			['arms'] = 44,
			['pants_1'] = 34, ['pants_2'] = 0,
			['shoes_1'] = 27, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = 2, ['ears_2'] = 0
		}
	},
	chef_wear = {
		male = {
			['tshirt_1'] = 58, ['tshirt_2'] = 0,
			['torso_1'] = 55, ['torso_2'] = 0,
			['decals_1'] = 8, ['decals_2'] = 3,
			['arms'] = 41,
			['pants_1'] = 25, ['pants_2'] = 0,
			['shoes_1'] = 25, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = 2, ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35, ['tshirt_2'] = 0,
			['torso_1'] = 48, ['torso_2'] = 0,
			['decals_1'] = 7, ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34, ['pants_2'] = 0,
			['shoes_1'] = 27, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = 2, ['ears_2'] = 0
		}
	},
	boss_wear = { -- currently the same as chef_wear
		male = {
			['tshirt_1'] = 58, ['tshirt_2'] = 0,
			['torso_1'] = 55, ['torso_2'] = 0,
			['decals_1'] = 8, ['decals_2'] = 3,
			['arms'] = 41,
			['pants_1'] = 25, ['pants_2'] = 0,
			['shoes_1'] = 25, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = 2, ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 35, ['tshirt_2'] = 0,
			['torso_1'] = 48, ['torso_2'] = 0,
			['decals_1'] = 7, ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34, ['pants_2'] = 0,
			['shoes_1'] = 27, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = 2, ['ears_2'] = 0
		}
	},
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
			['tshirt_1'] = 59, ['tshirt_2'] = 1
		},
		female = {
			['tshirt_1'] = 36, ['tshirt_2'] = 1
		}
	}
}