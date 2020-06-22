mhackingCallback = {}
showHelp = false
helpTimer = 0
helpCycle = 4000

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if showHelp then
			if helpTimer > GetGameTimer() then
				showHelpText("Navigue avec ~y~Z,Q,S,D~s~ confirme avec  ~y~ESPACE~s~ pour le bloc gauche.")
			elseif helpTimer > GetGameTimer()-helpCycle then
				showHelpText("Utilise les ~flèches directionnelles~s~ et ~y~ENTRER~s~ pour valider le bloc de droite.")
			else
				helpTimer = GetGameTimer()+helpCycle
			end
			if IsEntityDead(PlayerPedId()) then
				nuiMsg = {}
				nuiMsg.fail = true
				SendNUIMessage(nuiMsg)
			end
		end
	end
end)

function showHelpText(s)
	SetTextComponentFormat("STRING")
	AddTextComponentString(s)
	EndTextCommandDisplayHelp(0,0,0,-1)
end

AddEventHandler('mhacking:show', function()
    nuiMsg = {}
	nuiMsg.show = true
	SendNUIMessage(nuiMsg)
	SetNuiFocus(true, false)
end)

AddEventHandler('mhacking:hide', function()
    nuiMsg = {}
	nuiMsg.show = false
	SendNUIMessage(nuiMsg)
	SetNuiFocus(false, false)
	showHelp = false
end)

AddEventHandler('mhacking:start', function(solutionlength, duration, callback)
    mhackingCallback = callback
	nuiMsg = {}
	nuiMsg.s = solutionlength
	nuiMsg.d = duration
	nuiMsg.start = true
	SendNUIMessage(nuiMsg)
	showHelp = true
end)

AddEventHandler('mhacking:setmessage', function(msg)
    nuiMsg = {}
	nuiMsg.displayMsg = msg
	SendNUIMessage(nuiMsg)
end)

RegisterNUICallback('callback', function(data, cb)
	mhackingCallback(data.success, data.remainingtime)
    cb('ok')
end)

function mycb(success, timeremaining)
	if success then
		TriggerEvent('mhacking:hide')
	else
		TriggerEvent('mhacking:hide')
	end
end
--[[
Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1)
	  if IsControlJustReleased(1,57) then -- Home key
		TriggerEvent("mhacking:show")
		TriggerEvent("mhacking:start",7,35,mycb)
	  end
	end
  end) ]]