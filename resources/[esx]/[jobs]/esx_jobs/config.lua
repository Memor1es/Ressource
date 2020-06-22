Config              = {}
Config.DrawDistance = 100.0
Config.Locale       = 'fr'
Config.Jobs         = {}

Config.MaxCaution = 10000 -- the max caution allowed

Config.PublicZones = {

	EnterBuilding = {
		Pos   = { x = -118.21, y = -607.14, z = 35.28 },
		Size  = {x = 3.0, y = 3.0, z = 0.2},
		Color = {r = 204, g = 204, b = 0},
		Marker= 1,
		Blip  = false,
		Name  = _U('reporter_name'),
		Type  = "teleport",
		Hint  = _U('public_enter'),
		Teleport = { x = -139.09, y = -620.74, z = 167.82 }
	},

	ExitBuilding = {
		Pos   = { x = -139.45, y = -617.32, z = 167.82 },
		Size  = {x = 3.0, y = 3.0, z = 0.2},
		Color = {r = 204, g = 204, b = 0},
		Marker= 1,
		Blip  = false,
		Name  = _U('reporter_name'),
		Type  = "teleport",
		Hint  = _U('public_leave'),
		Teleport = { x = -113.07, y = -604.93, z = 35.28 },
	}

}

Config.Jobs.tailor = {

	BlipInfos = {
		Sprite = 366,
		Color = 4
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = 'youga2',
			Trailer = 'none',
			HasCaution = true
		}

	},

	Zones = {

		CloakRoom = {
			Pos = {x = 706.73, y = -960.90, z = 29.39},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('dd_dress_locker'),
			Type = 'cloakroom',
			Hint = _U('cloak_change'),
			GPS = {x = 740.80, y = -970.06, z = 23.46}
		},

		Wool = {
			Pos = {x = 1978.92, y = 5171.70, z = 46.63},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('dd_wool'),
			Type = 'work',
			Item = {
				{
					name = _U('dd_wool'),
					db_name = 'wool',
					time = 3,
					max = 40,
					add = 1,
					remove = 1,
					requires = 'nothing',
					requires_name = 'Nothing',
					drop = 100
				}
			},
			Hint = _U('dd_pickup'),
			GPS = {x = 715.95, y = -959.63, z = 29.39}
		},

		Fabric = {
			Pos = {x = 715.95, y = -959.63, z = 29.39},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('dd_fabric'),
			Type = 'work',
			Item = {
				{
					name = _U('dd_fabric'),
					db_name = 'fabric',
					time = 5,
					max = 80,
					add = 2,
					remove = 1,
					requires = 'wool',
					requires_name = _U('dd_wool'),
					drop = 100
				}
			},
			Hint = _U('dd_makefabric'),
			GPS = {x = 712.92, y = -970.58, z = 29.39}
		},

		Clothe = {
			Pos = {x = 712.92, y = -970.58, z = 29.39},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('dd_clothing'),
			Type = 'work',
			Item = {
				{
					name = _U('dd_clothing'),
					db_name = 'clothe',
					time = 4,
					max = 40,
					add = 1,
					remove = 2,
					requires = 'fabric',
					requires_name = _U('dd_fabric'),
					drop = 100
				}
			},
			Hint = _U('dd_makeclothing'),
			GPS = {x = 429.59, y = -807.34, z = 28.49}
		},

		VehicleSpawner = {
			Pos = {x = 740.80, y = -970.06, z = 23.46},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('spawn_veh'),
			Type = 'vehspawner',
			Spawner = 1,
			Hint = _U('spawn_veh_button'),
			Caution = 2000,
			GPS = {x = 1978.92, y = 5171.70, z = 46.63}
		},

		VehicleSpawnPoint = {
			Pos = {x = 747.31, y = -966.23, z = 23.70},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1,
			Blip = false,
			Name = _U('service_vh'),
			Type = 'vehspawnpt',
			Spawner = 1,
			Heading = 270.1,
			GPS = 0
		},

		VehicleDeletePoint = {
			Pos = {x = 693.79, y = -963.01, z = 22.82},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 255, g = 0, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('return_vh'),
			Type = 'vehdelete',
			Hint = _U('return_vh_button'),
			Spawner = 1,
			Caution = 2000,
			GPS = 0,
			Teleport = 0
		},

		Delivery = {
			Pos = {x = 429.59, y = -807.34, z = 28.49},
			Color = {r = 204, g = 204, b = 0},
			Size = {x = 5.0, y = 5.0, z = 3.0},
			Marker = 1,
			Blip = true,
			Name = _U('delivery_point'),
			Type = 'delivery',
			Spawner = 1,
			Item = {
				{
					name = _U('delivery'),
					time = 0.5,
					remove = 1,
					max = 100, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
					price = 40,
					requires = 'clothe',
					requires_name = _U('dd_clothing'),
					drop = 100
				}
			},
			Hint = _U('dd_deliver_clothes'),
			GPS = {x = 1978.92, y = 5171.70, z = 46.63}
		}
	}
}


Config.Jobs.slaughterer = {

	BlipInfos = {
		Sprite = 256,
		Color = 5
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = 'benson',
			Trailer = 'none',
			HasCaution = true
		}
	},

	Zones = {

		CloakRoom = {
			Pos = {x = -1071.13, y = -2003.78, z = 14.78},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('s_slaughter_locker'),
			Type = 'cloakroom',
			Hint = _U('cloak_change')
		},

		AliveChicken = {
			Pos = {x = -62.90, y = 6241.46, z = 30.09},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('s_hen'),
			Type = 'work',
			Item = {
				{
					name = _U('s_alive_chicken'),
					db_name = 'alive_chicken',
					time = 3,
					max = 20,
					add = 1,
					remove = 1,
					requires = 'nothing',
					requires_name = 'Nothing',
					drop = 100
				}
			},
			Hint = _U('s_catch_hen')
		},

		SlaughterHouse = {
			Pos = {x = -77.99, y = 6229.06, z = 30.09},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('s_slaughtered'),
			Type = 'work',
			Item = {
				{
					name = _U('s_slaughtered_chicken'),
					db_name = 'slaughtered_chicken',
					time = 5,
					max = 20,
					add = 1,
					remove = 1,
					requires = 'alive_chicken',
					requires_name = _U('s_alive_chicken'),
					drop = 100
				}
			},
			Hint = _U('s_chop_animal')
		},

		Packaging = {
			Pos = {x = -101.97, y = 6208.79, z = 30.02},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('s_package'),
			Type = 'work',
			Item = {
				{
					name = _U('s_packagechicken'),
					db_name = 'packaged_chicken',
					time = 4,
					max = 100,
					add = 5,
					remove = 1,
					requires = 'slaughtered_chicken',
					requires_name = _U('s_unpackaged'),
					drop = 100
				}
			},
			Hint = _U('s_unpackaged_button')
		},

		VehicleSpawner = {
			Pos = {x = -1042.94, y = -2023.25, z = 12.16},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('spawn_veh'),
			Type = 'vehspawner',
			Spawner = 1,
			Hint = _U('spawn_veh_button'),
			Caution = 2000
		},

		VehicleSpawnPoint = {
			Pos = {x = -1048.85, y = -2025.32, z = 12.16},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1,
			Blip = false,
			Name = _U('service_vh'),
			Type = 'vehspawnpt',
			Spawner = 1,
			Heading = 130.1
		},

		VehicleDeletePoint = {
			Pos = {x = -1061.51, y = -2008.35, z = 12.16},
			Size = {x = 5.0, y = 5.0, z = 1.0},
			Color = {r = 255, g = 0, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('return_vh'),
			Type = 'vehdelete',
			Hint = _U('return_vh_button'),
			Spawner = 1,
			Caution = 2000,
			GPS = 0,
			Teleport = 0
		},

		Delivery = {
			Pos = {x = -596.15, y = -889.32, z = 24.50},
			Color = {r = 204, g = 204, b = 0},
			Size = {x = 5.0, y = 5.0, z = 1.0},
			Marker = 1,
			Blip = true,
			Name = _U('delivery_point'),
			Type = 'delivery',
			Spawner = 1,
			Item = {
				{
					name = _U('delivery'),
					time = 0.5,
					remove = 1,
					max = 100, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
					price = 23,
					requires = 'packaged_chicken',
					requires_name = _U('s_packagechicken'),
					drop = 100
				}
			},
			Hint = _U('s_deliver')
		}
	}
}

Config.Jobs.reporter = {

	BlipInfos = {
		Sprite = 184,
		Color = 1
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = 'rumpo',
			Trailer = 'none',
			HasCaution = true
		}

	},

	Zones = {

		VehicleSpawner = {
			Pos = {x = -141.41, y = -620.80, z = 167.82},
			Size = {x = 2.0, y = 2.0, z = 0.2},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('reporter_name'),
			Type = 'vehspawner',
			Spawner = 1,
			Hint = _U('reporter_garage'),
			Caution = 2000
		},

		VehicleSpawnPoint = {
			Pos = {x = -149.32, y = -592.17, z = 31.42},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1,
			Blip = false,
			Name = _U('service_vh'),
			Type = 'vehspawnpt',
			Spawner = 1,
			Heading = 200.1
		},

		VehicleDeletePoint = {
			Pos = {x = -144.22, y = -577.02, z = 31.42},
			Size = {x = 5.0, y = 5.0, z = 0.2},
			Color = {r = 255, g = 0, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('return_vh'),
			Type = 'vehdelete',
			Hint = _U('return_vh_button'),
			Spawner = 1,
			Caution = 2000,
			GPS = 0,
			Teleport = {x = -139.09, y = -620.74, z = 167.82}
		}

	}
}

Config.Jobs.miner = {

	BlipInfos = {
		Sprite = 318,
		Color = 5
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = 'rubble',
			Trailer = 'none',
			HasCaution = true
		}

	},

	Zones = {

		CloakRoom = {
			Pos = {x = 892.35, y = -2172.77, z = 31.28},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('m_miner_locker'),
			Type = 'cloakroom',
			Hint = _U('cloak_change'),
			GPS = {x = 884.86, y = -2176.51, z = 29.51}
		},

		Mine = {
			Pos = {x = 2962.40, y = 2746.20, z = 42.39},
			Size = {x = 5.0, y = 5.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('m_rock'),
			Type = 'work',
			Item = {
				{
					name = _U('m_rock'),
					db_name = 'stone',
					time = 3,
					max = 7,
					add = 1,
					remove = 1,
					requires = 'nothing',
					requires_name = 'Nothing',
					drop = 100
				}
			},
			Hint = _U('m_pickrocks'),
			GPS = {x = 289.24, y = 2862.90, z = 42.64}
		},

		StoneWash = {
			Pos = {x = 289.24, y = 2862.90, z = 42.64},
			Size = {x = 5.0, y = 5.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('m_washrock'),
			Type = 'work',
			Item = {
				{
					name = _U('m_washrock'),
					db_name = 'washed_stone',
					time = 5,
					max = 7,
					add = 1,
					remove = 1,
					requires = 'stone',
					requires_name = _U('m_rock'),
					drop = 100
				}
			},
			Hint = _U('m_rock_button'),
			GPS = {x = 1109.14, y = -2007.87, z = 30.01}
		},

		Foundry = {
			Pos = {x = 1109.14, y = -2007.87, z = 30.01},
			Size = {x = 5.0, y = 5.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('m_rock_smelting'),
			Type = 'work',
			Item = {
				{
					name = _U('m_copper'),
					db_name = 'copper',
					time = 4,
					max = 56,
					add = 8,
					remove = 1,
					requires = 'washed_stone',
					requires_name = _U('m_washrock'),
					drop = 100
				},
				{
					name = _U('m_iron'),
					db_name = 'iron',
					max = 42,
					add = 6,
					drop = 100
				},
				{
					name = _U('m_gold'),
					db_name = 'gold',
					max = 21,
					add = 3,
					drop = 100
				},
				{
					name = _U('m_diamond'),
					db_name = 'diamond',
					max = 50,
					add = 1,
					drop = 5
				}
			},
			Hint = _U('m_melt_button'),
			GPS = {x = -169.48, y = -2659.16, z = 5.00}
		},

		VehicleSpawner = {
			Pos = {x = 884.86, y = -2176.51, z = 29.51},
			Size = {x = 5.0, y = 5.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('spawn_veh'),
			Type = 'vehspawner',
			Spawner = 1,
			Hint = _U('spawn_veh_button'),
			Caution = 2000,
			GPS = {x = 2962.40, y = 2746.20, z = 42.39}
		},

		VehicleSpawnPoint = {
			Pos = {x = 879.55, y = -2189.79, z = 29.51},
			Size = {x = 5.0, y = 5.0, z = 1.0},
			Marker = -1,
			Blip = false,
			Name = _U('service_vh'),
			Type = 'vehspawnpt',
			Spawner = 1,
			Heading = 90.1,
			GPS = 0
		},

		VehicleDeletePoint = {
			Pos = {x = 881.93, y = -2198.01, z = 29.51},
			Size = {x = 5.0, y = 5.0, z = 1.0},
			Color = {r = 255, g = 0, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('return_vh'),
			Type = 'vehdelete',
			Hint = _U('return_vh_button'),
			Spawner = 1,
			Caution = 2000,
			GPS = 0,
			Teleport = 0
		},

		CopperDelivery = {
			Pos = {x = -169.481, y = -2659.16, z = 5.00103},
			Color = {r = 204, g = 204, b = 0},
			Size = {x = 5.0, y = 5.0, z = 3.0},
			Marker = 1,
			Blip = true,
			Name = _U('m_sell_copper'),
			Type = 'delivery',
			Spawner = 1,
			Item = {
				{
					name = _U('delivery'),
					time = 0.5,
					remove = 1,
					max = 56, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
					price = 5,
					requires = 'copper',
					requires_name = _U('m_copper'),
					drop = 100
				}
			},
			Hint = _U('m_deliver_copper'),
			GPS = {x = -148.78, y = -1040.38, z = 26.27}
		},

		IronDelivery = {
			Pos = {x = -148.78, y = -1040.38, z = 26.27},
			Color = {r = 204, g = 204, b = 0},
			Size = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('m_sell_iron'),
			Type = 'delivery',
			Spawner = 1,
			Item = {
				{
					name = _U('delivery'),
					time = 0.5,
					remove = 1,
					max = 42, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
					price = 9,
					requires = 'iron',
					requires_name = _U('m_iron'),
					drop = 100
				}
			},
			Hint = _U('m_deliver_iron'),
			GPS = {x = 261.48, y = 207.35, z = 109.28}
		},

		GoldDelivery = {
			Pos = {x = 261.48, y = 207.35, z = 109.28},
			Color = {r = 204, g = 204, b = 0},
			Size = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('m_sell_gold'),
			Type = 'delivery',
			Spawner = 1,
			Item = {
				{
					name = _U('delivery'),
					time = 0.5,
					remove = 1,
					max = 21, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
					price = 25,
					requires = 'gold',
					requires_name = _U('m_gold'),
					drop = 100
				}
			},
			Hint = _U('m_deliver_gold'),
			GPS = {x = -621.04, y = -228.53, z = 37.05}
		},

		DiamondDelivery = {
			Pos = {x = -621.04, y = -228.53, z = 37.05},
			Color = {r = 204, g = 204, b = 0},
			Size = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('m_sell_diamond'),
			Type = 'delivery',
			Spawner = 1,
			Item = {
				{
					name = _U('delivery'),
					time = 0.5,
					remove = 1,
					max = 50, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
					price = 250,
					requires = 'diamond',
					requires_name = _U('m_diamond'),
					drop = 100
				}
			},
			Hint = _U('m_deliver_diamond'),
			GPS = {x = 2962.40, y = 2746.20, z = 42.39}
		}

	}
}
Config.Jobs.lumberjack = {

	BlipInfos = {
		Sprite = 237,
		Color = 4
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = 'phantom',
			Trailer = 'trailers',
			HasCaution = true
		}

	},

	Zones = {

		CloakRoom = {
			Pos = {x = 1200.63, y = -1276.87, z = 34.38},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('lj_locker_room'),
			Type = 'cloakroom',
			Hint = _U('cloak_change')
		},

		Wood = {
			Pos = {x = -534.32, y = 5373.79, z = 69.50},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('lj_mapblip'),
			Type = 'work',
			Item = {
				{
					name = _U('lj_wood'),
					db_name = 'wood',
					time = 3,
					max = 20,
					add = 1,
					remove = 1,
					requires = 'nothing',
					requires_name = 'Nothing',
					drop = 100
				}
			},
			Hint = _U('lj_pickup')
		},

		CuttedWood = {
			Pos = {x = -552.21, y = 5326.90, z = 72.59},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('lj_cutwood'),
			Type = 'work',
			Item = {
				{
					name = _U('lj_cutwood'),
					db_name = 'cutted_wood',
					time = 5,
					max = 20,
					add = 1,
					remove = 1,
					requires = 'wood',
					requires_name = _U('lj_wood'),
					drop = 100
				}
			},
			Hint = _U('lj_cutwood_button')
		},

		Planks = {
			Pos = {x = -501.38, y = 5280.53, z = 79.61},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('lj_board'),
			Type = 'work',
			Item = {
				{
					name = _U('lj_planks'),
					db_name = 'packaged_plank',
					time = 4,
					max = 100,
					add = 5,
					remove = 1,
					requires = 'cutted_wood',
					requires_name = _U('lj_cutwood'),
					drop = 100
				}
			},
			Hint = _U('lj_pick_boards')
		},

		VehicleSpawner = {
			Pos = {x = 1191.96, y = -1261.77, z = 34.17},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('spawn_veh'),
			Type = 'vehspawner',
			Spawner = 1,
			Hint = _U('spawn_veh_button'),
			Caution = 2000
		},

		VehicleSpawnPoint = {
			Pos = {x = 1194.62, y = -1286.95, z = 34.12},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1,
			Blip = false,
			Name = _U('service_vh'),
			Type = 'vehspawnpt',
			Spawner = 1,
			Heading = 264.40
		},

		VehicleDeletePoint = {
			Pos = {x = 1216.89, y = -1229.23, z = 34.40},
			Size = {x = 5.0, y = 5.0, z = 1.0},
			Color = {r = 255, g = 0, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('return_vh'),
			Type = 'vehdelete',
			Hint = _U('return_vh_button'),
			Spawner = 1,
			Caution = 2000,
			GPS = 0,
			Teleport = 0
		},

		Delivery = {
			Pos = {x = 1201.35, y = -1327.51, z = 34.22},
			Color = {r = 204, g = 204, b = 0},
			Size = {x = 5.0, y = 5.0, z = 3.0},
			Marker = 1,
			Blip = true,
			Name = _U('delivery_point'),
			Type = 'delivery',
			Spawner = 1,
			Item = {
				{
					name = _U('delivery'),
					time = 0.5,
					remove = 1,
					max = 100, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
					price = 13,
					requires = 'packaged_plank',
					requires_name = _U('lj_planks'),
					drop = 100
				}
			},
			Hint = _U('lj_deliver_button')
		}

	}
}
Config.Jobs.fueler = {

	BlipInfos = {
		Sprite = 436,
		Color = 5
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = 'phantom',
			Trailer = 'tanker',
			HasCaution = true
		}

	},

	Zones = {

		CloakRoom = {
			Pos = {x = 557.93, y = -2327.90, z = 4.82},
			Size = {x = 3.0, y = 3.0, z = 2.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('f_oil_refiner'),
			Type = 'cloakroom',
			Hint = _U('cloak_change'),
			GPS = {x = 554.59, y = -2314.43, z = 4.86}
		},

		OilFarm = {
			Pos = {x = 609.58, y = 2856.74, z = 38.90},
			Size = {x = 20.0, y = 20.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('f_drill_oil'),
			Type = 'work',
			Item = {
				{
					name = _U('f_fuel'),
					db_name = 'petrol',
					time = 5,
					max = 24,
					add = 1,
					remove = 1,
					requires = 'nothing',
					requires_name = 'Nothing',
					drop = 100
				}
			},
			Hint = _U('f_drillbutton'),
			GPS = {x = 2736.94, y = 1417.99, z = 23.48}
		},

		OilRefinement = {
			Pos = {x = 2736.94, y = 1417.99, z = 23.48},
			Size = {x = 10.0, y = 10.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('f_fuel_refine'),
			Type = 'work',
			Item = {
				{
					name = _U('f_fuel_refine'),
					db_name = 'petrol_raffin',
					time = 5,
					max = 24,
					add = 1,
					remove = 2,
					requires = 'petrol',
					requires_name = _U('f_fuel'),
					drop = 100
				}
			},
			Hint = _U('f_refine_fuel_button'),
			GPS = {x = 265.75, y = -3013.39, z = 4.73}
		},

		OilMix = {
			Pos = {x = 265.75, y = -3013.39, z = 4.73},
			Size = {x = 10.0, y = 10.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('f_fuel_mixture'),
			Type = 'work',
			Item = {
				{
					name = _U('f_gas'),
					db_name = 'essence',
					time = 5,
					max = 24,
					add = 2,
					remove = 1,
					requires = 'petrol_raffin',
					requires_name = _U('f_fuel_refine'),
					drop = 100
				}
			},
			Hint = _U('f_fuel_mixture_button'),
			GPS = {x = 491.40, y = -2163.37, z = 4.91}
		},

		VehicleSpawner = {
			Pos = {x = 554.59, y = -2314.43, z = 4.86},
			Size = {x = 3.0, y = 3.0, z = 2.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('spawn_veh'),
			Type = 'vehspawner',
			Spawner = 1,
			Hint = _U('spawn_truck_button'),
			Caution = 2000,
			GPS = {x = 602.25, y = 2926.62, z = 39.68}
		},

		VehicleSpawnPoint = {
			Pos = {x = 570.54, y = -2309.70, z = 4.90},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1,
			Blip = false,
			Name = _U('service_vh'),
			Type = 'vehspawnpt',
			Spawner = 1,
			GPS = 0,
			Heading = 0
		},

		VehicleDeletePoint = {
			Pos = {x = 520.68, y = -2124.21, z = 4.98},
			Size = {x = 5.0, y = 5.0, z = 1.0},
			Color = {r = 255, g = 0, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('return_vh'),
			Type = 'vehdelete',
			Hint = _U('return_vh_button'),
			Spawner = 1,
			Caution = 2000,
			GPS = 0,
			Teleport = 0
		},

		Delivery = {
			Pos = {x = 491.40, y = -2163.37, z = 4.91},
			Color = {r = 204, g = 204, b = 0},
			Size = {x = 10.0, y = 10.0, z = 1.0},
			Marker = 1,
			Blip = true,
			Name = _U('f_deliver_gas'),
			Type = 'delivery',
			Spawner = 1,
			Item = {
				{
					name = _U('delivery'),
					time = 0.5,
					remove = 1,
					max = 100, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
					price = 61,
					requires = 'essence',
					requires_name = _U('f_gas'),
					drop = 100
				}
			},

			Hint = _U('f_deliver_gas_button'),
			GPS = {x = 609.58, y = 2856.74, z = 39.49}
		}

	}
}
Config.Jobs.fisherman = {

	BlipInfos = {
		Sprite = 68,
		Color = 38
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
			Hash = 'benson',
			Trailer = 'none',
			HasCaution = true
		},

		Boat = {
			Spawner = 2,
			Hash = 'tug',
			Trailer = 'none',
			HasCaution = false
		}

	},

	Zones = {

		CloakRoom = {
			Pos   = {x = 868.39, y = -1639.75, z = 29.33},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker= 1,
			Blip  = true,
			Name  = _U('fm_fish_locker'),
			Type  = 'cloakroom',
			Hint  = _U('cloak_change'),
			GPS = {x = 880.74, y = -1663.96, z = 29.37}
		},

		FishingSpot = {
			Pos   = {x = 4435.21, y = 4829.60, z = 0.34},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 110.0, y = 110.0, z = 10.0},
			Marker= 1,
			Blip  = true,
			Name  = _U('fm_fish_area'),
			Type  = 'work',
			Hint  = _U('fm_fish_button'),
			GPS   = {x = 3859.43, y = 4448.83, z = 0.39},
			Item = {
				{
					name   = _U('fm_fish'),
					db_name= 'fish',
					time   = 2,
					max    = 100,
					add    = 1,
					remove = 1,
					requires = 'nothing',
					requires_name = 'Nothing',
					drop   = 100
				}
			},

		},

		BoatSpawner = {
			Pos   = {x = 3867.44, y = 4463.62, z = 1.72},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker= 1,
			Blip  = true,
			Name  = _U('fm_spawnboat_title'),
			Type  = 'vehspawner',
			Spawner = 2,
			Hint  = _U('fm_spawnboat'),
			Caution = 0,
			GPS = {x = 4435.21, y = 4829.60, z = 0.34}
		},

		BoatSpawnPoint = {
			Pos   = {x = 3888.3, y = 4468.09, z = 0.0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker= -1,
			Blip  = false,
			Name  = _U('fm_boat_title'),
			Type  = 'vehspawnpt',
			Spawner = 2,
			GPS = 0,
			Heading = 270.1
		},

		BoatDeletePoint = {
			Pos   = {x = 3859.43, y = 4448.83, z = 0.39},
			Size  = {x = 10.0, y = 10.0, z = 1.0},
			Color = {r = 255, g = 0, b = 0},
			Marker= 1,
			Blip  = false,
			Name  = _U('fm_boat_return_title'),
			Type  = 'vehdelete',
			Hint  = _U('fm_boat_return_button'),
			Spawner = 2,
			Caution = 0,
			GPS = {x = -1012.64, y = -1354.62, z = 5.54},
			Teleport = {x = 3867.44, y = 4463.62, z = 1.72}
		},

		VehicleSpawner = {
			Pos   = {x = 880.74, y = -1663.96, z = 29.37},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Marker= 1,
			Blip  = false,
			Name  = _U('spawn_veh'),
			Type  = 'vehspawner',
			Spawner = 1,
			Hint  = _U('spawn_veh_button'),
			Caution = 2000,
			GPS = {x = 3867.44, y = 4463.62, z = 1.72}
		},

		VehicleSpawnPoint = {
			Pos   = {x = 859.35, y = -1656.21, z = 29.56},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker= -1,
			Blip  = false,
			Name  = _U('service_vh'),
			Type  = 'vehspawnpt',
			Spawner = 1,
			GPS = 0,
			Heading = 70.1
		},

		VehicleDeletePoint = {
			Pos   = {x = 863.23, y = -1718.28, z = 28.63},
			Size  = {x = 5.0, y = 5.0, z = 1.0},
			Color = {r = 255, g = 0, b = 0},
			Marker= 1,
			Blip  = false,
			Name  = _U('return_vh'),
			Type  = 'vehdelete',
			Hint  = _U('return_vh_button'),
			Spawner = 1,
			Caution = 2000,
			GPS = 0,
			Teleport = 0
		},

		Delivery = {
			Pos   = {x = -1012.64, y = -1354.62, z = 5.54},
			Color = {r = 204, g = 204, b = 0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Marker= 1,
			Blip  = true,
			Name  = _U('delivery_point'),
			Type  = 'delivery',
			Spawner = 2,
			Hint  = _U('fm_deliver_fish'),
			GPS   = {x = 3867.44, y = 4463.62, z = 1.72},
			Item = {
				{
				name   = _U('delivery'),
				time   = 0.5,
				remove = 1,
				max    = 100, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
				price  = 11,
				requires = 'fish',
				requires_name = _U('fm_fish'),
				drop   = 100
				}
			}
		}

	}
}



