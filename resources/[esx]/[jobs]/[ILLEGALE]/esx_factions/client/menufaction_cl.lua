local GUI = {}
GUI.Time = 0
local PlayerData = {}
PlayerData.faction = {name = nil, faction_grade = nil, faction_label = nil, faction_grade_label = nil, faction_grade_name = nil}

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

  PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setFaction')
AddEventHandler('esx:setFaction', function(faction)
  PlayerData.faction = faction
  Citizen.Wait(2500)
end)

function OpenBanditsMenu()

ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'bandits_actions',
    {
      css = 'Hollidays',
      title = 'Menu Organisation',
      align = 'top-left',
      elements = {
        {label = 'Intéraction Civil', value = 'citizen_interaction'}
      },
    },
    function(data, menu)

      if data.current.value == 'citizen_interaction' then

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'citizen_interaction',
          {
	    css = 'Hollidays',
            title = 'Intéraction Victime',
            align = 'top-left',
            elements = {
              {label = 'Faire les poches', value = 'body_search'},
              {label = 'Ligotter/Enlever', value = 'handcuff'},
              {label = 'Kidnapper', value = 'drag'},
              {label = 'Mettre de force dans Véhicule', value = 'put_in_vehicle'},
              {label = 'Ejecter de la voiture', value = 'out_the_vehicle'}
            },
          },
		         
          function(data2, menu2)  
            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

              if data2.current.value == 'identity_card' then
                OpenIdentityCardMenu(player)
              elseif data2.current.value == 'body_search' then
                OpenBodySearchMenu(player)
              elseif data2.current.value == 'handcuff' then
                TriggerServerEvent('esx_faction:handcuff', GetPlayerServerId(player))
              elseif data2.current.value == 'drag' then
                TriggerServerEvent('esx_faction:drag', GetPlayerServerId(player))
              elseif data2.current.value == 'put_in_vehicle' then
                TriggerServerEvent('esx_faction:putInVehicle', GetPlayerServerId(player))
              elseif data2.current.value == 'out_the_vehicle' then
                TriggerServerEvent('esx_faction:OutVehicle', GetPlayerServerId(player))
              end
            else
              ESX.ShowNotification('no_players_nearby')
            end
          end,
          function(data2, menu2)
            menu2.close()
          end
        )
      end

    end,
    function(data, menu)
      menu.close()
    end
  )
end

function OpenBodySearchMenu(player)
  ESX.TriggerServerCallback('esx_faction:getOtherPlayerData', function(data)
    local elements = {}
    local blackMoney = 0

    for i=1, #data.accounts, 1 do
      if data.accounts[i].name == 'black_money' then
        blackMoney = data.accounts[i].money
      end
    end

    table.insert(elements, {
      label = 'confisquer argent sale : $' .. blackMoney,
      value = 'black_money',
      itemType = 'item_account',
      amount = blackMoney
    })

    table.insert(elements, {label = '--- Armes ---', value = nil})

    for i=1, #data.weapons, 1 do
      table.insert(elements, {
        label = 'confisquer ' .. ESX.GetWeaponLabel(data.weapons[i].name),
        value = data.weapons[i].name,
        itemType = 'item_weapon',
        amount = data.ammo,
      })
    end

    table.insert(elements, {label = '--- Inventaire ---', value = nil})

    for i=1, #data.inventory, 1 do
      if data.inventory[i].count > 0 then
        table.insert(elements, {
          label = 'confisquer x' .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
          value = data.inventory[i].name,
          itemType = 'item_standard',
          amount = data.inventory[i].count,
        })
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'body_search',
      {
	css = 'Hollidays',
        title = 'Faire les poches',
        align = 'top-left',
        elements = elements,
      },
      function(data, menu)

        local itemType = data.current.itemType
        local itemName = data.current.value
        local amount = data.current.amount

        if data.current.value ~= nil then

          TriggerServerEvent('esx_faction:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)

          OpenBodySearchMenu(player)

        end

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, GetPlayerServerId(player))

end

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsDisabledControlJustReleased(0, 168) and PlayerData.faction ~= nil and PlayerData.faction.grade_name ~= 'recrue' then
            OpenBanditsMenu()
        end 
    end
end)

RegisterNetEvent('esx_faction:handcuff')
AddEventHandler('esx_faction:handcuff', function()

  IsHandcuffed = not IsHandcuffed;
  local playerPed = GetPlayerPed(-1)

  Citizen.CreateThread(function()

    if IsHandcuffed then

      RequestAnimDict('mp_arresting')

      while not HasAnimDictLoaded('mp_arresting') do
        Citizen.Wait(10)
      end

      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      FreezeEntityPosition(playerPed, true)

    else

      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed, true)
      FreezeEntityPosition(playerPed, false)

    end

  end)
end)


RegisterNetEvent('esx_faction:drag')
AddEventHandler('esx_faction:drag', function(cop)
  TriggerServerEvent('esx:clientLog', 'starting dragging')
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if IsHandcuffed then
      if IsDragged then
        local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
        local myped = GetPlayerPed(-1)
        AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
      else
        DetachEntity(GetPlayerPed(-1), true, false)
      end
    end
  end
end)


RegisterNetEvent('esx_faction:putInVehicle')
AddEventHandler('esx_faction:putInVehicle', function()

  local playerPed = GetPlayerPed(-1)
  local coords = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

    if DoesEntityExist(vehicle) then

      local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
      local freeSeat = nil

      for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle, i) then
          freeSeat = i
          break
        end
      end

      if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
      end

    end

  end

end)


RegisterNetEvent('esx_faction:OutVehicle')
AddEventHandler('esx_faction:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
  local xnew = plyPos.x+2
  local ynew = plyPos.y+2

  SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)


-- Handcuff
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
    if IsHandcuffed then
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 30, true) -- MoveLeftRight
      DisableControlAction(0, 31, true) -- MoveUpDown
    end
  end
end)