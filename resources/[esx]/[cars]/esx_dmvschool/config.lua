Config = {}
Config.DrawDistance = 30.0
Config.MaxErrors = 5
Config.SpeedMultiplier = 3.6
Config.Locale = 'fr'

Config.Prices = {
	dmv = 500,
	drive = 1500,
	drive_bike = 1200,
	drive_truck = 1800
}

Config.VehicleModels = {
	drive = 'Prairie',
	drive_bike = 'Enduro',
	drive_truck = 'Biff'
}

Config.SpeedLimits = {
	residence = 50,
	town = 80,
	freeway = 120
}

Config.Zones = {

	DMVSchool = {
		Pos = {x = -271.01, y = -705.0, z = 37.27},
		Size = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type = 1
	},

	VehicleSpawnPoint = {
		Pos = {x = -355.82, y = -756.83, z = 32.96, h = 270.0},
		Size = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type = -1
	}

}

Config.CheckPoints = {

	{
		Pos = {x = -350.22, y = -729.01, z = 32.96},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('next_point_speed', Config.SpeedLimits['residence']), 5000)
		end
	},

	{
		Pos = {x = -339.46, y = -693.19, z = 31.82},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = -323.68, y = -681.12, z = 31.91},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Citizen.CreateThread(function()
				DrawMissionText(_U('stop_for_ped'), 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(4000)

				FreezeEntityPosition(vehicle, false)
				DrawMissionText(_U('good_lets_cont'), 5000)
			end)
		end
	},

	{
		Pos = {x = -323.01, y = -671.90, z = 31.54},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('town')

			Citizen.CreateThread(function()
				DrawMissionText(_U('stop_look_left', Config.SpeedLimits['town']), 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(6000)

				FreezeEntityPosition(vehicle, false)
				DrawMissionText(_U('good_turn_right'), 5000)
			end)
		end
	},

	{
		Pos = {x = -348.21, y = -655.24, z = 31.04},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('watch_traffic_lightson'), 5000)
		end
	},

	{
		Pos = {x = -393.37, y = -655.32, z = 29.15},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = -526.57, y = -655.15, z = 32.28},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('stop_for_passing'), 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			FreezeEntityPosition(vehicle, true)
			Citizen.Wait(6000)
			FreezeEntityPosition(vehicle, false)
		end
	},

	{
		Pos = {x = -502.92, y = -814.51, z = 29.48},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = -533.70, y = -947.92, z = 22.63},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},
	
	{
		Pos = {x = -544.52, y = -1147.24, z = 18.97},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},


	{
		Pos = {x = -453.790, y = -1444.726, z = 27.665},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('freeway')

			DrawMissionText(_U('hway_time', Config.SpeedLimits['freeway']), 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
		end
	},

	{
		Pos = {x = -463.237, y = -1592.178, z = 37.519},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = -900.647, y = -1986.28, z = 26.109},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 1225.759, y = -1948.792, z = 38.718},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 1225.759, y = -1948.792, z = 38.718},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('town')
			DrawMissionText(_U('in_town_speed', Config.SpeedLimits['town']), 5000)
		end
	},

	{
		Pos = {x = 1163.603, y = -1841.771, z = 35.679},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('gratz_stay_alert'), 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
		end
	},

	{
		Pos = {x = -290.35, y = -747.83, z = 32.96},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			ESX.Game.DeleteVehicle(vehicle)
		end
	}

}