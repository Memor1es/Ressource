ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

-- Blips
Citizen.CreateThread(function()
	
	for i=1, #Config.Map, 1 do
		local blipMap = AddBlipForCoord(Config.Map[i].x, Config.Map[i].y, Config.Map[i].z)
		SetBlipSprite(blipMap, Config.Map[i].id)
		SetBlipDisplay(blipMap, 4)
		SetBlipScale(blipMap, 0.7)
		SetBlipColour(blipMap, Config.Map[i].color)
		SetBlipAsShortRange(blipMap, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Map[i].name)
		EndTextCommandSetBlipName(blipMap)
	end

end)

-- esx_accessories
local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

function OpenAccessoryMenu()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'set_unset_accessory',
	{
		css 	= 'Hollidays',
		title = 'Mettre / Enlever',
		align = 'top-left',
		elements = {
			{label = 'Casque / Chapeau', value = 'Helmet'},
			{label = 'Accessoires d\'oreilles', value = 'Ears'},
			{label = 'Masque', value = 'Mask'},
			{label = 'Lunettes', value = 'Glasses'}
		}
	}, function(data, menu)
		menu.close()
		SetUnsetAccessory(data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

function SetUnsetAccessory(accessory)
	ESX.TriggerServerCallback('esx_accessories:get', function(hasAccessory, accessorySkin)
		local _accessory = string.lower(accessory)

		if hasAccessory then
			TriggerEvent('skinchanger:getSkin', function(skin)
				local mAccessory = -1
				local mColor = 0

				if _accessory == "mask" then
					mAccessory = 0
				end

				if skin[_accessory .. '_1'] == mAccessory then
					mAccessory = accessorySkin[_accessory .. '_1']
					mColor = accessorySkin[_accessory .. '_2']
				end

				local accessorySkin = {}
				accessorySkin[_accessory .. '_1'] = mAccessory
				accessorySkin[_accessory .. '_2'] = mColor
				TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
			end)
		else
			ESX.ShowNotification(_U('no_' .. _accessory))
		end

	end, accessory)
end

function OpenShopAccessoriesMenu(accessory)
	local _accessory = string.lower(accessory)
	local restrict = {}

	restrict = { _accessory .. '_1', _accessory .. '_2' }
	
	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)

		menu.close()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm',
		{
			css 	= 'Hollidays',
			title = 'Valider cet achat ?',
			align = 'top-left',
			elements = {
				{label = 'Non', value = 'no'},
				{label = _U('yes', ESX.Math.GroupDigits(Config.Price)), value = 'yes'}
			}
		}, function(data, menu)
			menu.close()
			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('esx_accessories:checkMoney', function(hasEnoughMoney)
					if hasEnoughMoney then
						TriggerServerEvent('esx_accessories:pay')
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_accessories:save', skin, accessory)
						end)
					else
						TriggerEvent('esx_skin:getLastSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
						end)
						ESX.ShowNotification('Vous n\'avez pas assez d\'argent.')
					end
				end)
			end

			if data.current.value == 'no' then
				local player = PlayerPedId()
				TriggerEvent('esx_skin:getLastSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
				if accessory == "Ears" then
					ClearPedProp(player, 2)
				elseif accessory == "Mask" then
					SetPedComponentVariation(player, 1, 0 ,0, 2)
				elseif accessory == "Helmet" then
					ClearPedProp(player, 0)
				elseif accessory == "Glasses" then
					SetPedPropIndex(player, 1, -1, 0, 0)
				end
			end
			CurrentAction = 'shop_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
			CurrentActionData = {}
		end, function(data, menu)
			menu.close()
			CurrentAction = 'shop_menu'
			CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
			CurrentActionData = {}

		end)
	end, function(data, menu)
		menu.close()
		CurrentAction = 'shop_menu'
		CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
		CurrentActionData = {}
	end, restrict)
end

AddEventHandler('esx_accessories:hasEnteredMarker', function(zone)
	CurrentAction = 'shop_menu'
	CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu'
	CurrentActionData = { accessory = zone }
end)

AddEventHandler('esx_accessories:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Create Blips --
Citizen.CreateThread(function()
	for k,v in pairs(Config.ShopsBlipsAcessories) do
		if v.Pos ~= nil then
			for i=1, #v.Pos, 1 do
				local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)

				SetBlipSprite(blip, v.Blip.sprite)
				SetBlipDisplay(blip, 4)
				SetBlipScale(blip, 0.7)
				SetBlipColour(blip, v.Blip.color)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('Magasin de masques')
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		for k,v in pairs(Config.ZonesAccessories) do
			for i = 1, #v.Pos, 1 do
				if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.DrawDistance) then
					DrawMarker(Config.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)

		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker = false
		local currentZone = nil
		for k,v in pairs(Config.ZonesAccessories) do
			for i = 1, #v.Pos, 1 do
				if GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < 1.5 then
					isInMarker  = true
					currentZone = k
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_accessories:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_accessories:hasExitedMarker', LastZone)
		end

	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and CurrentActionData.accessory then
				OpenShopAccessoriesMenu(CurrentActionData.accessory)
				CurrentAction = nil
			end
		elseif CurrentAction == nil then
			Citizen.Wait(500)
		end

	end
end)

-- Pole Emploi
local menuIsShowed, isInJoblistingMarker = false, false

function ShowJobListingMenu(data)
	ESX.TriggerServerCallback('esx_joblisting:getJobsList', function(data)
		local elements = {}
		for i = 1, #data, 1 do
			table.insert(
				elements,
				{label = data[i].label, value = data[i].value}
			)
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'joblisting',
			{
				css 	= 'Hollidays',
				title = 'Pôle-Emploi',
				elements = elements
			},
			function(data, menu)
				TriggerServerEvent('esx_joblisting:setJob', data.current.value)
				ESX.ShowNotification('Félicitation ! Vous avez un nouveau job !')
				menu.close()
			end,
			function(data, menu)
				menu.close()
			end
		)

	end)
end

AddEventHandler('esx_joblisting:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for i=1, #Config.ZonesPE, 1 do
			if(GetDistanceBetweenCoords(coords, Config.ZonesPE[i].x, Config.ZonesPE[i].y, Config.ZonesPE[i].z, true) < Config.DrawDistance) then
				DrawMarker(23, Config.ZonesPE[i].x, Config.ZonesPE[i].y, Config.ZonesPE[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		isInJoblistingMarker  = false
		local currentZone = nil
		for i=1, #Config.ZonesPE, 1 do
			if(GetDistanceBetweenCoords(coords, Config.ZonesPE[i].x, Config.ZonesPE[i].y, Config.ZonesPE[i].z, true) < 1.5) then
				isInJoblistingMarker  = true
				SetTextComponentFormat('STRING')
            	AddTextComponentString('Appuyez sur ~INPUT_PICKUP~ pour \naccéder au ~b~Pôle Emploi~s~.')
            	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			end
		end
		if isInJoblistingMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
		end
		if not isInJoblistingMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_joblisting:hasExitedMarker')
		end
	end
end)

-- Menu Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, 38) and isInJoblistingMarker and not menuIsShowed then
			ShowJobListingMenu()
		end
	end
end)