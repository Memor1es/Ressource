Config = {}
Config.DrawDistance = 15.0
Config.Size = { x = 1.0, y = 1.0, z = 1.25 }
Config.Color = { r = 255, g = 0, b = 0 }
Config.Type = 25
Config.Locale = 'fr'
Config.LicenseEnable = true -- only turn this on if you are using esx_license

Config.Zones = {
	GunShop = {
		Legal = true,
		Items = {},
		Locations = {
			vector3(-662.1, -935.3, 20.9),
			vector3(810.2, -2157.3, 28.7),
			vector3(1693.56, 3759.91, 33.9),
			vector3(-330.2, 6083.8, 30.6),
			vector3(252.3, -50.0, 69.05),
			vector3(22.26, -1107.02, 28.8),
			vector3(2567.6, 294.3, 107.9),
			vector3(-1117.5, 2698.6, 17.7),
			vector3(842.4, -1033.4, 27.3),
			vector3(-1305.91, -394.13, 35.8),
			vector3(-3172.0, 1087.72, 20.05)
		}
	},
	BlackWeashop = {
		Legal = false,
		Items = {},
		Locations = {
			--vector3(-1306.2, -394.0, 35.6)
		}
	}
}

Config.Zones2 = {
	GunLegalShop = {
		Legal = true,
		Items = {},
		Locations = {
			vector3(20.1, -1106.16, 28.8),
			vector3(812.3, -2157.3, 28.7),
			vector3(-664.23, -935.25, 20.9),
			vector3(252.89, -48.12, 69.05),
			vector3(-1305.39, -392.19, 35.8),
			vector3(2569.82, 294.31, 107.9),
			vector3(-3172.92, 1085.92, 20.05),
			vector3(-1119.31, 2697.23, 17.7),
			vector3(-331.73, 6082.34, 30.6),
			vector3(1692.14, 3758.3, 33.9),
			vector3(844.49, -1033.57, 27.3)
		}
	}
}