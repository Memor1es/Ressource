local group
local states = {}
states.frozen = false
states.frozenPos = nil

RegisterNetEvent('es:openmenu')
AddEventHandler('es:openmenu', function(toggle)
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'open', players = getPlayers()})
end)

RegisterNetEvent('es:Blackout')
AddEventHandler('es:Blackout', function(toggle)
	SetBlackout(true)
end)

RegisterNetEvent('es:BlackoutOff')
AddEventHandler('es:BlackoutOff', function(toggle)
	SetBlackout(false)
end)

RegisterNetEvent('es:NpcOff')
AddEventHandler('es:NpcOff', function(toggle)
	SetPedDensityMultiplierThisFrame(0) -- set npc/ai peds density to 0
	SetRandomVehicleDensityMultiplierThisFrame(0) -- set random vehicles (car scenarios / cars driving off from a parking spot etc.) to 0
	SetScenarioPedDensityMultiplierThisFrame(0, 0) -- set random npc/ai peds or scenario peds to 0
	SetGarbageTrucks(false) -- Stop garbage trucks from randomly spawning
	SetRandomBoats(false) -- Stop random boats from spawning in the water.
	SetCreateRandomCops(false) -- disable random cops walking/driving around.
	SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning.
	SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning.
	
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
	RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
	
	-- Fix OneSync
	if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then

		if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1),false),-1) == GetPlayerPed(-1) then
			SetVehicleDensityMultiplierThisFrame(0)
			SetParkedVehicleDensityMultiplierThisFrame(0)
		else
			SetVehicleDensityMultiplierThisFrame(0)
			SetParkedVehicleDensityMultiplierThisFrame(0)
		end
	else
		SetParkedVehicleDensityMultiplierThisFrame(0)
		SetVehicleDensityMultiplierThisFrame(0)
	end
end)

RegisterNetEvent('es:NpcOn')
AddEventHandler('es:NpcOn', function(toggle)
	SetPedDensityMultiplierThisFrame(0.2) -- set npc/ai peds density to 0
	SetRandomVehicleDensityMultiplierThisFrame(0.5) -- set random vehicles (car scenarios / cars driving off from a parking spot etc.) to 0
	SetScenarioPedDensityMultiplierThisFrame(0.2, 0.4) -- set random npc/ai peds or scenario peds to 0
	SetGarbageTrucks(false) -- Stop garbage trucks from randomly spawning
	SetRandomBoats(false) -- Stop random boats from spawning in the water.
	SetCreateRandomCops(false) -- disable random cops walking/driving around.
	SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning.
	SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning.
	
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
	RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);

	-- Fix OneSync
	if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then

		if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1),false),-1) == GetPlayerPed(-1) then
			SetVehicleDensityMultiplierThisFrame(0.1)
			SetParkedVehicleDensityMultiplierThisFrame(0.0)
		else
			SetVehicleDensityMultiplierThisFrame(0.0)
			SetParkedVehicleDensityMultiplierThisFrame(0.1)
		end
	else
		SetParkedVehicleDensityMultiplierThisFrame(0.0)
		SetVehicleDensityMultiplierThisFrame(0.1)
	end
end)

RegisterNetEvent('es_admin:setGroup')
AddEventHandler('es_admin:setGroup', function(g)
	group = g
end)

RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false)
end)

RegisterNUICallback('quick', function(data, cb)
	if data.type == "slay_all" or data.type == "bring_all" or data.type == "slap_all" or data.type == "heal_all" then
		TriggerServerEvent('es_admin:all', data.type)
	else
		TriggerServerEvent('es_admin:quick', data.id, data.type)
	end
end)

RegisterNUICallback('set', function(data, cb)
	TriggerServerEvent('es_admin:set', data.type, data.user, data.param)
end)

local noclip = false
RegisterNetEvent('es_admin:quick')
AddEventHandler('es_admin:quick', function(t, target)
	if t == "slay" then SetEntityHealth(PlayerPedId(), 0) end
	if t == "heal" then SetEntityHealth(PlayerPedId(), 200) end
	if t == "goto" then SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))) end
	if t == "bring" then 
		states.frozenPos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))
		SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))) 
	end
	if t == "crash" then 
		Citizen.Trace("Vous avez crash.\n")
		Citizen.CreateThread(function()
			while true do end
		end) 
	end
	if t == "slap" then ApplyForceToEntity(PlayerPedId(), 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false) end
	if t == "noclip" then
		local msg = "disabled"
		if(noclip == false)then
			noclip_pos = GetEntityCoords(GetPlayerPed(-1), false)
		end

		noclip = not noclip

		if(noclip)then
			msg = "enabled"
		end

		TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Noclip  ^2^*" .. msg)
	end
	if t == "freeze" then
		local player = PlayerId()

		local ped = GetPlayerPed(-1)

		states.frozen = not states.frozen
		states.frozenPos = GetEntityCoords(ped, false)

		if not state then
			if not IsEntityVisible(ped) then
				SetEntityVisible(ped, true)
			end

			if not IsPedInAnyVehicle(ped) then
				SetEntityCollision(ped, true)
			end

			FreezeEntityPosition(ped, false)
			SetPlayerInvincible(player, false)
		else
			SetEntityCollision(ped, false)
			FreezeEntityPosition(ped, true)
			SetPlayerInvincible(player, true)

			if not IsPedFatallyInjured(ped) then
				ClearPedTasksImmediately(ped)
			end
		end
	end

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if(states.frozen)then
			ClearPedTasksImmediately(GetPlayerPed(-1))
			SetEntityCoords(GetPlayerPed(-1), states.frozenPos)
		else
			Citizen.Wait(200)
		end
	end
end)

local heading = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if(noclip)then
			SetEntityCoordsNoOffset(GetPlayerPed(-1), noclip_pos.x, noclip_pos.y, noclip_pos.z, 0, 0, 0)

			if(IsControlPressed(1, 34))then
				heading = heading + 1.5
				if(heading > 360)then
					heading = 0
				end
				SetEntityHeading(GetPlayerPed(-1), heading)
			end
			if(IsControlPressed(1, 9))then
				heading = heading - 1.5
				if(heading < 0)then
					heading = 360
				end
				SetEntityHeading(GetPlayerPed(-1), heading)
			end
			if(IsControlPressed(1, 8))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 1.0, 0.0)
			end
			if(IsControlPressed(1, 32))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, -1.0, 0.0)
			end

			if(IsControlPressed(1, 27))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 0.0, 1.0)
			end
			if(IsControlPressed(1, 173))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 0.0, -1.0)
			end
		end
	end
end)

RegisterNetEvent('es_admin:spawnVehicle')
AddEventHandler('es_admin:spawnVehicle', function(v)
	local carid = GetHashKey(v)
	local playerPed = GetPlayerPed(-1)
	if playerPed and playerPed ~= -1 then
		RequestModel(carid)
		while not HasModelLoaded(carid) do
			Citizen.Wait(1)
		end

		local playerCoords = GetEntityCoords(playerPed)
		veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
		SetVehicleAsNoLongerNeeded(veh)
		TaskWarpPedIntoVehicle(playerPed, veh, -1)
	end
end)

RegisterNetEvent('es_admin:freezePlayer')
AddEventHandler("es_admin:freezePlayer", function(state)
	local player = PlayerId()

	local ped = GetPlayerPed(-1)

	states.frozen = state
	states.frozenPos = GetEntityCoords(ped, false)

	if not state then
		if not IsEntityVisible(ped) then
			SetEntityVisible(ped, true)
		end

		if not IsPedInAnyVehicle(ped) then
			SetEntityCollision(ped, true)
		end

		FreezeEntityPosition(ped, false)
		SetPlayerInvincible(player, false)
	else
		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)
		SetPlayerInvincible(player, true)

		if not IsPedFatallyInjured(ped) then
			ClearPedTasksImmediately(ped)
		end
	end
end)

RegisterNetEvent('es_admin:teleportUser')
AddEventHandler('es_admin:teleportUser', function(x, y, z)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	states.frozenPos = {x = x, y = y, z = z}
end)

RegisterNetEvent('es_admin:slap')
AddEventHandler('es_admin:slap', function()
	local ped = GetPlayerPed(-1)
	ApplyForceToEntity(ped, 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false)
end)

RegisterNetEvent('es_admin:givePosition')
AddEventHandler('es_admin:givePosition', function()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local string = "{ ['x'] = " .. pos.x .. ", ['y'] = " .. pos.y .. ", ['z'] = " .. pos.z .. " },\n"
	TriggerServerEvent('es_admin:givePos', string)
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, 'Position enregistrée dans le fichier.')
end)

RegisterNetEvent('es_admin:kill')
AddEventHandler('es_admin:kill', function()
	SetEntityHealth(GetPlayerPed(-1), 0)
end)

RegisterNetEvent('es_admin:heal')
AddEventHandler('es_admin:heal', function()
	SetEntityHealth(GetPlayerPed(-1), 200)
end)

RegisterNetEvent('es_admin:crash')
AddEventHandler('es_admin:crash', function()
	while true do
	end
end)

RegisterNetEvent("es_admin:noclip")
AddEventHandler("es_admin:noclip", function(t)
	local msg = "disabled"
	if(noclip == false)then
		noclip_pos = GetEntityCoords(GetPlayerPed(-1), false)
	end

	noclip = not noclip

	if(noclip)then
		msg = "enabled"
	end

	TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Noclip ^2^*" .. msg)
end)

RegisterNetEvent("es_admin:ghost")
AddEventHandler("es_admin:ghost", function(t)
	local msg = "disabled"
	if(noclip == false)then
		noclip_pos = GetEntityCoords(GetPlayerPed(-1), false)
	end

	noclip = not noclip

	if(noclip)then
		msg = "enabled"
	end

	TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Noclip  ^2^*" .. msg)
end)

function getPlayers()
	local players = {}
	for i = 0,255 do
		if NetworkIsPlayerActive(i) then
			table.insert(players, {id = GetPlayerServerId(i), name = GetPlayerName(i)})
		end
	end
	return players
end

RegisterNetEvent('es_admin:name')
AddEventHandler('es_admin:name', function(t)
	for id = 0, 256 do
		if  NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= GetPlayerPed(-1) then

			ped = GetPlayerPed(id)
			blip = GetBlipFromEntity(ped)

			-- HEAD DISPLAY STUFF --
			-- Create head display (this is safe to be spammed)
			headId = Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, GetPlayerName(id), false, false, "", false)

			-- Speaking display
			if NetworkIsPlayerTalking(id) then
				Citizen.InvokeNative(0x63BB75ABEDC1F6A0, headId, 9, true) -- Add speaking sprite
			else
				Citizen.InvokeNative(0x63BB75ABEDC1F6A0, headId, 9, false) -- Remove speaking sprite
			end

		end

	end
end)

RegisterNetEvent('es:openmenu')
AddEventHandler('es:openmenu', function(toggle)
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'open', players = getPlayers()})
end)