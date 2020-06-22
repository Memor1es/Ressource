ESX = nil
steamIdentifiers = {}

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

AddEventHandler('esx:onAddInventoryItem', function(source, item, count)
	local source_ = source
	if item.name == 'tracker' then
		if #steamIdentifiers > 0 then
			for i=#steamIdentifiers,1,-1 do
			    if steamIdentifiers[i].src == source_ then
			        table.remove(steamIdentifiers, i)
			    end
			end
		end
    	local identifier = GetPlayerIdentifiers(source_)[1]
		local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
		local jobname = xPlayer.getJob().name
		local elem = {}
		elem['src'] = source_
		elem['job'] = jobname
		elem['name'] = xPlayer.getName()
		table.insert(steamIdentifiers, elem)
		TriggerClientEvent('bl_trackGPS:update', -1)
	elseif item.name == 'sniffer' then
		TriggerClientEvent('bl_trackGPS:addSniffer', source_)
	end

	if item.name == 'tracker2' then
		if #steamIdentifiers > 0 then
			for i=#steamIdentifiers,1,-1 do
			    if steamIdentifiers[i].src == source_ then
			        table.remove(steamIdentifiers, i)
			    end
			end
		end
    	local identifier = GetPlayerIdentifiers(source_)[1]
		local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
		local jobname = xPlayer.getJob().name
		local elem = {}
		elem['src'] = source_
		elem['job'] = jobname
		elem['name'] = xPlayer.getName()
		table.insert(steamIdentifiers, elem)
		TriggerClientEvent('bl_trackGPS:update2', -1)
	elseif item.name == 'sniffer2' then
		TriggerClientEvent('bl_trackGPS:addSniffer2', source_)
	end	
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
	local source_ = source
	if item.name == 'tracker' and item.count < 1 then
		if #steamIdentifiers > 0 then
			for i=#steamIdentifiers,1,-1 do
			    if steamIdentifiers[i].src == source_ then
			        table.remove(steamIdentifiers, i)
			    end
			end
		end

		TriggerClientEvent('bl_trackGPS:update', -1)
	elseif item.name == 'sniffer' then
		TriggerClientEvent('bl_trackGPS:removeSniffer', source_)
	end

	if item.name == 'tracker2' and item.count < 1 then
		if #steamIdentifiers > 0 then
			for i=#steamIdentifiers,1,-1 do
			    if steamIdentifiers[i].src == source_ then
			        table.remove(steamIdentifiers, i)
			    end
			end
		end

		TriggerClientEvent('bl_trackGPS:update2', -1)
	elseif item.name == 'sniffer2' then
		TriggerClientEvent('bl_trackGPS:removeSniffer2', source_)
	end	
end)

RegisterServerEvent('bl_trackGPS:get')
AddEventHandler('bl_trackGPS:get', function()
	TriggerClientEvent('bl_trackGPS:getCallback', -1, steamIdentifiers)
end)

RegisterServerEvent('bl_trackGPS:get2')
AddEventHandler('bl_trackGPS:get2', function()
	TriggerClientEvent('bl_trackGPS:getCallback2', -1, steamIdentifiers)
end)

RegisterServerEvent('bl_trackGPS:addTracker')
AddEventHandler('bl_trackGPS:addTracker', function()
	local source_ = source
	if #steamIdentifiers > 0 then
		for i=#steamIdentifiers,1,-1 do
		    if steamIdentifiers[i].src == source_ then
		        table.remove(steamIdentifiers, i)
		    end
		end
	end

	local identifier = GetPlayerIdentifiers(source_)[1]
	local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
	local jobname = xPlayer.getJob().name
	local elem = {}
	elem['src'] = source_
	elem['job'] = jobname
	elem['name'] = xPlayer.getName()
	table.insert(steamIdentifiers, elem)
	TriggerClientEvent('bl_trackGPS:update', -1)
end)

RegisterServerEvent('bl_trackGPS:addTracker2')
AddEventHandler('bl_trackGPS:addTracker2', function()
	local source_ = source
	if #steamIdentifiers > 0 then
		for i=#steamIdentifiers,1,-1 do
		    if steamIdentifiers[i].src == source_ then
		        table.remove(steamIdentifiers, i)
		    end
		end
	end

	local identifier = GetPlayerIdentifiers(source_)[1]
	local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
	local jobname = xPlayer.getJob().name
	local elem = {}
	elem['src'] = source_
	elem['job'] = jobname
	elem['name'] = xPlayer.getName()
	table.insert(steamIdentifiers, elem)
	TriggerClientEvent('bl_trackGPS:update2', -1)
end)