local start = false

ESX = nil
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

--Dégat armes
Citizen.CreateThread(function()
    while true do
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.25) 
	Citizen.Wait(1)
    end
end)

-- Recul des armes
local recoils = {
	[453432689] = 0.3, -- PISTOL
	[3219281620] = 0.3, -- PISTOL MK2
	[1593441988] = 0.2, -- COMBAT PISTOL
	[584646201] = 0.1, -- AP PISTOL
	[2578377531] = 0.6, -- PISTOL .50
	[324215364] = 0.2, -- MICRO SMG
	[736523883] = 0.1, -- SMG
	[2024373456] = 0.1, -- SMG MK2
	[4024951519] = 0.1, -- ASSAULT SMG
	[3220176749] = 0.2, -- ASSAULT RIFLE
	[961495388] = 0.2, -- ASSAULT RIFLE MK2
	[2210333304] = 0.1, -- CARBINE RIFLE
	[4208062921] = 0.1, -- CARBINE RIFLE MK2
	[2937143193] = 0.1, -- ADVANCED RIFLE
	[2634544996] = 0.1, -- MG
	[2144741730] = 0.1, -- COMBAT MG
	[3686625920] = 0.1, -- COMBAT MG MK2
	[487013001] = 0.4, -- PUMP SHOTGUN
	[2017895192] = 0.7, -- SAWNOFF SHOTGUN
	[3800352039] = 0.4, -- ASSAULT SHOTGUN
	[2640438543] = 0.2, -- BULLPUP SHOTGUN
	[911657153] = 0.1, -- STUN GUN
	[100416529] = 0.5, -- SNIPER RIFLE
	[205991906] = 0.7, -- HEAVY SNIPER
	[177293209] = 0.7, -- HEAVY SNIPER MK2
	[856002082] = 1.2, -- REMOTE SNIPER
	[2726580491] = 1.0, -- GRENADE LAUNCHER
	[1305664598] = 1.0, -- GRENADE LAUNCHER SMOKE
	[2982836145] = 0.0, -- RPG
	[1752584910] = 0.0, -- STINGER
	[1119849093] = 0.8, -- MINIGUN
	[3218215474] = 0.2, -- SNS PISTOL
	[1627465347] = 0.1, -- GUSENBERG
	[3231910285] = 0.2, -- SPECIAL CARBINE
	[3523564046] = 0.5, -- HEAVY PISTOL
	[2132975508] = 0.2, -- BULLPUP RIFLE
	[137902532] = 0.4, -- VINTAGE PISTOL
	[2828843422] = 0.7, -- MUSKET
	[984333226] = 1.0, -- HEAVY SHOTGUN
	[3342088282] = 0.3, -- MARKSMAN RIFLE
	[1672152130] = 0, -- HOMING LAUNCHER
	[1198879012] = 0.9, -- FLARE GUN
	[171789620] = 0.2, -- COMBAT PDW
	[3696079510] = 0.9, -- MARKSMAN PISTOL
  	[1834241177] = 2.4, -- RAILGUN
	[3675956304] = 0.3, -- MACHINE PISTOL
	[3249783761] = 0.6, -- REVOLVER
	[4019527611] = 0.7, -- DOUBLE BARREL SHOTGUN
	[1649403952] = 0.3, -- COMPACT RIFLE
	[317205821] = 0.2, -- AUTO SHOTGUN
	[125959754] = 0.5, -- COMPACT LAUNCHER
	[3173288789] = 0.1 -- MINI SMG		
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if IsPedShooting(PlayerPedId()) and not IsPedDoingDriveby(PlayerPedId()) then
			local _,wep = GetCurrentPedWeapon(PlayerPedId())
			_,cAmmo = GetAmmoInClip(PlayerPedId(), wep)
			if recoils[wep] and recoils[wep] ~= 0 then
				tv = 0
				repeat 
					p = GetGameplayCamRelativePitch()
					if GetFollowPedCamViewMode() ~= 4 then
						SetGameplayCamRelativePitch(p+1.0, 2.0)
					end
					tv = tv+0.5
				until tv >= recoils[wep]
			end
			
		end
	end
end)

-- Animation Hosler Gang
local weapons = {
	'WEAPON_KNIFE',
	'WEAPON_NIGHTSTICK',
	'WEAPON_HAMMER',
	'WEAPON_BAT',
	'WEAPON_GOLFCLUB',
	'WEAPON_CROWBAR',
	'WEAPON_BOTTLE',
	'WEAPON_DAGGER',
	'WEAPON_HATCHET',
	'WEAPON_MACHETE',
	'WEAPON_BATTLEAXE',
	'WEAPON_POOLCUE',
	'WEAPON_WRENCH',
	'WEAPON_PISTOL',
	'WEAPON_PISTOL_MK2',
	'WEAPON_APPISTOL',
	'WEAPON_PISTOL50',
	'WEAPON_REVOLVER',
	'WEAPON_SNSPISTOL',
	'WEAPON_HEAVYPISTOL',
	'WEAPON_VINTAGEPISTOL',
	'WEAPON_MICROSMG',
	'WEAPON_SMG',
	'WEAPON_ASSAULTSMG',
	'WEAPON_MINISMG',
	'WEAPON_MACHINEPISTOL',
	'WEAPON_COMBATPDW',
	'WEAPON_PUMPSHOTGUN',
	'WEAPON_SAWNOFFSHOTGUN',
	'WEAPON_ASSAULTSHOTGUN',
	'WEAPON_BULLPUPSHOTGUN',
	'WEAPON_HEAVYSHOTGUN',
	'WEAPON_ASSAULTRIFLE',
	'WEAPON_CARBINERIFLE',
	'WEAPON_ADVANCEDRIFLE',
	'WEAPON_SPECIALCARBINE',
	'WEAPON_BULLPUPRIFLE',
	'WEAPON_COMPACTRIFLE',
	'WEAPON_MG',
	'WEAPON_COMBATMG',
	'WEAPON_GUSENBERG',
	'WEAPON_SNIPERRIFLE',
	'WEAPON_HEAVYSNIPER',
	'WEAPON_MARKSMANRIFLE',
	'WEAPON_GRENADELAUNCHER',
	'WEAPON_RPG',
	'WEAPON_STINGER',
	'WEAPON_MINIGUN',
	'WEAPON_GRENADE',
	'WEAPON_STICKYBOMB',
	'WEAPON_SMOKEGRENADE',
	'WEAPON_BZGAS',
	'WEAPON_MOLOTOV',
	'WEAPON_DIGISCANNER',
	'WEAPON_FIREWORK',
	'WEAPON_MUSKET',
	'WEAPON_HOMINGLAUNCHER',
	'WEAPON_PROXMINE',
	'WEAPON_FLAREGUN',
	'WEAPON_MARKSMANPISTOL',
	'WEAPON_RAILGUN',
	'WEAPON_DBSHOTGUN',
	'WEAPON_AUTOSHOTGUN',
	'WEAPON_COMPACTLAUNCHER',
	'WEAPON_PIPEBOMB',
	'WEAPON_DOUBLEACTION'
}

local holstered = true
local canfire = true
local currWeapon = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(250)
		if DoesEntityExist(GetPlayerPed(-1)) and not IsEntityDead(GetPlayerPed(-1)) and not IsPedInAnyVehicle(PlayerPedId(-1), true) then
			if currWeapon ~= GetSelectedPedWeapon(GetPlayerPed(-1)) then
				pos = GetEntityCoords(GetPlayerPed(-1), true)
				rot = GetEntityHeading(GetPlayerPed(-1))

				local newWeap = GetSelectedPedWeapon(GetPlayerPed(-1))
				SetCurrentPedWeapon(GetPlayerPed(-1), currWeapon, true)

				local dict2 = "reaction@intimidation@1h"
				RequestAnimDict(dict2)
				while not HasAnimDictLoaded(dict2) do
					Citizen.Wait(50)
				end

				if CheckWeapon(newWeap) then
					if holstered then
						canFire = false
						TaskPlayAnimAdvanced(GetPlayerPed(-1), "reaction@intimidation@1h", "intro", GetEntityCoords(GetPlayerPed(-1), true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
						Citizen.Wait(2000)
						SetCurrentPedWeapon(GetPlayerPed(-1), newWeap, true)
						currWeapon = newWeap
						Citizen.Wait(2000)
						ClearPedTasks(GetPlayerPed(-1))
						holstered = false
						canFire = true
					elseif newWeap ~= currWeapon then
						canFire = false
						SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey('WEAPON_UNARMED'), true)
						TaskPlayAnimAdvanced(GetPlayerPed(-1), "reaction@intimidation@1h", "intro", GetEntityCoords(GetPlayerPed(-1), true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
						Citizen.Wait(1000)
						SetCurrentPedWeapon(GetPlayerPed(-1), newWeap, true)
						currWeapon = newWeap
						Citizen.Wait(2000)
						ClearPedTasks(GetPlayerPed(-1))
						holstered = false
						canFire = true
					end
				else
					if not holstered and CheckWeapon(currWeapon) then
						canFire = false
						TaskPlayAnimAdvanced(GetPlayerPed(-1), "reaction@intimidation@1h", "outro", GetEntityCoords(GetPlayerPed(-1), true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
						Citizen.Wait(1600)
						SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey('WEAPON_UNARMED'), true)
						ClearPedTasks(GetPlayerPed(-1))
						SetCurrentPedWeapon(GetPlayerPed(-1), newWeap, true)
						holstered = true
						canFire = true
						currWeapon = newWeap
					else
						SetCurrentPedWeapon(GetPlayerPed(-1), newWeap, true)
						holstered = false
						canFire = true
						currWeapon = newWeap
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if not canFire then
			DisableControlAction(0, 25, true)
			DisablePlayerFiring(GetPlayerPed(-1), true)
		end
	end
end)

function CheckWeapon(newWeap)
	for i = 1, #weapons do
		if GetHashKey(weapons[i]) == newWeap then
			return true
		end
	end
	return false
end

-- HOLSTER/UNHOLSTER PISTOL
local holstered2 = true
local weapons2 = {
	"WEAPON_STUNGUN"
}

 Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if DoesEntityExist(GetPlayerPed(-1)) and not IsEntityDead(GetPlayerPed(-1)) and not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
			local dict3 = "rcmjosh4"
			RequestAnimDict(dict3)
			while not HasAnimDictLoaded(dict3) do
				Citizen.Wait(50)
			end

			if CheckWeapon2(hoslter) then

				if holstered2 then
					TaskPlayAnim(GetPlayerPed(-1), "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
					Citizen.Wait(300)
					holstered2 = false
				end

			elseif not CheckWeapon2(hoslter) then
				Citizen.Wait(300)
				holstered2 = true
			end
		end
	end
end)

function CheckWeapon2(hoslter)
	for i = 1, #weapons2 do
		if GetHashKey(weapons2[i]) == GetSelectedPedWeapon(GetPlayerPed(-1)) then
			return true
		end
	end
	return false
end

-- HOLSTER/UNHOLSTER PISTOL 2
local holstered3 = true
local weapons3 = {
	"WEAPON_COMBATPISTOL"
}

 Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if DoesEntityExist(GetPlayerPed(-1)) and not IsEntityDead(GetPlayerPed(-1)) and not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
			local dict4 = "rcmjosh4"
			RequestAnimDict(dict4)
			while not HasAnimDictLoaded(dict4) do
				Citizen.Wait(50)
			end

			if CheckWeapon3(hoslter) then

				if holstered3 then
					TaskPlayAnim(GetPlayerPed(-1), "rcmjosh4", "josh_leadout_cop1", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
					Citizen.Wait(300)
					holstered3 = false
				end

			elseif not CheckWeapon3(hoslter) then
				Citizen.Wait(300)
				holstered3 = true
			end
		end
	end
end)

function CheckWeapon3(hoslter)
	for i = 1, #weapons3 do
		if GetHashKey(weapons3[i]) == GetSelectedPedWeapon(GetPlayerPed(-1)) then
			return true
		end
	end
	return false
end

--Ko
local knockedOut = false
local wait = math.random(1,2)
local count = 20

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local myPed = GetPlayerPed(-1)
		if IsPedInMeleeCombat(myPed) then
			if GetEntityHealth(myPed) < 150 then
				SetPlayerInvincible(PlayerId(), true)
				SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
				ShowNotification("~r~Tu as été mis KO!")
				wait = math.random(1,2)
				knockedOut = true
				SetEntityHealth(myPed, 175)
			end
		end
		if knockedOut == true then
			SetPlayerInvincible(PlayerId(), true)
			DisablePlayerFiring(PlayerId(), true)
			SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
			ResetPedRagdollTimer(myPed)
			
			if wait >= 0 then
				count = count - 1
				if count == 0 then
					count = 20
					wait = wait - 1
					SetEntityHealth(myPed, GetEntityHealth(myPed)+1)
				end
			else
				SetPlayerInvincible(PlayerId(), false)
				knockedOut = false
			end
		end
	end
end)

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

-- No Crosshair
Citizen.CreateThread( function()
    while true do
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)

	    if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
			local a = GetSelectedPedWeapon(ped)

			if (GetFollowPedCamViewMode() ~= 5 ) then
				if (a == GetHashKey("WEAPON_SNIPERRIFLE") or
				 a == GetHashKey("WEAPON_MARKSMANRIFLE_MK2") or 
				 a == GetHashKey("WEAPON_MARKSMANRIFLE") or 
				 a == GetHashKey("WEAPON_HEAVYSNIPER") or 
				 a == GetHashKey("WEAPON_HEAVYSNIPER_MK2")) then
				else
					HideHudComponentThisFrame(14)
				end
			else
			end
	    end

    end 
end)

function stunGun()
  local playerPed = GetPlayerPed(-1)
  RequestAnimSet("move_m@drunk@verydrunk")
  while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
    Citizen.Wait(1)
  end
  DoScreenFadeOut(800)
  SetPedMinGroundTimeForStungun(GetPlayerPed(-1), 15000)
  SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)
  SetTimecycleModifier("spectator5")
  SetPedIsDrunk(playerPed, true)
  Citizen.Wait(15000)
  SetPedMotionBlur(playerPed, true)
  DoScreenFadeIn(800)
  Citizen.Wait(60000)
  DoScreenFadeOut(800)
  Citizen.Wait(1000)
  ClearTimecycleModifier()
  ResetScenarioTypesEnabled()
  ResetPedMovementClipset(playerPed, 0)
  SetPedIsDrunk(playerPed, false)
  SetPedMotionBlur(playerPed, false)
  DoScreenFadeIn(800)
end

Citizen.CreateThread(function()
   while true do
      if IsPedBeingStunned(GetPlayerPed(-1)) then
        stunGun()
      end
      SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
      ClearEntityLastDamageEntity(GetPlayerPed(-1))
      Citizen.Wait(1)
   end
end)