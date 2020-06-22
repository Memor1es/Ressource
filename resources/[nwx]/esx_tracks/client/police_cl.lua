ESX = nil
local hasSniffer = false
local blipList = {}

local loaded = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	local isHavingTracker = false
	local isHavingSniffer = false

	for i=1, #PlayerData.inventory, 1 do
		if PlayerData.inventory[i].name == 'sniffer' then
			if PlayerData.inventory[i].count > 0 then
				isHavingSniffer = true
			end
		elseif PlayerData.inventory[i].name == 'tracker' then
			if PlayerData.inventory[i].count > 0 then
				isHavingTracker = true
			end
		end
	end

	if isHavingTracker then
		TriggerServerEvent('bl_trackGPS:addTracker')
		if isHavingSniffer then
			hasSniffer = true
		end
	elseif isHavingSniffer then
		hasSniffer = true
	  	TriggerServerEvent('bl_trackGPS:get')
	end
end)

RegisterNetEvent('bl_trackGPS:addSniffer')
AddEventHandler('bl_trackGPS:addSniffer', function()
	hasSniffer = true
  	TriggerServerEvent('bl_trackGPS:get')
end)

RegisterNetEvent('bl_trackGPS:removeSniffer')
AddEventHandler('bl_trackGPS:removeSniffer', function()
	hasSniffer = false
  	TriggerServerEvent('bl_trackGPS:get')
end)

RegisterNetEvent('bl_trackGPS:update')
AddEventHandler('bl_trackGPS:update', function()
  	TriggerServerEvent('bl_trackGPS:get')
end)


RegisterNetEvent('bl_trackGPS:getCallback')
AddEventHandler('bl_trackGPS:getCallback', function(list)
	Citizen.CreateThread(function()
		-- Fuck that, blip seems to don't want to stick to player if inited to early
	    Citizen.Wait(5000)
		if #blipList > 0 then
			for i=#blipList,1,-1 do
			    if DoesBlipExist(blipList[i]) then
			    	RemoveBlip(blipList[i])
			    end
			end
		end
			blipList = {}

		if hasSniffer and #list > 0 then
		  local players = ESX.Game.GetPlayers()
	      for i = 1, #players, 1 do
	          local ped = GetPlayerPed(players[i])
	          local find = -1

	      	  for j = 1, #list, 1 do
		          if GetPlayerServerId(players[i]) == list[j].src then
		          	find = j
		          end
	      	  end

	          if find > -1 and DoesEntityExist(ped) and list[find] ~= nil then
	          	local myBlip = AddBlipForEntity(ped)

	          	if list[find].job == 'police' then
					SetBlipSprite(myBlip, 1)
					SetBlipColour(myBlip, 3)
					SetBlipScale(myBlip, 1.0)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(tostring("LSPD"))
					EndTextCommandSetBlipName(myBlip)
	          	elseif list[find].job == 'gouv' then
					SetBlipSprite(myBlip, 1)
					SetBlipColour(myBlip, 38)
					SetBlipScale(myBlip, 1.0)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(tostring("GOUV"))
					EndTextCommandSetBlipName(myBlip)
	          	else
					SetBlipSprite(myBlip, 188)
					SetBlipColour(myBlip, 1)
					SetBlipScale(myBlip, 1.0)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(tostring(list[find].name))
					EndTextCommandSetBlipName(myBlip)
	          	end
				SetBlipDisplay(myBlip, 3)
				SetBlipFlashes(myBlip, true)
			  	table.insert(blipList, myBlip)
	    		Citizen.Wait(1000)
	          end
	        end
	      end
	end)
end)
