local PlayerData = {}
local Factions = {}

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

ESX.RegisterServerCallback('esx_faction:getOtherPlayerData', function(source, cb, target)

    if Config.EnableESXIdentity then

        local xPlayer = ESX.GetPlayerFromId(target)

        local identifier = GetPlayerIdentifiers(target)[1]

        local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
            ['@identifier'] = identifier
        })

        local user = result[1]
        local firstname = user['firstname']
        local lastname = user['lastname']
        local sex = user['sex']
        local dob = user['dateofbirth']
        local height = user['height'] .. " Inches"

        local data = {
            name = GetPlayerName(target),
            job = xPlayer.job,
            inventory = xPlayer.inventory,
            accounts = xPlayer.accounts,
            weapons = xPlayer.loadout,
            firstname = firstname,
            lastname = lastname,
            sex = sex,
            dob = dob,
            height = height
        }

    else

        local xPlayer = ESX.GetPlayerFromId(target)

        local data = {
            name = GetPlayerName(target),
            job = xPlayer.job,
            inventory = xPlayer.inventory,
            accounts = xPlayer.accounts,
            weapons = xPlayer.loadout
        }

        cb(data)

    end

end)

ESX.RegisterServerCallback('esx_faction:getPlayerInventory2', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local blackMoney = xPlayer.getAccount('black_money').money

    cb({
        blackMoney = blackMoney
    })
end)

--Gestion Menu
RegisterServerEvent('esx_faction:giveWeapon')
AddEventHandler('esx_faction:giveWeapon', function(weapon, ammo)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_faction:confiscatePlayerItem')
AddEventHandler('esx_faction:confiscatePlayerItem', function(target, itemType, itemName, amount)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    if itemType == 'item_standard' then
        local label = sourceXPlayer.getInventoryItem(itemName).label

        targetXPlayer.removeInventoryItem(itemName, amount)
        sourceXPlayer.addInventoryItem(itemName, amount)

        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'vous avez confisqué ~y~x' .. amount .. ' ' .. label .. '~s~ à ~b~' .. targetXPlayer.name)
        TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. '~s~ vous a confisqué ~y~x' .. amount .. ' ' .. label)
    end

    if itemType == 'item_account' then
        targetXPlayer.removeAccountMoney(itemName, amount)
        sourceXPlayer.addAccountMoney(itemName, amount)

        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'vous avez confisqué ~y~$' .. amount .. '~s~ vous a confisqué ~y~x' .. targetXPlayer.name)
        TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. '~s~ vous a confisqué ~y~$' .. amount)
    end

    if itemType == 'item_weapon' then
        targetXPlayer.removeWeapon(itemName)
        sourceXPlayer.addWeapon(itemName, amount)

        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'vous avez confisqué ~y~x1 ' .. ESX.GetWeaponLabel(itemName) .. '~s~ à ~b~' .. targetXPlayer.name)
        TriggerClientEvent('esx:showNotification', targetXPlayer.source, '~b~' .. targetXPlayer.name .. '~s~ vous a confisqué ~y~x1 ' .. ESX.GetWeaponLabel(itemName))
    end

end)

ESX.RegisterServerCallback('esx_faction:getPlayerInventory', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local items = xPlayer.inventory

    cb({
        items = items
    })
end)

RegisterServerEvent('esx_faction:handcuff')
AddEventHandler('esx_faction:handcuff', function(target)
  TriggerClientEvent('esx_faction:handcuff', target)
end)


RegisterServerEvent('esx_faction:drag')
AddEventHandler('esx_faction:drag', function(target)
  local _source = source
  TriggerClientEvent('esx_faction:drag', target, _source)
end)


RegisterServerEvent('esx_faction:putInVehicle')
AddEventHandler('esx_faction:putInVehicle', function(target)
  TriggerClientEvent('esx_faction:putInVehicle', target)
end)


RegisterServerEvent('esx_faction:OutVehicle')
AddEventHandler('esx_faction:OutVehicle', function(target)
    TriggerClientEvent('esx_faction:OutVehicle', target)
end)

--Vagos
TriggerEvent('esx_societyfaction:registerSocietyFaction', 'vagos', 'Vagos', 'society_vagos', 'society_vagos', 'society_vagos', {type = 'private'})

ESX.RegisterServerCallback('esx_vagos:getStockItemsVagos', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vagos', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('esx_vagos:getStockItemsVagos')
AddEventHandler('esx_vagos:getStockItemsVagos', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vagos', function(inventory)
        local item = inventory.getItem(itemName)
        local sourceItem = xPlayer.getInventoryItem(itemName)

        --is there enough in the society?
        if count > 0 and item.count >= count then

            --can the player carry the said amount of x item?
            if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas assez de places')
            else
                inventory.removeItem(itemName, count)
                xPlayer.addInventoryItem(itemName, count)
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez pris ', count, item.label)
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
        end
    end)
end)

ESX.RegisterServerCallback('esx_vagos:putStockItemsVagos', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vagos', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('esx_vagos:putStockItemsVagos')
AddEventHandler('esx_vagos:putStockItemsVagos', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vagos', function(inventory)
        local item = inventory.getItem(itemName)
        local playerItemCount = xPlayer.getInventoryItem(itemName).count

        if item.count >= 0 and count <= playerItemCount then
            xPlayer.removeInventoryItem(itemName, count)
            inventory.addItem(itemName, count)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
        end

        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez déposé ', count, item.label)
    end)
end)

--Stock Armes Vagos
ESX.RegisterServerCallback('esx_vagos:getVagosWeapons', function(source, cb)
    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_vagos', function(store)
        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        cb(weapons)
    end)
end)

ESX.RegisterServerCallback('esx_vagos:addVagosWeapon', function(source, cb, weaponName, removeWeapon)
    local xPlayer = ESX.GetPlayerFromId(source)

    if removeWeapon then
        xPlayer.removeWeapon(weaponName)
    end

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_vagos', function(store)
        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = weapons[i].count + 1
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 1
            })
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback('esx_vagos:removeVagosWeapon', function(source, cb, weaponName)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addWeapon(weaponName, 500)

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_vagos', function(store)

        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 0
            })
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback('esx_vagos:getBlackMoney', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local blackMoney = 0
  
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vagos_black', function(account)
      blackMoney = account.money
    end)
  
    cb({
      blackMoney = blackMoney
    })
  
  end)

RegisterServerEvent('esx_vagos:getBlackMoney')
AddEventHandler('esx_vagos:getBlackMoney', function(type, item, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  if type == 'item_account' then
    local playerAccountMoney = xPlayer.getAccount(item).money

    if playerAccountMoney >= count then
      xPlayer.removeAccountMoney(item, count)
      TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vagos_black', function(account)
        account.addMoney(count)
      end)
    else
      TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
    end
  end

end)

RegisterServerEvent('esx_vagos:getPutMoney')
AddEventHandler('esx_vagos:getPutMoney', function(type, item, count)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vagos_black', function(account)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local roomAccountMoney = account.money

        if roomAccountMoney >= count then
        account.removeMoney(count)
        xPlayer.addAccountMoney(item, count)
        else
        TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
        end

    end)
end)

--Ballas
TriggerEvent('esx_societyfaction:registerSocietyFaction', 'ballas', 'Ballas', 'society_ballas', 'society_ballas', 'society_ballas', {type = 'private'})

ESX.RegisterServerCallback('esx_ballas:getStockItemsBallas', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ballas', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('esx_ballas:getStockItemsBallas')
AddEventHandler('esx_ballas:getStockItemsBallas', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ballas', function(inventory)
        local item = inventory.getItem(itemName)
        local sourceItem = xPlayer.getInventoryItem(itemName)

        --is there enough in the society?
        if count > 0 and item.count >= count then

            --can the player carry the said amount of x item?
            if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas assez de places')
            else
                inventory.removeItem(itemName, count)
                xPlayer.addInventoryItem(itemName, count)
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez pris ', count, item.label)
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
        end
    end)
end)

ESX.RegisterServerCallback('esx_ballas:putStockItemsBallas', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ballas', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('esx_ballas:putStockItemsBallas')
AddEventHandler('esx_ballas:putStockItemsBallas', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ballas', function(inventory)
        local item = inventory.getItem(itemName)
        local playerItemCount = xPlayer.getInventoryItem(itemName).count

        if item.count >= 0 and count <= playerItemCount then
            xPlayer.removeInventoryItem(itemName, count)
            inventory.addItem(itemName, count)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
        end

        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez déposé ', count, item.label)
    end)
end)

--Stock Armes Ballas
ESX.RegisterServerCallback('esx_ballas:getBallasWeapons', function(source, cb)
    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_ballas', function(store)
        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        cb(weapons)
    end)
end)

ESX.RegisterServerCallback('esx_ballas:addBallasWeapon', function(source, cb, weaponName, removeWeapon)
    local xPlayer = ESX.GetPlayerFromId(source)

    if removeWeapon then
        xPlayer.removeWeapon(weaponName)
    end

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_ballas', function(store)
        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = weapons[i].count + 1
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 1
            })
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback('esx_ballas:removeBallasWeapon', function(source, cb, weaponName)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addWeapon(weaponName, 500)

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_ballas', function(store)

        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 0
            })
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback('esx_ballas:getBlackMoney', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local blackMoney = 0
  
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ballas_black', function(account)
      blackMoney = account.money
    end)
  
    cb({
      blackMoney = blackMoney
    })
  
  end)

RegisterServerEvent('esx_ballas:getBlackMoney')
AddEventHandler('esx_ballas:getBlackMoney', function(type, item, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  if type == 'item_account' then
    local playerAccountMoney = xPlayer.getAccount(item).money

    if playerAccountMoney >= count then
      xPlayer.removeAccountMoney(item, count)
      TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ballas_black', function(account)
        account.addMoney(count)
      end)
    else
      TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
    end
  end

end)

RegisterServerEvent('esx_ballas:getPutMoney')
AddEventHandler('esx_ballas:getPutMoney', function(type, item, count)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ballas_black', function(account)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local roomAccountMoney = account.money

        if roomAccountMoney >= count then
        account.removeMoney(count)
        xPlayer.addAccountMoney(item, count)
        else
        TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
        end

    end)
end)

--Flash
TriggerEvent('esx_societyfaction:registerSocietyFaction', 'flash', 'Flash', 'society_flash', 'society_flash', 'society_flash', {type = 'private'})

ESX.RegisterServerCallback('esx_flash:getStockItemsFlash', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_flash', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('esx_flash:getStockItemsFlash')
AddEventHandler('esx_flash:getStockItemsFlash', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_flash', function(inventory)
        local item = inventory.getItem(itemName)
        local sourceItem = xPlayer.getInventoryItem(itemName)

        --is there enough in the society?
        if count > 0 and item.count >= count then

            --can the player carry the said amount of x item?
            if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas assez de places')
            else
                inventory.removeItem(itemName, count)
                xPlayer.addInventoryItem(itemName, count)
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez pris ', count, item.label)
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
        end
    end)
end)

ESX.RegisterServerCallback('esx_flash:putStockItemsFlash', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_flash', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('esx_flash:putStockItemsFlash')
AddEventHandler('esx_flash:putStockItemsFlash', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_flash', function(inventory)
        local item = inventory.getItem(itemName)
        local playerItemCount = xPlayer.getInventoryItem(itemName).count

        if item.count >= 0 and count <= playerItemCount then
            xPlayer.removeInventoryItem(itemName, count)
            inventory.addItem(itemName, count)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
        end

        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez déposé ', count, item.label)
    end)
end)

-- Stock Armes Flash
ESX.RegisterServerCallback('esx_flash:getFlashWeapons', function(source, cb)
    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_flash', function(store)
        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        cb(weapons)
    end)
end)

ESX.RegisterServerCallback('esx_flash:addFlashWeapon', function(source, cb, weaponName, removeWeapon)
    local xPlayer = ESX.GetPlayerFromId(source)

    if removeWeapon then
        xPlayer.removeWeapon(weaponName)
    end

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_flash', function(store)
        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = weapons[i].count + 1
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 1
            })
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback('esx_flash:removeFlashWeapon', function(source, cb, weaponName)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addWeapon(weaponName, 500)

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_flash', function(store)

        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 0
            })
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback('esx_flash:getBlackMoney', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local blackMoney = 0
  
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_flash_black', function(account)
      blackMoney = account.money
    end)
  
    cb({
      blackMoney = blackMoney
    })
  
  end)

RegisterServerEvent('esx_flash:getBlackMoney')
AddEventHandler('esx_flash:getBlackMoney', function(type, item, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  if type == 'item_account' then
    local playerAccountMoney = xPlayer.getAccount(item).money

    if playerAccountMoney >= count then
      xPlayer.removeAccountMoney(item, count)
      TriggerEvent('esx_addonaccount:getSharedAccount', 'society_flash_black', function(account)
        account.addMoney(count)
      end)
    else
      TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
    end
  end

end)

RegisterServerEvent('esx_flash:getPutMoney')
AddEventHandler('esx_flash:getPutMoney', function(type, item, count)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_flash_black', function(account)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local roomAccountMoney = account.money

        if roomAccountMoney >= count then
        account.removeMoney(count)
        xPlayer.addAccountMoney(item, count)
        else
        TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
        end

    end)
end)

--WeaponDealer
TriggerEvent('esx_societyfaction:registerSocietyFaction', 'weapondealer', 'WeaponDealer', 'society_weapondealer', 'society_weapondealer', 'society_weapondealer', { type = 'private' })

ESX.RegisterServerCallback('esx_weapondealer:getStockItemsweapondealer', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_weapondealer', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('esx_weapondealer:getStockItemsweapondealer')
AddEventHandler('esx_weapondealer:getStockItemsweapondealer', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_weapondealer', function(inventory)
        local item = inventory.getItem(itemName)
        local sourceItem = xPlayer.getInventoryItem(itemName)

        --is there enough in the society?
        if count > 0 and item.count >= count then

            --can the player carry the said amount of x item?
            if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas assez de places')
            else
                inventory.removeItem(itemName, count)
                xPlayer.addInventoryItem(itemName, count)
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez pris ', count, item.label)
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
        end
    end)
end)

ESX.RegisterServerCallback('esx_weapondealer:putStockItemsweapondealer', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_weapondealer', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('esx_weapondealer:putStockItemsweapondealer')
AddEventHandler('esx_weapondealer:putStockItemsweapondealer', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_weapondealer', function(inventory)
        local item = inventory.getItem(itemName)
        local playerItemCount = xPlayer.getInventoryItem(itemName).count

        if item.count >= 0 and count <= playerItemCount then
            xPlayer.removeInventoryItem(itemName, count)
            inventory.addItem(itemName, count)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
        end

        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez déposé ', count, item.label)
    end)
end)

--Stock Armes weapondealer
ESX.RegisterServerCallback('esx_weapondealer:getweapondealerWeapons', function(source, cb)
    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_weapondealer', function(store)
        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        cb(weapons)
    end)
end)

ESX.RegisterServerCallback('esx_weapondealer:addweapondealerWeapon', function(source, cb, weaponName, removeWeapon)
    local xPlayer = ESX.GetPlayerFromId(source)

    if removeWeapon then
        xPlayer.removeWeapon(weaponName)
    end

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_weapondealer', function(store)
        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = weapons[i].count + 1
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 1
            })
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback('esx_weapondealer:removeweapondealerWeapon', function(source, cb, weaponName)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addWeapon(weaponName, 500)

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_weapondealer', function(store)

        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 0
            })
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback('esx_weapondealer:getArmoryWeapons', function(source, cb)
    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapondealer', function(store)
        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        cb(weapons)
    end)
end)

ESX.RegisterServerCallback('esx_weapondealer:removeArmoryWeapon', function(source, cb, weaponName)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addWeapon(weaponName, 500)

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapondealer', function(store)

        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 0
            })
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

local AuthorizedWeapons = {
    boss = {
        {weapon = 'WEAPON_MICROSMG', price = 130000},
        {weapon = 'WEAPON_MINISMG', price = 140000},
        {weapon = 'WEAPON_SMG', price = 220000},
        {weapon = 'WEAPON_COMPACTRIFLE', price = 140000},
        {weapon = 'WEAPON_ASSAULTRIFLE', price = 250000},
        {weapon = 'WEAPON_PISTOL50', price = 45000},
        {weapon = 'WEAPON_SAWNOFFSHOTGUN', price = 115000},
        {weapon = 'WEAPON_BULLPUPSHOTGUN', price = 180000},
        {weapon = 'WEAPON_SNIPERRIFLE', price = 300000},
        {weapon = 'WEAPON_SWITCHBLADE', price = 25000},
        {weapon = 'WEAPON_MOLOTOV', price = 230000}
    }
}

ESX.RegisterServerCallback('esx_weapondealer:buyWeapon', function(source, cb, weaponName, type, componentNum)
    local xPlayer = ESX.GetPlayerFromId(source)
    local authorizedWeapons, selectedWeapon = AuthorizedWeapons['boss']

    for k, v in ipairs(authorizedWeapons) do
        if v.weapon == weaponName then
            selectedWeapon = v
            break
        end
    end

    if not selectedWeapon then
        print(('esx_weapondealer: %s attempted to buy an invalid weapon.'):format(xPlayer.identifier))
        cb(false)
    else
        --Weapon
        if type == 1 then
            if xPlayer.getMoney() >= selectedWeapon.price then
                xPlayer.removeMoney(selectedWeapon.price)
                xPlayer.addWeapon(weaponName, 450)

                cb(true)
            else
                cb(false)
            end

            --Weapon Component
        elseif type == 2 then
            local price = selectedWeapon.components[componentNum]
            local weaponNum, weapon = ESX.GetWeapon(weaponName)

            local component = weapon.components[componentNum]

            if component then
                if xPlayer.getMoney() >= price then
                    xPlayer.removeMoney(price)
                    xPlayer.addWeaponComponent(weaponName, component.name)

                    cb(true)
                else
                    cb(false)
                end
            else
                print(('esx_weapondealer: %s attempted to buy an invalid weapon component.'):format(xPlayer.identifier))
                cb(false)
            end
        end
    end
end)

ESX.RegisterServerCallback('esx_weapondealer:getBlackMoney', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local blackMoney = 0
  
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_weapondealer_black', function(account)
      blackMoney = account.money
    end)
  
    cb({
      blackMoney = blackMoney
    })
  
  end)

RegisterServerEvent('esx_weapondealer:getBlackMoney')
AddEventHandler('esx_weapondealer:getBlackMoney', function(type, item, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  if type == 'item_account' then
    local playerAccountMoney = xPlayer.getAccount(item).money

    if playerAccountMoney >= count then
      xPlayer.removeAccountMoney(item, count)
      TriggerEvent('esx_addonaccount:getSharedAccount', 'society_weapondealer_black', function(account)
        account.addMoney(count)
      end)
    else
      TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
    end
  end

end)

RegisterServerEvent('esx_weapondealer:getPutMoney')
AddEventHandler('esx_weapondealer:getPutMoney', function(type, item, count)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_weapondealer_black', function(account)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local roomAccountMoney = account.money

        if roomAccountMoney >= count then
        account.removeMoney(count)
        xPlayer.addAccountMoney(item, count)
        else
        TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
        end

    end)
end)

--Mafia
TriggerEvent('esx_societyfaction:registerSocietyFaction', 'mafia', 'Mafia', 'society_mafia', 'society_mafia', 'society_mafia', {type = 'private'})

ESX.RegisterServerCallback('esx_mafia:getStockItemsMafia', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mafia', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('esx_mafia:getStockItemsMafia')
AddEventHandler('esx_mafia:getStockItemsMafia', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mafia', function(inventory)
        local item = inventory.getItem(itemName)
        local sourceItem = xPlayer.getInventoryItem(itemName)

        --is there enough in the society?
        if count > 0 and item.count >= count then

            --can the player carry the said amount of x item?
            if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas assez de places')
            else
                inventory.removeItem(itemName, count)
                xPlayer.addInventoryItem(itemName, count)
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez pris ', count, item.label)
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
        end
    end)
end)

ESX.RegisterServerCallback('esx_mafia:putStockItemsMafia', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mafia', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('esx_mafia:putStockItemsMafia')
AddEventHandler('esx_mafia:putStockItemsMafia', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_mafia', function(inventory)
        local item = inventory.getItem(itemName)
        local playerItemCount = xPlayer.getInventoryItem(itemName).count

        if item.count >= 0 and count <= playerItemCount then
            xPlayer.removeInventoryItem(itemName, count)
            inventory.addItem(itemName, count)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
        end

        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez déposé ', count, item.label)
    end)
end)

-- Stock Armes Mafia
ESX.RegisterServerCallback('esx_mafia:getMafiaWeapons', function(source, cb)
    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_mafia', function(store)
        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        cb(weapons)
    end)
end)

ESX.RegisterServerCallback('esx_mafia:addMafiaWeapon', function(source, cb, weaponName, removeWeapon)
    local xPlayer = ESX.GetPlayerFromId(source)

    if removeWeapon then
        xPlayer.removeWeapon(weaponName)
    end

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_mafia', function(store)
        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = weapons[i].count + 1
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 1
            })
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback('esx_mafia:removeMafiaWeapon', function(source, cb, weaponName)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addWeapon(weaponName, 500)

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_mafia', function(store)

        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 0
            })
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback('esx_mafia:getBlackMoney', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local blackMoney = 0
  
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mafia_black', function(account)
      blackMoney = account.money
    end)
  
    cb({
      blackMoney = blackMoney
    })
  
  end)

RegisterServerEvent('esx_mafia:getBlackMoney')
AddEventHandler('esx_mafia:getBlackMoney', function(type, item, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  if type == 'item_account' then
    local playerAccountMoney = xPlayer.getAccount(item).money

    if playerAccountMoney >= count then
      xPlayer.removeAccountMoney(item, count)
      TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mafia_black', function(account)
        account.addMoney(count)
      end)
    else
      TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
    end
  end

end)

RegisterServerEvent('esx_mafia:getPutMoney')
AddEventHandler('esx_mafia:getPutMoney', function(type, item, count)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mafia_black', function(account)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local roomAccountMoney = account.money

        if roomAccountMoney >= count then
        account.removeMoney(count)
        xPlayer.addAccountMoney(item, count)
        else
        TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
        end

    end)
end)

--Bkc
TriggerEvent('esx_societyfaction:registerSocietyFaction', 'bkc', 'Bkc', 'society_bkc', 'society_bkc', 'society_bkc', {type = 'private'})

ESX.RegisterServerCallback('esx_bkc:getStockItemsBkc', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_bkc', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('esx_bkc:getStockItemsBkc')
AddEventHandler('esx_bkc:getStockItemsBkc', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_bkc', function(inventory)
        local item = inventory.getItem(itemName)
        local sourceItem = xPlayer.getInventoryItem(itemName)

        --is there enough in the society?
        if count > 0 and item.count >= count then

            --can the player carry the said amount of x item?
            if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas assez de places')
            else
                inventory.removeItem(itemName, count)
                xPlayer.addInventoryItem(itemName, count)
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez pris ', count, item.label)
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
        end
    end)
end)

ESX.RegisterServerCallback('esx_bkc:putStockItemsBkc', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_bkc', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('esx_bkc:putStockItemsBkc')
AddEventHandler('esx_bkc:putStockItemsBkc', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_bkc', function(inventory)
        local item = inventory.getItem(itemName)
        local playerItemCount = xPlayer.getInventoryItem(itemName).count

        if item.count >= 0 and count <= playerItemCount then
            xPlayer.removeInventoryItem(itemName, count)
            inventory.addItem(itemName, count)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
        end

        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez déposé ', count, item.label)
    end)
end)

-- Stock Armes Bkc
ESX.RegisterServerCallback('esx_bkc:getBkcWeapons', function(source, cb)
    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_bkc', function(store)
        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        cb(weapons)
    end)
end)

ESX.RegisterServerCallback('esx_bkc:addBkcWeapon', function(source, cb, weaponName, removeWeapon)
    local xPlayer = ESX.GetPlayerFromId(source)

    if removeWeapon then
        xPlayer.removeWeapon(weaponName)
    end

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_bkc', function(store)
        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = weapons[i].count + 1
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 1
            })
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback('esx_bkc:removeBkcWeapon', function(source, cb, weaponName)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addWeapon(weaponName, 500)

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_bkc', function(store)

        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 0
            })
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback('esx_bkc:getBlackMoney', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local blackMoney = 0
  
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_bkc_black', function(account)
      blackMoney = account.money
    end)
  
    cb({
      blackMoney = blackMoney
    })
  
  end)

RegisterServerEvent('esx_bkc:getBlackMoney')
AddEventHandler('esx_bkc:getBlackMoney', function(type, item, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  if type == 'item_account' then
    local playerAccountMoney = xPlayer.getAccount(item).money

    if playerAccountMoney >= count then
      xPlayer.removeAccountMoney(item, count)
      TriggerEvent('esx_addonaccount:getSharedAccount', 'society_bkc_black', function(account)
        account.addMoney(count)
      end)
    else
      TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
    end
  end

end)

RegisterServerEvent('esx_bkc:getPutMoney')
AddEventHandler('esx_bkc:getPutMoney', function(type, item, count)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_bkc_black', function(account)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local roomAccountMoney = account.money

        if roomAccountMoney >= count then
        account.removeMoney(count)
        xPlayer.addAccountMoney(item, count)
        else
        TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
        end

    end)
end)

--Atrax
TriggerEvent('esx_societyfaction:registerSocietyFaction', 'atrax', 'Atrax', 'society_atrax', 'society_atrax', 'society_atrax', {type = 'private'})

ESX.RegisterServerCallback('esx_atrax:getStockItemsAtrax', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_atrax', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('esx_atrax:getStockItemsAtrax')
AddEventHandler('esx_atrax:getStockItemsAtrax', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_atrax', function(inventory)
        local item = inventory.getItem(itemName)
        local sourceItem = xPlayer.getInventoryItem(itemName)

        --is there enough in the society?
        if count > 0 and item.count >= count then

            --can the player carry the said amount of x item?
            if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas assez de places')
            else
                inventory.removeItem(itemName, count)
                xPlayer.addInventoryItem(itemName, count)
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez pris ', count, item.label)
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
        end
    end)
end)

ESX.RegisterServerCallback('esx_atrax:putStockItemsAtrax', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_atrax', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('esx_atrax:putStockItemsAtrax')
AddEventHandler('esx_atrax:putStockItemsAtrax', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_atrax', function(inventory)
        local item = inventory.getItem(itemName)
        local playerItemCount = xPlayer.getInventoryItem(itemName).count

        if item.count >= 0 and count <= playerItemCount then
            xPlayer.removeInventoryItem(itemName, count)
            inventory.addItem(itemName, count)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
        end

        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez déposé ', count, item.label)
    end)
end)

-- Stock Armes Atrax
ESX.RegisterServerCallback('esx_atrax:getAtraxWeapons', function(source, cb)
    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_atrax', function(store)
        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        cb(weapons)
    end)
end)

ESX.RegisterServerCallback('esx_atrax:addAtraxWeapon', function(source, cb, weaponName, removeWeapon)
    local xPlayer = ESX.GetPlayerFromId(source)

    if removeWeapon then
        xPlayer.removeWeapon(weaponName)
    end

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_atrax', function(store)
        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = weapons[i].count + 1
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 1
            })
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback('esx_atrax:removeAtraxWeapon', function(source, cb, weaponName)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addWeapon(weaponName, 500)

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_atrax', function(store)

        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 0
            })
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback('esx_atra:getBlackMoney', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local blackMoney = 0
  
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_atrax_black', function(account)
      blackMoney = account.money
    end)
  
    cb({
      blackMoney = blackMoney
    })
  
  end)

RegisterServerEvent('esx_atrax:getBlackMoney')
AddEventHandler('esx_atrax:getBlackMoney', function(type, item, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  if type == 'item_account' then
    local playerAccountMoney = xPlayer.getAccount(item).money

    if playerAccountMoney >= count then
      xPlayer.removeAccountMoney(item, count)
      TriggerEvent('esx_addonaccount:getSharedAccount', 'society_atrax_black', function(account)
        account.addMoney(count)
      end)
    else
      TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
    end
  end

end)

RegisterServerEvent('esx_atrax:getPutMoney')
AddEventHandler('esx_atrax:getPutMoney', function(type, item, count)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_atrax_black', function(account)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local roomAccountMoney = account.money

        if roomAccountMoney >= count then
        account.removeMoney(count)
        xPlayer.addAccountMoney(item, count)
        else
        TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
        end

    end)
end)

--Families
TriggerEvent('esx_societyfaction:registerSocietyFaction', 'families', 'Families', 'society_families', 'society_families', 'society_families', {type = 'private'})

ESX.RegisterServerCallback('esx_families:getStockItemsFamilies', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_families', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('esx_families:getStockItemsFamilies')
AddEventHandler('esx_families:getStockItemsFamilies', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_families', function(inventory)
        local item = inventory.getItem(itemName)
        local sourceItem = xPlayer.getInventoryItem(itemName)

        --is there enough in the society?
        if count > 0 and item.count >= count then

            --can the player carry the said amount of x item?
            if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas assez de places')
            else
                inventory.removeItem(itemName, count)
                xPlayer.addInventoryItem(itemName, count)
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez pris ', count, item.label)
            end
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
        end
    end)
end)

ESX.RegisterServerCallback('esx_families:putStockItemsFamilies', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_families', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterServerEvent('esx_families:putStockItemsFamilies')
AddEventHandler('esx_families:putStockItemsFamilies', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_families', function(inventory)
        local item = inventory.getItem(itemName)
        local playerItemCount = xPlayer.getInventoryItem(itemName).count

        if item.count >= 0 and count <= playerItemCount then
            xPlayer.removeInventoryItem(itemName, count)
            inventory.addItem(itemName, count)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Quantité invalide')
        end

        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez déposé ', count, item.label)
    end)
end)

-- Stock Armes Families
ESX.RegisterServerCallback('esx_families:getFamiliesWeapons', function(source, cb)
    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_families', function(store)
        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        cb(weapons)
    end)
end)

ESX.RegisterServerCallback('esx_families:addFamiliesWeapon', function(source, cb, weaponName, removeWeapon)
    local xPlayer = ESX.GetPlayerFromId(source)

    if removeWeapon then
        xPlayer.removeWeapon(weaponName)
    end

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_families', function(store)
        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = weapons[i].count + 1
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 1
            })
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback('esx_families:removeFamiliesWeapon', function(source, cb, weaponName)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addWeapon(weaponName, 500)

    TriggerEvent('esx_datastore:getSharedDataStore', 'society_weapons_families', function(store)

        local weapons = store.get('weapons')

        if weapons == nil then
            weapons = {}
        end

        local foundWeapon = false

        for i = 1, #weapons, 1 do
            if weapons[i].name == weaponName then
                weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
                foundWeapon = true
                break
            end
        end

        if not foundWeapon then
            table.insert(weapons, {
                name = weaponName,
                count = 0
            })
        end

        store.set('weapons', weapons)
        cb()
    end)
end)

ESX.RegisterServerCallback('esx_families:getBlackMoney', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local blackMoney = 0
  
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_families_black', function(account)
      blackMoney = account.money
    end)
  
    cb({
      blackMoney = blackMoney
    })
  
  end)

RegisterServerEvent('esx_families:getBlackMoney')
AddEventHandler('esx_families:getBlackMoney', function(type, item, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  if type == 'item_account' then
    local playerAccountMoney = xPlayer.getAccount(item).money

    if playerAccountMoney >= count then
      xPlayer.removeAccountMoney(item, count)
      TriggerEvent('esx_addonaccount:getSharedAccount', 'society_families_black', function(account)
        account.addMoney(count)
      end)
    else
      TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
    end
  end

end)

RegisterServerEvent('esx_families:getPutMoney')
AddEventHandler('esx_families:getPutMoney', function(type, item, count)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_families_black', function(account)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local roomAccountMoney = account.money

        if roomAccountMoney >= count then
        account.removeMoney(count)
        xPlayer.addAccountMoney(item, count)
        else
        TriggerClientEvent('esx:showNotification', _source, 'Montant invalide')
        end

    end)
end)