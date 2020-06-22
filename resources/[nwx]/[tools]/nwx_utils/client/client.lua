local PlayerData = {}
local training = false
local resting = false
local membership = false

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	PlayerData = ESX.GetPlayerData()
end)

-- Gps
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)


-- Gym
function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local blips = {
	{title="Gym", colour=7, id=311, x = -1201.2257, y = -1568.8670, z = 4.6101}
}

RegisterNetEvent('esx_gym:trueMembership')
AddEventHandler('esx_gym:trueMembership', function()
	membership = true
end)

RegisterNetEvent('esx_gym:falseMembership')
AddEventHandler('esx_gym:falseMembership', function()
	membership = true
end)


local elecmag = {
    {x = 392.9, y = -831.86, z = 29.2}
}

local arms = {
    {x = -1202.9837,y = -1565.1718,z = 4.6115}
}

local pushup = {
    {x = -1203.3242,y = -1570.6184,z = 4.6115}
}

local yoga = {
    {x = -1204.7958,y = -1560.1906,z = 4.6115}
}

local situps = {
    {x = -1206.1055,y = -1565.1589,z = 4.6115}
}

local gym = {
    {x = -1195.6551,y = -1577.7689,z = 4.6115}
}

local chins = {
    {x = -1200.1284,y = -1570.9903,z = 4.6115}
}

local rentbike = {
    {x = -1199.1164,y = -1584.5972,z = 4.3249}
}

-- LOCATION (END)

Citizen.CreateThread(function()

	for _, info in pairs(blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.7)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end

    while true do
        Citizen.Wait(10)

        for k in pairs(gym) do
		
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, gym[k].x, gym[k].y, gym[k].z)

            if dist <= 0.5 then
				hintToDisplay('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu  ~b~gym~w~')
				
				if IsControlJustPressed(0, 38) then
					OpenGymMenu()
				end			
            end
        end

        for k in pairs(elecmag) do
		
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, elecmag[k].x, elecmag[k].y, elecmag[k].z)

            if dist <= 0.5 then
				hintToDisplay('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu  ~b~électronique~w~')
				
				if IsControlJustPressed(0, 38) then
					OpenElecMagMenu()
				end			
            end
        end

        for k in pairs(arms) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, arms[k].x, arms[k].y, arms[k].z)

            if dist <= 0.5 then
				hintToDisplay('Appuyez sur ~INPUT_CONTEXT~ pour exercer votre ~g~exercice')
				
				if IsControlJustPressed(0, 38) then
					if training == false then
					
						TriggerServerEvent('esx_gym:checkChip')
						ESX.ShowNotification("Préparer ~g~l'exercice~w~...")
						Citizen.Wait(1000)					
					
						if membership == true then
							local playerPed = GetPlayerPed(-1)
							TaskStartScenarioInPlace(playerPed, "world_human_muscle_free_weights", 0, true)
							Citizen.Wait(30000)
							ClearPedTasksImmediately(playerPed)
							ESX.ShowNotification("Tu as besoin de te reposer ~r~60 seconds ~w~avant de faire un autre exercice.")
							
							--TriggerServerEvent('esx_gym:trainArms') ## COMING SOON...
							
							training = true
						elseif membership == false then
							ESX.ShowNotification("Vous devez être membre pour faire des ~r~exercices")
						end
					elseif training == true then
						ESX.ShowNotification("Tu as besoin de te reposer...")
						
						resting = true
						
						CheckTraining()
					end
				end			
            end
        end

        for k in pairs(chins) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, chins[k].x, chins[k].y, chins[k].z)

            if dist <= 0.5 then
				hintToDisplay('Appuyez sur ~INPUT_CONTEXT~ faire quelques ~g~traction')
				
				if IsControlJustPressed(0, 38) then
					if training == false then
					
						TriggerServerEvent('esx_gym:checkChip')
						ESX.ShowNotification("Préparer ~g~l'exercice~w~...")
						Citizen.Wait(1000)					
					
						if membership == true then
							local playerPed = GetPlayerPed(-1)
							TaskStartScenarioInPlace(playerPed, "prop_human_muscle_chin_ups", 0, true)
							Citizen.Wait(30000)
							ClearPedTasksImmediately(playerPed)
							ESX.ShowNotification("Tu as besoin de te reposer ~r~60 seconds ~w~avant de faire un autre exercice.")
							
							--TriggerServerEvent('esx_gym:trainChins') ## COMING SOON...
							
							training = true
						elseif membership == false then
							ESX.ShowNotification("Vous devez être membre pour faire des ~r~exercice")
						end
					elseif training == true then
						ESX.ShowNotification("Tu as besoin de te reposer...")
						
						resting = true
						
						CheckTraining()
					end
				end			
            end
        end

        for k in pairs(pushup) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pushup[k].x, pushup[k].y, pushup[k].z)

            if dist <= 0.5 then
				hintToDisplay('Appuyez sur ~INPUT_CONTEXT~ faire quelques ~g~pompes')
				
				if IsControlJustPressed(0, 38) then
					if training == false then
					
						TriggerServerEvent('esx_gym:checkChip')
						ESX.ShowNotification("Préparer ~g~l'exercice~w~...")
						Citizen.Wait(1000)					
					
						if membership == true then				
							local playerPed = GetPlayerPed(-1)
							TaskStartScenarioInPlace(playerPed, "world_human_push_ups", 0, true)
							Citizen.Wait(30000)
							ClearPedTasksImmediately(playerPed)
							ESX.ShowNotification("Tu as besoin de te reposer ~r~60 seconds ~w~avant de faire un autre exercice.")
						
							--TriggerServerEvent('esx_gym:trainPushups') ## COMING SOON...
							
							training = true
						elseif membership == false then
							ESX.ShowNotification("Vous avez besoin d'une adhésion pour faire des ~r~exercice")
						end							
					elseif training == true then
						ESX.ShowNotification("Tu as besoin de te reposer...")
						
						resting = true
						
						CheckTraining()
					end
				end			
            end
        end

        for k in pairs(yoga) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, yoga[k].x, yoga[k].y, yoga[k].z)

            if dist <= 0.5 then
				hintToDisplay('Appuyez sur ~INPUT_CONTEXT~ pour faire du ~g~yoga')
				
				if IsControlJustPressed(0, 38) then
					if training == false then
					
						TriggerServerEvent('esx_gym:checkChip')
						ESX.ShowNotification("Préparation de ~g~l'exercice~w~...")
						Citizen.Wait(1000)					
					
						if membership == true then	
							local playerPed = GetPlayerPed(-1)
							TaskStartScenarioInPlace(playerPed, "world_human_yoga", 0, true)
							Citizen.Wait(30000)
							ClearPedTasksImmediately(playerPed)
							ESX.ShowNotification("Tu as besoin de te reposer ~r~60 seconds ~w~avant de faire un autre exercice.")
						
							--TriggerServerEvent('esx_gym:trainYoga') ## COMING SOON...
							
							training = true
						elseif membership == false then
							ESX.ShowNotification("Vous avez besoin d'une adhésion pour faire un ~r~exercice")
						end
					elseif training == true then
						ESX.ShowNotification("Tu as besoin de te reposer...")
						
						resting = true
						
						CheckTraining()
					end
				end			
            end
        end

        for k in pairs(situps) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, situps[k].x, situps[k].y, situps[k].z)

            if dist <= 0.5 then
				hintToDisplay('Appuyez sur ~INPUT_CONTEXT~ pour faire des ~g~pompes')
				
				if IsControlJustPressed(0, 38) then
					if training == false then

						TriggerServerEvent('esx_gym:checkChip')
						ESX.ShowNotification("Préparation de ~g~l'exercice~w~...")
						Citizen.Wait(1000)					
					
						if membership == true then	
							local playerPed = GetPlayerPed(-1)
							TaskStartScenarioInPlace(playerPed, "world_human_sit_ups", 0, true)
							Citizen.Wait(30000)
							ClearPedTasksImmediately(playerPed)
							ESX.ShowNotification("Tu as besoin de te reposer ~r~60 seconds ~w~avant de faire un autre exercice.")
						
							--TriggerServerEvent('esx_gym:trainSitups') ## COMING SOON...
							
							training = true
						elseif membership == false then
							ESX.ShowNotification("Vous avez besoin d'une adhésion pour faire un ~r~exercice")
						end
					elseif training == true then
						ESX.ShowNotification("Tu as besoin de te reposer...")
						
						resting = true
						
						CheckTraining()
					end
				end			
            end
        end
    end
end)

function CheckTraining()
	if resting == true then
		ESX.ShowNotification("Vous vous reposez...")
		
		resting = false
		Citizen.Wait(60000)
		training = false
	end
	
	if resting == false then
		ESX.ShowNotification("Vous pouvez maintenant exercer de nouveau...")
	end
end

function OpenGymMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'gym_menu',
        {
            title = 'Gym',
            elements = {
				{label = 'Shop', value = 'shop'},
				{label = 'Heures de travail', value = 'hours'},
				{label = 'Adhésion', value = 'ship'},
            }
        },
        function(data, menu)
            if data.current.value == 'shop' then
				OpenGymShopMenu()
            elseif data.current.value == 'hours' then
				ESX.UI.Menu.CloseAll()
				
				ESX.ShowNotification("Nous sommes ouverts ~g~H24~w~/~g~7J~w~. Bienvenue!")
            elseif data.current.value == 'ship' then
				OpenGymShipMenu()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenGymShopMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'gym_shop_menu',
        {
		css = 'Hollidays',
            title = 'Gym - Shop',
            elements = {
				{label = 'Sake Protein ($60)', value = 'protein_shake'},
				{label = 'Water ($15)', value = 'water'},
				{label = 'Déjeuné sportif ($20)', value = 'sportlunch'},
				{label = 'Powerade ($40)', value = 'powerade'}
            }
        },
        function(data, menu)
            if data.current.value == 'protein_shake' then
				TriggerServerEvent('esx_gym:buyProteinshake')
            elseif data.current.value == 'water' then
				TriggerServerEvent('esx_gym:buyWater')
            elseif data.current.value == 'sportlunch' then
				TriggerServerEvent('esx_gym:buySportlunch')
            elseif data.current.value == 'powerade' then
				TriggerServerEvent('esx_gym:buyPowerade')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenElecMagMenu()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'elecmag_menu',
        {
		css = 'Hollidays',
            title = 'Magasin - Electronique',
            elements = {
				--{label = 'GPS ($100)', value = 'buygps'},
				{label = 'Portable ($150)', value = 'buyphone'},
				{label = 'Talkies walkie ($250)', value = 'buyradio'},
				{label = 'Enceinte JBL ($150)', value = 'buyjbl'}
            }
        },
        function(data, menu)
            if data.current.value == 'buygps' then
				TriggerServerEvent('nwx_utils:buyGps')
            elseif data.current.value == 'buyphone' then
				TriggerServerEvent('nwx_utils:buyPhone')
			elseif data.current.value == 'buyradio' then
				TriggerServerEvent('nwx_utils:buyRadio')
			elseif data.current.value == 'buyjbl' then
				TriggerServerEvent('nwx_utils:buyJbl')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end


function OpenGymShipMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'gym_ship_menu',
        {css = 'Hollidays',
            title = 'Gym - Adhésion',
            elements = {
				{label = 'Adhésion ($1800)', value = 'membership'},
            }
        },
        function(data, menu)
            if data.current.value == 'membership' then
				TriggerServerEvent('esx_gym:buyMembership')
				
				ESX.UI.Menu.CloseAll()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenBikeMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'bike_menu',
        {css = 'Hollidays',
            title = 'Location vélo',
            elements = {
				{label = 'BMX ($250)', value = 'bmx'},
				{label = 'Cruiser ($300)', value = 'cruiser'},
				{label = 'Fixter ($329)', value = 'fixter'},
				{label = 'Scorcher ($400)', value = 'scorcher'},
            }
        },
        function(data, menu)
            if data.current.value == 'bmx' then
				TriggerServerEvent('esx_gym:hireBmx')
				TriggerEvent('esx:spawnVehicle', "bmx")
				
				ESX.UI.Menu.CloseAll()
            elseif data.current.value == 'cruiser' then
				TriggerServerEvent('esx_gym:hireCruiser')
				TriggerEvent('esx:spawnVehicle', "cruiser")
				
				ESX.UI.Menu.CloseAll()
            elseif data.current.value == 'fixter' then
				TriggerServerEvent('esx_gym:hireFixter')
				TriggerEvent('esx:spawnVehicle', "fixter")
				
				ESX.UI.Menu.CloseAll()
            elseif data.current.value == 'scorcher' then
				TriggerServerEvent('esx_gym:hireScorcher')
				TriggerEvent('esx:spawnVehicle', "scorcher")
				
				ESX.UI.Menu.CloseAll()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

-- Tacle
local isTackling, isGettingTackled, isRagdoll = false, false, false
local tackleLib = 'missmic2ig_11'
local tackleAnim = 'mic_2_ig_11_intro_goon'
local tackleVictimAnim = 'mic_2_ig_11_intro_p_one'
local lastTackleTime = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if isRagdoll then
			SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
		end
	end
end)

RegisterNetEvent('esx_kekke_tackle:getTackled')
AddEventHandler('esx_kekke_tackle:getTackled', function(target)
	isGettingTackled = true

	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	RequestAnimDict(tackleLib)

	while not HasAnimDictLoaded(tackleLib) do
		Citizen.Wait(10)
	end

	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 11816, 0.25, 0.5, 0.0, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
	TaskPlayAnim(playerPed, tackleLib, tackleVictimAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

	Citizen.Wait(3000)
	DetachEntity(GetPlayerPed(-1), true, false)

	isRagdoll = true
	Citizen.Wait(3000)
	isRagdoll = false

	isGettingTackled = false
end)

RegisterNetEvent('esx_kekke_tackle:playTackle')
AddEventHandler('esx_kekke_tackle:playTackle', function()
	local playerPed = GetPlayerPed(-1)

	RequestAnimDict(tackleLib)

	while not HasAnimDictLoaded(tackleLib) do
		Citizen.Wait(10)
	end

	TaskPlayAnim(playerPed, tackleLib, tackleAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

	Citizen.Wait(3000)

	isTackling = false

end)

-- Main thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlPressed(0, 21) and IsControlPressed(0, 47) and not isTackling and GetGameTimer() - lastTackleTime > 10 * 1000 then
			Citizen.Wait(10)
			local closestPlayer, distance = ESX.Game.GetClosestPlayer()

			if distance ~= -1 and distance <= 1.5 and not isTackling and not isGettingTackled and not IsPedInAnyVehicle(GetPlayerPed(-1)) and not IsPedInAnyVehicle(GetPlayerPed(closestPlayer)) then
				isTackling = true
				lastTackleTime = GetGameTimer()

				TriggerServerEvent('esx_kekke_tackle:tryTackle', GetPlayerServerId(closestPlayer))
			end
		end
	end
end)

-- Porter
local piggyBackInProgress = false

RegisterCommand("porter",function(source, args)
	if not piggyBackInProgress then
		piggyBackInProgress = true
		local player = PlayerPedId()	
		lib = 'anim@arena@celeb@flat@paired@no_props@'
		anim1 = 'piggyback_c_player_a'
		anim2 = 'piggyback_c_player_b'
		distans = -0.07
		distans2 = 0.0
		height = 0.45
		spin = 0.0		
		length = 100000
		controlFlagMe = 49
		controlFlagTarget = 33
		animFlagTarget = 1
		local closestPlayer = GetClosestPlayer(3)
		target = GetPlayerServerId(closestPlayer)
		if closestPlayer ~= nil then
			print("triggering cmg2_animations:sync")
			TriggerServerEvent('cmg2_animations:sync', closestPlayer, lib, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
		else
			print("Pas de joueur à proximité")
		end
	else
		piggyBackInProgress = false
		ClearPedSecondaryTask(GetPlayerPed(-1))
		DetachEntity(GetPlayerPed(-1), true, false)
		local closestPlayer = GetClosestPlayer(3)
		target = GetPlayerServerId(closestPlayer)
		TriggerServerEvent("cmg2_animations:stop",target)
	end
end,false)

RegisterNetEvent('cmg2_animations:syncTarget')
AddEventHandler('cmg2_animations:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	piggyBackInProgress = true
	print("triggered cmg2_animations:syncTarget")
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
end)

RegisterNetEvent('cmg2_animations:syncMe')
AddEventHandler('cmg2_animations:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = GetPlayerPed(-1)
	print("triggered cmg2_animations:syncMe")
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	Wait(500)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)

	Citizen.Wait(length)
end)

RegisterNetEvent('cmg2_animations:cl_stop')
AddEventHandler('cmg2_animations:cl_stop', function()
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	piggyBackInProgress = false
	ClearPedSecondaryTask(playerPed)
	DetachEntity(GetPlayerPed(GetPlayerFromServerId(target)), true, false)
end)

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function GetClosestPlayer(radius)
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
	print("closest player is dist: " .. tostring(closestDistance))
	if closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

-- TP
local TeleportFromTo = {
	
	["Humane Labs"] = {
		positionFrom = { ['x'] = 3541.7028, ['y'] = 3674.2761, ['z'] = 28.1211, nom = "Prendre l'ascenceur"},
		positionTo = { ['x'] = 3541.7314, ['y'] = 3674.2619, ['z'] = 20.9917, nom = "Prendre l'ascenceur"},
	},		
	
    	["Mont Chiliad - Telecabine"] = {
	    positionFrom = { ['x'] = -741.738, ['y'] = 5595.22, ['z'] = 41.6546, nom = "Prendre le Télépherique"},
		positionTo = { ['x'] = 446.051, ['y'] = 5572.32, ['z'] = 781.189, nom = "Prendre le Télépherique"},
	},		

	["AgentX"] = {
		positionFrom = { ['x'] = -1914.912, ['y'] = 1389.007, ['z'] = 219.714, nom = "Entrée"},
		positionTo = { ['x'] = 361.77810668945, ['y'] = 4833.6977539063, ['z'] = -58.999340057373, nom = "Sortie"},
	},

	["Gouvernement"] = {
		positionFrom = { ['x'] = -545.12, ['y'] = -204.16, ['z'] = 38.215, nom = "Entrer au Gouvernement"},
		positionTo = { ['x'] = 136.2, ['y'] = -761.7, ['z'] = 242.200, nom = "Sortir du Gouvernement"},
	},

	["Hopital"] = {
		positionFrom = { ['x'] = 298.95, ['y'] = -584.60, ['z'] = 43.265, nom = "Descendre dans l'Hopital"},
		positionTo = { ['x'] = 337.853, ['y'] = -594.386, ['z'] = 28.80, nom = "Remonter en haut"},
	},

	["H�lico Hopital"] = {
		positionFrom = { ['x'] = 340.669, ['y'] = -595.37, ['z'] = 28.80, nom = "Monter a l'héliport"},
		positionTo = { ['x'] = 339.121, ['y'] = -584.048, ['z'] = 74.20, nom = "Descendre dans l'Hopital"},
	},






}	


Drawing = setmetatable({}, Drawing)
Drawing.__index = Drawing


function Drawing.draw3DText(x,y,z,textInput,fontId,scaleX,scaleY,r, g, b, a)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*10
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function Drawing.drawMissionText(m_text, showtime)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(m_text)
    DrawSubtitleTimed(showtime, 1)
end

function msginf(msg, duree)
    duree = duree or 300
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(msg)
    DrawSubtitleTimed(duree, 1)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		
		for k, j in pairs(TeleportFromTo) do
		
			--msginf(k .. " " .. tostring(j.positionFrom.x), 15000)
			if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 2.0)then
				DrawMarker(23, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, .801, 255, 255, 255,255, 0, 0, 0,0)
				if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 1.0)then
					Drawing.draw3DText(j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1.100, j.positionFrom.nom, 1, 0.2, 0.1, 255, 255, 255, 215)
					if(Vdist(pos.x, pos.y, pos.z, j.positionFrom.x, j.positionFrom.y, j.positionFrom.z) < 1.0)then
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString("Appuyez sur la touche ~r~E~w~ pour ".. j.positionFrom.nom)
						DrawSubtitleTimed(1000, 1)
						if IsControlJustPressed(1, 38) then
							DoScreenFadeOut(1000)
							Citizen.Wait(2500)
							SetEntityCoords(GetPlayerPed(-1), j.positionTo.x, j.positionTo.y, j.positionTo.z - 1)
							DoScreenFadeIn(1000)
						end
					end
				end
			end
			
			if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 2.0)then
				DrawMarker(23, j.positionTo.x, j.positionTo.y, j.positionTo.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, .801, 255, 255, 255,255, 0, 0, 0,0)
				if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 1.0)then
					Drawing.draw3DText(j.positionTo.x, j.positionTo.y, j.positionTo.z - 1.100, j.positionTo.nom, 1, 0.2, 0.1, 255, 255, 255, 215)
					if(Vdist(pos.x, pos.y, pos.z, j.positionTo.x, j.positionTo.y, j.positionTo.z) < 1.0)then
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString("Appuyez sur la touche ~r~E~w~ pour ".. j.positionTo.nom)
						DrawSubtitleTimed(1000, 1)
						if IsControlJustPressed(1, 38) then
							DoScreenFadeOut(1000)
							Citizen.Wait(2500)
							SetEntityCoords(GetPlayerPed(-1), j.positionFrom.x, j.positionFrom.y, j.positionFrom.z - 1)
							DoScreenFadeIn(1000)
						end
					end
				end
			end
		end
	end
end)