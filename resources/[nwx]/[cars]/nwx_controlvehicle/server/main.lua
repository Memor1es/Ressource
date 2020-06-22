local arrayWeight = Config.localWeight
local VehicleList = {}

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
  ESX = obj
end)

RegisterServerEvent('esx_truck_inventory:getOwnedVehicule')
AddEventHandler('esx_truck_inventory:getOwnedVehicule', function()
  local vehicules = {}
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner',
   		{
   			['@owner'] = xPlayer.identifier
   		},
    function(result)
      if result ~= nil and #result > 0 then
          for _,v in pairs(result) do
      			local vehicle = json.decode(v.vehicle)
      			table.insert(vehicules, {plate = vehicle.plate})
      		end
      end
    TriggerClientEvent('esx_truck_inventory:setOwnedVehicule', _source, vehicules)
    end)
end)

AddEventHandler('onMySQLReady', function ()
	MySQL.Async.execute( 'DELETE FROM `truck_inventory` WHERE `count` = 0', {})
end)

function getInventoryWeight(inventory)
  local weight = 0
  local itemWeight = 0

  if inventory ~= nil then
	  for i=1, #inventory, 1 do
	    if inventory[i] ~= nil then
	      itemWeight = Config.DefaultWeight
	      if arrayWeight[inventory[i].name] ~= nil then
	        itemWeight = arrayWeight[inventory[i].name]
	      end
	      weight = weight + (itemWeight * inventory[i].count)
	    end
	  end
  end
  return weight
end

RegisterServerEvent('esx_truck_inventory:getInventory')
AddEventHandler('esx_truck_inventory:getInventory', function(plate)
  local inventory_ = {}
  local _source = source
  MySQL.Async.fetchAll('SELECT * FROM `truck_inventory` WHERE `plate` = @plate',
    {
      ['@plate'] = plate
    },
    function(inventory)
      if inventory ~= nil and #inventory > 0 then
        for i=1, #inventory, 1 do
		  if inventory[i].count > 0 then
			table.insert(inventory_, {
			  label = inventory[i].name,
			  name = inventory[i].item,
			  count = inventory[i].count,
			  type = inventory[i].itemt
			})
		   end
        end
      end
    local weight = (getInventoryWeight(inventory_))
    local xPlayer = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('esx_truck_inventory:getInventoryLoaded', xPlayer.source, inventory_,weight)
    end)
end)


RegisterServerEvent('esx_truck_inventory:removeInventoryItem')
AddEventHandler('esx_truck_inventory:removeInventoryItem', function(plate, item, itemType, count)
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)
	if plate ~= " " or plate ~= nil or plate ~= "" then
	  	MySQL.Async.fetchScalar('SELECT `count` FROM truck_inventory WHERE `plate` = @plate AND `item`= @item AND `itemt`= @itemt',
		{
			['@plate'] = plate,
			['@item'] = item,
			['@itemt'] = itemType
		}, function(countincar)
			if countincar >= count then
				 MySQL.Async.execute( 'UPDATE `truck_inventory` SET `count`= `count` - @qty WHERE `plate` = @plate AND `item`= @item AND `itemt`= @itemt',
				{
				['@plate'] = plate,
				['@qty'] = count,
				['@item'] = item,
				['@itemt'] = itemType
				})
				if xPlayer ~= nil then
					if itemType == 'item_standard' then
						xPlayer.addInventoryItem(item, count)
					end 

					if itemType == 'item_account' then
						xPlayer.addAccountMoney(item, count)
					end

					if itemType == 'item_weapon' then
						xPlayer.addWeapon(item, count)
					end
				end

			end

		end)
	end	
end)

RegisterServerEvent('esx_truck_inventory:addInventoryItem')
AddEventHandler('esx_truck_inventory:addInventoryItem', function(type, model, plate, item, qtty, name,itemType, ownedV)
  local _source = source
  local xPlayer  = ESX.GetPlayerFromId(_source)
  
	if plate ~= " " or plate ~= nil or plate ~= "" then
	  	MySQL.Async.execute( 'INSERT INTO truck_inventory (item,count,plate,name,itemt,owned) VALUES (@item,@qty,@plate,@name,@itemt,@owned) ON DUPLICATE KEY UPDATE count=count+ @qty',
	    {
		      ['@plate'] = plate,
		      ['@qty'] = qtty,
		      ['@item'] = item,
		      ['@name'] = name,
			  ['@itemt'] = itemType,
		      ['@owned'] = ownedV,
	    })
		
		if xPlayer ~= nil then
			if itemType == 'item_standard' then
				local playerItemCount = xPlayer.getInventoryItem(item).count
				if playerItemCount >= qtty then
				   xPlayer.removeInventoryItem(item, qtty)
				else
				  TriggerClientEvent('esx:showNotification', _source, 'quantité invalide')
				end
			end

			if itemType == 'item_account' then
				xPlayer.removeAccountMoney(item, qtty)
			end

			if itemType == 'item_weapon' then
				xPlayer.removeWeapon(item, qtty)
			end
		end
	end
end)

ESX.RegisterServerCallback('esx_truck:checkvehicle',function(source,cb, vehicleplate)
	local isFound = false
	local _source = source
	local plate = vehicleplate
	if plate ~= " " or plate ~= nil or plate ~= "" then
		for _,v in pairs(VehicleList) do
			if(plate == v.vehicleplate) then
				isFound = true
				break
				
			end	
		end
	else
		isFound = true
	end
	cb(isFound)
end)

RegisterServerEvent('esx_truck_inventory:AddVehicleList')
AddEventHandler('esx_truck_inventory:AddVehicleList', function(plate)
	local plateisfound = false
	if plate ~= " " or plate ~= nil or plate ~= "" then
		for _,v in pairs(VehicleList) do
			if(plate == v.vehicleplate) then
				plateisfound = true
				break
			end		
		end
		if not plateisfound then
			table.insert(VehicleList, {vehicleplate = plate})
		end
	end
end)

RegisterServerEvent('esx_truck_inventory:RemoveVehicleList')
AddEventHandler('esx_truck_inventory:RemoveVehicleList', function(plate)
	for i=1, #VehicleList, 1 do
		if VehicleList[i].vehicleplate == plate then
			if VehicleList[i].vehicleplate ~= " " or plate ~= " " or VehicleList[i].vehicleplate ~= nil or plate ~= nil or VehicleList[i].vehicleplate ~= "" or plate ~= "" then
				table.remove(VehicleList, i)
				break
			end
		end
	end
end)

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

-- Véhicle control


RegisterServerEvent("lvc_TogDfltSrnMuted_s")
AddEventHandler("lvc_TogDfltSrnMuted_s", function(toggle)
	TriggerClientEvent("lvc_TogDfltSrnMuted_c", -1, source, toggle)
end)

RegisterServerEvent("lvc_SetLxSirenState_s")
AddEventHandler("lvc_SetLxSirenState_s", function(newstate)
	TriggerClientEvent("lvc_SetLxSirenState_c", -1, source, newstate)
end)

RegisterServerEvent("lvc_TogPwrcallState_s")
AddEventHandler("lvc_TogPwrcallState_s", function(toggle)
	TriggerClientEvent("lvc_TogPwrcallState_c", -1, source, toggle)
end)

RegisterServerEvent("lvc_SetAirManuState_s")
AddEventHandler("lvc_SetAirManuState_s", function(newstate)
	TriggerClientEvent("lvc_SetAirManuState_c", -1, source, newstate)
end)

RegisterServerEvent("lvc_TogIndicState_s")
AddEventHandler("lvc_TogIndicState_s", function(newstate)
	TriggerClientEvent("lvc_TogIndicState_c", -1, source, newstate)
end)


-- E N G I N E --
AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/engine off" then
		CancelEvent()
		--------------
		TriggerClientEvent('engineoff', s)
	elseif message == "/engine on" then
		CancelEvent()
		--------------
		TriggerClientEvent('engineon', s)
	elseif message == "/engine" then
		CancelEvent()
		--------------
		TriggerClientEvent('engine', s)
	end
end)
-- T R U N K --
AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/trunk" then
		CancelEvent()
		--------------
		TriggerClientEvent('trunk', s)
	end
end)
-- R E A R  D O O R S --
AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/rdoors" then
		CancelEvent()
		--------------
		TriggerClientEvent('rdoors', s)
	end
end)
-- H O O D --
AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/hood" then
		CancelEvent()
		--------------
		TriggerClientEvent('hood', s)
	end
end)
-- L O C K --
AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/lock" then
		CancelEvent()
		--------------
		TriggerClientEvent('lock', s)
	end
end)
-- S A V E --
AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/save" then
		CancelEvent()
		--------------
		TriggerClientEvent('save', s)
	end
end)
-- R E M O T E --
AddEventHandler('chatMessage', function(s, n, m)
	local message = string.lower(m)
	if message == "/sveh" then
		CancelEvent()
		--------------
		TriggerClientEvent('controlsave', s)
	end
end)

-- esx_vehiclelock
local cars = {}

--Supprésion au démarrage des double de clés
AddEventHandler('onMySQLReady', function()
MySQL.Async.fetchAll('SELECT * FROM open_car WHERE NB = @NB',
		{
		['@NB'] = 2
		},
		function(result)
		for i=1, #result, 1 do
			MySQL.Async.execute('DELETE FROM open_car WHERE id = @id',
				{
					['@id'] = result[i].id
				}
			)
		end
	end)
end)

-- Dépence d'autre scripts
ESX.RegisterServerCallback('esx_society:isowned', function(source, cb, plate, jobs)
local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner',
	{
		['@owner'] = 'society:'..jobs
	},
	function(result)
		local found = false

		for i=1, #result, 1 do

			local vehicleProps = json.decode(result[i].vehicle)

			if vehicleProps.plate == plate then
				found = true
				break
			end
		end
		cb(found)
	end)
end)

-- Véhicle appartenue mais sans clés
ESX.RegisterServerCallback('esx_vehiclelock:getVehiclesnokey', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
MySQL.Async.fetchAll('SELECT * FROM open_car WHERE identifier = @owner',
		{
			['@owner'] = xPlayer.identifier
		},
		function(result2)
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner',
		{
			['@owner'] = xPlayer.identifier
		},
		function(result)
			local vehicles = {}
			
			for i=1, #result, 1 do
				local found = false
				local vehicleData = json.decode(result[i].vehicle)
				for j=1, #result2, 1 do
					if result2[j].value == vehicleData.plate then
						
						found = true
						
					end
				end

				if found ~= true then
					
					table.insert(vehicles, vehicleData)
				end

			end
			cb(vehicles)
		end
	)
		end
	)
end)

-- Véhicle appartenue mais sans clés

ESX.RegisterServerCallback('esx_vehiclelock:getVehiclesnokeycardealer', function(source, cb, target)
local xPlayer = ESX.GetPlayerFromId(target)
MySQL.Async.fetchAll('SELECT * FROM open_car WHERE identifier = @owner',
		{
			['@owner'] = xPlayer.identifier
		},
		function(result2)

			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner',
		{
			['@owner'] = xPlayer.identifier
		},
		function(result)
			local vehicles = {}

			for i=1, #result, 1 do
				local found = false
				local vehicleData = json.decode(result[i].vehicle)
				for j=1, #result2, 1 do
					if result2[j].value == vehicleData.plate then
						found = true
					end
				end
				if found ~= true then
					table.insert(vehicles, vehicleData)
				end
			end
			cb(vehicles)
		end
	)
		end
	)
end)

-- Donné les clé
RegisterServerEvent('esx_vehiclelock:givekeycardealer')
AddEventHandler('esx_vehiclelock:givekeycardealer', function(target, plate)
local _source = source
local xPlayer = nil
local toplate = plate
xPlayertarget = ESX.GetPlayerFromId(target)
xPlayer = ESX.GetPlayerFromId(_source)

MySQL.Async.execute('INSERT INTO open_car (label, value, NB, got, identifier) VALUES (@label, @value, @NB, @got, @identifier)',
	{
		['@label'] = 'Cles',
		['@value'] = toplate,
		['@NB'] = 1,
		['@got'] = 'true',
		['@identifier'] = xPlayertarget.identifier
	},
	function(result)
		TriggerClientEvent('esx:showNotification', xPlayertarget.source, '~g~Vous avez reçu les clés de votre véhicule ~g~')
	end)
end)

RegisterServerEvent('esx_vehiclelock:deletekeycardealer')
AddEventHandler('esx_vehiclelock:deletekeycardealer', function(target, plate)
local _source = source
local xPlayer = nil
local toplate = plate
xPlayer = ESX.GetPlayerFromId(_source)

MySQL.Async.fetchAll(
		'SELECT * FROM open_car WHERE value = @plate AND NB = @NB AND identifier = @identifier',
		{
		['@NB'] = 3,
		['@plate'] = toplate,
		['@identifier'] = xPlayer.identifier
		},
		function(result)

		for i=1, #result, 1 do
			MySQL.Async.execute(
			'DELETE FROM open_car WHERE id = @id',
			{
				['@id'] = result[i].id
			}
		)
		end
		TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Vous avez donné les clé à l'acheteur ~g~")
	end)
end)

RegisterServerEvent('esx_vehiclelock:registerkeycardealer')
AddEventHandler('esx_vehiclelock:registerkeycardealer', function(plate, target)
local _source = source
local xPlayer = nil
if target == 'no' then
	 xPlayer = ESX.GetPlayerFromId(_source)
else
	 xPlayer = ESX.GetPlayerFromId(target)
end
MySQL.Async.execute(
		'INSERT INTO open_car (label, value, NB, got, identifier) VALUES (@label, @value, @NB, @got, @identifier)',
		{
			['@label'] = 'Cles',
			['@value'] = plate,
			['@NB'] = 3,
			['@got'] = 'true',
			['@identifier'] = xPlayer.identifier

		},
		function(result)
				TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez un nouvelle paire de clés ! ')
				TriggerClientEvent('esx:showNotification', _source, 'Clés bien enregistrer ! ')
		end)
end)

--Clés appartenue par rapport a la plaque
ESX.RegisterServerCallback('esx_vehiclelock:mykey', function(source, cb, plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll(
		'SELECT * FROM open_car WHERE value = @plate AND identifier = @identifier', 
		{
			['@plate'] = plate,
			['@identifier'] = xPlayer.identifier
		},
		function(result)

			local found = false
			if result[1] ~= nil then
				
				if xPlayer.identifier == result[1].identifier then 
					found = true
				end
			end
			if found then
				cb(true)
	
			else
				cb(false)
			end

		end
	)
end)

-- Toutes les clés appartenu par le joueur
ESX.RegisterServerCallback('esx_vehiclelock:allkey', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll(
		'SELECT * FROM open_car WHERE identifier = @identifier', 
		{
			['@identifier'] = xPlayer.identifier

		},
		function(result)
			key = {}
			for i=1, #result, 1 do
				
				keyadd = { plate = result[i].value,
							  NB = result[i].NB,
							 got = result[i].got }
					
					table.insert(key, keyadd)
			end
			cb(key)
		end
	)
end)

-- Suppression clé jobs
RegisterServerEvent('esx_vehiclelock:deletekeyjobs')
AddEventHandler('esx_vehiclelock:deletekeyjobs', function(target, plate)
local _source = source
local xPlayer = nil
local toplate = plate

if target ~= 'no' then
	
	 xPlayer = ESX.GetPlayerFromId(target)
else
	
	 xPlayer = ESX.GetPlayerFromId(_source)
end

MySQL.Async.fetchAll(
		'SELECT * FROM open_car WHERE identifier = @identifier',
		{
		['@identifier']   = xPlayer.identifier
		},
		function(result)


		for i=1, #result, 1 do
			MySQL.Async.execute(
				'DELETE FROM open_car WHERE value = @value',
				{
					['@value'] = toplate
				}
			)
		end
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez rendu les clés du véhicule de fonction')
	end)
end)

-- Donné un double
RegisterServerEvent('esx_vehiclelock:givekey')
AddEventHandler('esx_vehiclelock:givekey', function(target, plate)
local _source = source
local xPlayer = nil
local toplate = plate

if target == 'no' then
	 xPlayer = ESX.GetPlayerFromId(_source)
else
	 xPlayer = ESX.GetPlayerFromId(target)
end

MySQL.Async.execute(
		'INSERT INTO open_car (label, value, NB, got, identifier) VALUES (@label, @value, @NB, @got, @identifier)',
		{
			['@label'] = 'Cles',
			['@value'] = toplate,
			['@NB'] = 2,
			['@got'] = 'true',
			['@identifier'] = xPlayer.identifier
		},
		function(result)
				TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez recu un double de clés ')
		end)
end)


--Enregistrement d'une nouvelle paire de clés
RegisterServerEvent('esx_vehiclelock:registerkey')
AddEventHandler('esx_vehiclelock:registerkey', function(plate, target)
local _source = source
local xPlayer = nil
if target == 'no' then
	 xPlayer = ESX.GetPlayerFromId(_source)
else
	 xPlayer = ESX.GetPlayerFromId(target)
end
MySQL.Async.execute(
		'INSERT INTO open_car (label, value, NB, got, identifier) VALUES (@label, @value, @NB, @got, @identifier)',
		{
			['@label'] = 'Cles',
			['@value'] = plate,
			['@NB'] = 1,
			['@got'] = 'true',
			['@identifier'] = xPlayer.identifier
		},
		function(result)
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez un nouvelle pair de clés ! ')
			TriggerClientEvent('esx:showNotification', _source, 'Clés bien enregistrer ! ')
		end)
end)

--Perte des clés 
RegisterServerEvent('esx_vehiclelock:onplayerdeath')
AddEventHandler('esx_vehiclelock:onplayerdeath', function()
local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)

MySQL.Async.fetchAll(
		'SELECT * FROM open_car WHERE identifier = @identifier',
		{
		['@identifier']   = xPlayer.identifier
		},
		function(result)

		for i=1, #result, 1 do
			if result[i].NB == 1 then 
			MySQL.Async.execute('UPDATE open_car SET got = @got WHERE id = @id',
				{
					['@id'] = result[i].id,
					['@got'] = 'false'
				}
			)
			else
				MySQL.Async.execute('DELETE FROM open_car WHERE id = @id',
					{
						['@id'] = result[i].id
					}
				)
			end
		end
	end)
end)

-- Menu pour donner / preter clé
-- changement de propriétaire
RegisterServerEvent('esx_vehiclelock:changeowner')
AddEventHandler('esx_vehiclelock:changeowner', function(target, vehicleProps)
local _source = source
local xPlayer = nil
xPlayertarget = ESX.GetPlayerFromId(target)
xPlayer = ESX.GetPlayerFromId(_source)
MySQL.Async.fetchAll('INSERT INTO owned_vehicles (owner, vehicle) VALUES (@owner, @vehicle)',
		{
			['@owner'] = xPlayer.identifier,
			['@vehicle'] = json.encode(vehicleProps)
		},
		function(result)
			print("insert into terminé")
	end)
end)

-- suppression des clés NB = 1
RegisterServerEvent('esx_vehiclelock:deletekey')
AddEventHandler('esx_vehiclelock:deletekey', function(plate)
local _source = source
local xPlayer = nil
local toplate = plate
xPlayer = ESX.GetPlayerFromId(_source)

MySQL.Async.fetchAll('SELECT * FROM open_car WHERE value = @plate AND NB = @NB AND identifier = @identifier',
		{
			['@NB'] = 1,
			['@plate'] = toplate,
			['@identifier'] = xPlayer.identifier
		},
		function(result)

		for i=1, #result, 1 do
			MySQL.Async.execute('DELETE FROM open_car WHERE id = @id',
			{
				['@id'] = result[i].id
			}
		)
		end
	end)
end)

-- Donné clé
RegisterServerEvent('esx_vehiclelock:donnerkey')
AddEventHandler('esx_vehiclelock:donnerkey', function(target, plate)
local _source = source
local xPlayer = nil
local toplate = plate
xPlayertarget = ESX.GetPlayerFromId(target)
xPlayer = ESX.GetPlayerFromId(_source)

MySQL.Async.execute('INSERT INTO open_car (label, value, NB, got, identifier) VALUES (@label, @value, @NB, @got, @identifier)',
		{
			['@label'] = 'Cles',
			['@value'] = toplate,
			['@NB'] = 1,
			['@got'] = 'true',
			['@identifier'] = xPlayertarget.identifier
		},
		function(result)
			TriggerClientEvent('esx:showNotification', xPlayertarget.source, 'Vous avez reçu de nouvelle clé ')
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez donné votre clé, vous ne les avez plus !')
		end)
end)

-- Préter clé
RegisterServerEvent('esx_vehiclelock:preterkey')
AddEventHandler('esx_vehiclelock:preterkey', function(target, plate)
local _source = source
local xPlayer = nil
local toplate = plate
xPlayertarget = ESX.GetPlayerFromId(target)
xPlayer = ESX.GetPlayerFromId(_source)

MySQL.Async.execute('INSERT INTO open_car (label, value, NB, got, identifier) VALUES (@label, @value, @NB, @got, @identifier)',
		{
			['@label'] = 'Cles',
			['@value'] = toplate,
			['@NB'] = 2,
			['@got'] = 'true',
			['@identifier'] = xPlayertarget.identifier
		},
		function(result)
			TriggerClientEvent('esx:showNotification', xPlayertarget.source, 'Vous avez reçu un double de clé ')
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez prété votre clé')
		end)

end)