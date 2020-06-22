ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('nwx_weed:DeleteWeed')
AddEventHandler('nwx_weed:DeleteWeed', function(x)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('nwx_weed:DeleteWeed', _source, x)

    MySQL.Async.execute(
        'DELETE FROM position_agricultures WHERE x = @x',
        {
            ['@x'] = x
        },
        function()
        end
    )
end)


RegisterServerEvent('nwx_weed:CreateWeed')
AddEventHandler('nwx_weed:CreateWeed', function(x, y, z,id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.execute(
        'INSERT INTO position_agricultures (id, identifier, name, x, y, z) VALUES (@id, @identifier, @name, @x, @y, @z)',
        {
        ['@id'] = id,
        ['@identifier'] = xPlayer.identifier,
        ['@name'] = 'Weed',
        ['@x'] = x,
        ['@y'] = y,
        ['@z'] = z
        },
        function(result)
        end
     ) 
end)

ESX.RegisterServerCallback('nwx_weed:CheckWeed', function(source, cb)

    MySQL.Async.fetchAll(
        'SELECT * FROM position_agricultures',
        {},
        function(result)
            local data = {}
            for i=1, #result, 1 do
                table.insert(data, {
                    identifier = result[i].identifier,
                    name = result[i].name,
                    x = result[i].x,
                    y = result[i].y,
                    z = result[i].z,
                    percent = result[i].percent 
                })
            end
            cb(data)
        end
    ) 
end)

RegisterServerEvent('nwx_weed:GiveWeed')
AddEventHandler('nwx_weed:GiveWeed', function(x)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local random = math.random(100,150)
    local randomweed = math.random(0,100)
    local randomgraineweed = math.random(1,5)

    xPlayer.addInventoryItem('weed', random)

    if randomweed <= 2 then
        xPlayer.addInventoryItem('weed_seed', randomgraineweed)
    end

    TriggerClientEvent('nwx_weed:DeleteWeed', _source, x)

    MySQL.Async.execute(
        'DELETE FROM position_agricultures WHERE x = @x',
        {
            ['@x'] = x
        },
        function()
        end
    )
end)

ESX.RegisterUsableItem('weed_seed', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local pot = xPlayer.getInventoryItem('pot').count

    if pot <= 0 then
        TriggerClientEvent('esx:showNotification', source,'~r~Vous devez avoir un ~b~Pot~s~ !')
    else 
        xPlayer.removeInventoryItem('weed_seed', 1)
        xPlayer.removeInventoryItem('pot', 1)
        TriggerClientEvent('nwx_weed:PlantationWeed', source)
        print("Graine de Weed Plante par: " ..xPlayer.name)
        TriggerClientEvent('esx:showNotification', source,'~g~Plantation~s~ en ~b~cours~s~.')     
    end
end)

ESX.RegisterUsableItem('truele', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent('nwx_weed:UseTruelle', source)
	print("Truelle utilise par: " ..xPlayer.name)
end)

ESX.RegisterUsableItem('pelle', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent('nwx_weed:UsePelle', source)
    TriggerClientEvent('esx:showNotification', source,'~r~Destruction~s~ de plant en ~b~cours~s~.')        
	print("Pelle utilise par: " ..xPlayer.name)
end)

RegisterServerEvent('nwx_weed:BuySeedWeed')
AddEventHandler('nwx_weed:BuySeedWeed', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeMoney(40)
    xPlayer.addInventoryItem('weed_seed', 1)

end)

RegisterServerEvent('nwx_weed:BuyTruelle')
AddEventHandler('nwx_weed:BuyTruelle', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeMoney(100)
    xPlayer.addInventoryItem('truele', 1)

end)

RegisterServerEvent('nwx_weed:BuyPot')
AddEventHandler('nwx_weed:BuyPot', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeMoney(65)
    xPlayer.addInventoryItem('pot', 1)

end)

function UptadePourcent()
	local xPlayers 	= ESX.GetPlayers()
	local TimeUpdate = 15 -- En minutes
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		MySQL.Async.execute(
			'UPDATE position_agricultures SET percent = percent + 2.69',
		 	{
		 	}
		)
	end
    SetTimeout(TimeUpdate * 60 * 1000, UptadePourcent)
    print('Le pourcentage des plantations de cannabis vient d\'augmenter')
end

UptadePourcent()