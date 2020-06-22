local PlayerData = {}
local GUI = {}
GUI.Time = 0

local HasAlreadyEnteredMarker = false
local LastZone = nil
local LastPart = nil
local LastData = {}
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local TargetCoords = nil

ESX = nil
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

--Farm Billets
function OpenBilletsFarmMenu()
  local elements = {
    {label = 'Récupérer des plaques de billets', value = 'billets'}
  }
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'billets_farm',
      {
	css = 'Hollidays',
        title = 'Machine a billets',
        elements = elements
      },
      function(data, menu)
        if data.current.value == 'billets' then
          menu.close()
          TriggerServerEvent('esx_casapapel:startFarmBillets')
        end       
      end,
      function(data, menu)
        menu.close()
        CurrentAction = 'billets_farm_menu'
        CurrentActionMsg = 'Récupérer des plaques de billets'
        CurrentActionData = {}
      end
    )
end

function OpenBilletsVenteMenu()

  local elements = {
    {label = 'Récupérer les billets', value = 'billetsvente'}
  }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'billets_vente',
      {
	css = 'Hollidays',
        title = 'Blanchir les plaques de billets',
        elements = elements
      },
      function(data, menu)
        if data.current.value == 'billetsvente' then
          menu.close()
          TriggerServerEvent('esx_casapapel:startVenteBillets')
        end

      end,

      function(data, menu)
        menu.close()
        CurrentAction = 'billets_vente_menu'
        CurrentActionMsg = 'Blanchir les plaques de billets'
        CurrentActionData = {}
      end
    )

end

AddEventHandler('esx_casapapel:hasEnteredMarker', function(zone)
  --MOUKATE
  if zone == 'BilletsFarm' then
    CurrentAction = 'billets_farm_menu'
    CurrentActionMsg = 'Récupérer des plaques de billets'
    CurrentActionData = {}
  elseif zone == 'BilletsFarm2' then
    CurrentAction = 'billets_farm_menu'
    CurrentActionMsg = 'Récupérer des plaques de billets'
    CurrentActionData = {}
  elseif zone == 'BilletsFarm3' then
    CurrentAction = 'billets_farm_menu'
    CurrentActionMsg = 'Récupérer des plaques de billets'
    CurrentActionData = {}
  elseif zone == 'BilletsFarm4' then
    CurrentAction = 'billets_farm_menu'
    CurrentActionMsg = 'Récupérer des plaques de billets'
    CurrentActionData = {}
  elseif zone == 'BilletsFarm5' then
    CurrentAction = 'billets_farm_menu'
    CurrentActionMsg = 'Récupérer des plaques de billets'
    CurrentActionData = {}
  elseif zone == 'BilletsFarm6' then
    CurrentAction = 'billets_farm_menu'
    CurrentActionMsg = 'Récupérer des plaques de billets'
    CurrentActionData = {}
  elseif zone == 'BilletsFarm7' then
    CurrentAction = 'billets_farm_menu'
    CurrentActionMsg = 'Récupérer des plaques de billets'
    CurrentActionData = {}
  elseif zone == 'BilletsFarm8' then
    CurrentAction = 'billets_farm_menu'
    CurrentActionMsg = 'Récupérer des plaques de billets'
    CurrentActionData = {}
  elseif zone == 'BilletsFarm9' then
    CurrentAction = 'billets_farm_menu'
    CurrentActionMsg = 'Récupérer des plaques de billets'
    CurrentActionData = {}
  elseif zone == 'BilletsFarm10' then
    CurrentAction = 'billets_farm_menu'
    CurrentActionMsg = 'Récupérer des plaques de billets'
    CurrentActionData = {}
  elseif zone == 'BilletsVente' then
    CurrentAction = 'billets_vente_menu'
    CurrentActionMsg = 'Blanchir les plaques de billets'
    CurrentActionData = {}
  elseif zone == 'BilletsVente2' then
    CurrentAction = 'billets_vente_menu'
    CurrentActionMsg = 'Blanchir les plaques de billets'
    CurrentActionData = {}
  elseif zone == 'BilletsVente3' then
    CurrentAction = 'billets_vente_menu'
    CurrentActionMsg = 'Blanchir les plaques de billets'
    CurrentActionData = {}
  elseif zone == 'BilletsVente4' then
    CurrentAction = 'billets_vente_menu'
    CurrentActionMsg = 'Blanchir les plaques de billets'
    CurrentActionData = {}
  elseif zone == 'BilletsVente5' then
    CurrentAction = 'billets_vente_menu'
    CurrentActionMsg = 'Blanchir les plaques de billets'
    CurrentActionData = {}
  elseif zone == 'BilletsVente6' then
    CurrentAction = 'billets_vente_menu'
    CurrentActionMsg = 'Blanchir les plaques de billets'
    CurrentActionData = {}
  elseif zone == 'BilletsVente7' then
    CurrentAction = 'billets_vente_menu'
    CurrentActionMsg = 'Blanchir les plaques de billets'
    CurrentActionData = {}
  end
end)

AddEventHandler('esx_casapapel:hasExitedMarker', function(zone)
  --FARM
  if zone == 'BilletsFarm' then
    TriggerServerEvent('esx_casapapel:stopFarmBillets')
  elseif zone == 'BilletsFarm2' then
    TriggerServerEvent('esx_casapapel:stopFarmBillets')
  elseif zone == 'BilletsFarm3' then
    TriggerServerEvent('esx_casapapel:stopFarmBillets')
  elseif zone == 'BilletsFarm4' then
    TriggerServerEvent('esx_casapapel:stopFarmBillets')
  elseif zone == 'BilletsFarm5' then
    TriggerServerEvent('esx_casapapel:stopFarmBillets')
  elseif zone == 'BilletsFarm6' then
    TriggerServerEvent('esx_casapapel:stopFarmBillets')
  elseif zone == 'BilletsFarm7' then
    TriggerServerEvent('esx_casapapel:stopFarmBillets')
  elseif zone == 'BilletsFarm8' then
    TriggerServerEvent('esx_casapapel:stopFarmBillets')
  elseif zone == 'BilletsFarm9' then
    TriggerServerEvent('esx_casapapel:stopFarmBillets')
  elseif zone == 'BilletsFarm10' then
    TriggerServerEvent('esx_casapapel:stopFarmBillets')
  elseif zone == 'BilletsVente' then
    TriggerServerEvent('esx_casapapel:stopVenteBillets')
  elseif zone == 'BilletsVente2' then
    TriggerServerEvent('esx_casapapel:stopVenteBillets')
  elseif zone == 'BilletsVente3' then
    TriggerServerEvent('esx_casapapel:stopVenteBillets')
  elseif zone == 'BilletsVente4' then
    TriggerServerEvent('esx_casapapel:stopVenteBillets')
  elseif zone == 'BilletsVente5' then
    TriggerServerEvent('esx_casapapel:stopVenteBillets')
  elseif zone == 'BilletsVente6' then
    TriggerServerEvent('esx_casapapel:stopVenteBillets')
  elseif zone == 'BilletsVente7' then
    TriggerServerEvent('esx_casapapel:stopVenteBillets')
  end
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)


-- Display markers
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)

      local coords = GetEntityCoords(GetPlayerPed(-1))

      for k,v in pairs(Config.Zones) do
        if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
          DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, 100, false, true, 2, false, false, false, false)
        end
      end
  end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)

      local coords = GetEntityCoords(GetPlayerPed(-1))
      local isInMarker = false
      local currentZone = nil

      for k,v in pairs(Config.Zones) do
        if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
          isInMarker = true
          currentZone = k
        end
      end

      if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
        HasAlreadyEnteredMarker = true
        LastZone = currentZone
        TriggerEvent('esx_casapapel:hasEnteredMarker', currentZone)
      end

      if not isInMarker and HasAlreadyEnteredMarker then
        HasAlreadyEnteredMarker = false
        TriggerEvent('esx_casapapel:hasExitedMarker', LastZone)
      end

  end
end)

--Key Controls
Citizen.CreateThread(function()

  while ESX == nil or not ESX.IsPlayerLoaded() do
    Citizen.Wait(1)
  end

    while true do
        Citizen.Wait(1)

        if CurrentAction ~= nil then
          SetTextComponentFormat('STRING')
          AddTextComponentString(CurrentActionMsg)
          DisplayHelpTextFromStringLabel(0, 0, 1, -1)

          if IsControlJustReleased(0, 38) then
            if CurrentAction == 'billets_farm_menu' then
                OpenBilletsFarmMenu()
            end
            if CurrentAction == 'billets_vente_menu' then
                OpenBilletsVenteMenu()
            end
            CurrentAction = nil
          end
        end
    end
end)

--TP

AddEventHandler('esx_casapapel:teleportMarkers', function(position)
  SetEntityCoords(GetPlayerPed(-1), position.x, position.y, position.z)
end)

-- Show top left hint
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if hintIsShowed == true then
      SetTextComponentFormat('STRING')
      AddTextComponentString(hintToDisplay)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end
  end
end)

-- Display teleport markers
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    local coords = GetEntityCoords(GetPlayerPed(-1))

    for k,v in pairs(Config.TeleportZones) do
      if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
        DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, 255, 0, 0, 100, false, true, 2, false, false, false, false)
      end
    end

  end
end)

-- Activate teleport marker
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local position = nil
    local zone = nil

    for k,v in pairs(Config.TeleportZones) do
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
      TriggerEvent('esx_casapapel:teleportMarkers', position)
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
end)