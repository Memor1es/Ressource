local GUI = {}
GUI.Time = 0
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local HasAlreadyEnteredMarker = false
local LastStation = nil
local LastPart = nil
local LastPartNum = nil
local LastEntity = nil
local hintIsShowed = false
local hintToDisplay = "no hint to display"
local PlayerData = {}

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().faction == nil do
        Citizen.Wait(100)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setFaction')
AddEventHandler('esx:setFaction', function(faction)
    ESX.PlayerData.faction = faction
end)

function SetVehicleMaxMods(vehicle)
    local props = {
        modEngine = 2,
        modBrakes = 2,
        modTransmission = 2,
        modSuspension = 3,
        modTurbo = true,
    }

    ESX.Game.SetVehicleProperties(vehicle, props)
end

function OpenWeaponDealerActionsMenu()
    local elements = {
        {label = 'Déposer Stock', value = 'put_stock'},
        {label = 'Prendre Stock', value = 'get_stock'},
        {label = '-------------', value = nil},
        {label = 'Déposer Armes', value = 'put_weapons'},
        {label = 'Prendre Armes', value = 'get_weapons'},
        {label = '-------------', value = nil},
        {label = 'Déposer Argent Sale', value = 'get_black_money'},
        {label = 'Prendre Argent Sale', value = 'put_black_money'},
        {label = '-------------', value = nil },
        {label = 'Menu armory', value = 'menu_armory'},
      }
    if Config.EnablePlayerManagement and ESX.PlayerData.faction ~= nil and ESX.PlayerData.faction.grade_name == 'boss' then
        table.insert(elements, { label = '-------------', value = nil })
        table.insert(elements, { label = 'Actions Boss', value = 'faction_actions' })
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'weapondealer_actions',
    {
        title = 'weapondealer',
        elements = elements
    },
    function(data, menu)
        if data.current.value == 'get_weapons' then
            OpenGetWeaponsweapondealer()
        elseif data.current.value == 'put_weapons' then
            OpenPutWeaponsweapondealer()
        elseif data.current.value == 'put_stock' then
            OpenPutStocksweapondealerMenu()
        elseif data.current.value == 'get_stock' then
            OpenGetStocksweapondealerMenu()
        elseif data.current.value == 'get_black_money' then
            OpenGetBlackMoneyWeaponDealer()
        elseif data.current.value == 'put_black_money' then
            OpenPutBlackMoneyWeaponDealer()
        elseif data.current.value == 'menu_armory' then
            OpenArmoryMenu()
        elseif data.current.value == 'faction_actions' then
            TriggerEvent('esx_societyfaction:openBossMenuFaction', 'weapondealer', function(data, menu)
                menu.close()
            end)
        end
    end,
    function(data, menu)
        menu.close()
        CurrentAction = 'weapondealer_actions_menu'
        CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
        CurrentActionData = {}
    end
    )
end

function OpenweapondealerCloakroomMenu()
    ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'cloakroom_weapondealer',
            {
                title = 'cloakroom',
                align = 'top-left',
                elements = {
                    { label = 'Tenue Civil', value = 'citizen_wear' },
                    { label = 'Tenue weapondealer', value = 'weapondealer_wear' }
                },
            },
            function(data, menu)
                menu.close()
                if data.current.value == 'citizen_wear' then
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, factionSkin)
                        TriggerEvent('skinchanger:loadSkin', skin)
                    end)
                end

                if data.current.value == 'weapondealer_wear' then
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkinFaction', function(skin, factionSkin)

                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadClothes', skin, factionSkin.skin_male)
                        else
                            TriggerEvent('skinchanger:loadClothes', skin, factionSkin.skin_female)
                        end

                    end)
                end

                CurrentAction = 'weapondealer_cloakroom_menu'
                CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au vestiaire.'
                CurrentActionData = {}
            end,
            function(data, menu)
                menu.close()
            end
    )
end

function OpenweapondealerGarageMenu()
    local elements = {
        { label = 'Liste Véhicules', value = 'vehicle_list' }
    }
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'weapondealer_garage',
            {
                title = 'weapondealer',
                elements = elements
            },
            function(data, menu)
                if data.current.value == 'vehicle_list' then

                    if Config.EnableSocietyOwnedVehicles then
                        local elements = {}

                        ESX.TriggerServerCallback('esx_societyfaction:getVehiclesInGarage', function(vehicles)

                            for i = 1, #vehicles, 1 do
                                table.insert(elements, { label = GetDisplayNameFromVehicleModel(vehicles[i].model) .. ' [' .. vehicles[i].plate .. ']', value = vehicles[i] })
                            end

                            ESX.UI.Menu.Open(
                                    'default', GetCurrentResourceName(), 'vehicle_spawner',
                                    {
                                        title = 'Véhicule weapondealer',
                                        align = 'top-left',
                                        elements = elements,
                                    },
                                    function(data, menu)
                                        menu.close()
                                        local playerPed = GetPlayerPed(-1)
                                        local vehicleProps = data.current.value
                                        local platenum = math.random(0001, 9999)

                                        ESX.Game.SpawnVehicle(vehicleProps.model, Config.WeaponDealer.VehicleWeaponDealerSpawnPoint.Pos, 68.565, function(vehicle)
                                            ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
                                            SetVehicleNumberPlateText(vehicle, "WPD" .. platenum)
                                            SetVehicleColours(vehicle, 12, 12)
                        					SetVehicleWindowTint(vehicle, 1)
                                            SetVehicleMaxMods(vehicle)
                                            SetEntityHeading(vehicle, 203.72)
                                            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                            local plate = GetVehicleNumberPlateText(vehicle)
                                            plate = string.gsub(plate, " ", "")
                                            TriggerServerEvent('esx_vehiclelock:givekey', 'no', plate) -- vehicle lock
                                        end)

                                        TriggerServerEvent('esx_faction:removeVehicleFromGarageFaction', 'weapondealer', vehicleProps)
                                    end,
                                    function(data, menu)
                                        menu.close()
                                    end
                            )
                        end, 'weapondealer')

                    else


                        local elements = {
                            {label = 'BF400', value = 'bf400'},
                            {label = 'Tailgater', value = 'tailgater'},
                            {label = 'Granger', value = 'granger'}
                        }
                        ESX.UI.Menu.CloseAll()
                        ESX.UI.Menu.Open(
                                'default', GetCurrentResourceName(), 'spawn_vehicle',
                                {
                                    title = 'Véhicule weapondealer',
                                    elements = elements
                                },
                                function(data, menu)

                                    for i = 1, #elements, 1 do

                                        local model = data.current.value
                                        local platenum = math.random(0001, 9999)
                                        local playerPed = GetPlayerPed(-1)

                                        if Config.MaxInService == -1 then

                                            ESX.Game.SpawnVehicle(data.current.value, Config.WeaponDealer.VehicleWeaponDealerSpawnPoint.Pos, 68.565, function(vehicle)
                                                SetVehicleNumberPlateText(vehicle, "WPD" .. platenum)
                                                SetVehicleColours(vehicle, 12, 12)
                       							SetVehicleWindowTint(vehicle, 1)
                                                SetVehicleMaxMods(vehicle)
                                                SetEntityHeading(vehicle, 195.83)
                                                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                                local plate = GetVehicleNumberPlateText(vehicle)
                                                plate = string.gsub(plate, " ", "")
                                                TriggerServerEvent('esx_vehiclelock:givekey', 'no', plate) -- vehicle lock
                                            end)

                                            break

                                        else

                                            ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

                                                if canTakeService then
                                                    ESX.Game.SpawnVehicle(data.current.value, Config.WeaponDealer.VehicleWeaponDealerSpawnPoint.Pos, 68.565, function(vehicle)
                                                        SetVehicleNumberPlateText(vehicle, "WPD" .. platenum)
                                                        SetVehicleColours(vehicle, 12, 12)
                       									SetVehicleWindowTint(vehicle, 1)
                                                        SetVehicleMaxMods(vehicle)
                                                        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                                    end)
                                                else
                                                    ESX.ShowNotification('service_full' .. inServiceCount .. '/' .. maxInService)
                                                end
                                            end, 'weapondealer')
                                            break
                                        end
                                    end
                                    menu.close()
                                end,
                                function(data, menu)
                                    menu.close()
                                    OpenWeaponDealerActionsMenu()
                                end
                        )
                    end
                end
            end,
            function(data, menu)
                menu.close()

                CurrentAction = 'weapondealer_garage_menu'
                CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage.'
                CurrentActionData = {}
            end
    )
end

-- Stock Items weapondealer
function OpenGetStocksweapondealerMenu()
    ESX.TriggerServerCallback('esx_weapondealer:getStockItemsweapondealer', function(items)
        local elements = {}

        for i = 1, #items, 1 do
            table.insert(elements, {
                label = 'x' .. items[i].count .. ' ' .. items[i].label,
                value = items[i].name
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css = 'entreprise',
            title = 'weapondealer',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
                title = 'Quantité'
            }, function(data2, menu2)
                local count = tonumber(data2.value)

                if count == nil then
                    ESX.ShowNotification('Quantité invalide')
                else
                    menu2.close()
                    menu.close()
                    TriggerServerEvent('esx_weapondealer:getStockItemsweapondealer', itemName, count)

                    Citizen.Wait(1000)
                    OpenGetStocksweapondealerMenu()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function OpenPutStocksweapondealerMenu()
    ESX.TriggerServerCallback('esx_faction:getPlayerInventory', function(inventory)
        local elements = {}

        for i = 1, #inventory.items, 1 do
            local item = inventory.items[i]

            if item.count > 0 then
                table.insert(elements, {
                    label = item.label .. ' x' .. item.count,
                    type = 'item_standard',
                    value = item.name
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css = 'Inventaire',
            title = 'Inventaire',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
                title = 'Quantité'
            }, function(data2, menu2)
                local count = tonumber(data2.value)

                if count == nil then
                    ESX.ShowNotification('Quantité invalide')
                else
                    menu2.close()
                    menu.close()
                    TriggerServerEvent('esx_weapondealer:putStockItemsweapondealer', itemName, count)

                    Citizen.Wait(1000)
                    OpenPutStocksweapondealerMenu()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

AddEventHandler('esx_weapondealer:hasEnteredMarkerweapondealer', function(zone, station, part, partNum)

    if zone == 'WeaponDealerActions' then
        CurrentAction = 'weapondealer_actions_menu'
        CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu.'
        CurrentActionData = {}
    elseif zone == 'CloakroomWeaponDealer' then
        CurrentAction = 'weapondealer_cloakroom_menu'
        CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au vestiaire.'
        CurrentActionData = {}
    elseif zone == 'GarageWeaponDealer' then
        CurrentAction = 'weapondealer_garage_menu'
        CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage.'
        CurrentActionData = {}
    elseif zone == 'VehicleWeaponDealerDeleter' then
        local playerPed = GetPlayerPed(-1)
        if IsPedInAnyVehicle(playerPed, false) then
            CurrentAction = 'delete_vehicle'
            CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule.'
            CurrentActionData = {}
        end
    end
end)

AddEventHandler('esx_weapondealer:hasExitedMarkerweapondealer', function(zone, station, part, partNum)
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)

-- Display markers
Citizen.CreateThread(function()
    while true do

        Citizen.Wait(0)

        if ESX.PlayerData.faction ~= nil and ESX.PlayerData.faction.name == 'weapondealer' then
            local playerPed = GetPlayerPed(-1)
            local coords = GetEntityCoords(GetPlayerPed(-1))

            for k, v in pairs(Config.WeaponDealer) do
                if (v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
                    DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                end
            end

        end

    end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if ESX.PlayerData.faction ~= nil and ESX.PlayerData.faction.name == 'weapondealer' then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            local isInMarker = false
            local currentZone = nil
            local currentStation = nil
            local currentPart = nil
            local currentPartNum = nil

            for k, v in pairs(Config.WeaponDealer) do
                if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                    isInMarker = true
                    currentZone = k
                end
            end

            local hasExited = false

            if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastZone ~= currentZone or LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then

                if
                (LastZone ~= nil and LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
                        (LastZone ~= currentZone or LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
                then
                    TriggerEvent('esx_weapondealer:hasExitedMarkerweapondealer', LastZone, LastStation, LastPart, LastPartNum)
                    hasExited = true
                end

                HasAlreadyEnteredMarker = true
                LastZone = currentZone
                LastStation = currentStation
                LastPart = currentPart
                LastPartNum = currentPartNum

                TriggerEvent('esx_weapondealer:hasEnteredMarkerweapondealer', currentZone, currentStation, currentPart, currentPartNum)
            end

            if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('esx_weapondealer:hasExitedMarkerweapondealer', LastZone, LastStation, LastPart, LastPartNum)
            end

        end

    end
end)

--[[   WEAPON    ]]--
function OpenArmoryMenu()
    local elements = {
        { label = 'Acheter Armes', value = 'buy_weapons' }
    }
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
        css = 'armurielspd',
        title = 'Armurerie',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'buy_weapons' then
            OpenBuyWeaponsMenu()
        end
    end, function(data, menu)
        menu.close()
        CurrentAction = 'menu_armory'
        CurrentActionMsg = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder à l\'armurerie'
    end)
end

function OpenGetWeaponMenu()
    ESX.TriggerServerCallback('esx_weapondealer:getArmoryWeapons', function(weapons)
        local elements = {}

        for i = 1, #weapons, 1 do
            if weapons[i].count > 0 then
                table.insert(elements, {
                    label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
                    value = weapons[i].name
                })
            end
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
            css = 'suicidsquad',
            title = 'Armurerie - Retirer arme',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            menu.close()

            ESX.TriggerServerCallback('esx_weapondealer:removeArmoryWeapon', function()
                OpenGetWeaponMenu()
            end, data.current.value)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

local AuthorizedWeapons = {
    boss = {
        { weapon = 'WEAPON_MICROSMG', price = 130000 },
        { weapon = 'WEAPON_MINISMG', price = 140000 },
        { weapon = 'WEAPON_SMG', price = 220000 },
        { weapon = 'WEAPON_COMPACTRIFLE', price = 140000 },
        { weapon = 'WEAPON_ASSAULTRIFLE', price = 250000 },
        { weapon = 'WEAPON_PISTOL50', price = 45000 },
        { weapon = 'WEAPON_SAWNOFFSHOTGUN', price = 115000 },
        { weapon = 'WEAPON_BULLPUPSHOTGUN', price = 180000 },
        { weapon = 'WEAPON_SNIPERRIFLE', price = 300000 },
        { weapon = 'WEAPON_SWITCHBLADE', price = 25000 },
        { weapon = 'WEAPON_MOLOTOV', price = 230000 },
    }
}

function OpenBuyWeaponsMenu()
    local elements = {}
    local playerPed = PlayerPedId()
    PlayerData = ESX.GetPlayerData()

    for k, v in ipairs(AuthorizedWeapons['boss']) do
        local weaponNum, weapon = ESX.GetWeapon(v.weapon)
        local components, label = {}
        local hasWeapon = HasPedGotWeapon(playerPed, GetHashKey(v.weapon), false)

        label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, ESX.Math.GroupDigits(v.price))

        table.insert(elements, {
            label = label,
            weaponLabel = weapon.label,
            name = weapon.name,
            components = components,
            price = v.price,
            hasWeapon = hasWeapon
        })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons', {
        css = 'armurielspd',
        title = 'Armurerie - Acheter une arme',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.hasWeapon then
            if #data.current.components > 0 then
                OpenWeaponComponentShop(data.current.components, data.current.name, menu)
            end
        else

            ESX.TriggerServerCallback('esx_weapondealer:buyWeapon', function(bought)
                if bought then
                    if data.current.price > 0 then
                        ESX.ShowNotification(string.format('Vous achetez un ~y~%s~s~ pour ~r~$%s~s~', data.current.weaponLabel, ESX.Math.GroupDigits(data.current.price)))
                    end

                    menu.close()
                    OpenBuyWeaponsMenu()
                else
                    ESX.ShowNotification('Vous ne pouvez pas acheter cette arme')
                end
            end, data.current.name, 1)

        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenWeaponComponentShop(components, weaponName, parentShop)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons_components', {
        css = 'armurielspd',
        title = 'Armurerie - Accessoires d\'armes',
        align = 'top-left',
        elements = components
    }, function(data, menu)
        if data.current.hasComponent then
            ESX.ShowNotification('Vous avez cet accessoire équipé!')
        else
            ESX.TriggerServerCallback('esx_weapondealer:buyWeapon', function(bought)
                if bought then
                    if data.current.price > 0 then
                        ESX.ShowNotification(string.format('Vous achetez un ~y~%s~s~ pour ~r~$%s~s~', data.current.weaponLabel, ESX.Math.GroupDigits(data.current.price)))
                    end

                    menu.close()
                    parentShop.close()
                    OpenBuyWeaponsMenu()
                else
                    print(bought)
                    print(bought)
                    print(bought)
                    print(bought)
                    print('sex')
                    ESX.ShowNotification('Vous ne pouvez pas acheter cette arme')
                end
            end, weaponName, 2, data.current.componentNum)
        end
    end, function(data, menu)
        menu.close()
    end)
end









-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if CurrentAction ~= nil then

            SetTextComponentFormat('STRING')
            AddTextComponentString(CurrentActionMsg)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)

            if IsControlPressed(0, 38) and ESX.PlayerData.faction ~= nil and ESX.PlayerData.faction.name == 'weapondealer' and (GetGameTimer() - GUI.Time) > 300 then

                if CurrentAction == 'weapondealer_actions_menu' then
                    OpenWeaponDealerActionsMenu()
                elseif CurrentAction == 'weapondealer_cloakroom_menu' then
                    OpenweapondealerCloakroomMenu()
                elseif CurrentAction == 'weapondealer_garage_menu' then
                    OpenweapondealerGarageMenu()
                elseif CurrentAction == 'delete_vehicle' then

                    local playerPed = GetPlayerPed(-1)
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    local hash = GetEntityModel(vehicle)
                    local plate = GetVehicleNumberPlateText(vehicle)
                    if hash == GetHashKey('tailgater') or hash == GetHashKey('bf400') or hash == GetHashKey('granger') then
                        if Config.MaxInService ~= -1 then
                            TriggerServerEvent('esx_service:disableService', 'weapondealer')
                        end
                        DeleteVehicle(vehicle)
                        TriggerServerEvent('esx_vehiclelock:deletekeyjobs', 'no', plate) --vehicle lock
                    else
                        ESX.ShowNotification('Vous ne pouvez ranger que des ~b~véhicules de Faction~s~.')
                    end

                end

                CurrentAction = nil
                GUI.Time = GetGameTimer()

            end

        end
    end
end)

-- TELEPORTERS
AddEventHandler('esx_weapondealer:teleportMarkers', function(position)
    SetEntityCoords(GetPlayerPed(-1), position.x, position.y, position.z)
end)

-- Show top left hint
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if hintIsShowed == true then
            SetTextComponentFormat("STRING")
            AddTextComponentString(hintToDisplay)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
        end
    end
end)

--[[
-- Display teleport markers
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    if ESX.PlayerData.faction ~= nil and ESX.PlayerData.faction.name == 'weapondealer' then
      local coords = GetEntityCoords(GetPlayerPed(-1))

      for k,v in pairs(Config.TeleportZonesweapondealer) do
        if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
          DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
        end
      end

    end

  end
end)
]]--

--[[
-- Activate teleport marker
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local position = nil
    local zone = nil

    if  ESX.PlayerData.faction ~= nil and  ESX.PlayerData.faction.name == 'weapondealer' then

      for k,v in pairs(Config.TeleportZonesweapondealer) do
        if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
          isInPublicMarker = true
          position = v.Teleport
          zone = v
          break
        else
          isInPublicMarker  = false
        end
      end

      if IsControlJustReleased(0, 38) and isInPublicMarker then
        TriggerEvent('esx_weapondealer:teleportMarkers', position)
      end

      -- hide or show top left zone hints
      if isInPublicMarker then
        hintToDisplay = zone.Hint
        hintIsShowed = true
      else
        if not isInMarker then
          hintToDisplay = "no hint to display"
          hintIsShowed = false
        end
      end

    end

  end
end)
]]

function OpenGetWeaponsweapondealer()
    ESX.TriggerServerCallback('esx_weapondealer:getweapondealerWeapons', function(weapons)
        local elements = {}

        for i = 1, #weapons, 1 do
            if weapons[i].count > 0 then
                table.insert(elements, {
                    label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
                    value = weapons[i].name
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
            title = 'Prendre armes',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            menu.close()

            ESX.TriggerServerCallback('esx_weapondealer:removeweapondealerWeapon', function()
                OpenGetWeaponsweapondealer()
            end, data.current.value)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function OpenPutWeaponsweapondealer()
    local elements = {}
    local playerPed = PlayerPedId()
    local weaponList = ESX.GetWeaponList()

    for i = 1, #weaponList, 1 do
        local weaponHash = GetHashKey(weaponList[i].name)

        if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
            table.insert(elements, {
                label = weaponList[i].label,
                value = weaponList[i].name
            })
        end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
        title = 'Déposer armes',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        menu.close()
        ESX.TriggerServerCallback('esx_weapondealer:addweapondealerWeapon', function()
            OpenPutWeaponsweapondealer()
        end, data.current.value, true)
    end, function(data, menu)
        menu.close()
    end)
end

function OpenGetBlackMoneyWeaponDealer()

    ESX.TriggerServerCallback('esx_faction:getPlayerInventory2', function(inventory)
  
      local elements = {}
  
      table.insert(elements, {label = 'Argent sale: ' .. inventory.blackMoney, type = 'item_account', value = 'black_money'})
  
      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'put_black_money',
        {
          title = 'Inventaire',
          align = 'top-left',
          elements = elements,
        },
        function(data, menu)
  
          ESX.UI.Menu.Open(
            'dialog', GetCurrentResourceName(), 'put_item_count',
            {
              title = 'Montant',
            },
            function(data2, menu)
  
              menu.close()
  
              TriggerServerEvent('esx_weapondealer:getBlackMoney', data.current.type, data.current.value, tonumber(data2.value))
  
              ESX.SetTimeout(300, function()
                OpenGetBlackMoneyWeaponDealer()
              end)
  
            end,
            function(data2,menu)
              menu.close()
            end
          )
  
        end,
        function(data, menu)
          menu.close()
        end
      )
    end)
  end
  
  function OpenPutBlackMoneyWeaponDealer()
  
    ESX.TriggerServerCallback('esx_weapondealer:getBlackMoney', function(inventory)
  
      local elements = {}
      table.insert(elements, {label = 'Argent sale: ' .. inventory.blackMoney, type = 'item_account', value = 'black_money'})
  
      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'get_black_money',
        {
          title = 'Inventaire',
          align = 'top-left',
          elements = elements,
        },
        function(data, menu)
          ESX.UI.Menu.Open(
            'dialog', GetCurrentResourceName(), 'get_item_count',
            {
              title = 'Montant',
            },
            function(data2, menu)
  
              local quantity = tonumber(data2.value)
  
              if quantity == nil then
                ESX.ShowNotification('Montant invalide')
              else
                menu.close()
                TriggerServerEvent('esx_weapondealer:getPutMoney', data.current.type, data.current.value, quantity)
                ESX.SetTimeout(300, function()
                  OpenPutBlackMoneyWeaponDealer()
                end)
              end
            end,
            function(data2,menu)
              menu.close()
            end
          )
        end,
        function(data, menu)
          menu.close()
        end
      )
    end)
  end