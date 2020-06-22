ESX = nil
local Factions = {}
local RegisteredSocietiesFaction = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetSocietyFaction(name)
	for i=1, #RegisteredSocietiesFaction, 1 do
		if RegisteredSocietiesFaction[i].name == name then
			return RegisteredSocietiesFaction[i]
		end
	end
end

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM factions', {})

	for i=1, #result, 1 do
		Factions[result[i].name] = result[i]
		Factions[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM faction_grades', {})

	for i=1, #result2, 1 do
		Factions[result2[i].faction_name].grades[tostring(result2[i].grade)] = result2[i]
	end
end)

AddEventHandler('esx_societyfaction:registerSocietyFaction', function(name, label, account, datastore, inventory, data)
	local found = false

	local society = {
		name = name,
		label = label,
		account = account,
		datastore = datastore,
		inventory = inventory,
		data = data,
	}

	for i=1, #RegisteredSocietiesFaction, 1 do
		if RegisteredSocietiesFaction[i].name == name then
			found = true
			RegisteredSocietiesFaction[i] = society
			break
		end
	end

	if not found then
		table.insert(RegisteredSocietiesFaction, society)
	end
end)

AddEventHandler('esx_societyfaction:getSocietiesFaction', function(cb)
	cb(RegisteredSocietiesFaction)
end)

AddEventHandler('esx_societyfaction:getSocietyFaction', function(name, cb)
	cb(GetSocietyFaction(name))
end)

RegisterServerEvent('esx_societyfaction:withdrawMoneyFaction')
AddEventHandler('esx_societyfaction:withdrawMoneyFaction', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSocietyFaction(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.faction.name ~= society.name then
		print(('esx_societyfaction: %s attempted to call withdrawMoneyFaction!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			xPlayer.addMoney(amount)

			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', ESX.Math.GroupDigits(amount)))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
		end
	end)
end)

RegisterServerEvent('esx_societyfaction:depositMoneyFaction')
AddEventHandler('esx_societyfaction:depositMoneyFaction', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSocietyFaction(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.faction.name ~= society.name then
		print(('esx_societyfaction: %s attempted to call depositMoneyFaction!'):format(xPlayer.identifier))
		return
	end

	if amount > 0 and xPlayer.getMoney() >= amount then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			xPlayer.removeMoney(amount)
			account.addMoney(amount)
		end)

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', ESX.Math.GroupDigits(amount)))
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
	end
end)

RegisterServerEvent('esx_societyfaction:washMoneyFaction')
AddEventHandler('esx_societyfaction:washMoneyFaction', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local account = xPlayer.getAccount('black_money')
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.faction.name ~= society then
		print(('esx_societyfaction: %s attempted to call washMoneyFaction!'):format(xPlayer.identifier))
		return
	end

	if amount and amount > 0 and account.money >= amount then
		xPlayer.removeAccountMoney('black_money', amount)

		MySQL.Async.execute('INSERT INTO society_moneywash (identifier, society, amount) VALUES (@identifier, @society, @amount)', {
			['@identifier'] = xPlayer.identifier,
			['@society'] = society,
			['@amount'] = amount
		}, function(rowsChanged)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have', ESX.Math.GroupDigits(amount)))
		end)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
	end

end)

RegisterServerEvent('esx_societyfaction:putVehicleInGarageFaction')
AddEventHandler('esx_societyfaction:putVehicleInGarageFaction', function(societyName, vehicle)
	local society = GetSocietyFaction(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		table.insert(garage, vehicle)
		store.set('garage', garage)
	end)
end)

RegisterServerEvent('esx_societyfaction:removeVehicleFromGarageFaction')
AddEventHandler('esx_societyfaction:removeVehicleFromGarageFaction', function(societyName, vehicle)
	local society = GetSocietyFaction(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}

		for i=1, #garage, 1 do
			if garage[i].plate == vehicle.plate then
				table.remove(garage, i)
				break
			end
		end

		store.set('garage', garage)
	end)
end)

ESX.RegisterServerCallback('esx_societyfaction:getSocietyMoneyFaction', function(source, cb, societyName)
	local society = GetSocietyFaction(societyName)

	if society then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			cb(account.money)
		end)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_societyfaction:getEmployeesFaction', function(source, cb, society)
	if Config.EnableESXIdentity then

		MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, faction, faction_grade FROM users WHERE faction = @faction ORDER BY faction_grade DESC', {
			['@faction'] = society
		}, function (results)
			local employees = {}

			for i=1, #results, 1 do
				table.insert(employees, {
					name = results[i].firstname .. ' ' .. results[i].lastname,
					identifier = results[i].identifier,
					faction = {
						name = results[i].faction,
						label = Factions[results[i].faction].label,
						grade = results[i].faction_grade,
						grade_name  = Factions[results[i].faction].grades[tostring(results[i].faction_grade)].name,
						grade_label = Factions[results[i].faction].grades[tostring(results[i].faction_grade)].label
					}
				})
			end

			cb(employees)
		end)
	else
		MySQL.Async.fetchAll('SELECT name, identifier, faction, faction_grade FROM users WHERE faction = @faction ORDER BY faction_grade DESC', {
			['@faction'] = society
		}, function (result)
			local employees = {}

			for i=1, #result, 1 do
				table.insert(employees, {
					name = result[i].name,
					identifier = result[i].identifier,
					faction = {
						name = result[i].faction,
						label = Factions[result[i].faction].label,
						grade = result[i].faction_grade,
						grade_name  = Factions[result[i].faction].grades[tostring(result[i].faction_grade)].name,
						grade_label = Factions[result[i].faction].grades[tostring(result[i].faction_grade)].label
					}
				})
			end

			cb(employees)
		end)
	end
end)

ESX.RegisterServerCallback('esx_societyfaction:getFaction', function(source, cb, society)
	local faction = json.decode(json.encode(Factions[society]))
	local grades = {}

	for k,v in pairs(faction.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	faction.grades = grades

	cb(faction)
end)


ESX.RegisterServerCallback('esx_societyfaction:setFaction', function(source, cb, identifier, faction, grade, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss = xPlayer.faction.grade_name == 'boss'

	if isBoss then
		local xTarget = ESX.GetPlayerFromIdentifier(identifier)

		if xTarget then
			xTarget.setFaction(faction, grade)

			if type == 'hire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_hired', faction))
			elseif type == 'promote' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_promoted'))
			elseif type == 'fire' then
				TriggerClientEvent('esx:showNotification', xTarget.source, _U('you_have_been_fired', xTarget.getFaction().label))
			end

			cb()
		else
			MySQL.Async.execute('UPDATE users SET faction = @faction, faction_grade = @faction_grade WHERE identifier = @identifier', {
				['@faction'] = faction,
				['@faction_grade']  = grade,
				['@identifier'] = identifier
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		print(('esx_societyfaction: %s attempted to setFaction'):format(xPlayer.identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_societyfaction:setFactionSalary', function(source, cb, faction, grade, salary)
	local isBoss = isPlayerBossFaction(source, faction)
	local identifier = GetPlayerIdentifier(source, 0)

	if isBoss then
		if salary <= Config.MaxSalary then
			MySQL.Async.execute('UPDATE faction_grades SET salary = @salary WHERE faction_name = @faction_name AND grade = @grade', {
				['@salary'] = salary,
				['@faction_name'] = faction,
				['@grade'] = grade
			}, function(rowsChanged)
				Factions[faction].grades[tostring(grade)].salary = salary
				local xPlayers = ESX.GetPlayers()

				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

					if xPlayer.faction.name == faction and xPlayer.faction.grade == grade then
						xPlayer.setFaction(faction, grade)
					end
				end

				cb()
			end)
		else
			print(('esx_societyfaction: %s attempted to setFactionSalary over config limit!'):format(identifier))
			cb()
		end
	else
		print(('esx_societyfaction: %s attempted to setFactionSalary'):format(identifier))
		cb()
	end
end)

ESX.RegisterServerCallback('esx_societyfaction:getOnlinePlayersFaction', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source = xPlayer.source,
			identifier = xPlayer.identifier,
			name = xPlayer.name,
			faction = xPlayer.faction
		})
	end

	cb(players)
end)

ESX.RegisterServerCallback('esx_societyfaction:getVehiclesInGarageFaction', function(source, cb, societyName)
	local society = GetSocietyFaction(societyName)

	TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
		local garage = store.get('garage') or {}
		cb(garage)
	end)
end)

ESX.RegisterServerCallback('esx_societyfaction:isBossFaction', function(source, cb, faction)
	cb(isPlayerBossFaction(source, faction))
end)

function isPlayerBossFaction(playerId, faction)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.faction.name == faction and xPlayer.faction.grade_name == 'boss' then
		return true
	else
		print(('esx_societyfaction: %s attempted open a society boss menu!'):format(xPlayer.identifier))
		return false
	end
end

function WashMoneyCRONFaction(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM faction_moneywash', {}, function(result)
		for i=1, #result, 1 do
			local society = GetSocietyFaction(result[i].society)
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].identifier)

			-- add society money
			TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
				account.addMoney(result[i].amount)
			end)

			-- send notification if player is online
			if xPlayer then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_laundered', ESX.Math.GroupDigits(result[i].amount)))
			end

			MySQL.Async.execute('DELETE FROM faction_moneywash WHERE id = @id', {
				['@id'] = result[i].id
			})
		end
	end)
end

TriggerEvent('cron:runAt', 3, 0, WashMoneyCRONFaction)
