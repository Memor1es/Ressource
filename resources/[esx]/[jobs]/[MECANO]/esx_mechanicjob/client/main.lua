local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local CurrentlyTowedVehicle, Blips, NPCOnJob, NPCTargetTowable, NPCTargetTowableZone = nil, {}, false, nil, nil
local NPCHasSpawnedTowable, NPCLastCancel, NPCHasBeenNextToTowable, NPCTargetDeleterZone = false, GetGameTimer() - 5 * 60000, false, false
local isDead, isBusy = false, false

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
  
    while ESX.GetPlayerData().job == nil do
      Citizen.Wait(100)
    end
    
    PlayerData = ESX.GetPlayerData()
  end)

function SelectRandomTowable()
    local index = GetRandomIntInRange(1, #Config.Towables)

    for k, v in pairs(Config.Zones) do
        if v.Pos.x == Config.Towables[index].x and v.Pos.y == Config.Towables[index].y and v.Pos.z == Config.Towables[index].z then
            return k
        end
    end
end

function StartNPCJob()
    NPCOnJob = true

    NPCTargetTowableZone = SelectRandomTowable()
    local zone = Config.Zones[NPCTargetTowableZone]

    Blips['NPCTargetTowableZone'] = AddBlipForCoord(zone.Pos.x, zone.Pos.y, zone.Pos.z)
    SetBlipRoute(Blips['NPCTargetTowableZone'], true)

    ESX.ShowNotification(_U('drive_to_indicated'))
end

function StopNPCJob(cancel)
    if Blips['NPCTargetTowableZone'] then
        RemoveBlip(Blips['NPCTargetTowableZone'])
        Blips['NPCTargetTowableZone'] = nil
    end

    if Blips['NPCDelivery'] then
        RemoveBlip(Blips['NPCDelivery'])
        Blips['NPCDelivery'] = nil
    end

    Config.Zones.VehicleDelivery.Type = -1

    NPCOnJob = false
    NPCTargetTowable = nil
    NPCTargetTowableZone = nil
    NPCHasSpawnedTowable = false
    NPCHasBeenNextToTowable = false

    if cancel then
        ESX.ShowNotification(_U('mission_canceled'))
    else
        --TriggerServerEvent('esx_mechanicjob:onNPCJobCompleted')
    end
end

function OpenMechanicActionsMenu()
    local elements = {
        { label = _U('deposit_stock'), value = 'put_stock' },
        { label = _U('withdraw_stock'), value = 'get_stock' }
    }

    if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' then
        table.insert(elements, { label = _U('boss_actions'), value = 'boss_actions' })
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_actions', {
        css 	= 'Hollidays',
        title = _U('mechanic'),
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'put_stock' then
            OpenPutStocksMenu()
        elseif data.current.value == 'get_stock' then
            OpenGetStocksMenu()
        elseif data.current.value == 'boss_actions' then
            TriggerEvent('esx_society:openBossMenu', 'mechanic', function(data, menu)
                menu.close()
            end)
        end
    end, function(data, menu)
        menu.close()

        CurrentAction = 'mechanic_actions_menu'
        CurrentActionMsg = _U('open_actions')
        CurrentActionData = {}
    end)
end

function OpenMechanicHarvestMenu()
    if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name ~= 'recrue' then
        local elements = {
            { label = _U('gas_can'), value = 'gaz_bottle' },
            { label = _U('repair_tools'), value = 'fix_tool' },
            { label = _U('body_work_tools'), value = 'caro_tool' }
        }

        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_harvest', {
            css 	= 'Hollidays',
            title = _U('harvest'),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            menu.close()

            if data.current.value == 'gaz_bottle' then
                TriggerServerEvent('esx_mechanicjob:startHarvest')
            elseif data.current.value == 'fix_tool' then
                TriggerServerEvent('esx_mechanicjob:startHarvest2')
            elseif data.current.value == 'caro_tool' then
                TriggerServerEvent('esx_mechanicjob:startHarvest3')
            end
        end, function(data, menu)
            menu.close()
            CurrentAction = 'mechanic_harvest_menu'
            CurrentActionMsg = _U('harvest_menu')
            CurrentActionData = {}
        end)
    else
        ESX.ShowNotification(_U('not_experienced_enough'))
    end
end

function OpenMechanicCraftMenu()
    if Config.EnablePlayerManagement and ESX.PlayerData.job and ESX.PlayerData.job.grade_name ~= 'recrue' then
        local elements = {
            { label = _U('blowtorch'), value = 'blow_pipe' },
            { label = _U('repair_kit'), value = 'fix_kit' },
            { label = _U('body_kit'), value = 'caro_kit' }
        }

        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_craft', {
            css 	= 'Hollidays',
            title = _U('craft'),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            menu.close()

            if data.current.value == 'blow_pipe' then
                TriggerServerEvent('esx_mechanicjob:startCraft')
            elseif data.current.value == 'fix_kit' then
                TriggerServerEvent('esx_mechanicjob:startCraft2')
            elseif data.current.value == 'caro_kit' then
                TriggerServerEvent('esx_mechanicjob:startCraft3')
            end
        end, function(data, menu)
            menu.close()

            CurrentAction = 'mechanic_craft_menu'
            CurrentActionMsg = _U('craft_menu')
            CurrentActionData = {}
        end)
    else
        ESX.ShowNotification(_U('not_experienced_enough'))
    end
end

function OpenMobileMechanicActionsMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mechanic_actions', {
        css 	= 'Hollidays',
        title = _U('mechanic'),
        align = 'top-left',
        elements = {
            { label = _U('billing'), value = 'billing' },
            { label = _U('hijack'), value = 'hijack_vehicle' },
            { label = _U('repair'), value = 'fix_vehicle' },
            { label = _U('clean'), value = 'clean_vehicle' },
            { label = _U('imp_veh'), value = 'del_vehicle' },
            { label = _U('flat_bed'), value = 'dep_vehicle' },
            { label = _U('place_objects'), value = 'object_spawner' }
        } }, function(data, menu)
        if isBusy then
            return
        end

        if data.current.value == 'billing' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {  css 	= 'Hollidays',
                title = _U('invoice_amount')
            }, function(data, menu)
                local amount = tonumber(data.value)

                if amount == nil or amount < 0 then
                    ESX.ShowNotification(_U('amount_invalid'))
                else
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification(_U('no_players_nearby'))
                    else
                        menu.close()
                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mechanic', _U('mechanic'), amount)
                    end
                end
            end, function(data, menu)
                menu.close()
            end)
        elseif data.current.value == 'hijack_vehicle' then
            local playerPed = PlayerPedId()
            local vehicle = ESX.Game.GetVehicleInDirection()
            local coords = GetEntityCoords(playerPed)

            if IsPedSittingInAnyVehicle(playerPed) then
                ESX.ShowNotification(_U('inside_vehicle'))
                return
            end

            if DoesEntityExist(vehicle) then
                isBusy = true
                TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
                Citizen.CreateThread(function()
                    Citizen.Wait(10000)

                    SetVehicleDoorsLocked(vehicle, 1)
                    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                    ClearPedTasksImmediately(playerPed)

                    ESX.ShowNotification(_U('vehicle_unlocked'))
                    isBusy = false
                end)
            else
                ESX.ShowNotification(_U('no_vehicle_nearby'))
            end
        elseif data.current.value == 'fix_vehicle' then
            local playerPed = PlayerPedId()
            local vehicle = ESX.Game.GetVehicleInDirection()
            local coords = GetEntityCoords(playerPed)

            if IsPedSittingInAnyVehicle(playerPed) then
                ESX.ShowNotification(_U('inside_vehicle'))
                return
            end

            if DoesEntityExist(vehicle) then
                isBusy = true
                TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
                Citizen.CreateThread(function()
                    Citizen.Wait(20000)

                    SetVehicleFixed(vehicle)
                    SetVehicleDeformationFixed(vehicle)
                    SetVehicleUndriveable(vehicle, false)
                    SetVehicleEngineOn(vehicle, true, true)
                    ClearPedTasksImmediately(playerPed)

                    ESX.ShowNotification(_U('vehicle_repaired'))
                    isBusy = false
                end)
            else
                ESX.ShowNotification(_U('no_vehicle_nearby'))
            end
        elseif data.current.value == 'clean_vehicle' then
            local playerPed = PlayerPedId()
            local vehicle = ESX.Game.GetVehicleInDirection()
            local coords = GetEntityCoords(playerPed)

            if IsPedSittingInAnyVehicle(playerPed) then
                ESX.ShowNotification(_U('inside_vehicle'))
                return
            end

            if DoesEntityExist(vehicle) then
                isBusy = true
                TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
                Citizen.CreateThread(function()
                    Citizen.Wait(10000)

                    SetVehicleDirtLevel(vehicle, 0)
                    ClearPedTasksImmediately(playerPed)

                    ESX.ShowNotification(_U('vehicle_cleaned'))
                    isBusy = false
                end)
            else
                ESX.ShowNotification(_U('no_vehicle_nearby'))
            end
        elseif data.current.value == 'del_vehicle' then
            local playerPed = PlayerPedId()

            if IsPedSittingInAnyVehicle(playerPed) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)

                if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                    ESX.ShowNotification(_U('vehicle_impounded'))
                    ESX.Game.DeleteVehicle(vehicle)
                else
                    ESX.ShowNotification(_U('must_seat_driver'))
                end
            else
                local vehicle = ESX.Game.GetVehicleInDirection()

                if DoesEntityExist(vehicle) then
                    ESX.ShowNotification(_U('vehicle_impounded'))
                    ESX.Game.DeleteVehicle(vehicle)
                else
                    ESX.ShowNotification(_U('must_near'))
                end
            end
        elseif data.current.value == 'dep_vehicle' then
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, true)

            local towmodel = GetHashKey('flatbed')

            local isVehicleTow = IsVehicleModel(vehicle, towmodel)
            Citizen.Trace(("Model vehicle tow : %s"):format(isVehicleTow))

            local targetVehicle = ESX.Game.GetVehicleInDirection()
            Citizen.Trace(("Target Vehicle : %s"):format(targetVehicle))

            if isVehicleTow then
                local targetVehicle = ESX.Game.GetVehicleInDirection()

                if CurrentlyTowedVehicle == nil then
                    if targetVehicle ~= 0 then
                        if not IsPedInAnyVehicle(playerPed, true) then
                            if vehicle ~= targetVehicle then
                                AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                                CurrentlyTowedVehicle = targetVehicle
                                ESX.ShowNotification(_U('vehicle_success_attached'))

                                if NPCOnJob then
                                    if NPCTargetTowable == targetVehicle then
                                        ESX.ShowNotification(_U('please_drop_off'))
                                        Config.Zones.VehicleDelivery.Type = 1

                                        if Blips['NPCTargetTowableZone'] then
                                            RemoveBlip(Blips['NPCTargetTowableZone'])
                                            Blips['NPCTargetTowableZone'] = nil
                                        end

                                        Blips['NPCDelivery'] = AddBlipForCoord(Config.Zones.VehicleDelivery.Pos.x, Config.Zones.VehicleDelivery.Pos.y, Config.Zones.VehicleDelivery.Pos.z)
                                        SetBlipRoute(Blips['NPCDelivery'], true)
                                    end
                                end
                            else
                                ESX.ShowNotification(_U('cant_attach_own_tt'))
                            end
                        end
                    else
                        ESX.ShowNotification(_U('no_veh_att'))
                    end
                else
                    AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                    DetachEntity(CurrentlyTowedVehicle, true, true)

                    if NPCOnJob then
                        if NPCTargetDeleterZone then

                            if CurrentlyTowedVehicle == NPCTargetTowable then
                                ESX.Game.DeleteVehicle(NPCTargetTowable)
                                TriggerServerEvent('esx_mechanicjob:onNPCJobMissionCompleted')
                                StopNPCJob()
                                NPCTargetDeleterZone = false
                            else
                                ESX.ShowNotification(_U('not_right_veh'))
                            end

                        else
                            ESX.ShowNotification(_U('not_right_place'))
                        end
                    end

                    CurrentlyTowedVehicle = nil
                    ESX.ShowNotification(_U('veh_det_succ'))
                end
            else
                ESX.ShowNotification(_U('imp_flatbed'))
            end
        elseif data.current.value == 'object_spawner' then
            local playerPed = PlayerPedId()

            if IsPedSittingInAnyVehicle(playerPed) then
                ESX.ShowNotification(_U('inside_vehicle'))
                return
            end

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mechanic_actions_spawn', {
                css 	= 'Hollidays',
                title = _U('objects'),
                align = 'top-left',
                elements = {
                    { label = _U('roadcone'), value = 'prop_roadcone02a' },
                    { label = _U('toolbox'), value = 'prop_toolchest_01' }
                } }, function(data2, menu2)
                local model = data2.current.value
                local coords = GetEntityCoords(playerPed)
                local forward = GetEntityForwardVector(playerPed)
                local x, y, z = table.unpack(coords + forward * 1.0)

                if model == 'prop_roadcone02a' then
                    z = z - 2.0
                elseif model == 'prop_toolchest_01' then
                    z = z - 2.0
                end

                ESX.Game.SpawnObject(model, { x = x, y = y, z = z }, function(obj)
                    SetEntityHeading(obj, GetEntityHeading(playerPed))
                    PlaceObjectOnGroundProperly(obj)
                end)
            end, function(data2, menu2)
                menu2.close()
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenGetStocksMenu()
    ESX.TriggerServerCallback('esx_mechanicjob:getStockItems', function(items)
        local elements = {}

        for i = 1, #items, 1 do
            table.insert(elements, {
                label = 'x' .. items[i].count .. ' ' .. items[i].label,
                value = items[i].name
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css 	= 'Hollidays',
            title = _U('mechanic_stock'),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
                title = _U('quantity')
            }, function(data2, menu2)
                local count = tonumber(data2.value)

                if count == nil then
                    ESX.ShowNotification(_U('invalid_quantity'))
                else
                    menu2.close()
                    menu.close()
                    TriggerServerEvent('esx_mechanicjob:getStockItem', itemName, count)

                    Citizen.Wait(1000)
                    OpenGetStocksMenu()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function OpenPutStocksMenu()
    ESX.TriggerServerCallback('esx_mechanicjob:getPlayerInventory', function(inventory)
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
            css 	= 'Hollidays',
            title = _U('inventory'),
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', { css 	= 'Hollidays',
                title = _U('quantity')
            }, function(data2, menu2)
                local count = tonumber(data2.value)

                if count == nil then
                    ESX.ShowNotification(_U('invalid_quantity'))
                else
                    menu2.close()
                    menu.close()
                    TriggerServerEvent('esx_mechanicjob:putStockItems', itemName, count)

                    Citizen.Wait(1000)
                    OpenPutStocksMenu()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

--Vestiaire
function OpenMechanicCloakroomMenu()
    local elements = {
        { label = _U('work_wear'), value = 'cloakroom' },
        { label = _U('civ_wear'), value = 'cloakroom2' }
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_cloakroom', {
        css 	= 'Hollidays',
        title = _U('mechanic'),
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'cloakroom' then
            menu.close()
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                else
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                end
            end)
        elseif data.current.value == 'cloakroom2' then
            menu.close()
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        end
    end, function(data, menu)
        menu.close()

        CurrentAction = 'mechanic_cloakroom_menu'
        CurrentActionMsg = _U('open_actions')
        CurrentActionData = {}
    end)
end

--Vehicles
function OpenMechanicVehiclesMenu()
    local elements = {
        { label = _U('vehicle_list'), value = 'vehicle_list' }
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_vehicles', {

        css 	= 'Hollidays',
        title = _U('mechanic'),
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'vehicle_list' then
            if Config.EnableSocietyOwnedVehicles then

                local elements = {}

                ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(vehicles)
                    for i = 1, #vehicles, 1 do
                        table.insert(elements, {
                            label = GetDisplayNameFromVehicleModel(vehicles[i].model) .. ' [' .. vehicles[i].plate .. ']',
                            value = vehicles[i]
                        })
                    end

                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
                        css 	= 'Hollidays',
                        title = _U('service_vehicle'),
                        align = 'top-left',
                        elements = elements
                    }, function(data, menu)
                        menu.close()
                        local vehicleProps = data.current.value

                        ESX.Game.SpawnVehicle(vehicleProps.model, Config.Zones.VehicleSpawnPoint.Pos, 270.0, function(vehicle)
                            ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
                            local playerPed = PlayerPedId()
                            local plate = GetVehicleNumberPlateText(vehicle)
                            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                            TriggerServerEvent('esx_vehiclelock:givekey', 'no', plate) -- vehicle lock
                        end)

                        TriggerServerEvent('esx_society:removeVehicleFromGarage', 'mechanic', vehicleProps)
                    end, function(data, menu)
                        menu.close()
                    end)
                end, 'mechanic')

            else

                local elements = {
                    { label = _U('flat_bed'), value = 'flatbed' },
                    { label = _U('tow_truck'), value = 'towtruck2' }
                }

                if Config.EnablePlayerManagement and ESX.PlayerData.job and (ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'chief' or ESX.PlayerData.job.grade_name == 'experimente') then
                    table.insert(elements, { label = 'Sadler', value = 'sadler' })
                end

                ESX.UI.Menu.CloseAll()

                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle', {
                    css 	= 'Hollidays',
                    title = _U('service_vehicle'),
                    align = 'top-left',
                    elements = elements
                }, function(data, menu)
                    if Config.MaxInService == -1 then
                        ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
                            local playerPed = PlayerPedId()
                            local plate = GetVehicleNumberPlateText(vehicle)
                            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                            TriggerServerEvent('esx_vehiclelock:givekey', 'no', plate) -- vehicle lock
                        end)
                    else
                        ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
                            if canTakeService then
                                ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 90.0, function(vehicle)
                                    local playerPed = PlayerPedId()
                                    local plate = GetVehicleNumberPlateText(vehicle)
                                    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                                    TriggerServerEvent('esx_vehiclelock:givekey', 'no', plate) -- vehicle lock
                                end)
                            else
                                ESX.ShowNotification(_U('service_full') .. inServiceCount .. '/' .. maxInService)
                            end
                        end, 'mechanic')
                    end

                    menu.close()
                end, function(data, menu)
                    menu.close()
                    OpenMechanicVehiclesMenu()
                end)

            end
        end
    end, function(data, menu)
        menu.close()

        CurrentAction = 'mechanic_vehicles_menu'
        CurrentActionMsg = _U('open_actions')
        CurrentActionData = {}
    end)
end

RegisterNetEvent('esx_mechanicjob:onHijack')
AddEventHandler('esx_mechanicjob:onHijack', function()
    local playerPed = PlayerPedId()
    local vehicle = ESX.Game.GetVehicleInDirection()
    local coords = GetEntityCoords(playerPed)

    if IsPedSittingInAnyVehicle(playerPed) then
        ESX.ShowNotification(_U('inside_vehicle'))
        return
    end

    local chance = math.random(100)
    local alarm = math.random(100)

    if DoesEntityExist(vehicle) then
        if alarm <= 60 then
            SetVehicleAlarm(vehicle, true)
            StartVehicleAlarm(vehicle)
        end

        TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)

        Citizen.CreateThread(function()
            Citizen.Wait(10000)
            if chance <= 30 then
                SetVehicleDoorsLocked(vehicle, 1)
                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                ClearPedTasksImmediately(playerPed)
                ESX.ShowNotification(_U('veh_unlocked'))
            else
                ESX.ShowNotification(_U('hijack_failed'))
                ClearPedTasksImmediately(playerPed)
            end
        end)
    end
end)

RegisterNetEvent('esx_mechanicjob:onCarokit')
AddEventHandler('esx_mechanicjob:onCarokit', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        local vehicle

        if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
        else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        end

        if DoesEntityExist(vehicle) then
            TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_HAMMERING', 0, true)
            Citizen.CreateThread(function()
                Citizen.Wait(10000)
                SetVehicleFixed(vehicle)
                SetVehicleDeformationFixed(vehicle)
                ClearPedTasksImmediately(playerPed)
                ESX.ShowNotification(_U('body_repaired'))
            end)
        end
    end
end)

RegisterNetEvent('esx_mechanicjob:onFixkit')
AddEventHandler('esx_mechanicjob:onFixkit', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        local vehicle

        if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
        else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
        end

        if DoesEntityExist(vehicle) then
            TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
            Citizen.CreateThread(function()
                Citizen.Wait(20000)
                SetVehicleFixed(vehicle)
                SetVehicleDeformationFixed(vehicle)
                SetVehicleUndriveable(vehicle, false)
                ClearPedTasksImmediately(playerPed)
                ESX.ShowNotification(_U('veh_repaired'))
            end)
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

AddEventHandler('esx_mechanicjob:hasEnteredMarker', function(zone)
    if zone == 'NPCJobTargetTowable' then

    elseif zone == 'VehicleDelivery' then
        NPCTargetDeleterZone = true
    elseif zone == 'MechanicActions' then
        CurrentAction = 'mechanic_actions_menu'
        CurrentActionMsg = _U('open_actions')
        CurrentActionData = {}
    elseif zone == 'Garage' then
        CurrentAction = 'mechanic_harvest_menu'
        CurrentActionMsg = _U('harvest_menu')
        CurrentActionData = {}
    elseif zone == 'Craft' then
        CurrentAction = 'mechanic_craft_menu'
        CurrentActionMsg = _U('craft_menu')
        CurrentActionData = {}
    elseif zone == 'MechanicCloakroom' then
        CurrentAction = 'mechanic_cloakroom_menu'
        CurrentActionMsg = _U('open_actions')
        CurrentActionData = {}
    elseif zone == 'MechanicVehicles' then
        CurrentAction = 'mechanic_vehicles_menu'
        CurrentActionMsg = _U('open_actions')
        CurrentActionData = {}
    elseif zone == 'VehicleDeleter' then
        local playerPed = PlayerPedId()

        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            CurrentAction = 'delete_vehicle'
            CurrentActionMsg = _U('veh_stored')
            CurrentActionData = { vehicle = vehicle }
        end
    end
end)

AddEventHandler('esx_mechanicjob:hasExitedMarker', function(zone)
    if zone == 'VehicleDelivery' then
        NPCTargetDeleterZone = false
    elseif zone == 'Craft' then
        TriggerServerEvent('esx_mechanicjob:stopCraft')
        TriggerServerEvent('esx_mechanicjob:stopCraft2')
        TriggerServerEvent('esx_mechanicjob:stopCraft3')
    elseif zone == 'Garage' then
        TriggerServerEvent('esx_mechanicjob:stopHarvest')
        TriggerServerEvent('esx_mechanicjob:stopHarvest2')
        TriggerServerEvent('esx_mechanicjob:stopHarvest3')
    end

    CurrentAction = nil
    ESX.UI.Menu.CloseAll()
end)

AddEventHandler('esx_mechanicjob:hasEnteredEntityZone', function(entity)
    local playerPed = PlayerPedId()

    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' and not IsPedInAnyVehicle(playerPed, false) then
        CurrentAction = 'remove_entity'
        CurrentActionMsg = _U('press_remove_obj')
        CurrentActionData = { entity = entity }
    end
end)

AddEventHandler('esx_mechanicjob:hasExitedEntityZone', function(entity)
    if CurrentAction == 'remove_entity' then
        CurrentAction = nil
    end
end)


-- Pop NPC mission vehicle when inside area
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)

        if NPCTargetTowableZone and not NPCHasSpawnedTowable then
            local coords = GetEntityCoords(PlayerPedId())
            local zone = Config.Zones[NPCTargetTowableZone]

            if GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < Config.NPCSpawnDistance then
                local model = Config.Vehicles[GetRandomIntInRange(1, #Config.Vehicles)]

                ESX.Game.SpawnVehicle(model, zone.Pos, 0, function(vehicle)
                    NPCTargetTowable = vehicle
                end)

                NPCHasSpawnedTowable = true
            end
        end

        if NPCTargetTowableZone and NPCHasSpawnedTowable and not NPCHasBeenNextToTowable then
            local coords = GetEntityCoords(PlayerPedId())
            local zone = Config.Zones[NPCTargetTowableZone]

            if GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < Config.NPCNextToDistance then
                ESX.ShowNotification(_U('please_tow'))
                NPCHasBeenNextToTowable = true
            end
        end
    end
end)



-- Create Blips
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(Config.Zones.MechanicActions.Pos.x, Config.Zones.MechanicActions.Pos.y, Config.Zones.MechanicActions.Pos.z)

    SetBlipSprite(blip, 446)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(_U('mechanic'))
    EndTextCommandSetBlipName(blip)
end)

-- Display markers
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
            local coords, letSleep = GetEntityCoords(PlayerPedId()), true

            for k, v in pairs(Config.Zones) do
                if v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
                    DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, nil, nil, false)
                    letSleep = false
                end
            end

            if letSleep then
                Citizen.Wait(500)
            end
        else
            Citizen.Wait(500)
        end
    end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)

        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then

            local coords = GetEntityCoords(PlayerPedId())
            local isInMarker = false
            local currentZone = nil

            for k, v in pairs(Config.Zones) do
                if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                    isInMarker = true
                    currentZone = k
                end
            end

            if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                HasAlreadyEnteredMarker = true
                LastZone = currentZone
                TriggerEvent('esx_mechanicjob:hasEnteredMarker', currentZone)
            end

            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('esx_mechanicjob:hasExitedMarker', LastZone)
            end

        end
    end
end)

Citizen.CreateThread(function()
    local trackedEntities = {
        'prop_roadcone02a',
        'prop_toolchest_01'
    }

    while true do
        Citizen.Wait(500)

        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        local closestDistance = -1
        local closestEntity = nil

        for i = 1, #trackedEntities, 1 do
            local object = GetClosestObjectOfType(coords, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

            if DoesEntityExist(object) then
                local objCoords = GetEntityCoords(object)
                local distance = GetDistanceBetweenCoords(coords, objCoords, true)

                if closestDistance == -1 or closestDistance > distance then
                    closestDistance = distance
                    closestEntity = object
                end
            end
        end

        if closestDistance ~= -1 and closestDistance <= 3.0 then
            if LastEntity ~= closestEntity then
                TriggerEvent('esx_mechanicjob:hasEnteredEntityZone', closestEntity)
                LastEntity = closestEntity
            end
        else
            if LastEntity then
                TriggerEvent('esx_mechanicjob:hasExitedEntityZone', LastEntity)
                LastEntity = nil
            end
        end
    end
end)

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if CurrentAction then
            ESX.ShowHelpNotification(CurrentActionMsg)

            if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then

                if CurrentAction == 'mechanic_actions_menu' then
                    OpenMechanicActionsMenu()
                elseif CurrentAction == 'mechanic_harvest_menu' then
                    OpenMechanicHarvestMenu()
                elseif CurrentAction == 'mechanic_craft_menu' then
                    OpenMechanicCraftMenu()
                elseif CurrentAction == 'mechanic_cloakroom_menu' then
                    OpenMechanicCloakroomMenu()
                elseif CurrentAction == 'mechanic_vehicles_menu' then
                    OpenMechanicVehiclesMenu()
                elseif CurrentAction == 'delete_vehicle' then

                    if Config.EnableSocietyOwnedVehicles then

                        local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
                        TriggerServerEvent('esx_society:putVehicleInGarage', 'mechanic', vehicleProps)

                    else

                        if
                        GetEntityModel(vehicle) == GetHashKey('flatbed') or
                                GetEntityModel(vehicle) == GetHashKey('towtruck2') or
                                GetEntityModel(vehicle) == GetHashKey('slamvan3')
                        then
                            TriggerServerEvent('esx_service:disableService', 'mechanic')
                        end

                    end

                    ESX.Game.DeleteVehicle(CurrentActionData.vehicle)

                elseif CurrentAction == 'remove_entity' then
                    --DeleteEntity(CurrentActionData.entity)
                    NetworkRegisterEntityAsNetworked(CurrentActionData.entity)
                    Citizen.Wait(100)

                    NetworkRequestControlOfEntity(CurrentActionData.entity)

                    if not IsEntityAMissionEntity(CurrentActionData.entity) then
                        SetEntityAsMissionEntity(CurrentActionData.entity)
                    end

                    Citizen.Wait(100)
                    DeleteEntity(CurrentActionData.entity)
                end

                CurrentAction = nil
            end
        end

        if IsControlJustReleased(0, 167) and not isDead and ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
            OpenMobileMechanicActionsMenu()
        end

        if IsControlJustReleased(0, 178) and not isDead and ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
            if NPCOnJob then
                if GetGameTimer() - NPCLastCancel > 5 * 60000 then
                    StopNPCJob(true)
                    NPCLastCancel = GetGameTimer()
                else
                    ESX.ShowNotification(_U('wait_five'))
                end
            else
                local playerPed = PlayerPedId()

                if IsPedInAnyVehicle(playerPed, false) and IsVehicleModel(GetVehiclePedIsIn(playerPed, false), GetHashKey('flatbed')) then
                    StartNPCJob()
                else
                    ESX.ShowNotification(_U('must_in_flatbed'))
                end
            end
        end

    end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
    isDead = false
end)

local ShowLineGrueHelp = true
local VehicleModelKeyFlatBed = GetHashKey('flatbed')
local KEY_E = 38
local KEY_UP = 96 -- N+
local KEY_DOWN = 97 -- N-
local KEY_CLOSE = 177


local function GetVehicleInDirection( coordFrom, coordTo )
	local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
	local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
	return vehicle
end

local function flatBed()
	local myPed = GetPlayerPed(-1)
    local myCoord = GetEntityCoords(myPed)
    local currentVehicle = GetVehiclePedIsIn(myPed, 0)

    if currentVehicle == 0 then
        -- a pied
        local flatbed = GetClosestVehicle(myCoord.x, myCoord.y, myCoord.z, 10.0, VehicleModelKeyFlatBed, 70)
        if flatbed ~= 0 then
            local coords = GetOffsetFromEntityInWorldCoords(flatbed, -1.5, -5.2, 0)
            local dist = GetDistanceBetweenCoords(myCoord.x, myCoord.y, myCoord.z, coords.x, coords.y, coords.z, true)
            if dist < 10 then
                DrawMarker(1, coords.x, coords.y, coords.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 200, 0, 0, 0, 0)
            end
            if dist < 1.5 then

                -- local c1 = GetOffsetFromEntityInWorldCoords(flatbed, -1.0, -1.4, 1.2)
                -- local c2 = GetOffsetFromEntityInWorldCoords(flatbed, 1.0, -1.4, 1.2)

                local c1 = GetOffsetFromEntityInWorldCoords(flatbed, -2.0, -1.2, 1.2)
                local c2 = GetOffsetFromEntityInWorldCoords(flatbed, 2.0, -1.2, 1.2)
                -- DrawLine(c1.x, c1.y, c1.z, c2.x, c2.y, c2.z, 0, 255, 0, 255)
                local cvg = GetVehicleInDirection(c1, c2)
                --local cvg = GetEntityAttachedTo(flatbed)
                -- restart depanneur
                if cvg ~= 0 and GetEntityAttachedTo(cvg) == flatbed then
					BeginTextCommandDisplayHelp("STRING")
                    AddTextComponentString('~g~E~s~ Détacher le véhicule')
					EndTextCommandDisplayHelp(0, 0, 1, -1)
                    if IsControlJustPressed(1, KEY_E) then
                        DetachEntity(cvg, true, true)
                        local c = GetOffsetFromEntityInWorldCoords(flatbed, 0.0, -10.0, 0)
                        SetEntityCoords(cvg, c.x, c.y, c.z)
                        SetVehicleOnGroundProperly(cvg)
                    end
                else
                    local c1 = GetOffsetFromEntityInWorldCoords(flatbed, 0.0, -7.3, 1.8)
                    local c2 = GetOffsetFromEntityInWorldCoords(flatbed, 0.0, -7.3, -1.2)
                    local vehicleGrap = GetVehicleInDirection(c1, c2)
                    if ShowLineGrueHelp == true then
                        if vehicleGrap ~= 0 then
                            DrawLine(c1.x, c1.y, c1.z, c2.x, c2.y, c2.z, 0, 255, 0, 255)
                        else
                            DrawLine(c1.x, c1.y, c1.z, c2.x, c2.y, c2.z, 255, 0, 0, 255)
                        end
                    end

                    if vehicleGrap ~= 0 then
                        SetTextComponentFormat("STRING")
                        AddTextComponentString('~g~E~s~ Attacher le véhicule')
                        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                        if IsControlJustPressed(1, KEY_E) then
							NetworkRequestControlOfDoor(vehicleGrap)

							for i = 1, 10 do
								AttachEntityToEntity(vehicleGrap, flatbed, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, true, false, true, false, 20, true)
								print("attached")
							end
							--AttachEntityToEntityPhysically(vehicleGrap, flatbed, 20, 0,-0.5, -5.0, 1.0, 0.0, 0.0, 0.0, ,0,0,0,false, false, false, false, 20, true)
							print('called ')
						end
                    else
						BeginTextCommandDisplayHelp("STRING")
                        AddTextComponentString('Aucun véhicule a  porté')
						EndTextCommandDisplayHelp(0, 0, 1, -1)
                        if IsControlJustPressed(1, KEY_E) then
                            DetachEntity(flatbed, true, true)
                        end
                    end
                end
            end
        end
    else
        if ShowLineGrueHelp == true then
            local inFlatBed = IsVehicleModel(currentVehicle, VehicleModelKeyFlatBed)
            if inFlatBed then
                local c1 = GetOffsetFromEntityInWorldCoords(currentVehicle, 0.0, -7.3, 1.8)
                local c2 = GetOffsetFromEntityInWorldCoords(currentVehicle, 0.0, -7.3, -1.2)
                local vehicleGrap = GetVehicleInDirection(c1, c2)
                if vehicleGrap ~= 0 then
                    DrawLine(c1.x, c1.y, c1.z, c2.x, c2.y, c2.z, 0, 255, 0, 255)
                else
                    DrawLine(c1.x, c1.y, c1.z, c2.x, c2.y, c2.z, 255, 0, 0, 255)
                end

            end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			flatBed();
		end
    end
end)