ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
	ESX = obj 
end)

--BOISSONS
ESX.RegisterUsableItem('vin', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('vin', 1)

	TriggerClientEvent('esx_basicneeds:BoireVin', source)
	TriggerClientEvent('esx_status:add', source, 'thirst', 120000)
	TriggerClientEvent('esx_status:add', source, 'drunk', 100000)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu du ~r~Vin~s~')
end)

ESX.RegisterUsableItem('tequila', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('tequila', 1)
	
	TriggerClientEvent('esx_basicneeds:onDrinkTequila', source)
	TriggerClientEvent('esx_status:add', source, 'thirst', 125000)
	TriggerClientEvent('esx_status:add', source, 'drunk', 170000)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu un ~r~Tequilaa~s~')
end)

ESX.RegisterUsableItem('whisky', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('whisky', 1)
	
	TriggerClientEvent('esx_basicneeds:onDrinkWhisky', source)
	TriggerClientEvent('esx_status:add', source, 'thirst', 120000)
	TriggerClientEvent('esx_status:add', source, 'drunk', 170000)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu un ~r~Whisky~s~')
end)

ESX.RegisterUsableItem('mojito', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('mojito', 1)
	
	TriggerClientEvent('esx_basicneeds:onDrinkMojito', source)
	TriggerClientEvent('esx_status:add', source, 'thirst', 120000)
	TriggerClientEvent('esx_status:add', source, 'drunk', 170000)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu un ~b~Mojito~s~')
end)

ESX.RegisterUsableItem('rhum', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('rhum', 1)
	
	TriggerClientEvent('esx_basicneeds:onDrinkRhum', source)
	TriggerClientEvent('esx_status:add', source, 'thirst', 120000)
	TriggerClientEvent('esx_status:add', source, 'drunk', 170000)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu du ~b~Rhum~s~')
end)

ESX.RegisterUsableItem('vodka', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('vodka', 1)
	
	TriggerClientEvent('esx_basicneeds:onDrinkVodka', source)
	TriggerClientEvent('esx_status:add', source, 'thirst', 120000)
	TriggerClientEvent('esx_status:add', source, 'drunk', 170000)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu une ~r~Vodka~s~')
end)

ESX.RegisterUsableItem('biere', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('biere', 1)
	
	TriggerClientEvent('esx_basicneeds:BoireBiere', source)
	TriggerClientEvent('esx_status:add', source, 'thirst', 120000)
	TriggerClientEvent('esx_status:add', source, 'drunk', 170000)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu une ~b~Bière~s~')
end)

ESX.RegisterUsableItem('pepsi', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('pepsi', 1)

	TriggerClientEvent('esx_basicneeds:onDrinkPepsi', source)
	TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu un ~g~Pepsi~s~')
end)


ESX.RegisterUsableItem('up7', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('up7', 1)

	TriggerClientEvent('esx_basicneeds:onDrinkSprunk', source)
	TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu un ~g~7up~s~')
end)


ESX.RegisterUsableItem('coca', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('coca', 1)

	TriggerClientEvent('esx_basicneeds:onDrinkCoca', source)
	TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu un ~g~Coca~s~')
end)


ESX.RegisterUsableItem('fanta', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('fanta', 1)
    
    TriggerClientEvent('esx_basicneeds:onDrinkSoda', source)
	TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu un ~g~Fanta~s~')
end)


ESX.RegisterUsableItem('sprite', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('sprite', 1)

	TriggerClientEvent('esx_basicneeds:onDrinkSprunk', source)
	TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu un ~g~Sprite~s~')
end)


ESX.RegisterUsableItem('orangina', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('orangina', 1)
    
    TriggerClientEvent('esx_basicneeds:onDrinkSoda', source)
	TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu un ~g~Orangina~s~')
end)

---Cocktail
ESX.RegisterUsableItem('cocktail', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('cocktail', 1)
    
    TriggerClientEvent('esx_basicneeds:onDrinkCocktail', source)
	TriggerClientEvent('esx_status:add', source, 'thirst', 170000)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu un ~b~Cocktail~s~ ~g~sans Alcool~s~')
end)

-- Register Usable Item soda
ESX.RegisterUsableItem('soda', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('soda', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
	TriggerClientEvent('esx_basicneeds:onDrinkSoda', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu un ~g~Soda~s~')
end)

-- Register Usable Item water
ESX.RegisterUsableItem('water', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('water', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 145000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu de ~g~ l\'Eau~s~')
end)

-- Register Usable Item water
ESX.RegisterUsableItem('waterg', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('waterg', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 135000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu de ~g~ l\'Eau Gazeuse~s~')
end)

-- Lait
ESX.RegisterUsableItem('milk', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('milk', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 120000)
	TriggerClientEvent('esx_basicneeds:onDrinkMilk', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu du ~g~Lait~s~')
end)

-- Smoothies
ESX.RegisterUsableItem('smoothies', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('smoothies', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
	TriggerClientEvent('esx_basicneeds:onDrinkSmoothies', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu un ~g~Smoothie~s~')
end)

-- Ice tea
ESX.RegisterUsableItem('tea', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('tea', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 170000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu un ~g~Ice-Tea~s~')
end)

-- Jus de raisin
ESX.RegisterUsableItem('jusraisin', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('jusraisin', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
	TriggerClientEvent('esx_basicneeds:BoireJusRaisin', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu du ~g~Jus de raisin~s~')
end)

-- Chocolat chaud
ESX.RegisterUsableItem('chocolate', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('chocolate', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 180000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous mangez du ~b~chocolat~s~')
end)

-- Café
ESX.RegisterUsableItem('coffee', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('coffee', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 100000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu un ~g~Café~s~')
end)

-- Jus de fruit
ESX.RegisterUsableItem('jusfruit', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('jusfruit', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 180000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu du ~g~Jus de fruit~s~')
end)

-- Redbull
ESX.RegisterUsableItem('energy', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('energy', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 175000)
	TriggerClientEvent('esx_basicneeds:onDrinkRedBull', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu une ~g~RedBull~s~')
end)

-- Dr Pepper
ESX.RegisterUsableItem('drpepper', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('drpepper', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 155000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu du ~r~DrPepper~s~')
end)

-- NOURRITURES
-- Register Usable Item hamburger
ESX.RegisterUsableItem('hamburger', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('hamburger', 1)

	TriggerClientEvent('esx_basicneeds:onEatHamburger', source)
	TriggerClientEvent('esx_status:add', source, 'hunger', 600000)
	TriggerClientEvent('esx:showNotification', source, 'Vous mangez un ~b~Hamburger~s~')
end)

-- Register Usable Item bread
ESX.RegisterUsableItem('bread', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('bread', 1)

	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx_status:add', source, 'hunger', 150000)
	TriggerClientEvent('esx:showNotification', source, 'Vous mangez un ~b~Sandwich~s~')
end)

-- Register Usable Item frites
ESX.RegisterUsableItem('frites', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('frites', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous mangez des ~b~Frites~s~')
end)

-- Register Usable Item Fishburger
ESX.RegisterUsableItem('fishburger', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('fishburger', 1)

	TriggerClientEvent('esx_basicneeds:onEatHamburger', source)
	TriggerClientEvent('esx_status:add', source, 'hunger', 600000)
	TriggerClientEvent('esx:showNotification', source, 'Vous mangez un ~b~BurgerFish~s~')
end)

-- Register Usable Item Veganburger
ESX.RegisterUsableItem('veganburger', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('veganburger', 1)

	TriggerClientEvent('esx_basicneeds:onEatHamburger', source)
	TriggerClientEvent('esx_status:add', source, 'hunger', 500000)
	TriggerClientEvent('esx:showNotification', source, 'Vous mangez un ~b~VeganBurger~s~')
end)

-- Register Usable Item Hotdog
ESX.RegisterUsableItem('hotdog', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('hotdog', 1)

	TriggerClientEvent('esx_basicneeds:onEatHotDog', source)
	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx:showNotification', source, 'Vous mangez un ~b~Hotdog~s~')
end)

-- Pizza
ESX.RegisterUsableItem('pizza', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('pizza', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous mangez une part de ~b~Pizza~s~')
end)


-- Orange
ESX.RegisterUsableItem('orange', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('orange', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 50000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous mangez une ~b~Orange~s~')
end)

---- Autres
-- Malbora
ESX.RegisterUsableItem('malbora', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local briquet = xPlayer.getInventoryItem('briquet', 1)

	if briquet.count > 0 then
		xPlayer.removeInventoryItem('malbora', 1)
		TriggerClientEvent('esx_basicneeds:onSmoke', source)
		TriggerClientEvent('esx:showNotification', source, 'Vous fumez une ~r~Malborose~s~')
	else
		TriggerClientEvent('esx:showNotification', source, ('Vous n\'avez de briquet'))
	end
end)

-- Cigar
ESX.RegisterUsableItem('cigar', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local briquet = xPlayer.getInventoryItem('briquet', 1)

	if briquet.count > 0 then
		xPlayer.removeInventoryItem('cigar', 1)
		TriggerClientEvent('esx_basicneeds:onSmokeCigar', source)
		TriggerClientEvent('esx:showNotification', source, 'Vous fumez un ~r~Cigario~s~')
	else
		TriggerClientEvent('esx:showNotification', source, ('Vous n\'avez pas de briquet'))
	end
end)

-- traceur
ESX.RegisterUsableItem('traceur', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('traceur', 1)
	TriggerClientEvent('esx_basicneeds:traceur', source, '')
	TriggerClientEvent('esx:showNotification', source, _U('used_traceur'))
end)

-- Stéroïdes
ESX.RegisterUsableItem('steroids', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('steroids', 1)
	TriggerClientEvent('esx_basicneeds:onEatSteroids', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_steroid'))
end)

-- Huile pour cheveux
ESX.RegisterUsableItem('hair_oil', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('hair_oil', 1)
	TriggerClientEvent('esx_basicneeds:onMoussaStuff', source, 'hair_oil')
	TriggerClientEvent('esx:showNotification', source, _U('used_hair_oil'))
end)

-- Champagne
ESX.RegisterUsableItem('champagne', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('champagne', 1)
	TriggerClientEvent('esx_basicneeds:onMoussaStuff', source, 'champagne')
	TriggerClientEvent('esx:showNotification', source, 'Vous avez bu du ~r~Champagne~s~')
end)

-- Carte de Moussa
ESX.RegisterUsableItem('moussa_card', function(source)
	TriggerClientEvent('esx_basicneeds:onMoussaStuff', source, 'moussa_card')
end)

-- Boite noir
ESX.RegisterUsableItem('dark_case', function(source)
	TriggerClientEvent('esx_basicneeds:onMoussaStuff', source, 'dark_case')
end)

-- Cape
ESX.RegisterUsableItem('cape', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('cape', 1)
  TriggerClientEvent('esx_basicneeds:onCape', source)
end)

-- Leurre
ESX.RegisterUsableItem('leurre', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('leurre', 1)
  TriggerClientEvent('esx_basicneeds:leurre', source)
end)

-- Vision
ESX.RegisterUsableItem('vision', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem('vision', 1)
  TriggerClientEvent('esx_basicneeds:vision', source)
end)

-- Effect1
AddEventHandler("EffectForAll1", function(EffectPlayer) --Triggers The Teleport Effect On Other Clients
	TriggerClientEvent("Effect1", -1, EffectPlayer)
end)

RegisterServerEvent("EffectForAll1") --Just Don't Edit!

-- Register Usable splif
ESX.RegisterUsableItem('splif', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('splif', 1)

	TriggerClientEvent('esx_basicneeds:onPot', _source)
	TriggerClientEvent('esx_status:remove', source, 'hunger', 300000) 
	TriggerClientEvent('esx_status:remove', source, 'thirst', 200000)	
    TriggerClientEvent('esx:showNotification', _source, 'Vous fumez un ~r~Join de weed~s~')
end)

-- Register Usable coke
ESX.RegisterUsableItem('coke', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('coke', 1)

	TriggerClientEvent('esx_basicneeds:onEatCoke', _source)
    TriggerClientEvent('esx:showNotification', _source, 'Vous avez ~g~sniffé~s~ de la ~r~Coke~s~')
end)

-- Register Usable Acid
ESX.RegisterUsableItem('acid', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('acid', 1)

	TriggerClientEvent('esx_basicneeds:onEatAcid', _source)
    TriggerClientEvent('esx:showNotification', _source, 'Vous avez ~g~ingurgité~s~ de un ~r~AcidTrip~s~')
end)

-- Register Usable splif
ESX.RegisterUsableItem('ghb', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('ghb', 1)

	TriggerClientEvent('esx_basicneeds:onEatGhb', _source)
	TriggerClientEvent('esx_status:remove', source, 'hunger', 150000) 
	TriggerClientEvent('esx_status:remove', source, 'thirst', 120000)	
    TriggerClientEvent('esx:showNotification', _source, 'Vous consommé du ~r~GHB~s~')
end)

-- Register Usable sedatif
ESX.RegisterUsableItem('sedatif', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('sedatif', 1)

	TriggerClientEvent('bl_Advanceddrugs:onPotSed', _source)
    TriggerClientEvent('esx:showNotification', _source, _'Vous vous êtes fait ~r~Drogué~s~ !')
end)

-- Register Usable huilecanna
ESX.RegisterUsableItem('huile_pooch', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('huile_pooch', 1)

	TriggerClientEvent('esx_basicneeds:onPot', _source)
	TriggerClientEvent('esx_ambulancejob:heal', source, 'big')
	TriggerClientEvent('esx_status:remove', source, 'hunger', 400000) 
	TriggerClientEvent('esx_status:remove', source, 'thirst', 300000)
    TriggerClientEvent('esx:showNotification', _source, 'Vous avez ~b~utilisé~s~ des ~g~gouttes d\'huile de Canna~s~')
end)

-- Register Usable Meth
ESX.RegisterUsableItem('meth_pooch', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('meth_pooch', 1)

	TriggerClientEvent('esx_basicneeds:onPot', _source)
    TriggerClientEvent('esx:showNotification', _source, 'Vous avez pris de la ~g~Meth~s~')
end)

ESX.RegisterUsableItem('bonbon', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('bonbon', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'Vous mangez un ~b~Bonbon~s~')
end)


ESX.RegisterUsableItem('poison', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('poison', 1)

	TriggerClientEvent('esx_status:remove', source, 'prevHealth', -50000)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez ~r~ingérez du poison~s~ !')		
end)