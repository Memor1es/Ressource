--EAT SANDWICH(Hot-Dog)
RegisterNetEvent('esx_basicneeds:sandwich')
AddEventHandler('esx_basicneeds:sandwich', function()

  local playerPed = GetPlayerPed(-1)
  local coords = GetEntityCoords(playerPed)

  Citizen.CreateThread(function()
    
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local boneIndex = GetPedBoneIndex(playerPed, 18905)
    local boneIndex2 = GetPedBoneIndex(playerPed, 57005)

      RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
        
    while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
      Citizen.Wait(1)
    end
    
    ESX.Game.SpawnObject('prop_sandwich_01', {x = coords.x, y = coords.y, z = coords.z - 3}, function(object)

    Citizen.CreateThread(function()
    
      TaskPlayAnim(playerPed, "amb@code_human_wander_eating_donut@male@idle_a", "idle_c", 3.5, -8, -1, 49, 0, 0, 0, 0)
      AttachEntityToEntity(object, playerPed, boneIndex2, 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
      Citizen.Wait(6500)
      DeleteObject(object)
      ClearPedSecondaryTask(playerPed)
      end)
    end)
  end)
end)

--EAT HAMBURGER
RegisterNetEvent('esx_basicneeds:hamburger')
AddEventHandler('esx_basicneeds:hamburger', function()

  local playerPed = GetPlayerPed(-1)
  local coords = GetEntityCoords(playerPed)

  Citizen.CreateThread(function()
    
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local boneIndex = GetPedBoneIndex(playerPed, 18905)
    local boneIndex2 = GetPedBoneIndex(playerPed, 57005)

      RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
        
    while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
      Citizen.Wait(1)
    end
    
    ESX.Game.SpawnObject('prop_cs_burger_01', {x = coords.x, y = coords.y, z = coords.z - 3}, function(object)

    Citizen.CreateThread(function()
    
      TaskPlayAnim(playerPed, "amb@code_human_wander_eating_donut@male@idle_a", "idle_c", 3.5, -8, -1, 49, 0, 0, 0, 0)
      AttachEntityToEntity(object, playerPed, boneIndex2, 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
      Citizen.Wait(6500)
      DeleteObject(object)
      ClearPedSecondaryTask(playerPed)
      end)
    end)
  end)
end)

--EAT FISHBURGER
RegisterNetEvent('esx_basicneeds:fishburger')
AddEventHandler('esx_basicneeds:fishburger', function()

  local playerPed = GetPlayerPed(-1)
  local coords = GetEntityCoords(playerPed)

  Citizen.CreateThread(function()
    
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local boneIndex = GetPedBoneIndex(playerPed, 18905)
    local boneIndex2 = GetPedBoneIndex(playerPed, 57005)

      RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
        
    while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
      Citizen.Wait(1)
    end
    
    ESX.Game.SpawnObject('prop_cs_burger_01', {x = coords.x, y = coords.y, z = coords.z - 3}, function(object)

    Citizen.CreateThread(function()
    
      TaskPlayAnim(playerPed, "amb@code_human_wander_eating_donut@male@idle_a", "idle_c", 3.5, -8, -1, 49, 0, 0, 0, 0)
      AttachEntityToEntity(object, playerPed, boneIndex2, 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
      Citizen.Wait(6500)
      DeleteObject(object)
      ClearPedSecondaryTask(playerPed)
      end)
    end)
  end)
end)

--EAT VEGANBURGER
RegisterNetEvent('esx_basicneeds:veganburger')
AddEventHandler('esx_basicneeds:veganburger', function()

  local playerPed = GetPlayerPed(-1)
  local coords = GetEntityCoords(playerPed)

  Citizen.CreateThread(function()
    
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local boneIndex  = GetPedBoneIndex(playerPed, 18905)
    local boneIndex2 = GetPedBoneIndex(playerPed, 57005)

      RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
        
    while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
      Citizen.Wait(1)
    end
    
    ESX.Game.SpawnObject('prop_cs_burger_01', {x = coords.x, y = coords.y, z = coords.z - 3}, function(object)

    Citizen.CreateThread(function()
    
      TaskPlayAnim(playerPed, "amb@code_human_wander_eating_donut@male@idle_a", "idle_c", 3.5, -8, -1, 49, 0, 0, 0, 0)
      AttachEntityToEntity(object, playerPed, boneIndex2, 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
      Citizen.Wait(6500)
      DeleteObject(object)
      ClearPedSecondaryTask(playerPed)
      end)
    end)
  end)
end)

--EAT HOTDOG
RegisterNetEvent('esx_basicneeds:hotdog')
AddEventHandler('esx_basicneeds:hotdog', function()

  local playerPed = GetPlayerPed(-1)
  local coords = GetEntityCoords(playerPed)

  Citizen.CreateThread(function()
    
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local boneIndex  = GetPedBoneIndex(playerPed, 18905)
    local boneIndex2 = GetPedBoneIndex(playerPed, 57005)

      RequestAnimDict('amb@code_human_wander_eating_donut@male@idle_a')
        
    while not HasAnimDictLoaded('amb@code_human_wander_eating_donut@male@idle_a') do
      Citizen.Wait(1)
    end
    
    ESX.Game.SpawnObject('prop_cs_hotdog_01', {x = coords.x, y = coords.y, z = coords.z - 3}, function(object)

    Citizen.CreateThread(function()
    
      TaskPlayAnim(playerPed, "amb@code_human_wander_eating_donut@male@idle_a", "idle_c", 3.5, -8, -1, 49, 0, 0, 0, 0)
      AttachEntityToEntity(object, playerPed, boneIndex2, 0.15, 0.01, -0.06, 185.0, 215.0, 180.0, true, true, false, true, 1, true)
      Citizen.Wait(6500)
      DeleteObject(object)
      ClearPedSecondaryTask(playerPed)
      end)
    end)
  end)
end)

--DRINK COCA
RegisterNetEvent('esx_basicneeds:coca')
AddEventHandler('esx_basicneeds:coca', function()

  local playerPed = GetPlayerPed(-1)
  local coords = GetEntityCoords(playerPed)

  Citizen.CreateThread(function()
    
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local boneIndex = GetPedBoneIndex(playerPed, 18905)
    local boneIndex2 = GetPedBoneIndex(playerPed, 57005)

      RequestAnimDict('amb@world_human_drinking@beer@male@idle_a')
        
    while not HasAnimDictLoaded('amb@world_human_drinking@beer@male@idle_a') do
      Citizen.Wait(1)
    end
    
    ESX.Game.SpawnObject('prop_ecola_can', {x = coords.x, y = coords.y, z = coords.z - 3}, function(object)

    Citizen.CreateThread(function()
    
      TaskPlayAnim(playerPed, "amb@world_human_drinking@beer@male@idle_a", "idle_c", 3.5, -8, -1, 49, 0, 0, 0, 0)
      AttachEntityToEntity(object, playerPed, boneIndex2, 0.13, 0.02, -0.05, -85.0, 175.0, 0.0, true, true, false, true, 1, true)
      Citizen.Wait(6500)
      DeleteObject(object)
      ClearPedSecondaryTask(playerPed)
      end)
    end)
  end)
end)

--DRINK 7up
RegisterNetEvent('esx_basicneeds:sprunk')
AddEventHandler('esx_basicneeds:sprunk', function()

  local playerPed = GetPlayerPed(-1)
  local coords = GetEntityCoords(playerPed)

  Citizen.CreateThread(function()
    
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local boneIndex = GetPedBoneIndex(playerPed, 18905)
    local boneIndex2 = GetPedBoneIndex(playerPed, 57005)

      RequestAnimDict('amb@world_human_drinking@beer@male@idle_a')
        
    while not HasAnimDictLoaded('amb@world_human_drinking@beer@male@idle_a') do
      Citizen.Wait(1)
    end
    
    ESX.Game.SpawnObject('prop_ld_can_01', {x = coords.x, y = coords.y, z = coords.z - 3}, function(object)

    Citizen.CreateThread(function()
    
      TaskPlayAnim(playerPed, "amb@world_human_drinking@beer@male@idle_a", "idle_c", 3.5, -8, -1, 49, 0, 0, 0, 0)
      AttachEntityToEntity(object, playerPed, boneIndex2, 0.13, 0.02, -0.05, -85.0, 175.0, 0.0, true, true, false, true, 1, true)
      Citizen.Wait(6500)
      DeleteObject(object)
      ClearPedSecondaryTask(playerPed)
      end)
    end)
  end)
end)

--DRINK EAU
RegisterNetEvent('esx_basicneeds:water')
AddEventHandler('esx_basicneeds:water', function()

  local playerPed = GetPlayerPed(-1)
  local coords = GetEntityCoords(playerPed)

  Citizen.CreateThread(function()
    
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local boneIndex = GetPedBoneIndex(playerPed, 18905)
    local boneIndex2 = GetPedBoneIndex(playerPed, 57005)

      RequestAnimDict('amb@world_human_drinking@beer@male@idle_a')
        
    while not HasAnimDictLoaded('amb@world_human_drinking@beer@male@idle_a') do
      Citizen.Wait(1)
    end
    
    ESX.Game.SpawnObject('prop_ld_flow_bottle', {x = coords.x, y = coords.y, z = coords.z - 3}, function(object)

    Citizen.CreateThread(function()
    
      TaskPlayAnim(playerPed, "amb@world_human_drinking@beer@male@idle_a", "idle_c", 3.5, -8, -1, 49, 0, 0, 0, 0)
      AttachEntityToEntity(object, playerPed, boneIndex2, 0.13, 0.02, -0.05, -85.0, 175.0, 0.0, true, true, false, true, 1, true)
      Citizen.Wait(6500)
      DeleteObject(object)
      ClearPedSecondaryTask(playerPed)
      end)
    end)
  end)
end)

--DRINK SODA
RegisterNetEvent('esx_basicneeds:soda')
AddEventHandler('esx_basicneeds:soda', function()

  local playerPed = GetPlayerPed(-1)
  local coords = GetEntityCoords(playerPed)

  Citizen.CreateThread(function()
    
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local boneIndex = GetPedBoneIndex(playerPed, 18905)
    local boneIndex2 = GetPedBoneIndex(playerPed, 57005)

      RequestAnimDict('amb@world_human_drinking@beer@male@idle_a')
        
    while not HasAnimDictLoaded('amb@world_human_drinking@beer@male@idle_a') do
      Citizen.Wait(1)
    end
    
    ESX.Game.SpawnObject('prop_orang_can_01', {x = coords.x, y = coords.y, z = coords.z - 3}, function(object)

    Citizen.CreateThread(function()
    
      TaskPlayAnim(playerPed, "amb@world_human_drinking@beer@male@idle_a", "idle_c", 3.5, -8, -1, 49, 0, 0, 0, 0)
      AttachEntityToEntity(object, playerPed, boneIndex2, 0.13, 0.02, -0.05, -85.0, 175.0, 0.0, true, true, false, true, 1, true)
      Citizen.Wait(6500)
      DeleteObject(object)
      ClearPedSecondaryTask(playerPed)
      end)
    end)
  end)
end)

--DRINK COCKTAIL
RegisterNetEvent('esx_basicneeds:cocktail')
AddEventHandler('esx_basicneeds:cocktail', function()

  local playerPed = GetPlayerPed(-1)
  local coords = GetEntityCoords(playerPed)

  Citizen.CreateThread(function()
    
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local boneIndex = GetPedBoneIndex(playerPed, 18905)
    local boneIndex2 = GetPedBoneIndex(playerPed, 57005)

      RequestAnimDict('amb@world_human_drinking@beer@male@idle_a')
        
    while not HasAnimDictLoaded('amb@world_human_drinking@beer@male@idle_a') do
      Citizen.Wait(1)
    end
    
    ESX.Game.SpawnObject('prop_cocktail', {x = coords.x, y = coords.y, z = coords.z - 3}, function(object)

    Citizen.CreateThread(function()
    
      TaskPlayAnim(playerPed, "amb@world_human_drinking@beer@male@idle_a", "idle_c", 3.5, -8, -1, 49, 0, 0, 0, 0)
      AttachEntityToEntity(object, playerPed, boneIndex2, 0.13, -0.06, -0.05, -85.0, 175.0, 0.0, true, true, false, true, 1, true)
      Citizen.Wait(6500)
      DeleteObject(object)
      ClearPedSecondaryTask(playerPed)
      end)
    end)
  end)
end)

ESX.RegisterUsableItem('pepsi', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('pepsi', 1)

  TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
  TriggerClientEvent('esx_basicneeds:onDrink', source)
  TriggerClientEvent('esx:showNotification', source, 'Vous buvez un Pepsi')
end)

ESX.RegisterUsableItem('7up', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('7up', 1)

  TriggerClientEvent('esx_basicneeds:sprunk', source)
  TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
  TriggerClientEvent('esx:showNotification', source, 'Vous buvez un Pepsi')
end)

ESX.RegisterUsableItem('coca', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('coca', 1)

  TriggerClientEvent('esx_basicneeds:coca', source)
  TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
  TriggerClientEvent('esx:showNotification', source, 'Vous buvez un Coca')
end)

ESX.RegisterUsableItem('fanta', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('fanta', 1)
    
  TriggerClientEvent('esx_basicneeds:soda', source)
  TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
  TriggerClientEvent('esx:showNotification', source, 'Vous buvez un Fanta')
end)

ESX.RegisterUsableItem('sprite', function(source)
  TriggerClientEvent('esx_basicneeds:sprunk', source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('sprite', 1)

  TriggerClientEvent('esx_basicneeds:sprunk', source)
  TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
  TriggerClientEvent('esx:showNotification', source, 'Vous buvez un Sprite')
end)

ESX.RegisterUsableItem('orangina', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('orangina', 1)
    
  TriggerClientEvent('esx_basicneeds:soda', source)
  TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
  TriggerClientEvent('esx:showNotification', source, 'Vous buvez un Orangina')
end)

ESX.RegisterUsableItem('cocktail', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('cocktail', 1)
    
  TriggerClientEvent('esx_basicneeds:cocktail', source)
  TriggerClientEvent('esx_status:add', source, 'thirst', 400000)
  TriggerClientEvent('esx:showNotification', source, 'Vous buvez un Cocktail sans Alcool')
end)

ESX.RegisterUsableItem('bonbons', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('bonbons', 1)

  TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
  TriggerClientEvent('esx_basicneeds:onEat', source)
  TriggerClientEvent('esx:showNotification', source, 'Vous mangez des Bonbons ')
end)

-- Register Usable Item hamburger
ESX.RegisterUsableItem('hamburger', function(source)
  TriggerClientEvent('esx_basicneeds:hamburger', source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('hamburger', 1)

  TriggerClientEvent('esx_status:add', source, 'hunger', 600000)
  TriggerClientEvent('esx:showNotification', source, 'Vous mangez un Hamburger')
end)

-- Register Usable Item frites
ESX.RegisterUsableItem('frites', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('frites', 1)

  TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
  TriggerClientEvent('esx_basicneeds:onEat', source)
  TriggerClientEvent('esx:showNotification', source, 'Vous mangez des Frites')
end)

-- Register Usable Item soda
ESX.RegisterUsableItem('soda', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('soda', 1)

  TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
  TriggerClientEvent('esx_basicneeds:soda', source)
  TriggerClientEvent('esx:showNotification', source, 'Vous buvez un Soda')
end)

ESX.RegisterUsableItem('viande', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('viande', 1)

  TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
  TriggerClientEvent('esx_basicneeds:onEat', source)
  TriggerClientEvent('esx:showNotification', source, 'Vous mangez de la Viande')
end)

ESX.RegisterUsableItem('poison', function(source)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('poison', 1)

  TriggerClientEvent('esx_status:remove', source, 'prevHealth', -50000)
  TriggerClientEvent('esx:showNotification', source, 'used_poison')    
end)

-- Register Usable Item Fishburger
ESX.RegisterUsableItem('fishburger', function(source)
  TriggerClientEvent('esx_basicneeds:fishburger', source) 
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('fishburger', 1)

  TriggerClientEvent('esx_status:add', source, 'hunger', 600000)
  TriggerClientEvent('esx:showNotification', source, 'Vous avez mangé 1x Fishburger')
end)

-- Register Usable Item Veganburger
ESX.RegisterUsableItem('veganburger', function(source)
  TriggerClientEvent('esx_basicneeds:veganburger', source)  
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('veganburger', 1)

  TriggerClientEvent('esx_status:add', source, 'hunger', 500000)
  TriggerClientEvent('esx:showNotification', source, 'Vous avez mangé 1x Veganburger')
end)

-- Register Usable Item Hotdog
ESX.RegisterUsableItem('hotdog', function(source)
  TriggerClientEvent('esx_basicneeds:hotdog', source) 
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeInventoryItem('hotdog', 1)

  TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
  TriggerClientEvent('esx:showNotification', source, 'Vous avez mangé 1x Hotdog')
end)

-- Utiliser Cabiho
ESX.RegisterUsableItem('cabiho', function(source)
    TriggerClientEvent('esx_basicneeds:cigare', source)
    
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeInventoryItem('cabiho', 1)
    TriggerClientEvent('esx:showNotification', source, 'Vous avez fumé ~g~1x ~b~ Cabiho')
end)