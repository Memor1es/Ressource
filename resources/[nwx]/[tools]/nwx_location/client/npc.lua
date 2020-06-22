Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0) -- prevent crashing

		-- These natives have to be called every frame.
		SetPedDensityMultiplierThisFrame(0.25) -- set npc/ai peds density to 0
        SetVehicleDensityMultiplierThisFrame(0.1) 
		SetParkedVehicleDensityMultiplierThisFrame(0.15)
		SetRandomVehicleDensityMultiplierThisFrame(0.1) -- set random vehicles (car scenarios / cars driving off from a parking spot etc.) to 0
		SetScenarioPedDensityMultiplierThisFrame(0.2, 0.3) -- set random npc/ai peds or scenario peds to 0
		SetGarbageTrucks(false) -- Stop garbage trucks from randomly spawning
		SetRandomBoats(false) -- Stop random boats from spawning in the water.
		SetCreateRandomCops(false) -- disable random cops walking/driving around.
		SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning.
		SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning.

			--[[Citizen.Wait(150) -- prevent crashing
			local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
			ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
			RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);]]--

		-- fix OneSync NPC by Albert0
        if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then

            if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1),false),-1) == GetPlayerPed(-1) then
                SetVehicleDensityMultiplierThisFrame(0.1)
                SetParkedVehicleDensityMultiplierThisFrame(0.15)
            else
                SetVehicleDensityMultiplierThisFrame(0.0)
                SetParkedVehicleDensityMultiplierThisFrame(0.0)
            end
        else
          SetParkedVehicleDensityMultiplierThisFrame(0.15)
          SetVehicleDensityMultiplierThisFrame(0.1)
        end

        Citizen.Wait(0)
        for i = 1, 12 do
			EnableDispatchService(i, false)
		end
		SetPlayerWantedLevel(GetPlayerPed(-1), 0, false)
		SetPlayerWantedLevelNow(GetPlayerPed(-1), false)
		SetPlayerWantedLevelNoDrop(GetPlayerPed(-1), 0, false)
		N_0x4757f00bc6323cfe(-1553120962, 0.0)
	end
end)

local pedindex = {}

function SetWeaponDrops() -- This function will set the closest entity to you as the variable entity.
    local handle, ped = FindFirstPed()
    local finished = false -- FindNextPed will turn the first variable to false when it fails to find another ped in the index
    repeat 
        if not IsEntityDead(ped) then
                pedindex[ped] = {}
        end
        finished, ped = FindNextPed(handle) -- first param returns true while entities are found
    until not finished
    EndFindPed(handle)

    for peds,_ in pairs(pedindex) do
        if peds ~= nil then -- set all peds to not drop weapons on death.
            SetPedDropsWeaponsWhenDead(peds, false) 
        end
    end
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        SetWeaponDrops()
    end
end)

-- AFK Camera
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- The idle camera activates after 30 second so we don't need to call this per frame

        N_0xf4f2c0d4ee209e20() -- Disable the pedestrian idle camera
        N_0x9e4cfff989258472() -- Disable the vehicle idle camera
    end
end)

Citizen.CreateThread( function()
  while true do
    Citizen.Wait(100)       

    RemovePedHelmet(GetVehiclePedIsUsing(GetPlayerPed(-1)),true) end  
end)