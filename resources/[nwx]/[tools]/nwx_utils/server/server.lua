ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

-- Gym
RegisterServerEvent('esx_kekke_tackle:tryTackle')
AddEventHandler('esx_kekke_tackle:tryTackle', function(target)
	local targetPlayer = ESX.GetPlayerFromId(target)
	TriggerClientEvent('esx_kekke_tackle:getTackled', targetPlayer.source, source)
	TriggerClientEvent('esx_kekke_tackle:playTackle', source)
end)

RegisterServerEvent('esx_gym:hireBmx')
AddEventHandler('esx_gym:hireBmx', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 250) then
		xPlayer.removeMoney(250)
			
		notification("Vous avez loué un ~g~BMX")
	else
		notification("Tu n'as pas assez ~r~d'argent")
	end	
end)

RegisterServerEvent('esx_gym:checkChip')
AddEventHandler('esx_gym:checkChip', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local memberQuantity = xPlayer.getInventoryItem('gym_membership').count
	
	if memberQuantity > 0 then
		TriggerClientEvent('esx_gym:trueMembership', source) -- true
	else
		TriggerClientEvent('esx_gym:falseMembership', source) -- false
	end
end)

RegisterServerEvent('esx_gym:buyMembership')
AddEventHandler('esx_gym:buyMembership', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if(xPlayer.getMoney() >= 1800) then
		xPlayer.removeMoney(1800)
		
		xPlayer.addInventoryItem('gym_membership', 1)		
		notification("Vous avez acheté une ~g~carte d'adhésion")
		
		TriggerClientEvent('esx_gym:trueMembership', source) -- true
	else
		notification(" Tu n'as pas assez ~r~d'argent")
	end	
end)

RegisterServerEvent('esx_gym:buyProteinshake')
AddEventHandler('esx_gym:buyProteinshake', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local ProteinQuantity = xPlayer.getInventoryItem('protein_shake').count

	if ProteinQuantity >= 5 then
		notification("Vous n'avez pas assez de ~r~place !")
	else
		if(xPlayer.getMoney() >= 60) then
		xPlayer.removeMoney(60)
		xPlayer.addInventoryItem('protein_shake', 1)
		
		notification("Vous avez acheté un ~g~Shake protein")
		else
			notification("Vous n'avez pas assez ~r~d'argent")
		end
	end	
end)

ESX.RegisterUsableItem('protein_shake', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('protein_shake', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 350000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu un ~g~Shake protein')

end)

RegisterServerEvent('nwx_utils:buyPhone')
AddEventHandler('nwx_utils:buyPhone', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local PhoneQuantity = xPlayer.getInventoryItem('phone').count

	if PhoneQuantity >= 2 then
		notification("Vous n'avez pas assez de ~r~place !")
	else
		if(xPlayer.getMoney() >= 100) then
			xPlayer.removeMoney(100)
			xPlayer.addInventoryItem('phone', 1)
			
			notification("Vous avez acheté un ~g~Portable")
		else
			notification("Vous n'avez pas assez ~r~d'argent")
		end
	end	
end)

RegisterServerEvent('nwx_utils:buyRadio')
AddEventHandler('nwx_utils:buyRadio', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local RadioQuantity = xPlayer.getInventoryItem('radio').count

	if RadioQuantity >= 2 then
		notification("Vous n'avez pas assez de ~r~place !")
	else
		if(xPlayer.getMoney() >= 250) then
			xPlayer.removeMoney(250)
			xPlayer.addInventoryItem('radio', 1)
			
			notification("Vous avez acheté un ~g~Talkies walkie")
		else
			notification("Vous n'avez pas assez ~r~d'argent")
		end
	end	
end)

RegisterServerEvent('nwx_utils:buyJbl')
AddEventHandler('nwx_utils:buyJbl', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local JblQuantity = xPlayer.getInventoryItem('jbl').count

	if JblQuantity >= 2 then
		notification("Vous n'avez pas assez de ~r~place !")
	else
		if(xPlayer.getMoney() >= 150) then
			xPlayer.removeMoney(150)
			xPlayer.addInventoryItem('jbl', 1)
			
			notification("Vous avez acheté une ~g~Enceinte Jbl")
		else
			notification("Vous n'avez pas assez ~r~d'argent")
		end
	end	
end)

RegisterServerEvent('nwx_utils:buyGps')
AddEventHandler('nwx_utils:buyGps', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local GpsQuantity = xPlayer.getInventoryItem('gps').count

	if GpsQuantity >= 2 then
		notification("Vous n'avez pas assez de ~r~place !")
	else
		if(xPlayer.getMoney() >= 100) then
			xPlayer.removeMoney(100)
			xPlayer.addInventoryItem('gps', 1)
			
			notification("Vous avez acheté un ~g~GPS")
		else
			notification("Vous n'avez pas assez ~r~d'argent")
		end
	end	
end)

RegisterServerEvent('esx_gym:buyWater')
AddEventHandler('esx_gym:buyWater', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local WaterQuantity = xPlayer.getInventoryItem('water').count

	if WaterQuantity >= 10 then
		notification("Vous n'avez pas assez de ~r~place !")
	else
		if(xPlayer.getMoney() >= 15) then
			xPlayer.removeMoney(15)
			xPlayer.addInventoryItem('water', 1)
			
			notification("Vous avez acheté de ~g~l'eau")
		else
			notification("Vous n'avez pas assez ~r~d'argent")
		end
	end	
end)


RegisterServerEvent('esx_gym:buySportlunch')
AddEventHandler('esx_gym:buySportlunch', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local SportLunchQuantity = xPlayer.getInventoryItem('sportlunch').count

	if SportLunchQuantity >= 2 then
		notification("Vous n'avez pas assez de ~r~place !")
	else
		if(xPlayer.getMoney() >= 20) then
			xPlayer.removeMoney(20)
			xPlayer.addInventoryItem('sportlunch', 1)
			
			notification("Vous avez acheté un ~g~dejeuné sportif")
		else
			notification("Vous n'avez pas assez ~r~d'argent")
		end
	end	
end)

ESX.RegisterUsableItem('sportlunch', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('sportlunch', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 350000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez mangé votre ~g~dejeuné sportif')

end)

RegisterServerEvent('esx_gym:buyPowerade')
AddEventHandler('esx_gym:buyPowerade', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local PoweradeQuantity = xPlayer.getInventoryItem('powerade').count

	if PoweradeQuantity >= 2 then
		notification("Vous n'avez pas assez de ~r~place !")
	else
		if(xPlayer.getMoney() >= 15) then
			xPlayer.removeMoney(15)
			xPlayer.addInventoryItem('powerade', 1)
			
			notification("Vous avez acheté une ~g~powerade")
		else
			notification("Vous n'avez pas assez ~r~d'argent")
		end
	end	
end)

ESX.RegisterUsableItem('powerade', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('powerade', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 700000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu votre ~g~powerade')

end)

function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end

-- Porter
RegisterServerEvent('cmg2_animations:sync')
AddEventHandler('cmg2_animations:sync', function(target, animationLib, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	print("got to srv cmg2_animations:sync")
	TriggerClientEvent('cmg2_animations:syncTarget', targetSrc, source, animationLib, animation2, distans, distans2, height, length, spin, controlFlagTarget, animFlagTarget)
	print("triggering to target: " .. tostring(targetSrc))
	TriggerClientEvent('cmg2_animations:syncMe', source, animationLib, animation, length, controlFlagSrc, animFlagTarget)
end)

RegisterServerEvent('cmg2_animations:stop')
AddEventHandler('cmg2_animations:stop', function(targetSrc)
	TriggerClientEvent('cmg2_animations:cl_stop', targetSrc)
end)
