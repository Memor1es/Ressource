Config                            = {}
Config.DrawDistance               = 100.0
Config.MaxInService               = -1
Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false
Config.EnableLicenses             = false
Config.EnableESXIdentity          = false
Config.Locale                     = 'fr'

Config.Cig = {
  'malbora',
  'gitanes'
}

Config.CigResellChances = {
  malbora = 45,
  gitanes = 55,
}

Config.CigResellQuantity= {
  malbora = {min = 5, max = 10},
  gitanes = {min = 5, max = 10},
}

Config.CigPrices = {
  malbora = {min = 35, max = 20},
  gitanes = {min = 25,   max = 25},
}

Config.CigPricesHigh = {
  malbora = {min = 65, max = 30},
  gitanes = {min = 55,   max = 35},
}

Config.Time = {
	malbora = 5 * 60,
	gitanes = 5 * 60,
}

Config.Blip = {
  Pos     = { x = 988.27, y = -1536.43, z = 30.78 },
  Sprite  = 79,
  Display = 4,
  Scale   = 0.7,
  Colour  = 2,
}

Config.Zones = {

  TabacActions = {
    Pos   = { x =984.16, y = -1531.61, z = 29.80 },
    Size  = { x = 1.6, y = 1.6, z = 1.0 },
    Color = {r = 136, g = 243, b = 216},
    Type  = 23,
  },

  Garage = {
    Pos   = { x = 2886.9729003906, y = 4609.4565429688, z = 46.987 },
    Size  = { x = 1.6, y = 1.6, z = 1.0 },
	Color = {r = 136, g = 243, b = 216},
    Type  = 23,
  },

  Craft = {
    Pos   = { x = 992.30, y = -1550.50, z = 29.75 },
    Size  = { x = 1.6, y = 1.6, z = 1.0 },
	Color = {r = 136, g = 243, b = 216},
    Type  = 27,
  },

  Craft2 = {
    Pos   = { x = 1006.49, y = -1556.21, z = 29.83 },
    Size  = { x = 1.6, y = 1.6, z = 1.0 },
	Color = {r = 136, g = 243, b = 216},
    Type  = 27,
  },

  VehicleSpawnPoint = {
    Pos   = { x = 988.24, y = -1535.27, z = 30.77 },
    Size  = { x = 1.6, y = 1.6, z = 1.0 },
    Type  = -1,
  },

  VehicleDeleter = {
    Pos   = { x = 1000.94, y = -1533.26, z = 28.81 },
    Size  = { x = 1.6, y = 1.6, z = 1.0 },
    Color = { r = 204, g = 204, b = 0 },
    Type  = 1,
  },

  SellFarm = {
    Pos   = {x = -688.57, y = -878.54, z = 23.50},
    Size  = { x = 4.6, y = 4.6, z = 1.0 },
    Color = {r = 136, g = 243, b = 216},
    Name  = "Vente des produits",
    Type  = 1
  },
  
}
