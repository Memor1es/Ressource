local PlayersFarmBillets = {}
local PlayersVenteBillets = {}

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--Farm Billets
local function FarmBillets(source)

  SetTimeout(4000, function()

    if PlayersFarmBillets[source] == true then
      local xPlayer = ESX.GetPlayerFromId(source)
      local BilletsQuantity = xPlayer.getInventoryItem('billets').count

      if BilletsQuantity >= 10 then
        TriggerClientEvent('esx:showNotification', source, 'Vous avez trop de plaques de billets.')
      else
          xPlayer.addInventoryItem('billets', 1)

        FarmBillets(source)
      end

    end
  end)
end

RegisterServerEvent('esx_casapapel:startFarmBillets')
AddEventHandler('esx_casapapel:startFarmBillets', function()
  local _source = source
  PlayersFarmBillets[_source] = true
  TriggerClientEvent('esx:showNotification', _source, 'Vous récupérer des plaques de billets.')
  FarmBillets(source)
end)

RegisterServerEvent('esx_casapapel:stopFarmBillets')
AddEventHandler('esx_casapapel:stopFarmBillets', function()
  local _source = source
  PlayersFarmBillets[_source] = false
end)

local function VenteBillets(source)

  SetTimeout(6000, function()

    if PlayersVenteBillets[source] == true then
      local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)

      local BilletsQuantity = xPlayer.getInventoryItem('billets').count

      if BilletsQuantity == 0 then
        TriggerClientEvent('esx:showNotification', source, 'vous n\'avez plus de ~r~plaque de billets~s~')
      else
        xPlayer.removeInventoryItem('billets', 1)
        xPlayer.addAccountMoney('black_money', 2000)
        TriggerClientEvent('esx:showNotification', source, 'Vous avez récupéré des ~b~Billets')
       
        VenteBillets(source)
      end

    end
  end)
end

RegisterServerEvent('esx_casapapel:startVenteBillets')
AddEventHandler('esx_casapapel:startVenteBillets', function()
  local _source = source
  PlayersVenteBillets[_source] = true
  TriggerClientEvent('esx:showNotification', _source, '~g~Blanchiement des billets~s~...')

  VenteBillets(_source)
end)

RegisterServerEvent('esx_casapapel:stopVenteBillets')
AddEventHandler('esx_casapapel:stopVenteBillets', function()
  local _source = source
  PlayersVenteBillets[_source] = false
end)