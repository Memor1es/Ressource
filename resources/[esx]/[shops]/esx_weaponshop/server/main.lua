local shopItems = {}
local shopItems2 = {}

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()

	MySQL.Async.fetchAll('SELECT * FROM weashops', {}, function(result)
		for i=1, #result, 1 do
			if shopItems[result[i].zone] == nil then
				shopItems[result[i].zone] = {}
			end

			table.insert(shopItems[result[i].zone], {
				item = result[i].item,
				price = result[i].price,
				label = ESX.GetWeaponLabel(result[i].item)
			})
		end

		TriggerClientEvent('esx_weaponshop:sendShop', -1, shopItems)
	end)

end)

-- Legal
MySQL.ready(function()

	MySQL.Async.fetchAll('SELECT * FROM weashops_legal', {}, function(result)
		for i=1, #result, 1 do
			if shopItems2[result[i].zone] == nil then
				shopItems2[result[i].zone] = {}
			end

			table.insert(shopItems2[result[i].zone], {
				item = result[i].item,
				price = result[i].price,
				label = ESX.GetWeaponLabel(result[i].item)
			})
		end

		TriggerClientEvent('esx_weaponshop:sendShopLegal', -1, shopItems2)
	end)

end)

-- Base
ESX.RegisterServerCallback('esx_weaponshop:getShop', function(source, cb)
	cb(shopItems)
end)

ESX.RegisterServerCallback('esx_weaponshop:buyWeapon', function(source, cb, weaponName, zone)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = GetPrice(weaponName, zone)

	if price == 0 then
		print(('esx_weaponshop: %s attempted to buy a unknown weapon!'):format(xPlayer.identifier))
		cb(false)
	end

	if xPlayer.hasWeapon(weaponName) then
		TriggerClientEvent('esx:showNotification', source, _U('already_owned'))
		cb(false)
	else
		if zone == 'BlackWeashop' then

			if xPlayer.getAccount('black_money').money >= price then
				xPlayer.removeAccountMoney('black_money', price)
				xPlayer.addWeapon(weaponName, 42)

				cb(true)
			else
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_black'))
				cb(false)
			end

		else

			if xPlayer.getMoney() >= price then
				xPlayer.removeMoney(price)
				xPlayer.addWeapon(weaponName, 42)

				cb(true)
			else
				TriggerClientEvent('esx:showNotification', source, _U('not_enough'))
				cb(false)
			end
	
		end
	end
end)

function GetPrice(weaponName, zone)
	local price = MySQL.Sync.fetchScalar('SELECT price FROM weashops WHERE zone = @zone AND item = @item', {
		['@zone'] = zone,
		['@item'] = weaponName
	})

	if price then
		return price
	else
		return 0
	end
end

-- Legal
ESX.RegisterServerCallback('esx_weaponshop:getShopLegal', function(source, cb)
	cb(shopItems2)
end)

ESX.RegisterServerCallback('esx_weaponshop:buyWeaponLegal', function(source, cb, weaponName, zone)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = GetPriceLegal(weaponName, zone)

	if price == 0 then
		print(('esx_weaponshop: %s attempted to buy a unknown weapon!'):format(xPlayer.identifier))
		cb(false)
	end

	if xPlayer.hasWeapon(weaponName) then
		TriggerClientEvent('esx:showNotification', source, _U('already_owned'))
		cb(false)
	else

		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)
			xPlayer.addWeapon(weaponName, 42)

			cb(true)
		else
			TriggerClientEvent('esx:showNotification', source, _U('not_enough'))
			cb(false)
		end
	end
end)

function GetPriceLegal(weaponName, zone)
	local price = MySQL.Sync.fetchScalar('SELECT price FROM weashops_legal WHERE zone = @zone AND item = @item', {
		['@zone'] = zone,
		['@item'] = weaponName
	})

	if price then
		return price
	else
		return 0
	end
end