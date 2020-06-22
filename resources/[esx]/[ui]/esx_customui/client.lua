local isTalking = false

AddEventHandler('no_hud',function(test)
  TriggerEvent('ui:toggle', test)
end)

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	TriggerEvent('es:setMoneyDisplay', 0.0)
	ESX.UI.HUD.SetDisplay(0.0)
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer) 
	Citizen.Wait(2000)
	local data = xPlayer
	local accounts = data.accounts
	for k,v in pairs(accounts) do
		local account = v
		if account.name == "bank" then
			SendNUIMessage({action = "setValue", key = "bankmoney", value = "$"..account.money})
		elseif account.name == "black_money" then
			SendNUIMessage({action = "setValue", key = "dirtymoney", value = "$"..account.money})
		end
	end

	-- Job
	local job = data.job
	SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})
	-- Faction
	local faction = data.faction
	SendNUIMessage({action = "setValue", key = "faction", value = faction.label.." - "..faction.grade_label, icon = faction.name})
	-- Money
	SendNUIMessage({action = "setValue", key = "money", value = "$"..data.money})
end)

RegisterNetEvent('ui:toggle')
AddEventHandler('ui:toggle', function(show)
	SendNUIMessage({action = "toggle", show = show})
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == "bank" then
		SendNUIMessage({action = "setValue", key = "bankmoney", value = "$"..account.money})
	elseif account.name == "black_money" then
		SendNUIMessage({action = "setValue", key = "dirtymoney", value = "$"..account.money})
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})
end)

RegisterNetEvent('esx:setFaction')
AddEventHandler('esx:setFaction', function(faction)
  SendNUIMessage({action = "setValue", key = "faction", value = faction.label.." - "..faction.grade_label, icon = faction.name})
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(e)
	SendNUIMessage({action = "setValue", key = "money", value = "$"..e})
end)

RegisterNetEvent('esx_customui:updateStatus')
AddEventHandler('esx_customui:updateStatus', function(status)
	SendNUIMessage({action = "updateStatus", status = status})
end)

function dump(o, nb)
  if nb == nil then
    nb = 0
  end
   if type(o) == 'table' then
      local s = ''
      for i = 1, nb + 1, 1 do
        s = s .. "    "
      end
      s = '{\n'
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
          for i = 1, nb, 1 do
            s = s .. "    "
          end
         s = s .. '['..k..'] = ' .. dump(v, nb + 1) .. ',\n'
      end
      for i = 1, nb, 1 do
        s = s .. "    "
      end
      return s .. '}'
   else
      return tostring(o)
   end
end