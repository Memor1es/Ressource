ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('jbl', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.removeInventoryItem('jbl', 1)
	
	TriggerClientEvent('esx_jbl:place_jbl', source)
	TriggerClientEvent('esx:showNotification', source, _U('put_jbl'))
end)

RegisterServerEvent('esx_jbl:remove_jbl')
AddEventHandler('esx_jbl:remove_jbl', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getInventoryItem('jbl').count < xPlayer.getInventoryItem('jbl').limit then
		xPlayer.addInventoryItem('jbl', 1)
	end
	TriggerClientEvent('esx_jbl:stop_music', -1, coords)
end)


RegisterServerEvent('esx_jbl:play_music')
AddEventHandler('esx_jbl:play_music', function(id, coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_jbl:play_music', -1, id, coords)
end)

RegisterServerEvent('esx_jbl:stop_music')
AddEventHandler('esx_jbl:stop_music', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_jbl:stop_music', -1, coords)
end)

RegisterServerEvent('esx_jbl:setVolume')
AddEventHandler('esx_jbl:setVolume', function(volume, coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_jbl:setVolume', -1, volume, coords)
end)