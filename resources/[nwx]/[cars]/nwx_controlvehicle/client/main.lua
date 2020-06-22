ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

-- Regulateur

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if IsControlJustPressed(1, 246) then
			TriggerEvent('pv:setCruiseSpeed')
		end
	end
end)

AddEventHandler('pv:setNewSpeed', function()
	Citizen.CreateThread(function()
		while IsControlPressed(1, 32) do
			Citizen.Wait(0)
		end
		TriggerEvent('pv:setCruiseSpeed')
	end)
end)

local cruise = 0

AddEventHandler('pv:setCruiseSpeed', function()
	if cruise == 0 and IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		if GetEntitySpeedVector(GetVehiclePedIsIn(GetPlayerPed(-1), false), true)['y'] > 0 then
			
			cruise = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
			
			local cruiseKm  = math.floor(cruise * 3.6 + 0.5)
			local cruiseMph = math.floor(cruise * 2.23694 + 0.5)
			
			ESX.ShowNotification('Limitateur: ~g~ ACTIF~w~ - ~b~ ' .. cruiseKm ..' km/h')
			
			Citizen.CreateThread(function()
				while cruise > 0 and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) do
					local cruiseVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
					if IsVehicleOnAllWheels(cruiseVeh) and GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) > (cruise - 2.0) then
						SetVehicleForwardSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), cruise)
					else
						cruise = 0
						ESX.ShowNotification('Limitateur: ~r~ INACTIF~s~')
						break
					end
					if IsControlPressed(1, 8) then
						cruise = 0
						ESX.ShowNotification('Limitateur: ~r~ INACTIF~s~')
					end
					if IsControlPressed(1, 32) then
						cruise = 0
						TriggerEvent('pv:setNewSpeed')
					end
					if cruise > 44 then
						cruise = 0
						ESX.ShowNotification('Limitateur: Ne peux pas être aussi élevé !')
						break
					end
					Citizen.Wait(200)
				end
				cruise = 0
			end)
		else
			cruise = 0
			ESX.ShowNotification('Limitateur: ~r~INACTIF~s~')
		end
	else
		if cruise > 0 then
			ESX.ShowNotification('Limitateur: ~r~INACTIF~s~')
		end
		cruise = 0
	end
end)

Citizen.CreateThread(function() 
    while true do              
        if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId())) then
            local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
            local lock = GetVehicleDoorLockStatus(veh)

            if lock == 7 then
                SetVehicleDoorsLocked(veh, 2)
            end
                 
            local pedd = GetPedInVehicleSeat(veh, -1)

            if pedd then                   
                SetPedCanBeDraggedOut(pedd, false)
            end             
        end
        Citizen.Wait(0)	    							
    end
end)

-- Forklift
isAttached = false
attachedEntity = nil

Citizen.CreateThread(function()
    while true do
        Wait(0)

        -- f10 to attach/detach
        if IsControlJustPressed(0, 57) then
			-- if already attached detach
			if isAttached then
				DetachEntity(attachedEntity, true, true)
				
				attachedEntity = nil
				isAttached = false
			else	
				-- get vehicle infront
				local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
				local veh = GetClosestVehicle(pos, 2.0, 0, 70)
				
				-- if vehicle is found
				if veh ~= 0 and IsPedInAnyVehicle(PlayerPedId(), false) then
					local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
					
					-- check if player is in forklift
					if GetEntityModel(currentVehicle) == GetHashKey("forklift") then 
						isAttached = true
						attachedEntity = veh
						
						-- attach vehicle to forklift, you can change some values
						AttachEntityToEntity(veh, currentVehicle, 3, 0.0, 1.3, -0.09, 0.0, 0, 90.0, false, false, false, false, 2, true)
					end
				end
			end
        end        
    end
end)

-- C O N F I G --
interactionDistance = 3.5 --The radius you have to be in to interact with the vehicle.
lockDistance = 25 --The radius you have to be in to lock your vehicle.

--  V A R I A B L E S --
engineoff = false
saved = false
controlsave_bool = false

-- E N G I N E --
IsEngineOn = true
RegisterNetEvent('engine')
AddEventHandler('engine',function() 
	local player = GetPlayerPed(-1)
	
	if (IsPedSittingInAnyVehicle(player)) then 
		local vehicle = GetVehiclePedIsIn(player,false)
		
		if IsEngineOn == true then
			IsEngineOn = false
			SetVehicleEngineOn(vehicle,false,false,false)
		else
			IsEngineOn = true
			SetVehicleUndriveable(vehicle,false)
			SetVehicleEngineOn(vehicle,true,false,false)
		end
		
		while (IsEngineOn == false) do
			SetVehicleUndriveable(vehicle,true)
			Citizen.Wait(0)
		end
	end
end)

RegisterNetEvent('engineoff')
AddEventHandler('engineoff',function() 
		local player = GetPlayerPed(-1)

        if (IsPedSittingInAnyVehicle(player)) then 
            local vehicle = GetVehiclePedIsIn(player,false)
			engineoff = true
			ShowNotification("Engine ~r~off~s~.")
			while (engineoff) do
			SetVehicleEngineOn(vehicle,false,false,false)
			SetVehicleUndriveable(vehicle,true)
			Citizen.Wait(0)
			end
		end
end)
RegisterNetEvent('engineon')
AddEventHandler('engineon',function() 
    local player = GetPlayerPed(-1)

        if (IsPedSittingInAnyVehicle(player)) then 
            local vehicle = GetVehiclePedIsIn(player,false)
			engineoff = false
			SetVehicleUndriveable(vehicle,false)
			SetVehicleEngineOn(vehicle,true,false,false)
			ShowNotification("Engine ~g~on~s~.")
	end
end)
-- T R U N K --
RegisterNetEvent('trunk')
AddEventHandler('trunk',function() 
	local player = GetPlayerPed(-1)
			if controlsave_bool == true then
				vehicle = saveVehicle
			else
				vehicle = GetVehiclePedIsIn(player,true)
			end
			
			local isopen = GetVehicleDoorAngleRatio(vehicle,5)
			local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
			
			if distanceToVeh <= interactionDistance then
				if (isopen == 0) then
				SetVehicleDoorOpen(vehicle,5,0,0)
				else
				SetVehicleDoorShut(vehicle,5,0)
				end
			else
				ShowNotification("~r~You must be near your vehicle to do that.")
			end
end)
-- R E A R  D O O R S --
RegisterNetEvent('rdoors')
AddEventHandler('rdoors',function() 
	local player = GetPlayerPed(-1)
    		if controlsave_bool == true then
				vehicle = saveVehicle
			else
				vehicle = GetVehiclePedIsIn(player,true)
			end
			local isopen = GetVehicleDoorAngleRatio(vehicle, 0) and GetVehicleDoorAngleRatio(vehicle, 1) or GetVehicleDoorAngleRatio(vehicle, 2) and GetVehicleDoorAngleRatio(vehicle, 3)
			local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
			
			if distanceToVeh <= interactionDistance then
				if (isopen == 0) then
					SetVehicleDoorOpen(vehicle, 0, 0)
					SetVehicleDoorOpen(vehicle, 1, 0)
					SetVehicleDoorOpen(vehicle, 2, 0)
					SetVehicleDoorOpen(vehicle, 3, 0)
				else
					SetVehicleDoorShut(vehicle, 0, 0)
					SetVehicleDoorShut(vehicle, 1, 0)
					SetVehicleDoorShut(vehicle, 2, 0)
					SetVehicleDoorShut(vehicle, 3, 0)
				end
			else
				ShowNotification("~r~You must be near your vehicle to do that.")
			end
end)		

-- H O O D --
RegisterNetEvent('hood')
AddEventHandler('hood',function() 
	local player = GetPlayerPed(-1)
    	if controlsave_bool == true then
			vehicle = saveVehicle
		else
			vehicle = GetVehiclePedIsIn(player,true)
		end
			
			local isopen = GetVehicleDoorAngleRatio(vehicle,4)
			local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
			
			if distanceToVeh <= interactionDistance then
				if (isopen == 0) then
				SetVehicleDoorOpen(vehicle,4,0,0)
				else
				SetVehicleDoorShut(vehicle,4,0)
				end
			else
				ShowNotification("~r~You must be near your vehicle to do that.")
			end
end)
-- L O C K --
RegisterNetEvent('lockLights')
AddEventHandler('lockLights',function()
local vehicle = saveVehicle
	StartVehicleHorn(vehicle, 100, 1, false)
	SetVehicleLights(vehicle, 2)
	Wait (200)
	SetVehicleLights(vehicle, 0)
	StartVehicleHorn(vehicle, 100, 1, false)
	Wait (200)
	SetVehicleLights(vehicle, 2)
	Wait (400)
	SetVehicleLights(vehicle, 0)
end)

RegisterNetEvent('lock')
AddEventHandler('lock',function()
	local playerPed = GetPlayerPed(-1)
	local coords = GetEntityCoords(playerPed, true)

	local vehicle = nil

	if IsPedInAnyVehicle(playerPed,  false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 71)
	end

	ESX.TriggerServerCallback('esx_vehiclelock:mykey', function(gotkey)

		if gotkey then
			local locked = GetVehicleDoorLockStatus(vehicle)
			if locked == 1 or locked == 0 then -- if unlocked
				SetVehicleDoorsLocked(vehicle, 2)
				PlayVehicleDoorCloseSound(vehicle, 1)
				ESX.ShowNotification("Vous avez ~r~fermé~s~ le véhicule.")
			elseif locked == 2 then -- if locked
				SetVehicleDoorsLocked(vehicle, 1)
				PlayVehicleDoorOpenSound(vehicle, 0)
				ESX.ShowNotification("Vous avez ~g~ouvert~s~ le véhicule.")
			end
		else
			ESX.ShowNotification("~r~Vous n'avez pas les clés de ce véhicule.")
		end
	end, GetVehicleNumberPlateText(vehicle))
end)

function ShowNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end
-- S A V E --
RegisterNetEvent('save')
AddEventHandler('save',function() 
	local player = GetPlayerPed(-1)
	if (IsPedSittingInAnyVehicle(player)) then 
		if  saved == true then
			--remove from saved.
			saveVehicle = nil
			RemoveBlip(targetBlip)
			ShowNotification("Saved vehicle ~r~removed~w~.")
			saved = false
		else
			RemoveBlip(targetBlip)
			saveVehicle = GetVehiclePedIsIn(player,true)
			local vehicle = saveVehicle
			targetBlip = AddBlipForEntity(vehicle)
			SetBlipSprite(targetBlip,225)
			ShowNotification("This ~y~" .. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) .. "~w~ is now your~g~ saved ~w~vehicle.")
			saved = true
		end
	end
end)
-- R E M O T E --
RegisterNetEvent('controlsave')
AddEventHandler('controlsave',function() 
		if controlsave_bool == false then
			controlsave_bool = true
			if saveVehicle == nil then
			ShowNotification("~r~No saved vehicle.")
			else
			ShowNotification("You are no longer controlling your ~y~" .. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(saveVehicle))))
			end
		else
			controlsave_bool = false
			if saveVehicle == nil then
			ShowNotification("~r~No saved vehicle.")
			else
			ShowNotification("You are no longer controlling your ~y~" .. GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(saveVehicle))))
			end
		end
end)

-- esx_vehiclelock
local playerCars = {}

--Menu Mes clés
RegisterNetEvent('esx_menu:key')
AddEventHandler('esx_menu:key', function()
    ESX.TriggerServerCallback('esx_vehiclelock:allkey', function(mykey)
	 local elements = {}
		for i=1, #mykey, 1 do
			if mykey[i].got == 'true' then 
				if 	mykey[i].NB == 1 then									
						table.insert(elements, {label = 'Clés : '.. ' [' .. mykey[i].plate .. ']', value = mykey[i].plate})
					elseif mykey[i].NB == 2 then
						table.insert(elements, {label = '[DOUBLE] Véhicule : '.. ' [' .. mykey[i].plate .. ']', value = nil})
					end
				end
			end
    end)
end)

function openKeysMenu()
    ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'mykey',
	{	css = 'Hollidays',
		title = 'Mes clés',
		align = 'top-right',
		elements = elements
	  },
        function(data2, menu2) --Submit Cb
 
        if data2.current.value ~= 'nil' then
        ESX.UI.Menu.CloseAll()
  			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'mykey',
				{	css = 'Hollidays',
				title = 'Voulez vous ?',
				align = 'top-right',
				elements = {
						--{label = 'Vendre Voiture', value = 'donnerkey'}, -- Donné les clés
						{label = 'Préter Clé', value = 'preterkey'}, -- Donné les clés
			  		},
	  			},
        		function(data3, menu3) --Submit Cb
 					local player, distance = ESX.Game.GetClosestPlayer()
 					local playerPed = GetPlayerPed(-1)
					local coords = GetEntityCoords(playerPed, true)
 					local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 71)
 					local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

       				 if data3.current.value == 'donnerkey' then
       					 ESX.UI.Menu.CloseAll()
       					if distance ~= -1 and distance <= 3.0 then
       					  TriggerServerEvent('esx_vehiclelock:donnerkey', GetPlayerServerId(player), data2.current.value)
       					  TriggerServerEvent('esx_vehiclelock:deletekey', data2.current.value)
       					  print("deletekey owner")
       					  TriggerServerEvent('esx_vehiclelock:changeowner', GetPlayerServerId(player), vehicleProps)
       					  print("changement owner")
       					end
      				 end
      				 if data3.current.value == 'preterkey' then
       					 ESX.UI.Menu.CloseAll()
       					if distance ~= -1 and distance <= 3.0 then 
       					  TriggerServerEvent('esx_vehiclelock:preterkey', GetPlayerServerId(player), data2.current.value)
       					end
      				 end
       			 end,
       			 function(data3, menu3) --Cancel Cb
           		     menu3.close()
       			 end,
       			 function(data3, menu3) --Change Cb
         
        		 end
   			 )
        end
        end,
        
        function(data2, men2) --Cancel Cb
                men2.close()
        end,
        function(dat2, men2) --Change Cb
        end
      )
end

--Menu Mes clés
RegisterNetEvent('esx_menu:key')
AddEventHandler('esx_menu:key', function()
ESX.TriggerServerCallback('esx_vehiclelock:allkey', function(mykey)
	local elements = {}
		for i=1, #mykey, 1 do
			if mykey[i].got == 'true' then 
				if 	mykey[i].NB == 1 then									
						table.insert(elements, {label = 'Clés : '.. ' [' .. mykey[i].plate .. ']', value = mykey[i].plate})
					elseif mykey[i].NB == 2 then
						table.insert(elements, {label = '[DOUBLE] Véhicule : '.. ' [' .. mykey[i].plate .. ']', value = nil})
					end
				end
			end

 ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'mykey',
	{	css = 'Hollidays',
		title = 'Mes clés',
		align = 'top-right',
		elements = elements
	  },
        function(data2, menu2) --Submit Cb
 
        if data2.current.value ~= nil then
        ESX.UI.Menu.CloseAll()
  			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'mykey',
				{	css = 'Hollidays',
				title = 'Voulez vous ?',
				align = 'top-right',
				elements = {
						{label = 'Préter', value = data2.current.value}, -- Donné les clés
			  		},
	  			},
        		function(data3, menu3) --Submit Cb
 					local player, distance = ESX.Game.GetClosestPlayer()

       				 if data3.current.value ~= nil then
       					 ESX.UI.Menu.CloseAll()
       					if distance ~= -1 and distance <= 3.0 then
       					  TriggerServerEvent('esx_vehiclelock:givekey', GetPlayerServerId(player), data2.current.value)
       					end
      				 end
       			 end,
       			 function(data3, menu3) --Cancel Cb
           		     menu3.close()
       			 end,
       			 function(data3, menu3) --Change Cb
         
        		 end
   			 )
        end
        end,
        
        function(data2, men2) --Cancel Cb
                men2.close()
        end,
        function(dat2, men2) --Change Cb
        end
      )
  end)
end)

AddEventHandler('esx_vehiclelock:hasEnteredMarker', function(zone)
	CurrentAction = 'Serrurier'
	CurrentActionMsg = 'Serrurier'
	CurrentActionData = {zone = zone}
end)

AddEventHandler('esx_vehiclelock:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

function OpenCloseVehicle()
	local playerPed = GetPlayerPed(-1)
	local coords = GetEntityCoords(playerPed, true)

	local vehicle = nil

	if IsPedInAnyVehicle(playerPed,  false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 71)
	end

	ESX.TriggerServerCallback('esx_vehiclelock:mykey', function(gotkey)

		if gotkey then
			local locked = GetVehicleDoorLockStatus(vehicle)
			if locked == 1 or locked == 0 then -- if unlocked
				SetVehicleDoorsLocked(vehicle, 2)
				PlayVehicleDoorCloseSound(vehicle, 1)
				ESX.ShowNotification("Vous avez ~r~fermé~s~ le véhicule.")
			elseif locked == 2 then -- if locked
				SetVehicleDoorsLocked(vehicle, 1)
				PlayVehicleDoorOpenSound(vehicle, 0)
				ESX.ShowNotification("Vous avez ~g~ouvert~s~ le véhicule.")
			end
		else
			ESX.ShowNotification("~r~Vous n'avez pas les clés de ce véhicule.")
		end
	end, GetVehicleNumberPlateText(vehicle))
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 303) then -- Touche U 303
			OpenCloseVehicle()
		end
	end
end)

--Car Dealer
RegisterNetEvent('esx_menu:keycardealer')
AddEventHandler('esx_menu:keycardealer', function()
ESX.TriggerServerCallback('esx_vehiclelock:allkey', function(mykey)
	local elements = {}
		for i=1, #mykey, 1 do
			if mykey[i].got == 'true' then 
				if 	mykey[i].NB == 3 then									
						table.insert(elements, {label = '[PRO] Clés : '.. ' [' .. mykey[i].plate .. ']', value = mykey[i].plate})
					end
				end
			end
ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'mykey',
	{	css = 'Hollidays',
		title = 'Clé Pro',
		align = 'top-right',
		elements = elements
	  },
        function(data2, menu2) --Submit Cb
 
        if data2.current.value ~= nil then
        ESX.UI.Menu.CloseAll()
  			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'mykey',
				{	css = 'Hollidays',
				title = 'Voulez vous ?',
				align = 'top-right',
				elements = {{label = 'Donner', value = data2.current.value}, -- Donné un double
			  		},
	  			},
        		function(data3, menu3) --Submit Cb
 					local player, distance = ESX.Game.GetClosestPlayer()

       				 if data3.current.value ~= nil then
       					 ESX.UI.Menu.CloseAll()
       					if distance ~= -1 and distance <= 3.0 then
       					  TriggerServerEvent('esx_vehiclelock:givekeycardealer', GetPlayerServerId(player), data2.current.value)
       					  TriggerServerEvent('esx_vehiclelock:deletekeycardealer', GetPlayerServerId(player), data2.current.value)
       					end
      				 end
       			 end,
        
       			 function(data3, menu3) --Cancel Cb
           		     menu3.close()
       			 end,
       			 function(data3, menu3) --Change Cb
         
        		 end
   			 )
        end
        end,
        function(data2, men2) --Cancel Cb
                men2.close()
        end,
        function(dat2, men2) --Change Cb
        end
      )
  end)
end)

--Menu Serrurier
function OpenSerrurierMenu()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'GetKey',
	{	css = 'Hollidays',
		title = 'Que voulez vous ? ',
		align = 'top-right',
		elements = {
			{label = ('Enregistrer une nouvelle clé'), value = 'registerkey'},
	}
	  },
        function(data, menu) --Submit Cb

        if data.current.value == 'registerkey' then
					ESX.TriggerServerCallback('esx_vehiclelock:getVehiclesnokey', function(Vehicles2)
						local elements = {}

						if Vehicles2 == nil then
							table.insert(elements, {label = 'Aucun véhicule sans clés ', value = nil})
						else
							for i=1, #Vehicles2, 1 do
								model = Vehicles2[i].model
								modelname = GetDisplayNameFromVehicleModel(model)
								Vehicles2[i].model = GetLabelText(modelname)
							end

							for i=1, #Vehicles2, 1 do
								table.insert(elements, {label = Vehicles2[i].model .. ' [' .. Vehicles2[i].plate .. ']', value = Vehicles2[i].plate})					
							end

							ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'backey',
							{	css = 'Hollidays',
							title = 'Séléctionner vos clés',
							align = 'top-right',
							elements = elements
							},
							function(data2, menu2)
								menu2.close()	
								TriggerServerEvent('esx_vehiclelock:registerkey', data2.current.value, 'no')
							end,
							function(data2, menu2)
								menu2.close()
							end
							)
						end
					end)
			end
        end,   
        function(data, menu) --Cancel Cb
                menu.close()
        end,
        function(data, menu) --Change Cb
        end
      )
end

-- Key Controls
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir')
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlJustReleased(0, 38) then

        if CurrentAction == 'Serrurier' then
          OpenSerrurierMenu(CurrentActionData.zone)
        end

        CurrentAction = nil
      end

    end
  end
end)

--NB : gestion des menu
RegisterNetEvent('nwx:openKeysMenu')
AddEventHandler('nwx:openKeysMenu', function()
TriggerEvent('esx_menu:key')
  	openKeysMenu()
end)

local blacklistedModels = {
	"example_model",
}

local turnEngineOn = false

-- [[ THREAD ]] --
	-- Todo: Make sure the vehicle is not a boat, bike, plane, heli or blacklisted

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)

		
		local ped = GetPlayerPed(-1)
		local veh = GetVehiclePedIsIn(ped)
		if DoesEntityExist(veh) then
			-- disableAirControl(ped, veh)
			disableVehicleRoll(ped, veh)
		end


	end
end)


-- [[ FUNCTIONS ]] --
function resetVehicle(veh)
	FreezeEntityPosition(veh,false)
	SetVehicleOnGroundProperly(veh)
	SetVehicleEngineOn(veh,turnEngineOn)
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if DoesEntityExist(veh) and not IsEntityDead(veh) then
            local model = GetEntityModel(veh)
            -- If it's not a boat, plane or helicopter, and the vehilce is off the ground with ALL wheels, then block steering/leaning left/right/up/down.
            if not IsThisModelABoat(model) and not IsThisModelAHeli(model) and not IsThisModelAPlane(model) and not IsThisModelABike(model) and not IsThisModelABicycle(model) and IsEntityInAir(veh) then
                DisableControlAction(0, 59) -- leaning left/right
                DisableControlAction(0, 60) -- leaning up/down
            end
        end
    end
end)

function disableVehicleRoll(ped, veh)
	local roll = GetEntityRoll(veh)

	if not IsThisModelBlacklisted(veh) then
		if GetPedInVehicleSeat(veh, -1) == ped then
			if (roll > 75.0 or roll < -75.0) then
				DisableControlAction(2,59,true)
				DisableControlAction(2,60,true)
				if not IsEntityInAir(veh) and GetEntitySpeed(veh) < 0.15 then
					destroyPedsVehicle(ped)
				end
			end
		end
	end
end

function IsThisModelBlacklisted(veh)
	local model = GetEntityModel(veh)

	for i = 1, #blacklistedModels do
		if model == GetHashKey(blacklistedModels[i]) then
			return true
		end
	end
	return false
end

function destroyPedsVehicle(ped)
	local veh = GetVehiclePedIsIn(ped)
	--FreezeEntityPosition(veh,true)
	SetVehicleEngineOn(veh, false)
end