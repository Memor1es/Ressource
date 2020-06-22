ESX = nil
Citizen.CreateThread(function()
  	while ESX == nil do
	    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	    Citizen.Wait(0)
  	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

-- Zone Ballas
local notifInBallas = false
local notifOutBallas = false
local closestZoneBallas = 1

local zones_ballas = {
	{ ['x'] = 105.44, ['y'] = -1940.97, ['z'] = 20.8}
}

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		local playerPed = GetPlayerPed(-1)
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistanceBallas = 100000
		for i = 1, #zones_ballas, 1 do
			distBallas = Vdist(zones_ballas[i].x, zones_ballas[i].y, zones_ballas[i].z, x, y, z)
			if distBallas < minDistanceBallas then
				minDistanceBallas = distBallas
				closestZoneBallas = i
			end
		end
		Citizen.Wait(15000)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(0)
		local player = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local distBallas = Vdist(zones_ballas[closestZoneBallas].x, zones_ballas[closestZoneBallas].y, zones_ballas[closestZoneBallas].z, x, y, z)
	
		if distBallas <= 50.0 then  -- Here you can change the RADIUS of the Safe Zone. Remember, whatever you put here will DOUBLE because 
			if not notifInBallas then	 -- it is a sphere. So 50 will actually result in a diameter of 100. I assume it is meters. No clue to be honest.
				ESX.ShowNotification('~r~Vous êtes dans une zone sensible~s~')
				notifInBallas = true
				notifOutBallas = false
			end
		else
			if not notifOutBallas then
				ESX.ShowNotification('~g~Vous n\'êtes plus dans une zone sensible~s~')
				notifOutBallas = true
				notifInBallas = false
			end
		end
		-- Comment out lines 142 - 145 if you dont want a marker.
		if DoesEntityExist(player) then	    --The -1.0001 will place it on the ground flush		-- SIZING CIRCLE |  x    y    z | R   G    B   alpha| *more alpha more transparent*
			DrawMarker(1, zones_ballas[closestZoneBallas].x, zones_ballas[closestZoneBallas].y, zones_ballas[closestZoneBallas].z-1.0001, 0, 0, 0, 0, 0, 0, 100.0, 100.0, 2.0, 13, 255, 0, 0, 0, 0, 2, 0, 0, 0, 0) -- heres what all these numbers are. Honestly you dont really need to mess with any other than what isnt 0.
			--DrawMarker(type, float posX, float posY, float posZ, float dirX, float dirY, float dirZ, float rotX, float rotY, float rotZ, float scaleX, float scaleY, float scaleZ, int red, int green, int blue, int alpha, BOOL bobUpAndDown, BOOL faceCamera, int p19(LEAVE AS 2), BOOL rotate, char* textureDict, char* textureName, BOOL drawOnEnts)
		end
	end
end)

-- Zone Vagos
local notifInVagos = false
local notifOutVagos = false
local closestZoneVagos = 1

local zones_vagos = {
	{ ['x'] = 360.85, ['y'] = -2062.79, ['z'] = 21.53}
}

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		local playerPed = GetPlayerPed(-1)
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistanceVagos = 150000
		for i = 1, #zones_vagos, 1 do
			distVagos = Vdist(zones_vagos[i].x, zones_vagos[i].y, zones_vagos[i].z, x, y, z)
			if distVagos < minDistanceVagos then
				minDistanceVagos = distVagos
				closestZoneVagos = i
			end
		end
		Citizen.Wait(15000)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(0)
		local player = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local distVagos = Vdist(zones_vagos[closestZoneVagos].x, zones_vagos[closestZoneVagos].y, zones_vagos[closestZoneVagos].z, x, y, z)
	
		if distVagos <= 95.0 then  -- Here you can change the RADIUS of the Safe Zone. Remember, whatever you put here will DOUBLE because 
			if not notifInVagos then	 -- it is a sphere. So 50 will actually result in a diameter of 100. I assume it is meters. No clue to be honest.
				ESX.ShowNotification('~r~Vous êtes dans une zone sensible~s~')
				notifInVagos = true
				notifOutVagos = false
			end
		else
			if not notifOutVagos then
				ESX.ShowNotification('~g~Vous n\'êtes plus dans une zone sensible~s~')
				notifOutVagos = true
				notifInVagos = false
			end
		end
		-- Comment out lines 142 - 145 if you dont want a marker.
		if DoesEntityExist(player) then	    --The -1.0001 will place it on the ground flush		-- SIZING CIRCLE |  x    y    z | R   G    B   alpha| *more alpha more transparent*
			DrawMarker(1, zones_vagos[closestZoneVagos].x, zones_vagos[closestZoneVagos].y, zones_vagos[closestZoneVagos].z-1.0001, 0, 0, 0, 0, 0, 0, 100.0, 100.0, 2.0, 13, 255, 0, 0, 0, 0, 2, 0, 0, 0, 0) -- heres what all these numbers are. Honestly you dont really need to mess with any other than what isnt 0.
			--DrawMarker(type, float posX, float posY, float posZ, float dirX, float dirY, float dirZ, float rotX, float rotY, float rotZ, float scaleX, float scaleY, float scaleZ, int red, int green, int blue, int alpha, BOOL bobUpAndDown, BOOL faceCamera, int p19(LEAVE AS 2), BOOL rotate, char* textureDict, char* textureName, BOOL drawOnEnts)
		end
	end
end)

-- Zone White
local notifInWhite = false
local notifOutWhite = false
local closestZoneWhite = 1

local zones_white = {
	{ ['x'] = -608.13, ['y'] = 194.46, ['z'] = 71.36}
}

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		local playerPed = GetPlayerPed(-1)
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistanceWhite = 100000
		for i = 1, #zones_white, 1 do
			distWhite = Vdist(zones_white[i].x, zones_white[i].y, zones_white[i].z, x, y, z)
			if distWhite < minDistanceWhite then
				minDistanceWhite = distWhite
				closestZoneWhite = i
			end
		end
		Citizen.Wait(15000)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(0)
		local player = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local distWhite = Vdist(zones_white[closestZoneWhite].x, zones_white[closestZoneWhite].y, zones_white[closestZoneWhite].z, x, y, z)

		if distWhite <= 50.0 then  -- Here you can change the RADIUS of the Safe Zone. Remember, whatever you put here will DOUBLE because 
			if not notifInWhite then	 -- it is a sphere. So 50 will actually result in a diameter of 100. I assume it is meters. No clue to be honest.
				ESX.ShowNotification('~r~Vous êtes dans une zone sensible~s~')
				notifInWhite = true
				notifOutWhite = false
			end
		else
			if not notifOutWhite then
				ESX.ShowNotification('~g~Vous n\'êtes plus dans une zone sensible~s~')
				notifOutWhite = true
				notifInWhite = false
			end
		end
		-- Comment out lines 142 - 145 if you dont want a marker.
		if DoesEntityExist(player) then	    --The -1.0001 will place it on the ground flush		-- SIZING CIRCLE |  x    y    z | R   G    B   alpha| *more alpha more transparent*
			DrawMarker(1, zones_white[closestZoneWhite].x, zones_white[closestZoneWhite].y, zones_white[closestZoneWhite].z-1.0001, 0, 0, 0, 0, 0, 0, 100.0, 100.0, 2.0, 13, 255, 0, 0, 0, 0, 2, 0, 0, 0, 0) -- heres what all these numbers are. Honestly you dont really need to mess with any other than what isnt 0.
			--DrawMarker(type, float posX, float posY, float posZ, float dirX, float dirY, float dirZ, float rotX, float rotY, float rotZ, float scaleX, float scaleY, float scaleZ, int red, int green, int blue, int alpha, BOOL bobUpAndDown, BOOL faceCamera, int p19(LEAVE AS 2), BOOL rotate, char* textureDict, char* textureName, BOOL drawOnEnts)
		end
	end
end)

-- Zone QLF
local notifInQlf = false
local notifOutQlf = false
local closestZoneQlf = 1

local zones_qlf = {
	{ ['x'] = 1554.09, ['y'] = 2203.56, ['z'] = 78.82}
}

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		local playerPed = GetPlayerPed(-1)
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistanceQlf = 100000
		for i = 1, #zones_qlf, 1 do
			distQlf = Vdist(zones_qlf[i].x, zones_qlf[i].y, zones_qlf[i].z, x, y, z)
			if distQlf < minDistanceQlf then
				minDistanceQlf = distQlf
				closestZoneQlf = i
			end
		end
		Citizen.Wait(15000)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(0)
		local player = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local distQlf = Vdist(zones_qlf[closestZoneQlf].x, zones_qlf[closestZoneQlf].y, zones_qlf[closestZoneQlf].z, x, y, z)

		if distQlf <= 75.0 then  -- Here you can change the RADIUS of the Safe Zone. Remember, whatever you put here will DOUBLE because 
			if not notifInQlf then	 -- it is a sphere. So 50 will actually result in a diameter of 100. I assume it is meters. No clue to be honest.
				ESX.ShowNotification('~r~Vous êtes dans une zone sensible~s~')
				notifInQlf = true
				notifOutQlf = false
			end
		else
			if not notifOutQlf then
				ESX.ShowNotification('~g~Vous n\'êtes plus dans une zone sensible~s~')
				notifOutQlf = true
				notifInQlf = false
			end
		end
		-- Comment out lines 142 - 145 if you dont want a marker.
		if DoesEntityExist(player) then	    --The -1.0001 will place it on the ground flush		-- SIZING CIRCLE |  x    y    z | R   G    B   alpha| *more alpha more transparent*
			DrawMarker(1, zones_qlf[closestZoneQlf].x, zones_qlf[closestZoneQlf].y, zones_qlf[closestZoneQlf].z-1.0001, 0, 0, 0, 0, 0, 0, 100.0, 100.0, 2.0, 13, 255, 0, 0, 0, 0, 2, 0, 0, 0, 0) -- heres what all these numbers are. Honestly you dont really need to mess with any other than what isnt 0.
			--DrawMarker(type, float posX, float posY, float posZ, float dirX, float dirY, float dirZ, float rotX, float rotY, float rotZ, float scaleX, float scaleY, float scaleZ, int red, int green, int blue, int alpha, BOOL bobUpAndDown, BOOL faceCamera, int p19(LEAVE AS 2), BOOL rotate, char* textureDict, char* textureName, BOOL drawOnEnts)
		end
	end
end)