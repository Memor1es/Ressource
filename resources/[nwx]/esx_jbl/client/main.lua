ESX = nil
local menuOpen = false
local wasOpen = false
local lastEntity = nil
local currentAction = nil
local currentData = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx_jbl:place_jbl')
AddEventHandler('esx_jbl:place_jbl', function()
    startAnimation("anim@heists@money_grab@briefcase","put_down_case")
    Citizen.Wait(1000)
    ClearPedTasks(PlayerPedId())
    TriggerEvent('esx:spawnObject', 'prop_boombox_01')
end)

RegisterNetEvent('esx_jbl:play_music')
AddEventHandler('esx_jbl:play_music', function(id, object)
    if distance(object) < Config.distance then
        SendNUIMessage({
            transactionType = 'playSound',
            transactionData = id		
        })
		
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(100)
                if distance(object) > Config.distance then
                    SendNUIMessage({
                        transactionType = 'volume',
                        transactionData = 0.0
                    })
                end
            end
        end)		
    end
end)

RegisterNetEvent('esx_jbl:stop_music')
AddEventHandler('esx_jbl:stop_music', function(object)
    if distance(object) < Config.distance then
        SendNUIMessage({
            transactionType = 'stopSound'
        })
    end
end)

RegisterNetEvent('esx_jbl:setVolume')
AddEventHandler('esx_jbl:setVolume', function(volume, object)
    if distance(object) < Config.distance then
        SendNUIMessage({
            transactionType = 'volume',
            transactionData = volume
        })
    end
end)

function distance(object)
    local playerPed = PlayerPedId()
    local lCoords = GetEntityCoords(playerPed)
    local distance = GetDistanceBetweenCoords(lCoords, object, true)
    return distance
end

function OpenhifiMenu()
    menuOpen = true
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'jbl', {
	css = 'Hollidays',
        title = 'Enceinte JBL',
        align = 'top-left',
        elements = {
            {label = _U('get_jbl'), value = 'get_jbl'},
            {label = _U('play_music'), value = 'play'},
            {label = _U('volume_music'), value = 'volume'},
            {label = _U('stop_music'), value = 'stop'}
        }
    }, function(data, menu)
        local playerPed = PlayerPedId()
        local lCoords = GetEntityCoords(playerPed)
        if data.current.value == 'get_jbl' then
            ESX.PlayerData = ESX.GetPlayerData()
            local alreadyOne = false
            for i=1, #ESX.PlayerData.inventory, 1 do
                if ESX.PlayerData.inventory[i].name == 'jbl' and ESX.PlayerData.inventory[i].count > 0 then
                    alreadyOne = true
                end
            end
            if not alreadyOne then
                NetworkRequestControlOfEntity(currentData)
                menu.close()
                menuOpen = false
                startAnimation("anim@heists@narcotics@trash","pickup")
                Citizen.Wait(700)
                SetEntityAsMissionEntity(currentData,false,true)
                DeleteEntity(currentData)
                ESX.Game.DeleteObject(currentData)
                if not DoesEntityExist(currentData) then
                    TriggerServerEvent('esx_jbl:remove_jbl', lCoords)
                    currentData = nil
                end
                Citizen.Wait(500)
                ClearPedTasks(PlayerPedId())
            else
                menu.close()
                menuOpen = false
                TriggerEvent('esx:showNotification', _U('jbl_alreadyOne'))
            end
        elseif data.current.value == 'play' then
            play(lCoords)
        elseif data.current.value == 'stop' then
            TriggerServerEvent('esx_jbl:stop_music', lCoords)
            menuOpen = false
            menu.close()
        elseif data.current.value == 'volume' then
            setVolume(lCoords)
        end
    end, function(data, menu)
        menuOpen = false
        menu.close()
    end)
end

function setVolume(coords)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'setvolume',
        {
		css = 'Hollidays',
            title = _U('set_volume'),
        }, function(data, menu)
            local value = tonumber(data.value)
            if value < 0 or value > 100 then
                ESX.ShowNotification(_U('sound_limit'))
            else
                TriggerServerEvent('esx_jbl:setVolume', value, coords)
                menu.close()
            end
        end, function(data, menu)
            menu.close()
        end)
end


function play(coords)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'play',
        {	css = 'Hollidays',
            title = 'CODE - Video Youtube',
        }, function(data, menu)
            TriggerServerEvent('esx_jbl:play_music', data.value, coords)
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        local closestDistance = -1
        local closestEntity = nil

        local object = GetClosestObjectOfType(coords, 3.0, GetHashKey('prop_boombox_01'), false, false, false)

        if DoesEntityExist(object) then
            local objCoords = GetEntityCoords(object)
            local distance = GetDistanceBetweenCoords(coords, objCoords, true)

            if closestDistance == -1 or closestDistance > distance then
                closestDistance = distance
                closestEntity = object
            end
        end

        if closestDistance ~= -1 and closestDistance <= 3.0 then
            if lastEntity ~= closestEntity and not menuOpen then
                ESX.ShowHelpNotification(_U('jbl_help'))
                lastEntity = closestEntity
                currentAction = "music"
                currentData = closestEntity
                SendNUIMessage({
                    transactionType = 'volume',
                    transactionData = 40.0
                })				
            end
        else
            if lastEntity then
                lastEntity = nil
                currentAction = nil
                currentData = nil
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if currentAction then
            if IsControlJustReleased(0, 38) and currentAction == 'music' then
                OpenhifiMenu()
            end
        end
    end
end)

function startAnimation(lib,anim)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
    end)
end