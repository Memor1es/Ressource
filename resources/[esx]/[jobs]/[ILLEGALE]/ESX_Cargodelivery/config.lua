Config                        	= {}
Config.CopsScaleReward			= true

-- Change this to false if you want clean / legit money
Config.UsesBlackMoney			= true

--Hash of the npc ped. Change only if you know what you are doing.
Config.NPCHash					= 349680864 			

--Random time societies will get alerted. This is a range in seconds.
Config.AlertCopsDelayRangeStart	= 20
Config.AlertCopsDelayRangeEnd	= 20

--If you want to notify more societies add them here. example { "mafia", "bikers" }
Config.AlertExtraSocieties 		= {"police"}

--Self Explained
Config.CargoProviderLocation	= { x = 483.6, y = -3382.69, z = 5.1, h = 355.02 }


Config.CargoDeliveryLocations 	= {

		{ x = 731.89, y = 4172.27, z = 39.3 },
		{ x = 1959.28, y = 3845.48, z = 31.2 },
		{ x = 388.76, y = 3591.34, z = 32.09},
		{ x = 97.24, y = 3739.86, z = 38.8}

}


Config.Scenarios = {
	
	{ 
		SpawnPoint = { x = 478.92, y = -3371.19, z = 5.5, h = 5.77 }, 
		DeliveryPoint = 6.0,
		VehicleName = "bison3",
		MinCopsOnline = 0,
		CargoCost = 0,
		CargoReward = 1000
	
	},

	{ 
		SpawnPoint = { x = 478.92, y = -3371.19, z = 5.5, h = 5.77 }, 
		DeliveryPoint = 6.0,
		VehicleName = "surfer2",
		MinCopsOnline = 0,
		CargoCost = 0,
		CargoReward = 2000
	
	},
	{ 
		SpawnPoint = { x = 478.92, y = -3371.19, z = 5.5, h = 5.77 },  
		DeliveryPoint = 6.0,
		VehicleName = "barracks",
		MinCopsOnline = 0,
		CargoCost = 0,
		CargoReward = 3000
	
	}
}