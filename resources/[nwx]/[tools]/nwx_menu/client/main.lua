f_menuPool = nil
local personalmenu = {}

local invItem, wepItem, billItem, mainMenu, itemMenu, weaponItemMenu = {}, {}, {}, nil, nil, nil

local isDead, inAnim = false, false

local playerGroup, noclip, godmode, visible = nil, false, false, false

local actualGPS, actualGPSIndex = _U('default_gps'), 1
local actualDemarche, actualDemarcheIndex = _U('default_demarche'), 1

local societymoney, societymoney2 = nil, nil

local wepList = nil

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	while ESX.GetPlayerData().faction == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	while playerGroup == nil do
		ESX.TriggerServerCallback('KorioZ-PersonalMenu:Admin_getUsergroup', function(group) playerGroup = group end)
		Citizen.Wait(10)
	end

	while actualSkin == nil do
		TriggerEvent('skinchanger:getSkin', function(skin) actualSkin = skin end)
		Citizen.Wait(10)
	end

	RefreshMoney()

    RefreshMoney2()

	wepList = ESX.GetWeaponList()

	_menuPool = NativeUI.CreatePool()

	mainMenu = NativeUI.CreateMenu(Config.servername, _U('mainmenu_subtitle'))
	itemMenu = NativeUI.CreateMenu(Config.servername, _U('inventory_actions_subtitle'))
	weaponItemMenu = NativeUI.CreateMenu(Config.servername, _U('loadout_actions_subtitle'))
	_menuPool:Add(mainMenu)
	_menuPool:Add(itemMenu)
	_menuPool:Add(weaponItemMenu)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
	_menuPool:CloseAllMenus()
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('playerSpawned', function()
	isDead = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	RefreshMoney()
end)

RegisterNetEvent('esx:setFaction')
AddEventHandler('esx:setFaction', function(faction)
	ESX.PlayerData.faction = faction
	RefreshMoney2()
end)

function RefreshMoney()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			UpdateSocietyMoney(money)
		end, ESX.PlayerData.job.name)
	end

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'capitaine' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			UpdateSocietyMoney(money)
		end, ESX.PlayerData.job.name)
	end
end

function RefreshMoney2()
	if ESX.PlayerData.faction ~= nil and ESX.PlayerData.faction.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_societyfaction:getSocietyMoneyFaction', function(money)
			UpdateSociety2Money(money)
		end, ESX.PlayerData.faction.name)
	end
end

RegisterNetEvent('esx_addonaccount:setMoney')
AddEventHandler('esx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then
		UpdateSocietyMoney(money)
	end
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'capitaine' and 'society_' .. ESX.PlayerData.job.name == society then
		UpdateSocietyMoney(money)
	end
	if ESX.PlayerData.faction ~= nil and ESX.PlayerData.faction.grade_name == 'boss' and 'society_' .. ESX.PlayerData.faction.name == society then
		UpdateSociety2Money(money)
	end
end)

function UpdateSocietyMoney(money)
	societymoney = ESX.Math.GroupDigits(money)
end

function UpdateSociety2Money(money)
	societymoney2 = ESX.Math.GroupDigits(money)
end

--Message text joueur
function Text(text)
	SetTextColour(255, 255, 255, 255)
	SetTextFont(0)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.017, 0.977)
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
	blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(10)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
		blockinput = false
        return result
    else
        Citizen.Wait(500)
		blockinput = false
        return nil
    end
end

-- Weapon Menu --

RegisterNetEvent("KorioZ-PersonalMenu:Weapon_addAmmoToPedC")
AddEventHandler("KorioZ-PersonalMenu:Weapon_addAmmoToPedC", function(value, quantity)
	local weaponHash = GetHashKey(value)

	if HasPedGotWeapon(plyPed, weaponHash, false) and value ~= 'WEAPON_UNARMED' then
		AddAmmoToPed(plyPed, value, quantity)
	end
end)

-- Admin Menu --

RegisterNetEvent('KorioZ-PersonalMenu:Admin_BringC')
AddEventHandler('KorioZ-PersonalMenu:Admin_BringC', function(plyPedCoords)
	SetEntityCoords(plyPed, plyPedCoords)
end)

-- GOTO JOUEUR
function admin_tp_toplayer()
	local plyId = KeyboardInput("KORIOZ_BOX_ID", _U('dialogbox_playerid'), "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			local targetPlyCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(plyId)))
			SetEntityCoords(plyPed, targetPlyCoords)
		end
	end
end
-- FIN GOTO JOUEUR

-- TP UN JOUEUR A MOI
function admin_tp_playertome()
	local plyId = KeyboardInput("KORIOZ_BOX_ID", _U('dialogbox_playerid'), "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			local plyPedCoords = GetEntityCoords(plyPed)
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_BringS', plyId, plyPedCoords)
		end
	end
end
-- FIN TP UN JOUEUR A MOI

-- TP A POSITION
function admin_tp_pos()
	local pos = KeyboardInput("KORIOZ_BOX_XYZ", _U('dialogbox_xyz'), "", 50)

	local _, _, x, y, z = string.find(pos, "([%d%.]+) ([%d%.]+) ([%d%.]+)")
			
	if x ~= nil and y ~= nil and z ~= nil then
		SetEntityCoords(plyPed, x + .0, y + .0, z + .0)
	end
end
-- FIN TP A POSITION

-- FONCTION NOCLIP 
function admin_no_clip()
	noclip = not noclip

	if noclip then
		SetEntityInvincible(plyPed, true)
		SetEntityVisible(plyPed, false, false)
		ESX.ShowNotification(_U('admin_noclipon'))
	else
		SetEntityInvincible(plyPed, false)
		SetEntityVisible(plyPed, true, false)
		ESX.ShowNotification(_U('admin_noclipoff'))
	end
end

function getPosition()
	local x, y, z = table.unpack(GetEntityCoords(plyPed, true))

	return x, y, z
end

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(plyPed)
	local pitch = GetGameplayCamRelativePitch()

	local x = -math.sin(heading * math.pi/180.0)
	local y = math.cos(heading * math.pi/180.0)
	local z = math.sin(pitch * math.pi/180.0)

	local len = math.sqrt(x * x + y * y + z * z)

	if len ~= 0 then
		x = x/len
		y = y/len
		z = z/len
	end

	return x, y, z
end

function isNoclip()
	return noclip
end
-- FIN NOCLIP

-- GOD MODE
function admin_godmode()
	godmode = not godmode

	if godmode then
		SetEntityInvincible(plyPed, true)
		ESX.ShowNotification(_U('admin_godmodeon'))
	else
		SetEntityInvincible(plyPed, false)
		ESX.ShowNotification(_U('admin_godmodeoff'))
	end
end
-- FIN GOD MODE

-- INVISIBLE
function admin_mode_fantome()
	invisible = not invisible

	if invisible then
		SetEntityVisible(plyPed, false, false)
		ESX.ShowNotification(_U('admin_ghoston'))
	else
		SetEntityVisible(plyPed, true, false)
		ESX.ShowNotification(_U('admin_ghostoff'))
	end
end
-- FIN INVISIBLE

-- Réparer vehicule
function admin_vehicle_repair()
	local car = GetVehiclePedIsIn(plyPed, false)

	SetVehicleFixed(car)
	SetVehicleDirtLevel(car, 0.0)
end
-- FIN Réparer vehicule

-- Spawn vehicule
function admin_vehicle_spawn()
	local vehicleName = KeyboardInput("KORIOZ_BOX_VEHICLE_NAME", _U('dialogbox_vehiclespawner'), "", 50)

	if vehicleName ~= nil then
		vehicleName = tostring(vehicleName)
		
		if type(vehicleName) == 'string' then
			local car = GetHashKey(vehicleName)
				
			Citizen.CreateThread(function()
				RequestModel(car)

				while not HasModelLoaded(car) do
					Citizen.Wait(50)
				end

				local x, y, z = table.unpack(GetEntityCoords(plyPed, true))

				local veh = CreateVehicle(car, x, y, z, 0.0, true, false)
				local id = NetworkGetNetworkIdFromEntity(veh)

				SetEntityVelocity(veh, 2000)
				SetVehicleOnGroundProperly(veh)
				SetVehicleHasBeenOwnedByPlayer(veh, true)
				SetNetworkIdCanMigrate(id, true)
				SetVehRadioStation(veh, "OFF")
				SetPedIntoVehicle(plyPed, veh, -1)
			end)
		end
	end
end
-- FIN Spawn vehicule

-- flipVehicle
function admin_vehicle_flip()
	local plyCoords = GetEntityCoords(plyPed)
	local closestCar = GetClosestVehicle(plyCoords['x'], plyCoords['y'], plyCoords['z'], 10.0, 0, 70)
	local plyCoords = plyCoords + vector3(0, 2, 0)

	SetEntityCoords(closestCar, plyCoords)

	ESX.ShowNotification(_U('admin_vehicleflip'))
end
-- FIN flipVehicle

-- GIVE DE L'ARGENT
function admin_give_money()
	local amount = KeyboardInput("KORIOZ_BOX_AMOUNT", _U('dialogbox_amount'), "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveCash', amount)
		end
	end
end
-- FIN GIVE DE L'ARGENT

-- GIVE DE L'ARGENT EN BANQUE
function admin_give_bank()
	local amount = KeyboardInput("KORIOZ_BOX_AMOUNT", _U('dialogbox_amount'), "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveBank', amount)
		end
	end
end
-- FIN GIVE DE L'ARGENT EN BANQUE

-- GIVE DE L'ARGENT SALE
function admin_give_dirty()
	local amount = KeyboardInput("KORIOZ_BOX_AMOUNT", _U('dialogbox_amount'), "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveDirtyMoney', amount)
		end
	end
end
-- FIN GIVE DE L'ARGENT SALE

-- Afficher Coord
function modo_showcoord()
	showcoord = not showcoord
end
-- FIN Afficher Coord

-- Afficher Nom
function modo_showname()
	showname = not showname
end
-- FIN Afficher Nom

-- TP MARKER
function admin_tp_marker()
	local WaypointHandle = GetFirstBlipInfoId(8)

	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

				break
			end

			Citizen.Wait(50)
		end

		ESX.ShowNotification(_U('admin_tpmarker'))
	else
		ESX.ShowNotification(_U('admin_nomarker'))
	end
end
-- FIN TP MARKER

-- HEAL JOUEUR
function admin_heal_player()
	local plyId = KeyboardInput("KORIOZ_BOX_ID", _U('dialogbox_playerid'), "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			TriggerServerEvent('esx_ambulancejob:revive', plyId)
		end
	end
end
-- FIN HEAL JOUEUR

function changer_skin()
	_menuPool:CloseAllMenus()
	Citizen.Wait(100)
	TriggerEvent('esx_skin:openSaveableMenu', source)
end

function save_skin()
	TriggerEvent('esx_skin:requestSaveSkin', source)
end

function startAttitude(lib, anim)
	Citizen.CreateThread(function()
		RequestAnimSet(anim)

		while not HasAnimSetLoaded(anim) do
			Citizen.Wait(50)
		end

		SetPedMotionBlur(plyPed, false)
		SetPedMovementClipset(plyPed, anim, true)
	end)
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(plyPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
end

function startAnimAction(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(plyPed, lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
	end)
end

function startScenario(anim)
	TaskStartScenarioInPlace(plyPed, anim, 0, false)
end

function AddMenuInventoryMenu(menu)
	inventorymenu = _menuPool:AddSubMenu(menu, _U('inventory_title'))
	local invCount = {}

	for i=1, #ESX.PlayerData.inventory, 1 do
		local count = ESX.PlayerData.inventory[i].count

		if count > 0 then
			local label = ESX.PlayerData.inventory[i].label
			local value = ESX.PlayerData.inventory[i].name

			invCount = {}

			for i = 1, count, 1 do
				table.insert(invCount, i)
			end
			
			table.insert(invItem, value)

			invItem[value] = NativeUI.CreateListItem(label .. " (" .. count .. ")", invCount, 1)
			inventorymenu.SubMenu:AddItem(invItem[value])
		end
	end

	local useItem = NativeUI.CreateItem(_U('inventory_use_button'), "")
	itemMenu:AddItem(useItem)

	local giveItem = NativeUI.CreateItem(_U('inventory_give_button'), "")
	itemMenu:AddItem(giveItem)

	local dropItem = NativeUI.CreateItem(_U('inventory_drop_button'), "")
	dropItem:SetRightBadge(4)
	itemMenu:AddItem(dropItem)

	inventorymenu.SubMenu.OnListSelect = function(sender, item, index)
		_menuPool:CloseAllMenus(true)
		itemMenu:Visible(true)

		for i = 1, #ESX.PlayerData.inventory, 1 do
			local label = ESX.PlayerData.inventory[i].label
			local count = ESX.PlayerData.inventory[i].count
			local value = ESX.PlayerData.inventory[i].name
			local usable = ESX.PlayerData.inventory[i].usable
			local canRemove = ESX.PlayerData.inventory[i].canRemove
			local quantity = index

			if item == invItem[value] then
				itemMenu.OnItemSelect = function(sender, item, index)
					if item == useItem then
						if usable then
							TriggerServerEvent('esx:useItem', value)
						else
							ESX.ShowNotification(_U('not_usable', label))
						end
					elseif item == giveItem then
						local foundPlayers = false
						personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

						if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3 then
			 				foundPlayers = true
						end

						if foundPlayers == true then
							local closestPed = GetPlayerPed(personalmenu.closestPlayer)

							if not IsPedSittingInAnyVehicle(closestPed) then
								if quantity ~= nil and count > 0 then
									TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(personalmenu.closestPlayer), 'item_standard', value, quantity)
									_menuPool:CloseAllMenus()
								else
									ESX.ShowNotification(_U('amount_invalid'))
								end
							else
								ESX.ShowNotification(_U('in_vehicle_give'))
							end
						else
							ESX.ShowNotification(_U('players_nearby'))
						end
					elseif item == dropItem then
						if canRemove then
							if not IsPedSittingInAnyVehicle(plyPed) then
								if quantity ~= nil then
									TriggerServerEvent('esx:removeInventoryItem', 'item_standard', value, quantity)
									_menuPool:CloseAllMenus()
								else
									ESX.ShowNotification(_U('amount_invalid'))
								end
							else
								ESX.ShowNotification(_U('in_vehicle_drop', label))
							end
						else
							ESX.ShowNotification(_U('not_droppable', label))
						end
					end
				end
			end
		end
	end
end

function AddMenuWeaponMenu(menu)
	weaponMenu = _menuPool:AddSubMenu(menu, _U('loadout_title'))

	for i = 1, #wepList, 1 do
		local weaponHash = GetHashKey(wepList[i].name)

		if HasPedGotWeapon(plyPed, weaponHash, false) and wepList[i].name ~= 'WEAPON_UNARMED' then
			local ammo = GetAmmoInPedWeapon(plyPed, weaponHash)
			local label = wepList[i].label .. ' [' .. ammo .. ']'
			local value = wepList[i].name

			wepItem[value] = NativeUI.CreateItem(label, "")
			weaponMenu.SubMenu:AddItem(wepItem[value])
		end
	end

	local giveItem = NativeUI.CreateItem(_U('loadout_give_button'), "")
	weaponItemMenu:AddItem(giveItem)

	local giveMunItem = NativeUI.CreateItem(_U('loadout_givemun_button'), "")
	weaponItemMenu:AddItem(giveMunItem)

	local dropItem = NativeUI.CreateItem(_U('loadout_drop_button'), "")
	dropItem:SetRightBadge(4)
	weaponItemMenu:AddItem(dropItem)

	weaponMenu.SubMenu.OnItemSelect = function(sender, item, index)
		_menuPool:CloseAllMenus(true)
		weaponItemMenu:Visible(true)

		for i = 1, #wepList, 1 do
			local weaponHash = GetHashKey(wepList[i].name)

			if HasPedGotWeapon(plyPed, weaponHash, false) and wepList[i].name ~= 'WEAPON_UNARMED' then
				local ammo = GetAmmoInPedWeapon(plyPed, weaponHash)
				local value = wepList[i].name
				local label = wepList[i].label

				if item == wepItem[value] then
					weaponItemMenu.OnItemSelect = function(sender, item, index)
						if item == giveItem then
							local foundPlayers = false
							personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

							if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3 then
				 				foundPlayers = true
							end

							if foundPlayers == true then
								local closestPed = GetPlayerPed(personalmenu.closestPlayer)

								if not IsPedSittingInAnyVehicle(closestPed) then
									TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(personalmenu.closestPlayer), 'item_weapon', value, ammo)
									_menuPool:CloseAllMenus()
								else
									ESX.ShowNotification(_U('in_vehicle_give'))
								end
							else
								ESX.ShowNotification(_U('players_nearby'))
							end
						elseif item == giveMunItem then
							local quantity = KeyboardInput("KORIOZ_BOX_AMMO_AMOUNT", _U('dialogbox_amount_ammo'), "", 8)

							if quantity ~= nil then
								local post = true
								quantity = tonumber(quantity)

								if type(quantity) == 'number' then
									quantity = ESX.Math.Round(quantity)

									if quantity <= 0 then
										post = false
									end
								end

								local foundPlayers = false
								personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

								if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3 then
				 					foundPlayers = true
								end

								if foundPlayers == true then
									local closestPed = GetPlayerPed(personalmenu.closestPlayer)

									if not IsPedSittingInAnyVehicle(closestPed) then
										if ammo > 0 then
											if post == true then
												if quantity <= ammo and quantity >= 0 then
													local finalAmmo = math.floor(ammo - quantity)
													SetPedAmmo(plyPed, value, finalAmmo)
													TriggerServerEvent('KorioZ-PersonalMenu:Weapon_addAmmoToPedS', GetPlayerServerId(personalmenu.closestPlayer), value, quantity)

													ESX.ShowNotification(_U('gave_ammo', quantity, GetPlayerName(personalmenu.closestPlayer)))
													_menuPool:CloseAllMenus()
												else
													ESX.ShowNotification(_U('not_enough_ammo'))
												end
											else
												ESX.ShowNotification(_U('amount_invalid'))
											end
										else
											ESX.ShowNotification(_U('no_ammo'))
										end
									else
										ESX.ShowNotification(_U('in_vehicle_give'))
									end
								else
									ESX.ShowNotification(_U('players_nearby'))
								end
							end
						elseif item == dropItem then
							if not IsPedSittingInAnyVehicle(plyPed) then
								TriggerServerEvent('esx:removeInventoryItem', 'item_weapon', value)
								TriggerEvent('skinchanger:modelLoaded')
								_menuPool:CloseAllMenus()
							else
								ESX.ShowNotification(_U('in_vehicle_drop', label))
							end
						end
					end
				end
			end
		end
	end
end

function AddMenuWalletMenu(menu)
	local moneyOption = {}
	
	moneyOption = {
		_U('wallet_option_give'),
		_U('wallet_option_drop')
	}

	walletmenu = _menuPool:AddSubMenu(menu, _U('wallet_title'))

	local walletJob = NativeUI.CreateItem(_U('wallet_job_button', ESX.PlayerData.job.label, ESX.PlayerData.job.grade_label), "")
	walletmenu.SubMenu:AddItem(walletJob)

	local walletFaction = NativeUI.CreateItem(_U('wallet_job2_button', ESX.PlayerData.faction.label, ESX.PlayerData.faction.grade_label), "")
	walletmenu.SubMenu:AddItem(walletFaction)

	local walletMoney = NativeUI.CreateListItem(_U('wallet_money_button', ESX.Math.GroupDigits(ESX.PlayerData.money)), moneyOption, 1)
	walletmenu.SubMenu:AddItem(walletMoney)

	local walletdirtyMoney = nil
	local showID = nil
	local showDriver = nil
	local showFirearms = nil
	local checkID = nil
	local checkDriver = nil
	local checkFirearms = nil

	for i = 1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == 'black_money' then
			walletdirtyMoney = NativeUI.CreateListItem(_U('wallet_blackmoney_button', ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money)), moneyOption, 1)
			walletmenu.SubMenu:AddItem(walletdirtyMoney)
		end
	end

	if Config.EnableJsfourIDCard then
		showID = NativeUI.CreateItem(_U('wallet_show_idcard_button'), "")
		walletmenu.SubMenu:AddItem(showID)

		checkID = NativeUI.CreateItem(_U('wallet_check_idcard_button'), "")
		walletmenu.SubMenu:AddItem(checkID)
       
        showDriver = NativeUI.CreateItem(_U('wallet_show_driver_button'), "")
        walletmenu.SubMenu:AddItem(showDriver)
       
        checkDriver = NativeUI.CreateItem(_U('wallet_check_driver_button'), "")
        walletmenu.SubMenu:AddItem(checkDriver)
           
        showFirearms = NativeUI.CreateItem(_U('wallet_show_firearms_button'), "")
        walletmenu.SubMenu:AddItem(showFirearms)
       
        checkFirearms = NativeUI.CreateItem(_U('wallet_check_firearms_button'), "")
        walletmenu.SubMenu:AddItem(checkFirearms)
	end

	walletmenu.SubMenu.OnItemSelect = function(sender, item, index)
		if Config.EnableJsfourIDCard then
			if item == showID then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()
											
				if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3.0 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(personalmenu.closestPlayer))
				else
					ESX.ShowNotification(_U('players_nearby'))
				end
			elseif item == checkID then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
			elseif item == showDriver then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()
											
				if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3.0 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(personalmenu.closestPlayer), 'driver')
				else
					ESX.ShowNotification(_U('players_nearby'))
				end
			elseif item == checkDriver then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
			elseif item == showFirearms then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()
											
				if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3.0 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(personalmenu.closestPlayer), 'weapon')
				else
					ESX.ShowNotification(_U('players_nearby'))
				end
			elseif item == checkFirearms then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
			end
		end
	end

	walletmenu.SubMenu.OnListSelect = function(sender, item, index)
		if item == walletMoney or item == walletdirtyMoney then
			if index == 1 then
				local quantity = KeyboardInput("KORIOZ_BOX_AMOUNT", _U('dialogbox_amount'), "", 8)

				if quantity ~= nil then
					local post = true
					quantity = tonumber(quantity)

					if type(quantity) == 'number' then
						quantity = ESX.Math.Round(quantity)

						if quantity <= 0 then
							post = false
						end
					end

					local foundPlayers = false
					personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

					if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3 then
						foundPlayers = true
					end

					if foundPlayers == true then
						local closestPed = GetPlayerPed(personalmenu.closestPlayer)

						if not IsPedSittingInAnyVehicle(closestPed) then
							if post == true then
								if item == walletMoney then
									TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(personalmenu.closestPlayer), 'item_money', 'money', quantity)
									_menuPool:CloseAllMenus()
								elseif item == walletdirtyMoney then
									TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(personalmenu.closestPlayer), 'item_account', 'black_money', quantity)
									_menuPool:CloseAllMenus()
								end
							else
								ESX.ShowNotification(_U('amount_invalid'))
							end
						else
							ESX.ShowNotification(_U('in_vehicle_give'))
						end
					else
						ESX.ShowNotification(_U('players_nearby'))
					end
				end
			elseif index == 2 then
				local quantity = KeyboardInput("KORIOZ_BOX_AMOUNT", _U('dialogbox_amount'), "", 8)

				if quantity ~= nil then
					local post = true
					quantity = tonumber(quantity)

					if type(quantity) == 'number' then
						quantity = ESX.Math.Round(quantity)

						if quantity <= 0 then
							post = false
						end
					end

					if not IsPedSittingInAnyVehicle(plyPed) then
						if post == true then
							if item == walletMoney then
								TriggerServerEvent('esx:removeInventoryItem', 'item_money', 'money', quantity)
								_menuPool:CloseAllMenus()
							elseif item == walletdirtyMoney then
								TriggerServerEvent('esx:removeInventoryItem', 'item_account', 'black_money', quantity)
								_menuPool:CloseAllMenus()
							end
						else
							ESX.ShowNotification(_U('amount_invalid'))
						end
					else
						if item == walletMoney then
							ESX.ShowNotification(_U('in_vehicle_drop', 'de l\'argent'))
						elseif item == walletdirtyMoney then
							ESX.ShowNotification(_U('in_vehicle_drop', 'de l\'argent sale'))
						end
					end
				end
			end
		end
	end
end

function AddMenuFacturesMenu(menu)
	billMenu = _menuPool:AddSubMenu(menu, _U('bills_title'))
	billItem = {}

	ESX.TriggerServerCallback('KorioZ-PersonalMenu:Bill_getBills', function(bills)
		for i = 1, #bills, 1 do
			local label = bills[i].label
			local amount = bills[i].amount
			local value = bills[i].id

			table.insert(billItem, value)

			billItem[value] = NativeUI.CreateItem(label, "")
			billItem[value]:RightLabel("$" .. ESX.Math.GroupDigits(amount))
			billMenu.SubMenu:AddItem(billItem[value])
		end

		billMenu.SubMenu.OnItemSelect = function(sender, item, index)
			for i = 1, #bills, 1 do
				local label  = bills[i].label
				local value = bills[i].id

				if item == billItem[value] then
					ESX.TriggerServerCallback('esx_billing:payBill', function()
						_menuPool:CloseAllMenus()
					end, value)
				end
			end
		end
	end)
end

function AddMenuClothesMenu(menu)
	clothesMenu = _menuPool:AddSubMenu(menu, _U('clothes_title'))

	local torsoItem = NativeUI.CreateItem(_U('clothes_top'), "")
	clothesMenu.SubMenu:AddItem(torsoItem)
	local pantsItem = NativeUI.CreateItem(_U('clothes_pants'), "")
	clothesMenu.SubMenu:AddItem(pantsItem)
	local shoesItem = NativeUI.CreateItem(_U('clothes_shoes'), "")
	clothesMenu.SubMenu:AddItem(shoesItem)
	local bagItem = NativeUI.CreateItem(_U('clothes_bag'), "")
	clothesMenu.SubMenu:AddItem(bagItem)
	local bproofItem = NativeUI.CreateItem(_U('clothes_bproof'), "")
	clothesMenu.SubMenu:AddItem(bproofItem)

	clothesMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == torsoItem then
			setUniform('torso', plyPed)
		elseif item == pantsItem then
			setUniform('pants', plyPed)
		elseif item == shoesItem then
			setUniform('shoes', plyPed)
		elseif item == bagItem then
			setUniform('bag', plyPed)
		elseif item == bproofItem then
			setUniform('bproof', plyPed)
		end
	end
end

function setUniform(value, plyPed)
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:getSkin', function(skina)
			if value == 'torso' then
				startAnimAction("clothingtie", "try_tie_neutral_a")
				Citizen.Wait(1000)
				ClearPedTasks(plyPed)

				if skin.torso_1 ~= skina.torso_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2, ['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2, ['arms'] = skin.arms})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
				end
			elseif value == 'pants' then
				if skin.pants_1 ~= skina.pants_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = skin.pants_1, ['pants_2'] = skin.pants_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 61, ['pants_2'] = 1})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 15, ['pants_2'] = 0})
					end
				end
			elseif value == 'shoes' then
				if skin.shoes_1 ~= skina.shoes_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 34, ['shoes_2'] = 0})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 35, ['shoes_2'] = 0})
					end
				end
			elseif value == 'bag' then
				if skin.bags_1 ~= skina.bags_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = skin.bags_1, ['bags_2'] = skin.bags_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = 0, ['bags_2'] = 0})
				end
			elseif value == 'bproof' then
				startAnimAction("clothingtie", "try_tie_neutral_a")
				Citizen.Wait(1000)
				ClearPedTasks(plyPed)

				if skin.bproof_1 ~= skina.bproof_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = skin.bproof_1, ['bproof_2'] = skin.bproof_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = 0, ['bproof_2'] = 0})
				end
			end
		end)
	end)
end

function AddMenuAccessoryMenu(menu)
	accessoryMenu = _menuPool:AddSubMenu(menu, _U('accessories_title'))

	local earsItem = NativeUI.CreateItem(_U('accessories_ears'), "")
	accessoryMenu.SubMenu:AddItem(earsItem)
	local glassesItem = NativeUI.CreateItem(_U('accessories_glasses'), "")
	accessoryMenu.SubMenu:AddItem(glassesItem)
	local helmetItem = NativeUI.CreateItem(_U('accessories_helmet'), "")
	accessoryMenu.SubMenu:AddItem(helmetItem)
	local maskItem = NativeUI.CreateItem(_U('accessories_mask'), "")
	accessoryMenu.SubMenu:AddItem(maskItem)

	accessoryMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == earsItem then
			SetUnsetAccessory('Ears')
		elseif item == glassesItem then
			SetUnsetAccessory('Glasses')
		elseif item == helmetItem then
			SetUnsetAccessory('Helmet')
		elseif item == maskItem then
			SetUnsetAccessory('Mask')
		end
	end
end

function SetUnsetAccessory(accessory)
	ESX.TriggerServerCallback('esx_accessories:get', function(hasAccessory, accessorySkin)
		local _accessory = string.lower(accessory)

		if hasAccessory then
			TriggerEvent('skinchanger:getSkin', function(skin)
				local mAccessory = -1
				local mColor = 0

				if _accessory == 'ears' then
				elseif _accessory == "glasses" then
					mAccessory = 0
					startAnimAction("clothingspecs", "try_glasses_positive_a")
					Citizen.Wait(1000)
					ClearPedTasks(plyPed)
				elseif _accessory == 'helmet' then
					startAnimAction("missfbi4", "takeoff_mask")
					Citizen.Wait(1000)
					ClearPedTasks(plyPed)
				elseif _accessory == "mask" then
					mAccessory = 0
					startAnimAction("missfbi4", "takeoff_mask")
					Citizen.Wait(850)
					ClearPedTasks(plyPed)
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
			if _accessory == 'ears' then
				ESX.ShowNotification(_U('accessories_no_ears'))
			elseif _accessory == 'glasses' then
				ESX.ShowNotification(_U('accessories_no_glasses'))
			elseif _accessory == 'helmet' then
				ESX.ShowNotification(_U('accessories_no_helmet'))
			elseif _accessory == 'mask' then
				ESX.ShowNotification(_U('accessories_no_mask'))
			end
		end

	end, accessory)
end

function startAttitudes(lib, anim)
	Citizen.CreateThread(function()
	
		local playerPed = GetPlayerPed(-1)
		RequestAnimSet(anim)
		
		while not HasAnimSetLoaded(anim) do
			Citizen.Wait(1)
		end
		SetPedMovementClipset(playerPed, anim, true)
	end)
end

function startAnims(lib, anim, flag)
	Citizen.CreateThread(function()
		RequestAnimDict(lib)
		while not HasAnimDictLoaded( lib) do
			Citizen.Wait(1)
		end

		local lFlag = 0

		if flag ~= nil then
			lFlag = flag
		end

		TaskPlayAnim(GetPlayerPed(-1), lib ,anim ,8.0, -8.0, -1, lFlag, 0, false, false, false )
	end)
end

function startScenarios(anim, flag)
    local lFlag = false

	if flag ~= nil then
		lFlag = true
	end

	TaskStartScenarioInPlace(GetPlayerPed(-1), anim, 0, lFlag)
end


function AddMenuAnimationMenu(menu)
	animMenu = _menuPool:AddSubMenu(menu, _U('animation_title'))

	AddSubMenuPositionsMenu(animMenu)
	AddSubMenuFestivesMenu(animMenu)
	AddSubMenuDansesMenu(animMenu)
	AddSubMenuSalutationsMenu(animMenu)
	AddSubMenuTravailMenu(animMenu)
	AddSubMenuHumeursMenu(animMenu)
	AddSubMenuSportsMenu(animMenu)
	AddSubMenuPEGI21Menu(animMenu)
end

function AddSubMenuPositionsMenu(menu)
	animPositionsMenu = _menuPool:AddSubMenu(menu.SubMenu, "Positions")

	local suspectItem = NativeUI.CreateItem("Se rendre", "")
	animPositionsMenu.SubMenu:AddItem(suspectItem)
	local suspect2Item = NativeUI.CreateItem("Position de Fouille", "")
	animPositionsMenu.SubMenu:AddItem(suspect2Item)
	local asseoirItem = NativeUI.CreateItem("S'asseoir", "")
	animPositionsMenu.SubMenu:AddItem(asseoirItem)
	local asseoir2Item = NativeUI.CreateItem("S'asseoir (Par terre)", "")
	animPositionsMenu.SubMenu:AddItem(asseoir2Item)
	local attmurItem = NativeUI.CreateItem("Attendre contre un mur", "")
	animPositionsMenu.SubMenu:AddItem(attmurItem)
	local attposeItem = NativeUI.CreateItem("Attente posé", "")
	animPositionsMenu.SubMenu:AddItem(attposeItem)
	local couchedosItem = NativeUI.CreateItem("Couché sur le dos", "")
	animPositionsMenu.SubMenu:AddItem(couchedosItem)
	local coucheventreItem = NativeUI.CreateItem("Couché sur le ventre", "")
	animPositionsMenu.SubMenu:AddItem(coucheventreItem)
	local posgardeItem = NativeUI.CreateItem("Garde", "")
	animPositionsMenu.SubMenu:AddItem(posgardeItem)
	local posplsItem = NativeUI.CreateItem("PLS", "")
	animPositionsMenu.SubMenu:AddItem(posplsItem)
	local posblesseItem = NativeUI.CreateItem("Bléssé Assis", "")
	animPositionsMenu.SubMenu:AddItem(posblesseItem)
	local posbouleItem = NativeUI.CreateItem("Assis en boule", "")
	animPositionsMenu.SubMenu:AddItem(posbouleItem)
	local posdeceeItem = NativeUI.CreateItem("Décée", "")
	animPositionsMenu.SubMenu:AddItem(posdeceeItem)

	animPositionsMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == suspectItem then
			startAnims("random@arrests@busted", "idle_c", 9)
		elseif item == suspect2Item then
			startAnims("mini@prostitutes@sexlow_veh", "low_car_bj_to_prop_female", 9)
		elseif item == asseoirItem then
			startAnims("anim@heists@prison_heistunfinished_biztarget_idle", "target_idle", 9)
		elseif item == asseoir2Item then
			startScenarios("WORLD_HUMAN_PICNIC", 9)
		elseif item == attmurItem then
			startScenarios("world_human_leaning", 9)
		elseif item == attposeItem then
			startAnims("anim@heists@heist_corona@single_team", "single_team_loop_boss", 9)
		elseif item == couchedosItem then
			startScenarios("WORLD_HUMAN_SUNBATHE_BACK", 9)
		elseif item == coucheventreItem then
			startScenarios("WORLD_HUMAN_SUNBATHE", 9)
		elseif item == posgardeItem then
			startAnims("amb@world_human_stand_guard@male@enter", "enter", 9)
		elseif item == posplsItem then
			startAnims("amb@world_human_bum_slumped@male@laying_on_right_side@base", "base", 9)
		elseif item == posblesseItem then
			startAnims("amb@world_human_stupor@male@base", "base", 9)
		elseif item == posbouleItem then
			startAnims("anim@heists@fleeca_bank@ig_7_jetski_owner", "owner_idle", 9)
		elseif item == posdeceeItem then
			startAnims("mini@cpr@char_b@cpr_str", "cpr_fail", 9)
		end
	end
end

function AddSubMenuFestivesMenu(menu)
	animFeteMenu = _menuPool:AddSubMenu(menu.SubMenu, "Festives")

	local cigaretteItem = NativeUI.CreateItem("Fumer une cigarette", "")
	animFeteMenu.SubMenu:AddItem(cigaretteItem)
	local musiqueItem = NativeUI.CreateItem("Jouer de la musique", "")
	animFeteMenu.SubMenu:AddItem(musiqueItem)
	local DJItem = NativeUI.CreateItem("DJ", "")
	animFeteMenu.SubMenu:AddItem(DJItem)
	local zikItem = NativeUI.CreateItem("Bière en zik", "")
	animFeteMenu.SubMenu:AddItem(zikItem)
	local guitarItem = NativeUI.CreateItem("Air Guitar", "")
	animFeteMenu.SubMenu:AddItem(guitarItem)
	local shaggingItem = NativeUI.CreateItem("Air Shagging", "")
	animFeteMenu.SubMenu:AddItem(shaggingItem)
	local rockItem = NativeUI.CreateItem("Rock'n'roll", "")
	animFeteMenu.SubMenu:AddItem(rockItem)
	local bourreItem = NativeUI.CreateItem("Bourré sur place", "")
	animFeteMenu.SubMenu:AddItem(bourreItem)
	local vomirItem = NativeUI.CreateItem("Vomir en voiture", "")
	animFeteMenu.SubMenu:AddItem(vomirItem)

	animFeteMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == cigaretteItem then
			startScenarios("WORLD_HUMAN_SMOKING")
		elseif item == musiqueItem then
			startScenarios("WORLD_HUMAN_MUSICIAN")
		elseif item == DJItem then
			startAnims("anim@mp_player_intcelebrationmale@dj", "dj")
		elseif item == zikItem then
			startScenarios("WORLD_HUMAN_PARTYING")
		elseif item == guitarItem then
			startAnims("anim@mp_player_intcelebrationmale@air_guitar", "air_guitar")
		elseif item == shaggingItem then
			startAnims("anim@mp_player_intcelebrationfemale@air_shagging", "air_shagging")
		elseif item == rockItem then
			startAnims("mp_player_int_upperrock", "mp_player_int_rock")
		elseif item == bourreItem then
			startAnims("amb@world_human_bum_standing@drunk@idle_a", "idle_a")
		elseif item == vomirItem then
			startAnims("oddjobs@taxi@tie", "vomit_outside")
		end
	end
end

function AddSubMenuDansesMenu(menu)
	animDanseMenu = _menuPool:AddSubMenu(menu.SubMenu, "Danses")

	local danse1 = NativeUI.CreateItem("Danse 1", "")
	animDanseMenu.SubMenu:AddItem(danse1)
	local danse2 = NativeUI.CreateItem("Danse 2", "")
	animDanseMenu.SubMenu:AddItem(danse2)
	local danse3 = NativeUI.CreateItem("Danse 3", "")
	animDanseMenu.SubMenu:AddItem(danse3)
	local danse4 = NativeUI.CreateItem("Danse 4", "")
	animDanseMenu.SubMenu:AddItem(danse4)
	local danse5 = NativeUI.CreateItem("Danse 5", "")
	animDanseMenu.SubMenu:AddItem(danse5)
	local danse6 = NativeUI.CreateItem("Danse 6", "")
	animDanseMenu.SubMenu:AddItem(danse6)
	local danse7 = NativeUI.CreateItem("Danse 7", "")
	animDanseMenu.SubMenu:AddItem(danse7)
	local danse8 = NativeUI.CreateItem("Danse 8", "")
	animDanseMenu.SubMenu:AddItem(danse8)
	local danse9 = NativeUI.CreateItem("Danse 9", "")
	animDanseMenu.SubMenu:AddItem(danse9)
	local danse10 = NativeUI.CreateItem("Danse 10", "")
	animDanseMenu.SubMenu:AddItem(danse10)
	local danse11 = NativeUI.CreateItem("Danse 11", "")
	animDanseMenu.SubMenu:AddItem(danse11)
	local danse12 = NativeUI.CreateItem("Danse 12", "")
	animDanseMenu.SubMenu:AddItem(danse12)
	local danse13 = NativeUI.CreateItem("Danse 13", "")
	animDanseMenu.SubMenu:AddItem(danse13)
	local danse14 = NativeUI.CreateItem("Danse 14", "")
	animDanseMenu.SubMenu:AddItem(danse14)
	local danse15 = NativeUI.CreateItem("Danse 15", "")
	animDanseMenu.SubMenu:AddItem(danse15)
	local danse16 = NativeUI.CreateItem("Danse 16", "")
	animDanseMenu.SubMenu:AddItem(danse16)
	local danse17 = NativeUI.CreateItem("Danse 17", "")
	animDanseMenu.SubMenu:AddItem(danse17)
	local danse18 = NativeUI.CreateItem("Danse 18", "")
	animDanseMenu.SubMenu:AddItem(danse18)
	local danse19 = NativeUI.CreateItem("Danse Claquette", "")
	animDanseMenu.SubMenu:AddItem(danse19)
	local danse20 = NativeUI.CreateItem("Danse Claquette 2", "")
	animDanseMenu.SubMenu:AddItem(danse20)
	local danse21 = NativeUI.CreateItem("Danse Claquette 3", "")
	animDanseMenu.SubMenu:AddItem(danse21)
	local danse22 = NativeUI.CreateItem("Danse 22", "")
	animDanseMenu.SubMenu:AddItem(danse22)
	local danse23 = NativeUI.CreateItem("Danse 23", "")
	animDanseMenu.SubMenu:AddItem(danse23)
	local danse24 = NativeUI.CreateItem("Danse 24", "")
	animDanseMenu.SubMenu:AddItem(danse24)
	local danse25 = NativeUI.CreateItem("Danse 25", "")
	animDanseMenu.SubMenu:AddItem(danse25)
	local danse26 = NativeUI.CreateItem("Danse 26", "")
	animDanseMenu.SubMenu:AddItem(danse26)
	local danse27 = NativeUI.CreateItem("Danse Macarena", "")
	animDanseMenu.SubMenu:AddItem(danse27)
	local danse28 = NativeUI.CreateItem("Danse Macarena 2", "")
	animDanseMenu.SubMenu:AddItem(danse28)
	local danse29 = NativeUI.CreateItem("Danse 29", "")
	animDanseMenu.SubMenu:AddItem(danse29)
	local danse30 = NativeUI.CreateItem("Danse 30", "")
	animDanseMenu.SubMenu:AddItem(danse30)
	local danse31 = NativeUI.CreateItem("Danse 31", "")
	animDanseMenu.SubMenu:AddItem(danse31)
	local danse32 = NativeUI.CreateItem("Danse 32", "")
	animDanseMenu.SubMenu:AddItem(danse32)
	local danse33 = NativeUI.CreateItem("Danse 33", "")
	animDanseMenu.SubMenu:AddItem(danse33)
	local danse34 = NativeUI.CreateItem("Danse 34", "")
	animDanseMenu.SubMenu:AddItem(danse34)
	local danse35 = NativeUI.CreateItem("Danse 35", "")
	animDanseMenu.SubMenu:AddItem(danse35)
	local danse36 = NativeUI.CreateItem("Danse 36", "")
	animDanseMenu.SubMenu:AddItem(danse36)
	local danse37 = NativeUI.CreateItem("Danse 37", "")
	animDanseMenu.SubMenu:AddItem(danse37)
	local danse38 = NativeUI.CreateItem("Danse 38", "")
	animDanseMenu.SubMenu:AddItem(danse38)
	local danse39 = NativeUI.CreateItem("Danse 39", "")
	animDanseMenu.SubMenu:AddItem(danse39)
	local danse40 = NativeUI.CreateItem("Danse 40", "")
	animDanseMenu.SubMenu:AddItem(danse40)
	local dansexD = NativeUI.CreateItem("Danse xD", "")
	animDanseMenu.SubMenu:AddItem(dansexD)
	local danseJuan = NativeUI.CreateItem("Danse Juan", "")
	animDanseMenu.SubMenu:AddItem(danseJuan)


	animDanseMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == danse1 then
			startAnims("anim@amb@nightclub@dancers@club_ambientpeds@med-hi_intensity", "mi-hi_amb_club_10_v1_male^6")
		elseif item == danse2 then
			startAnims("amb@code_human_in_car_mp_actions@dance@bodhi@ds@base", "idle_a_fp")
		elseif item == danse3 then
			startAnims("amb@code_human_in_car_mp_actions@dance@bodhi@rds@base", "idle_b")
		elseif item == danse4 then
			startAnims("amb@code_human_in_car_mp_actions@dance@std@ds@base", "idle_a")
		elseif item == danse5 then
			startAnims("anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", "hi_dance_facedj_09_v2_male^6")
		elseif item == danse6 then
			startAnims("anim@amb@nightclub@dancers@crowddance_facedj@low_intesnsity", "li_dance_facedj_09_v1_male^6")
		elseif item == danse7 then
			startAnims("anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", "trans_dance_facedj_hi_to_li_09_v1_male^6")
		elseif item == danse8 then
			startAnims("anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_low_intensity", "trans_dance_facedj_li_to_hi_07_v1_male^6")
		elseif item == danse9 then
			startAnims("anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", "hi_dance_crowd_13_v2_male^6")
		elseif item == danse10 then
			startAnims("anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", "trans_dance_crowd_hi_to_li__07_v1_male^6")
		elseif item == danse11 then
			startAnims("anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", "hi_dance_prop_13_v1_male^6")
		elseif item == danse12 then
			startAnims("anim@amb@nightclub@dancers@crowddance_single_props_transitions@from_med_intensity", "trans_crowd_prop_mi_to_li_11_v1_male^6")
		elseif item == danse13 then
			startAnims("anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "med_center_up")
		elseif item == danse14 then
			startAnims("anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "med_right_up")
		elseif item == danse15 then
			startAnims("anim@amb@nightclub@dancers@crowddance_groups@low_intensity", "li_dance_crowd_17_v1_male^6")
		elseif item == danse16 then
			startAnims("anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", "trans_dance_facedj_mi_to_li_09_v1_male^6")
		elseif item == danse17 then
			startAnims("timetable@tracy@ig_5@idle_b", "idle_e")
		elseif item == danse18 then
			startAnims("mini@strip_club@idles@dj@idle_04", "idle_04")
		elseif item == danse19 then
			startAnims("special_ped@mountain_dancer@monologue_1@monologue_1a", "mtn_dnc_if_you_want_to_get_to_heaven", 9)
		elseif item == danse20 then
			startAnims("special_ped@mountain_dancer@monologue_4@monologue_4a", "mnt_dnc_verse", 9)
		elseif item == danse21 then
			startAnims("special_ped@mountain_dancer@monologue_3@monologue_3a", "mnt_dnc_buttwag", 9)
		elseif item == danse22 then
			startAnims("anim@amb@nightclub@dancers@black_madonna_entourage@", "hi_dance_facedj_09_v2_male^5")
		elseif item == danse23 then
			startAnims("anim@amb@nightclub@dancers@crowddance_single_props@", "hi_dance_prop_09_v1_male^6")
		elseif item == danse24 then
			startAnims("anim@amb@nightclub@dancers@dixon_entourage@", "mi_dance_facedj_15_v1_male^4")
		elseif item == danse25 then
			startAnims("anim@amb@nightclub@dancers@podium_dancers@", "hi_dance_facedj_17_v2_male^5")
		elseif item == danse26 then
			startAnims("anim@amb@nightclub@dancers@tale_of_us_entourage@", "mi_dance_prop_13_v2_male^4")
		elseif item == danse27 then
			startAnims("misschinese2_crystalmazemcs1_cs", "dance_loop_tao")
		elseif item == danse28 then
			startAnims("misschinese2_crystalmazemcs1_ig", "dance_loop_tao")
		elseif item == danse29 then
			startAnims("anim@mp_player_intcelebrationfemale@uncle_disco", "uncle_disco")
		elseif item == danse30 then
			startAnims("anim@mp_player_intcelebrationfemale@raise_the_roof", "raise_the_roof")
		elseif item == danse31 then
			startAnims("anim@mp_player_intcelebrationmale@cats_cradle", "cats_cradle")
		elseif item == danse32 then
			startAnims("anim@mp_player_intupperbanging_tunes", "idle_a")
		elseif item == danse33 then
			startAnims("anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_center")
		elseif item == danse34 then
			startAnims("anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "high_center")
		elseif item == danse35 then
			startAnims("anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center")
		elseif item == danse36 then
			startAnims("anim@amb@nightclub@dancers@crowddance_facedj_transitions@", "trans_dance_facedj_hi_to_mi_11_v1_female^6")
		elseif item == danse37 then
			startAnims("anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_hi_intensity", "trans_dance_facedj_hi_to_li_07_v1_female^6")
		elseif item == danse38 then
			startAnims("anim@amb@nightclub@dancers@crowddance_facedj@", "hi_dance_facedj_09_v1_female^6")
		elseif item == danse39 then
			startAnims("anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", "hi_dance_crowd_09_v1_female^6")
		elseif item == danse40 then
			startAnims("anim@amb@nightclub@lazlow@hi_podium@", "danceidle_hi_06_base_laz")
		elseif item == dansexD then
			startAnims("special_ped@zombie@monologue_4@monologue_4l", "iamtheundead_11")
		elseif item == danseJuan then
			startAnims("special_ped@mountain_dancer@monologue_3@monologue_3a", "mnt_dnc_buttwag")
		end
	end
end

function AddSubMenuSalutationsMenu(menu)
	animSaluteMenu = _menuPool:AddSubMenu(menu.SubMenu, "Salutations")

	local saluerItem = NativeUI.CreateItem("Saluer", "")
	animSaluteMenu.SubMenu:AddItem(saluerItem)
	local serrerItem = NativeUI.CreateItem("Serrer la main", "")
	animSaluteMenu.SubMenu:AddItem(serrerItem)
	local tchekItem = NativeUI.CreateItem("Tchek", "")
	animSaluteMenu.SubMenu:AddItem(tchekItem)
	local banditItem = NativeUI.CreateItem("Salut bandit", "")
	animSaluteMenu.SubMenu:AddItem(banditItem)
	local militaireItem = NativeUI.CreateItem("Salut Militaire", "")
	animSaluteMenu.SubMenu:AddItem(militaireItem)
	local enlacerItem = NativeUI.CreateItem("Enlacer", "")
	animSaluteMenu.SubMenu:AddItem(enlacerItem)
	local bisousItem = NativeUI.CreateItem("Bisous Femme", "")
	animSaluteMenu.SubMenu:AddItem(bisousItem)
	local bisous2Item = NativeUI.CreateItem("Bisous Homme", "")
	animSaluteMenu.SubMenu:AddItem(bisous2Item)
	local poucerItem = NativeUI.CreateItem("Pouce en l'air", "")
	animSaluteMenu.SubMenu:AddItem(poucerItem)
	local poucer2Item = NativeUI.CreateItem("2 pouces en l'air", "")
	animSaluteMenu.SubMenu:AddItem(poucer2Item)
	local fuck1Item = NativeUI.CreateItem("Doigt d'honneur 1", "")
	animSaluteMenu.SubMenu:AddItem(fuck1Item)
	local fuck2Item = NativeUI.CreateItem("Doigt d'honneur 2", "")
	animSaluteMenu.SubMenu:AddItem(fuck2Item)
	local fuck3Item = NativeUI.CreateItem("Doigt d'honneur 3", "")
	animSaluteMenu.SubMenu:AddItem(fuck3Item)
	local bro1Item = NativeUI.CreateItem("Vous êtes mes bro", "")
	animSaluteMenu.SubMenu:AddItem(bro1Item)
	local sifflet1Item = NativeUI.CreateItem("Sifflé", "")
	animSaluteMenu.SubMenu:AddItem(sifflet1Item)
	local vvictoireItem = NativeUI.CreateItem("V de victoire", "")
	animSaluteMenu.SubMenu:AddItem(vvictoireItem)

	animSaluteMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == saluerItem then
			startAnims("gestures@m@standing@casual", "gesture_hello")
		elseif item == serrerItem then
			startAnims("mp_common", "givetake1_a")
		elseif item == tchekItem then
			startAnims("mp_ped_interaction", "handshake_guy_a")
		elseif item == banditItem then
			startAnims("mp_ped_interaction", "hugs_guy_a")
		elseif item == militaireItem then
			startAnims("mp_player_int_uppersalute", "mp_player_int_salute")
		elseif item == enlacerItem then
			startAnims("mp_ped_interaction", "kisses_guy_a")
		elseif item == bisousItem then
			startAnims("anim@mp_player_intcelebrationfemale@blow_kiss", "blow_kiss")
		elseif item == bisous2Item then
			startAnims("anim@mp_player_intcelebrationmale@blow_kiss", "blow_kiss")
		elseif item == poucerItem then
			startAnims("anim@mp_player_intincarthumbs_upstd@rps@", "exit")
		elseif item == poucer2Item then
			startAnims("mp_action", "thanks_male_06")
		elseif item == fuck1Item then
			startAnims("anim@mp_player_intcelebrationfemale@finger", "finger")
		elseif item == fuck2Item then
			startAnims("anim@mp_player_intcelebrationmale@finger", "finger")
		elseif item == fuck3Item then
			startAnims("mp_player_int_upperfinger", "mp_player_int_finger_01_enter")
		elseif item == bro1Item then
			startAnims("anim@mp_player_intcelebrationfemale@bro_love", "bro_love")
		elseif item == sifflet1Item then
			startAnims("taxi_hail", "fp_hail_taxi")
		elseif item == vvictoireItem then
			startAnims("amb@code_human_in_car_mp_actions@v_sign@bodhi@rps@base", "idle_a")
		end
	end
end

function AddSubMenuTravailMenu(menu)
	animTravailMenu = _menuPool:AddSubMenu(menu.SubMenu, "Travail")

	local pecheurItem = NativeUI.CreateItem("Pêcheur", "")
	animTravailMenu.SubMenu:AddItem(pecheurItem)
	local pEnqueterItem = NativeUI.CreateItem("Police : enquêter", "")
	animTravailMenu.SubMenu:AddItem(pEnqueterItem)
	local pRadioItem = NativeUI.CreateItem("Police : parler à la radio", "")
	animTravailMenu.SubMenu:AddItem(pRadioItem)
	local pCirculationItem = NativeUI.CreateItem("Police : circulation", "")
	animTravailMenu.SubMenu:AddItem(pCirculationItem)
	local pJumelleItem = NativeUI.CreateItem("Police : jumelles", "")
	animTravailMenu.SubMenu:AddItem(pJumelleItem)
	local aRecolterItem = NativeUI.CreateItem("Agriculture : récolter", "")
	animTravailMenu.SubMenu:AddItem(aRecolterItem)
	local dReparerItem = NativeUI.CreateItem("Dépanneur : réparer le moteur", "")
	animTravailMenu.SubMenu:AddItem(dReparerItem)
	local mObserverItem = NativeUI.CreateItem("Médecin : observer", "")
	animTravailMenu.SubMenu:AddItem(mObserverItem)
	local tParlerItem = NativeUI.CreateItem("Taxi : parler au client", "")
	animTravailMenu.SubMenu:AddItem(tParlerItem)
	local tFacturerItem = NativeUI.CreateItem("Taxi : donner la facture", "")
	animTravailMenu.SubMenu:AddItem(tFacturerItem)
	local eCoursesItem = NativeUI.CreateItem("Epicier : donner les courses", "")
	animTravailMenu.SubMenu:AddItem(eCoursesItem)
	local bShotItem = NativeUI.CreateItem("Barman : servir un shot", "")
	animTravailMenu.SubMenu:AddItem(bShotItem)
	local jPhotoItem = NativeUI.CreateItem("Journaliste : Prendre une photo", "")
	animTravailMenu.SubMenu:AddItem(jPhotoItem)
	local NotesItem = NativeUI.CreateItem("Tout : Prendre des notes", "")
	animTravailMenu.SubMenu:AddItem(NotesItem)
	local MarteauItem = NativeUI.CreateItem("Tout : Coup de marteau", "")
	animTravailMenu.SubMenu:AddItem(MarteauItem)
	local sdfMancheItem = NativeUI.CreateItem("SDF : Faire la manche", "")
	animTravailMenu.SubMenu:AddItem(sdfMancheItem)
	local sdfStatueItem = NativeUI.CreateItem("SDF : Faire la statue", "")
	animTravailMenu.SubMenu:AddItem(sdfStatueItem)

	animTravailMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == pecheurItem then
			startScenarios("world_human_stand_fishing")
		elseif item == pEnqueterItem then
			startAnims("amb@code_human_police_investigate@idle_b", "idle_f")
		elseif item == pRadioItem then
			startAnims("random@arrests", "generic_radio_chatter")
		elseif item == pCirculationItem then
			startScenarios("WORLD_HUMAN_CAR_PARK_ATTENDANT")
		elseif item == pJumelleItem then
			startScenarios("WORLD_HUMAN_BINOCULARS")
		elseif item == aRecolterItem then
			startScenarios("world_human_gardener_plant")
		elseif item == dReparerItem then
			startAnims("mini@repair", "fixing_a_ped")
		elseif item == mObserverItem then
			startScenarios("CODE_HUMAN_MEDIC_KNEEL")
		elseif item == tParlerItem then
			startAnims("oddjobs@taxi@driver", "leanover_idle")
		elseif item == tFacturerItem then
			startAnims("oddjobs@taxi@cyi", "std_hand_off_ps_passenger")
		elseif item == eCoursesItem then
			startAnims("mp_am_hold_up", "purchase_beerbox_shopkeeper")
		elseif item == bShotItem then
			startAnims("mini@drinking", "shots_barman_b")
		elseif item == jPhotoItem then
			startScenarios("WORLD_HUMAN_PAPARAZZI")
		elseif item == NotesItem then
			startScenarios("WORLD_HUMAN_CLIPBOARD")
		elseif item == MarteauItem then
			startScenarios("WORLD_HUMAN_HAMMERING")
		elseif item == sdfMancheItem then
			startScenarios("WORLD_HUMAN_BUM_FREEWAY")
		elseif item == sdfStatueItem then
			startScenarios("WORLD_HUMAN_HUMAN_STATUE")
		end
	end
end

function AddSubMenuHumeursMenu(menu)
	animHumeurMenu = _menuPool:AddSubMenu(menu.SubMenu, "Humeurs")

	local feliciterItem = NativeUI.CreateItem("Féliciter", "")
	animHumeurMenu.SubMenu:AddItem(feliciterItem)
	local superItem = NativeUI.CreateItem("Super", "")
	animHumeurMenu.SubMenu:AddItem(superItem)
	local toiItem = NativeUI.CreateItem("Toi", "")
	animHumeurMenu.SubMenu:AddItem(toiItem)
	local viensItem = NativeUI.CreateItem("Viens", "")
	animHumeurMenu.SubMenu:AddItem(viensItem)
	local keskyaItem = NativeUI.CreateItem("Keskya ?", "")
	animHumeurMenu.SubMenu:AddItem(keskyaItem)
	local moiItem = NativeUI.CreateItem("A moi", "")
	animHumeurMenu.SubMenu:AddItem(moiItem)
	local putainItem = NativeUI.CreateItem("Je le savais, putain", "")
	animHumeurMenu.SubMenu:AddItem(putainItem)
	local epuiserItem = NativeUI.CreateItem("Etre épuisé", "")
	animHumeurMenu.SubMenu:AddItem(epuiserItem)
	local merdeItem = NativeUI.CreateItem("Je suis dans la merde", "")
	animHumeurMenu.SubMenu:AddItem(merdeItem)
	local facepalmItem = NativeUI.CreateItem("Facepalm", "")
	animHumeurMenu.SubMenu:AddItem(facepalmItem)
	local calmeItem = NativeUI.CreateItem("Calme-toi ", "")
	animHumeurMenu.SubMenu:AddItem(calmeItem)
	local jaifaitItem = NativeUI.CreateItem("Qu'est ce que j'ai fait ?", "")
	animHumeurMenu.SubMenu:AddItem(jaifaitItem)
	local peurItem = NativeUI.CreateItem("Avoir peur", "")
	animHumeurMenu.SubMenu:AddItem(peurItem)
	local fightItem = NativeUI.CreateItem("Fight ?", "")
	animHumeurMenu.SubMenu:AddItem(fightItem)
	local paspossibleItem = NativeUI.CreateItem("C'est pas Possible !", "")
	animHumeurMenu.SubMenu:AddItem(paspossibleItem)
	local doigtItem = NativeUI.CreateItem("Doigt d'honneur", "")
	animHumeurMenu.SubMenu:AddItem(doigtItem)
	local branleurItem = NativeUI.CreateItem("Branleur", "")
	animHumeurMenu.SubMenu:AddItem(branleurItem)
	local balleItem = NativeUI.CreateItem("Balle dans la tete", "")
	animHumeurMenu.SubMenu:AddItem(balleItem)
	local malventreItem = NativeUI.CreateItem("Se tenir le vente", "")
	animHumeurMenu.SubMenu:AddItem(malventreItem)
	local chutItem = NativeUI.CreateItem("Chut", "")
	animHumeurMenu.SubMenu:AddItem(chutItem)
	local agiterbItem = NativeUI.CreateItem("Agiter les bras", "")
	animHumeurMenu.SubMenu:AddItem(agiterbItem)
	local croisermItem = NativeUI.CreateItem("Croiser les mains", "")
	animHumeurMenu.SubMenu:AddItem(croisermItem)
	local frottermItem = NativeUI.CreateItem("Se frotter les mains", "")
	animHumeurMenu.SubMenu:AddItem(frottermItem)

	animHumeurMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == feliciterItem then
			startScenarios("WORLD_HUMAN_CHEERING")
		elseif item == superItem then
			startAnims("mp_action", "thanks_male_06")
		elseif item == toiItem then
			startAnims("gestures@m@standing@casual", "gesture_point")
		elseif item == viensItem then
			startAnims("gestures@m@standing@casual", "gesture_come_here_soft")
		elseif item == keskyaItem then
			startAnims("gestures@m@standing@casual", "gesture_bring_it_on")
		elseif item == moiItem then
			startAnims("gestures@m@standing@casual", "gesture_me")
		elseif item == putainItem then
			startAnims("anim@am_hold_up@male", "shoplift_high")
		elseif item == epuiserItem then
			startAnims("amb@world_human_jog_standing@male@idle_b", "idle_d")
		elseif item == merdeItem then
			startAnims("amb@world_human_bum_standing@depressed@idle_a", "idle_a")
		elseif item == facepalmItem then
			startAnims("anim@mp_player_intcelebrationmale@face_palm", "face_palm")
		elseif item == calmeItem then
			startAnims("gestures@m@standing@casual", "gesture_easy_now")
		elseif item == jaifaitItem then
			startAnims("oddjobs@assassinate@multi@", "react_big_variations_a")
		elseif item == peurItem then
			startAnims("amb@code_human_cower_stand@male@react_cowering", "base_right")
		elseif item == fightItem then
			startAnims("anim@deathmatch_intros@unarmed", "intro_male_unarmed_e")
		elseif item == paspossibleItem then
			startAnims("gestures@m@standing@casual", "gesture_damn")
		elseif item == doigtItem then
			startAnims("mp_player_int_upperfinger", "mp_player_int_finger_01_enter")
		elseif item == branleurItem then
			startAnims("mp_player_int_upperwank", "mp_player_int_wank_01")
		elseif item == balleItem then
			startAnims("mp_suicide", "pistol")
		elseif item == malventreItem then
			startAnims("rcmpaparazzo1", "idle", 9)
		elseif item == chutItem then
			startAnims("anim@mp_player_intcelebrationfemale@shush", "shush")
		elseif item == agiterbItem then
			startAnims("random@car_thief@victimpoints_ig_3", "arms_waving")
		elseif item == croisermItem then
			startAnims("pro_mcs_7_concat-0", "cs_priest_dual-0")
		elseif item == frottermItem then
			startAnims("move_action@p_m_one@unarmed@idle@variations", "idle_a")
		end
	end
end

function AddSubMenuSportsMenu(menu)
	animSportMenu = _menuPool:AddSubMenu(menu.SubMenu, "Sports")

	local muscleItem = NativeUI.CreateItem("Montrer ses muscles", "")
	animSportMenu.SubMenu:AddItem(muscleItem)
	local muscuItem = NativeUI.CreateItem("Barre de musculation", "")
	animSportMenu.SubMenu:AddItem(muscuItem)
	local pompeItem = NativeUI.CreateItem("Faire des pompes", "")
	animSportMenu.SubMenu:AddItem(pompeItem)
	local abdoItem = NativeUI.CreateItem("Faire des abdos", "")
	animSportMenu.SubMenu:AddItem(abdoItem)
	local yogaItem = NativeUI.CreateItem("Faire du yoga", "")
	animSportMenu.SubMenu:AddItem(yogaItem)

	animSportMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == muscleItem then
			startAnims("amb@world_human_muscle_flex@arms_at_side@base", "base")
		elseif item == muscuItem then
			startAnims("amb@world_human_muscle_free_weights@male@barbell@base", "base")
		elseif item == pompeItem then
			startAnims("amb@world_human_push_ups@male@base", "base", 9)
		elseif item == abdoItem then
			startAnims("amb@world_human_sit_ups@male@base", "base", 9)
		elseif item == yogaItem then
			startAnims("amb@world_human_yoga@male@base", "base_a")
		end
	end
end


function AddSubMenuPEGI21Menu(menu)
	animPegiMenu = _menuPool:AddSubMenu(menu.SubMenu, "PEGI 21")

	local hSuceItem = NativeUI.CreateItem("Homme se faire su* en voiture", "")
	animPegiMenu.SubMenu:AddItem(hSuceItem)
	local fSuceItem = NativeUI.CreateItem("Femme faire une gaterie en voiture", "")
	animPegiMenu.SubMenu:AddItem(fSuceItem)
	local hBaiserItem = NativeUI.CreateItem("Homme bais en voiture", "")
	animPegiMenu.SubMenu:AddItem(hBaiserItem)
	local fBaiserItem = NativeUI.CreateItem("Femme bais** en voiture", "")
	animPegiMenu.SubMenu:AddItem(fBaiserItem)
	local gratterItem = NativeUI.CreateItem("Se gratter les couilles", "")
	animPegiMenu.SubMenu:AddItem(gratterItem)
	local charmeItem = NativeUI.CreateItem("Faire du charme", "")
	animPegiMenu.SubMenu:AddItem(charmeItem)
	local michtoItem = NativeUI.CreateItem("Pose michto", "")
	animPegiMenu.SubMenu:AddItem(michtoItem)
	local poitrineItem = NativeUI.CreateItem("Montrer sa poitrine", "")
	animPegiMenu.SubMenu:AddItem(poitrineItem)
	local strip1Item = NativeUI.CreateItem("Strip Tease 1", "")
	animPegiMenu.SubMenu:AddItem(strip1Item)
	local strip2Item = NativeUI.CreateItem("Strip Tease 2", "")
	animPegiMenu.SubMenu:AddItem(strip2Item)
	local stripsolItem = NativeUI.CreateItem("Stip Tease au sol", "")
	animPegiMenu.SubMenu:AddItem(stripsolItem)

	animPegiMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == hSuceItem then
			startAnims("oddjobs@towing", "m_blow_job_loop")
		elseif item == fSuceItem then
			startAnims("oddjobs@towing", "f_blow_job_loop")
		elseif item == hBaiserItem then
			startAnims("mini@prostitutes@sexlow_veh", "low_car_sex_loop_player")
		elseif item == fBaiserItem then
			startAnims("mini@prostitutes@sexlow_veh", "low_car_sex_loop_female")
		elseif item == gratterItem then
			startAnims("mp_player_int_uppergrab_crotch", "mp_player_int_grab_crotch")
		elseif item == charmeItem then
			startAnims("mini@strip_club@idles@stripper", "stripper_idle_02")
		elseif item == michtoItem then
			startScenarios("WORLD_HUMAN_PROSTITUTE_HIGH_CLASS")
		elseif item == poitrineItem then
			startAnims("mini@strip_club@backroom@", "stripper_b_backroom_idle_b")
		elseif item == strip1Item then
			startAnims("mini@strip_club@lap_dance@ld_girl_a_song_a_p1", "ld_girl_a_song_a_p1_f")
		elseif item == strip2Item then
			startAnims("mini@strip_club@private_dance@part2", "priv_dance_p2")
		elseif item == stripsolItem then
			startAnims("mini@strip_club@private_dance@part3", "priv_dance_p3")
		end
	end
end

function AddMenuVehicleMenu(menu)
	personalmenu.frontLeftDoorOpen = false
	personalmenu.frontRightDoorOpen = false
	personalmenu.backLeftDoorOpen = false
	personalmenu.backRightDoorOpen = false
	personalmenu.hoodDoorOpen = false
	personalmenu.trunkDoorOpen = false
	personalmenu.vehAutoDrive = false
	personalmenu.vehAutoToDrive = false
	personalmenu.doorList = {
		_U('vehicle_door_frontleft'),
		_U('vehicle_door_frontright'),
		_U('vehicle_door_backleft'),
		_U('vehicle_door_backright')
	}

	vehicleMenu = _menuPool:AddSubMenu(menu, _U('vehicle_title'))

	local vehEngineItem = NativeUI.CreateItem(_U('vehicle_engine_button'), "")
	vehicleMenu.SubMenu:AddItem(vehEngineItem)
	local vehDoorListItem = NativeUI.CreateListItem(_U('vehicle_door_button'), personalmenu.doorList, 1)
	vehicleMenu.SubMenu:AddItem(vehDoorListItem)
	local vehHoodItem = NativeUI.CreateItem(_U('vehicle_hood_button'), "")
	vehicleMenu.SubMenu:AddItem(vehHoodItem)
	local vehTrunkItem = NativeUI.CreateItem(_U('vehicle_trunk_button'), "")
	vehicleMenu.SubMenu:AddItem(vehTrunkItem)
	local vehAutoDriveItem = NativeUI.CreateItem('Conduite Aléatoire', "")
	vehicleMenu.SubMenu:AddItem(vehAutoDriveItem)

	vehicleMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if not IsPedSittingInAnyVehicle(plyPed) then
			ESX.ShowNotification(_U('no_vehicle'))
		elseif IsPedSittingInAnyVehicle(plyPed) then
			plyVehicle = GetVehiclePedIsIn(plyPed, false)
			if item == vehEngineItem then
				if GetIsVehicleEngineRunning(plyVehicle) then
					SetVehicleEngineOn(plyVehicle, false, false, true)
					SetVehicleUndriveable(plyVehicle, true)
				elseif not GetIsVehicleEngineRunning(plyVehicle) then
					SetVehicleEngineOn(plyVehicle, true, false, true)
					SetVehicleUndriveable(plyVehicle, false)
				end
			elseif item == vehHoodItem then
				if not personalmenu.hoodDoorOpen then
					personalmenu.hoodDoorOpen = true
					SetVehicleDoorOpen(plyVehicle, 4, false, false)
				elseif personalmenu.hoodDoorOpen then
					personalmenu.hoodDoorOpen = false
					SetVehicleDoorShut(plyVehicle, 4, false, false)
				end
			elseif item == vehTrunkItem then
				if not personalmenu.trunkDoorOpen then
					personalmenu.trunkDoorOpen = true
					SetVehicleDoorOpen(plyVehicle, 5, false, false)
				elseif personalmenu.trunkDoorOpen then
					personalmenu.trunkDoorOpen = false
					SetVehicleDoorShut(plyVehicle, 5, false, false)
				end
			elseif item == vehAutoDriveItem then
				if not personalmenu.vehAutoDrive then
					personalmenu.vehAutoDrive = true
					TaskVehicleDriveWander(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), 20.0, 447)
					SetDriveTaskDrivingStyle(PlayerPedId(), 447)
					ESX.ShowNotification('Vous ~g~conduisez désormais~s~ comme un ~b~moldu~s~.')
				elseif personalmenu.vehAutoDrive then
					personalmenu.vehAutoDrive = false
					ClearPedTasks(PlayerPedId())
					ESX.ShowNotification('Vous ~r~arrêtez de conduire~s~ comme un ~b~moldu~s~.')
				end
			end
		end
	end

	vehicleMenu.SubMenu.OnListSelect = function(sender, item, index)
		if not IsPedSittingInAnyVehicle(plyPed) then
			ESX.ShowNotification(_U('no_vehicle'))
		elseif IsPedSittingInAnyVehicle(plyPed) then
			plyVehicle = GetVehiclePedIsIn(plyPed, false)
			if item == vehDoorListItem then
				if index == 1 then
					if not personalmenu.frontLeftDoorOpen then
						personalmenu.frontLeftDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 0, false, false)
					elseif personalmenu.frontLeftDoorOpen then
						personalmenu.frontLeftDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 0, false, false)
					end
				elseif index == 2 then
					if not personalmenu.frontRightDoorOpen then
						personalmenu.frontRightDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 1, false, false)
					elseif personalmenu.frontRightDoorOpen then
						personalmenu.frontRightDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 1, false, false)
					end
				elseif index == 3 then
					if not personalmenu.backLeftDoorOpen then
						personalmenu.backLeftDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 2, false, false)
					elseif personalmenu.backLeftDoorOpen then
						personalmenu.backLeftDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 2, false, false)
					end
				elseif index == 4 then
					if not personalmenu.backRightDoorOpen then
						personalmenu.backRightDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 3, false, false)
					elseif personalmenu.backRightDoorOpen then
						personalmenu.backRightDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 3, false, false)
					end
				end
			end
		end
	end
end

function AddMenuDiversMenu(menu)
	diversMenu = _menuPool:AddSubMenu(menu, "Divers")

	local syncPersoItem = NativeUI.CreateItem("Synchroniser son personnage", "")
	diversMenu.SubMenu:AddItem(syncPersoItem)
	local dodoItem = NativeUI.CreateItem("Dormir | Se réveiller", "")
	diversMenu.SubMenu:AddItem(dodoItem)
	local mykeyItem = NativeUI.CreateItem("Mes clés", "")
	diversMenu.SubMenu:AddItem(mykeyItem)
	local togglehudItem = NativeUI.CreateItem("Enlever | Afficher HUD", "")
	diversMenu.SubMenu:AddItem(togglehudItem)
	local cinemodItem = NativeUI.CreateItem("Mode cinématique", "")
	diversMenu.SubMenu:AddItem(cinemodItem)

	diversMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == syncPersoItem then
			Citizen.Wait(500)
			TriggerEvent('skinchanger:modelLoaded')
			ESX.ShowNotification('~b~Personnage synchronisé~s~')
		elseif item == dodoItem then
			TriggerEvent("Ragdoll", plyPed)
		elseif item == mykeyItem then
			openKeys()
			_menuPool:CloseAllMenus()
		elseif item == togglehudItem then
			openInterface()
		elseif item == cinemodItem then
			openCinematique()
		end
	end
end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('esx_ambulancejob:multicharacter', coords.x, coords.y, coords.z)

	ESX.UI.Menu.CloseAll()
end

function openKeys()
	TriggerEvent('openKeysMenu')
end

function setRagdoll(flag)
	ragdoll = flag
end
  
Citizen.CreateThread(function()
while true do
  Citizen.Wait(0)
  if ragdoll then
	SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
  end
end
end)

ragdol = true

RegisterNetEvent("Ragdoll")
AddEventHandler("Ragdoll", function()
  if (ragdol) then
	  setRagdoll(true)
	  ragdol = false
  else
	  setRagdoll(false)
	  ragdol = true
  end
end)

local interface = true
 function openInterface()
	interface = not interface
	if not interface then -- hide
		TriggerEvent('ui:toggle', false)
	elseif interface then -- show
	  	TriggerEvent('ui:toggle', true)
	end
 end

local hasCinematic = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsPauseMenuActive() then
			ESX.UI.HUD.SetDisplay(0.0)
		elseif hasCinematic == true then
			ESX.UI.HUD.SetDisplay(0.0)
		end
	end
end)

 function openCinematique()
	hasCinematic = not hasCinematic
	if not hasCinematic then -- show
		SendNUIMessage({openCinema = true})
		ESX.UI.HUD.SetDisplay(0.0)
		TriggerEvent('es:setMoneyDisplay', 0.0)
		TriggerEvent('esx_status:setDisplay', 0.0)
		DisplayRadar(false)
		TriggerEvent('ui:toggle', false)
	elseif hasCinematic then -- hide
		SendNUIMessage({openCinema = false})
		ESX.UI.HUD.SetDisplay(1.0)
		TriggerEvent('es:setMoneyDisplay', 1.0)
		TriggerEvent('esx_status:setDisplay', 1.0)
		DisplayRadar(true)
		TriggerEvent('ui:toggle', true)
	end
 end

function AddMenuBossMenu(menu)
	bossMenu = _menuPool:AddSubMenu(menu, _U('bossmanagement_title', ESX.PlayerData.job.label))

	local coffreItem = nil

	if societymoney ~= nil then
		coffreItem = NativeUI.CreateItem(_U('bossmanagement_chest_button'), "")
		coffreItem:RightLabel("$" .. societymoney)
		bossMenu.SubMenu:AddItem(coffreItem)
	end

	local recruterItem = NativeUI.CreateItem(_U('bossmanagement_hire_button'), "")
	bossMenu.SubMenu:AddItem(recruterItem)
	local virerItem = NativeUI.CreateItem(_U('bossmanagement_fire_button'), "")
	bossMenu.SubMenu:AddItem(virerItem)
	local promouvoirItem = NativeUI.CreateItem(_U('bossmanagement_promote_button'), "")
	bossMenu.SubMenu:AddItem(promouvoirItem)
	local destituerItem = NativeUI.CreateItem(_U('bossmanagement_demote_button'), "")
	bossMenu.SubMenu:AddItem(destituerItem)

	bossMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == recruterItem then
			if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'capitaine' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification(_U('players_nearby'))
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_recruterplayer', GetPlayerServerId(personalmenu.closestPlayer), ESX.PlayerData.job.name, 0)
				end
			else
				ESX.ShowNotification(_U('missing_rights'))
			end
		elseif item == virerItem then
			if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'capitaine' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification(_U('players_nearby'))
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_virerplayer', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				ESX.ShowNotification(_U('missing_rights'))
			end
		elseif item == promouvoirItem then
			if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'capitaine' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification(_U('players_nearby'))
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_promouvoirplayer', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				ESX.ShowNotification(_U('missing_rights'))
			end
		elseif item == destituerItem then
			if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'capitaine' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification(_U('players_nearby'))
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_destituerplayer', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				ESX.ShowNotification(_U('missing_rights'))
			end
		end
	end
end

function AddMenuBossMenu2(menu)
	bossMenu2 = _menuPool:AddSubMenu(menu, _U('bossmanagement2_title', ESX.PlayerData.faction.label))

	local coffre2Item = nil

	if societymoney2 ~= nil then
		coffre2Item = NativeUI.CreateItem(_U('bossmanagement2_chest_button'), "")
		coffre2Item:RightLabel("$" .. societymoney2)
		bossMenu2.SubMenu:AddItem(coffre2Item)
	end

	local recruter2Item = NativeUI.CreateItem(_U('bossmanagement2_hire_button'), "")
	bossMenu2.SubMenu:AddItem(recruter2Item)
	local virer2Item = NativeUI.CreateItem(_U('bossmanagement2_fire_button'), "")
	bossMenu2.SubMenu:AddItem(virer2Item)
	local promouvoir2Item = NativeUI.CreateItem(_U('bossmanagement2_promote_button'), "")
	bossMenu2.SubMenu:AddItem(promouvoir2Item)
	local destituer2Item = NativeUI.CreateItem(_U('bossmanagement2_demote_button'), "")
	bossMenu2.SubMenu:AddItem(destituer2Item)

	bossMenu2.SubMenu.OnItemSelect = function(sender, item, index)
		if item == recruter2Item then
			if ESX.PlayerData.faction.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification(_U('players_nearby'))
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_recruterplayer2', GetPlayerServerId(personalmenu.closestPlayer), ESX.PlayerData.faction.name, 0)
				end
			else
				ESX.ShowNotification(_U('missing_rights'))
			end
		elseif item == virer2Item then
			if ESX.PlayerData.faction.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification(_U('players_nearby'))
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_virerplayer2', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				ESX.ShowNotification(_U('missing_rights'))
			end
		elseif item == promouvoir2Item then
			if ESX.PlayerData.faction.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification(_U('players_nearby'))
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_promouvoirplayer2', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				ESX.ShowNotification(_U('missing_rights'))
			end
		elseif item == destituer2Item then
			if ESX.PlayerData.faction.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification(_U('players_nearby'))
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_destituerplayer2', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				ESX.ShowNotification(_U('missing_rights'))
			end
		end
	end
end

function AddMenuDemarcheVoixGPS(menu)
    personalmenu.gps = {
		"Aucun",
		"Poste de Police",
		"Garage Central",
        	"Hôpital",
		"Concessionnaire",
        	"Benny's Custom",
		" Pôle Emploi",
        	" Auto école",
	}

	personalmenu.demarche = {
		"Normal",
		"Homme effiminer",
		"Bouffiasse",
		"Dépressif",
		"Dépressive",
		"Muscle",
		"Hipster",
		"Business",
		"Intimide",
		"Bourrer",
		"Malheureux",
		"Triste",
		"Choc",
		"Sombre",
		"Fatiguer",
		"Presser",
		"Frimeur",
		"Fier",
		"Petite course",
		"Pupute",
		"Impertinente",
		"Arrogante",
		"Blesser",
		"Trop manger",
		"Casual",
		"Determiner",
		"Peureux",
		"Trop Swag",
		"Travailleur",
		"Brute",
		"Rando",
		"Gangstère",
		"Gangster"
	}

	local gpsItem = NativeUI.CreateListItem(_U('mainmenu_gps_button'), personalmenu.gps, actualGPSIndex)
	menu:AddItem(gpsItem)
	local demarcheItem = NativeUI.CreateListItem(_U('mainmenu_approach_button'), personalmenu.demarche, actualDemarcheIndex)
	menu:AddItem(demarcheItem)

	menu.OnListSelect = function(sender, item, index)
		if item == gpsItem then
			actualGPS = item:IndexToItem(index)
			actualGPSIndex = index

			ESX.ShowNotification(_U('gps', actualGPS))

			if actualGPS == "Aucun" then
				local plyCoords = GetEntityCoords(plyPed)
				SetNewWaypoint(plyCoords.x, plyCoords.y)
			elseif actualGPS == "Poste de Police" then
				SetNewWaypoint(425.13, -979.55)
			elseif actualGPS == "Hôpital" then
				SetNewWaypoint(-449.67, -340.83)
			elseif actualGPS == "Concessionnaire" then
				SetNewWaypoint(-33.88, -1102.37)
			elseif actualGPS == "Garage Central" then
				SetNewWaypoint(101.41, -1067.61)
			elseif actualGPS == "Benny's Custom" then
				SetNewWaypoint(-212.13, -1325.27)
			elseif actualGPS == " Pôle Emploi" then
				SetNewWaypoint(-264.83, -964.54)
			elseif actualGPS == " Auto école" then
				SetNewWaypoint(232.96, -1388.44)
			end

		elseif item == demarcheItem then
			TriggerEvent('skinchanger:getSkin', function(skin)
				actualDemarche = item:IndexToItem(index)
				actualDemarcheIndex = index

				ESX.ShowNotification(_U('approach', actualDemarche))

				if actualDemarche == "Normal" then
					if skin.sex == 0 then
						startAttitude("move_m@multiplayer", "move_m@multiplayer")
					elseif skin.sex == 1 then
						startAttitude("move_f@multiplayer", "move_f@multiplayer")
					end
				elseif actualDemarche == "Homme effiminer" then
					startAttitude("move_m@confident", "move_m@confident")
				elseif actualDemarche == "Bouffiasse" then
					startAttitude("move_f@heels@c","move_f@heels@c")
				elseif actualDemarche == "Dépressif" then
					startAttitude("move_m@depressed@a","move_m@depressed@a")
				elseif actualDemarche == "Dépressive" then
					startAttitude("move_f@depressed@a","move_f@depressed@a")
				elseif actualDemarche == "Muscle" then
					startAttitude("move_m@muscle@a","move_m@muscle@a")
				elseif actualDemarche == "Hipster" then
					startAttitude("move_m@hipster@a","move_m@hipster@a")
				elseif actualDemarche == "Business" then
					startAttitude("move_m@business@a","move_m@business@a")
				elseif actualDemarche == "Intimide" then
					startAttitude("move_m@hurry@a","move_m@hurry@a")
				elseif actualDemarche == "Bourrer" then
					startAttitude("move_m@hobo@a","move_m@hobo@a")
				elseif actualDemarche == "Malheureux" then
					startAttitude("move_m@sad@a","move_m@sad@a")
				elseif actualDemarche == "Triste" then
					startAttitude("move_m@leaf_blower","move_m@leaf_blower")
				elseif actualDemarche == "Choc" then
					startAttitude("move_m@shocked@a","move_m@shocked@a")
				elseif actualDemarche == "Sombre" then
					startAttitude("move_m@shadyped@a","move_m@shadyped@a")
				elseif actualDemarche == "Fatiguer" then
					startAttitude("move_m@buzzed","move_m@buzzed")
				elseif actualDemarche == "Presser" then
					startAttitude("move_m@hurry_butch@a","move_m@hurry_butch@a")
				elseif actualDemarche == "Frimeur" then
					startAttitude("move_m@money","move_m@money")
				elseif actualDemarche == "Fier" then
					startAttitude("move_m@posh@","move_m@posh@")
				elseif actualDemarche == "Petite course" then
					startAttitude("move_m@quick","move_m@quick")
				elseif actualDemarche == "Pupute" then
					startAttitude("move_f@maneater","move_f@maneater")
				elseif actualDemarche == "Impertinente" then
					startAttitude("move_f@sassy","move_f@sassy")
				elseif actualDemarche == "Arrogante" then
					startAttitude("move_f@arrogant@a","move_f@arrogant@a")
				elseif actualDemarche == "Blesser" then
					startAttitude("move_m@injured","move_m@injured")
				elseif actualDemarche == "Trop manger" then
					startAttitude("move_m@fat@a","move_m@fat@a")
				elseif actualDemarche == "Casual" then
					startAttitude("move_m@casual@a","move_m@casual@a")
				elseif actualDemarche == "Determiner" then
					startAttitude("move_m@brave@a","move_m@brave@a")
				elseif actualDemarche == "Peureux" then
					startAttitude("move_m@scared","move_m@scared")
				elseif actualDemarche == "Trop Swag" then
					startAttitude("move_m@swagger@b","move_m@swagger@b")
				elseif actualDemarche == "Travailleur" then
					startAttitude("move_m@tool_belt@a","move_m@tool_belt@a")
				elseif actualDemarche == "Brute" then
					startAttitude("move_m@tough_guy@","move_m@tough_guy@")
				elseif actualDemarche == "Rando" then
					startAttitude("move_m@hiking","move_m@hiking")
				elseif actualDemarche == "Gangstère" then
					startAttitude("move_m@gangster@ng","move_m@gangster@ng")
				elseif actualDemarche == "Gangster" then
					startAttitude("move_m@gangster@generic","move_m@gangster@generic")
				end
			end)
		end
	end
end

function AddMenuAdminMenu(menu)
	adminMenu = _menuPool:AddSubMenu(menu, _U('admin_title'))

	if playerGroup == 'mod' then
		local tptoPlrItem = NativeUI.CreateItem(_U('admin_goto_button'), "")
		adminMenu.SubMenu:AddItem(tptoPlrItem)
		local tptoMeItem = NativeUI.CreateItem(_U('admin_bring_button'), "")
		adminMenu.SubMenu:AddItem(tptoMeItem)
		local tptoWaypointItem = NativeUI.CreateItem(_U('admin_tpmarker_button'), "")
		adminMenu.SubMenu:AddItem(tptoWaypointItem)
		local showXYZItem = NativeUI.CreateItem(_U('admin_showxyz_button'), "")
		adminMenu.SubMenu:AddItem(showXYZItem)
		local showPlrNameItem = NativeUI.CreateItem(_U('admin_showname_button'), "")
		adminMenu.SubMenu:AddItem(showPlrNameItem)
		local noclipItem = NativeUI.CreateItem(_U('admin_noclip_button'), "")
		adminMenu.SubMenu:AddItem(noclipItem)

		adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == tptoPlrItem then
				admin_tp_toplayer()
				_menuPool:CloseAllMenus()
			elseif item == tptoMeItem then
				admin_tp_playertome()
				_menuPool:CloseAllMenus()
			elseif item == showXYZItem then
				modo_showcoord()
			elseif item == showPlrNameItem then
				modo_showname()
			end
		end
	elseif playerGroup == 'admin' then
		local tptoPlrItem = NativeUI.CreateItem(_U('admin_goto_button'), "")
		adminMenu.SubMenu:AddItem(tptoPlrItem)
		local tptoMeItem = NativeUI.CreateItem(_U('admin_bring_button'), "")
		adminMenu.SubMenu:AddItem(tptoMeItem)
		local noclipItem = NativeUI.CreateItem(_U('admin_noclip_button'), "")
		adminMenu.SubMenu:AddItem(noclipItem)
		local repairVehItem = NativeUI.CreateItem(_U('admin_repairveh_button'), "")
		adminMenu.SubMenu:AddItem(repairVehItem)
		local returnVehItem = NativeUI.CreateItem(_U('admin_flipveh_button'), "")
		adminMenu.SubMenu:AddItem(returnVehItem)
		local showXYZItem = NativeUI.CreateItem(_U('admin_showxyz_button'), "")
		adminMenu.SubMenu:AddItem(showXYZItem)
		local showPlrNameItem = NativeUI.CreateItem(_U('admin_showname_button'), "")
		adminMenu.SubMenu:AddItem(showPlrNameItem)
		local tptoWaypointItem = NativeUI.CreateItem(_U('admin_tpmarker_button'), "")
		adminMenu.SubMenu:AddItem(tptoWaypointItem)
		local revivePlrItem = NativeUI.CreateItem(_U('admin_revive_button'), "")
		adminMenu.SubMenu:AddItem(revivePlrItem)

		adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == tptoPlrItem then
				admin_tp_toplayer()
				_menuPool:CloseAllMenus()
			elseif item == tptoMeItem then
				admin_tp_playertome()
				_menuPool:CloseAllMenus()
			elseif item == noclipItem then
				admin_no_clip()
				_menuPool:CloseAllMenus()
			elseif item == repairVehItem then
				admin_vehicle_repair()
			elseif item == returnVehItem then
				admin_vehicle_flip()
			elseif item == showXYZItem then
				modo_showcoord()
			elseif item == showPlrNameItem then
				modo_showname()
			elseif item == tptoWaypointItem then
				admin_tp_marker()
			elseif item == revivePlrItem then
				admin_heal_player()
				_menuPool:CloseAllMenus()
			end
		end
	elseif playerGroup == 'superadmin' or playerGroup == 'owner' then
		local tptoPlrItem = NativeUI.CreateItem(_U('admin_goto_button'), "")
		adminMenu.SubMenu:AddItem(tptoPlrItem)
		local tptoMeItem = NativeUI.CreateItem(_U('admin_bring_button'), "")
		adminMenu.SubMenu:AddItem(tptoMeItem)
		--local tptoXYZItem = NativeUI.CreateItem(_U('admin_tpxyz_button'), "")
		--adminMenu.SubMenu:AddItem(tptoXYZItem)
		local noclipItem = NativeUI.CreateItem(_U('admin_noclip_button'), "")
		adminMenu.SubMenu:AddItem(noclipItem)
		local godmodeItem = NativeUI.CreateItem(_U('admin_godmode_button'), "")
		adminMenu.SubMenu:AddItem(godmodeItem)
		local ghostmodeItem = NativeUI.CreateItem(_U('admin_ghostmode_button'), "")
		adminMenu.SubMenu:AddItem(ghostmodeItem)
		local spawnVehItem = NativeUI.CreateItem(_U('admin_spawnveh_button'), "")
		adminMenu.SubMenu:AddItem(spawnVehItem)
		local repairVehItem = NativeUI.CreateItem(_U('admin_repairveh_button'), "")
		adminMenu.SubMenu:AddItem(repairVehItem)
		local returnVehItem = NativeUI.CreateItem(_U('admin_flipveh_button'), "")
		adminMenu.SubMenu:AddItem(returnVehItem)
		local givecashItem = NativeUI.CreateItem(_U('admin_givemoney_button'), "")
		adminMenu.SubMenu:AddItem(givecashItem)
		local givebankItem = NativeUI.CreateItem(_U('admin_givebank_button'), "")
		adminMenu.SubMenu:AddItem(givebankItem)
		local givedirtyItem = NativeUI.CreateItem(_U('admin_givedirtymoney_button'), "")
		adminMenu.SubMenu:AddItem(givedirtyItem)
		local showXYZItem = NativeUI.CreateItem(_U('admin_showxyz_button'), "")
		adminMenu.SubMenu:AddItem(showXYZItem)
		local showPlrNameItem = NativeUI.CreateItem(_U('admin_showname_button'), "")
		adminMenu.SubMenu:AddItem(showPlrNameItem)
		local tptoWaypointItem = NativeUI.CreateItem(_U('admin_tpmarker_button'), "")
		adminMenu.SubMenu:AddItem(tptoWaypointItem)
		local revivePlrItem = NativeUI.CreateItem(_U('admin_revive_button'), "")
		adminMenu.SubMenu:AddItem(revivePlrItem)
		local skinPlrItem = NativeUI.CreateItem(_U('admin_changeskin_button'), "")
		adminMenu.SubMenu:AddItem(skinPlrItem)
		local saveSkinPlrItem = NativeUI.CreateItem(_U('admin_saveskin_button'), "")
		adminMenu.SubMenu:AddItem(saveSkinPlrItem)

		local superPoing = NativeUI.CreateItem("Poing explosif", "")
		adminMenu.SubMenu:AddItem(superPoing)

		adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == tptoPlrItem then
				admin_tp_toplayer()
				_menuPool:CloseAllMenus()
			elseif item == tptoMeItem then
				admin_tp_playertome()
				_menuPool:CloseAllMenus()
			--elseif item == tptoXYZItem then
				--admin_tp_pos()
				--_menuPool:CloseAllMenus()
			elseif item == noclipItem then
				admin_no_clip()
				_menuPool:CloseAllMenus()
			elseif item == godmodeItem then
				admin_godmode()
			elseif item == ghostmodeItem then
				admin_mode_fantome()
			elseif item == superPoing then
				admin_mode_poing()
			elseif item == spawnVehItem then
				admin_vehicle_spawn()
				_menuPool:CloseAllMenus()
			elseif item == repairVehItem then
				admin_vehicle_repair()
			elseif item == returnVehItem then
				admin_vehicle_flip()
			elseif item == givecashItem then
				admin_give_money()
				_menuPool:CloseAllMenus()
			elseif item == givebankItem then
				admin_give_bank()
				_menuPool:CloseAllMenus()
			elseif item == givedirtyItem then
				admin_give_dirty()
				_menuPool:CloseAllMenus()
			elseif item == showXYZItem then
				modo_showcoord()
			elseif item == showPlrNameItem then
				modo_showname()
			elseif item == tptoWaypointItem then
				admin_tp_marker()
			elseif item == revivePlrItem then
				admin_heal_player()
				_menuPool:CloseAllMenus()
			elseif item == skinPlrItem then
				changer_skin()
			elseif item == saveSkinPlrItem then
				save_skin()
			end
		end
	end
end
local PoingExplo = false
function admin_mode_poing()
	PoingExplo = not PoingExplo
end

Citizen.CreateThread(function()
	while true do
		Wait(0.1)
		if PoingExplo then
			
			SetExplosiveMeleeThisFrame(GetPlayerPed(-1))
		end
	end
end)
function GeneratePersonalMenu()	
	AddMenuInventoryMenu(mainMenu)
	AddMenuWeaponMenu(mainMenu)
	AddMenuWalletMenu(mainMenu)
	AddMenuClothesMenu(mainMenu)
	AddMenuAccessoryMenu(mainMenu)
	AddMenuAnimationMenu(mainMenu)
	AddMenuDiversMenu(mainMenu)

	if IsPedSittingInAnyVehicle(plyPed) then
		if (GetPedInVehicleSeat(GetVehiclePedIsIn(plyPed, false), -1) == plyPed) then
			AddMenuVehicleMenu(mainMenu)
		end
	end

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'capitaine' then
		AddMenuBossMenu(mainMenu)
	end

	if ESX.PlayerData.faction ~= nil and ESX.PlayerData.faction.grade_name == 'boss' then
		AddMenuBossMenu2(mainMenu)
	end

	AddMenuFacturesMenu(mainMenu)
	AddMenuDemarcheVoixGPS(mainMenu)

	if playerGroup ~= nil and (playerGroup == 'mod' or playerGroup == 'admin' or playerGroup == 'superadmin' or playerGroup == 'owner') then
		AddMenuAdminMenu(mainMenu)
	end

	_menuPool:RefreshIndex()
end

Citizen.CreateThread(function()
	while true do
		if IsControlJustReleased(0, Config.Menu.clavier) then
			if mainMenu ~= nil and not mainMenu:Visible() then
				ESX.PlayerData = ESX.GetPlayerData()
				GeneratePersonalMenu()
				mainMenu:Visible(true)
				Citizen.Wait(10)
			end
		end
		
		Citizen.Wait(1)
	end
end)

Citizen.CreateThread(function()
	while true do
		if _menuPool ~= nil then
			_menuPool:ProcessMenus()
		end
		
		Citizen.Wait(1)
	end
end)

Citizen.CreateThread(function()
	while true do
		while _menuPool ~= nil and _menuPool:IsAnyMenuOpen() do
			Citizen.Wait(1)

			if not _menuPool:IsAnyMenuOpen() then
				mainMenu:Clear()
				itemMenu:Clear()
				weaponItemMenu:Clear()

				_menuPool:Clear()
				_menuPool:Remove()

				personalmenu = {}

				invItem = {}
				wepItem = {}
				billItem = {}

				collectgarbage()

				_menuPool = NativeUI.CreatePool()

				mainMenu = NativeUI.CreateMenu(Config.servername, _U('mainmenu_subtitle'))
				itemMenu = NativeUI.CreateMenu(Config.servername, _U('inventory_actions_subtitle'))
				weaponItemMenu = NativeUI.CreateMenu(Config.servername, _U('loadout_actions_subtitle'))
				_menuPool:Add(mainMenu)
				_menuPool:Add(itemMenu)
				_menuPool:Add(weaponItemMenu)
			end
		end

		Citizen.Wait(1)
	end
end)

Citizen.CreateThread(function()
	while true do
		if ESX ~= nil then
			ESX.TriggerServerCallback('KorioZ-PersonalMenu:Admin_getUsergroup', function(group) playerGroup = group end)

			Citizen.Wait(30 * 1000)
		else
			Citizen.Wait(100)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		plyPed = PlayerPedId()
		
		if IsControlJustReleased(0, Config.stopAnim.clavier) and GetLastInputMethod(2) then
			ClearPedTasks(plyPed)
		end

		if playerGroup ~= nil and (playerGroup == 'mod' or playerGroup == 'admin' or playerGroup == 'superadmin' or playerGroup == 'owner') then
			if IsControlPressed(1, Config.TPMarker.clavier1) and IsControlJustReleased(1, Config.TPMarker.clavier2) and GetLastInputMethod(2) then
				admin_tp_marker()
			end
		end

		if showcoord then
			local playerPos = GetEntityCoords(plyPed)
			local playerHeading = GetEntityHeading(plyPed)
			Text("~r~X~s~: " .. playerPos.x .. " ~b~Y~s~: " .. playerPos.y .. " ~g~Z~s~: " .. playerPos.z .. " ~y~Angle~s~: " .. playerHeading)
		end

		if noclip then
			local x, y, z = getPosition()
			local dx, dy, dz = getCamDirection()
			local speed = Config.noclip_speed

			SetEntityVelocity(plyPed, 0.0001, 0.0001, 0.0001)

			if IsControlPressed(0, 32) then
				x = x + speed * dx
				y = y + speed * dy
				z = z + speed * dz
			end

			if IsControlPressed(0, 269) then
				x = x - speed * dx
				y = y - speed * dy
				z = z - speed * dz
			end

			SetEntityCoordsNoOffset(plyPed, x, y, z, true, true, true)
		end

		if showname then
			for id = 0, 255 do
				if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= plyPed then
					local headId = Citizen.InvokeNative(0xBFEFE3321A3F5015, GetPlayerPed(id), (GetPlayerServerId(id) .. ' - ' .. GetPlayerName(id)), false, false, "", false)
				end
			end
		end
		
		Citizen.Wait(1)
	end
end)