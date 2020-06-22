ESX = nil
local PlayerData = {}

Citizen.CreateThread(function ()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    	Citizen.Wait(0)
  end
  Citizen.Wait(500)
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

local playerCurrentlyAnimated = false
local playerCurrentlyHasProp = false
local LastAD
local playerPropList = {}

Citizen.CreateThread( function()

	while true do
		Citizen.Wait(0)
		if (IsControlJustPressed(0,Config.RadioKey))  then
			local player = PlayerPedId()
			if ( DoesEntityExist( player ) and not IsEntityDead( player ) ) then 

				loadAnimDict( "random@arrests" )
				if IsEntityPlayingAnim(player, "random@arrests", "generic_radio_chatter", 3) then
					ClearPedSecondaryTask(player)
				else
					TaskPlayAnim(player, "random@arrests", "generic_radio_chatter", 2.0, 2.5, -1, 49, 0, 0, 0, 0 )
					RemoveAnimDict("random@arrests")
				end
			end

		elseif (IsControlJustPressed(0,Config.HoverHolsterKey)) then
			local player = PlayerPedId()
	
			if ( DoesEntityExist( player ) and not IsEntityDead( player ) ) then
	
				loadAnimDict( "move_m@intimidation@cop@unarmed" )
	
				if IsEntityPlayingAnim(player, "move_m@intimidation@cop@unarmed", "idle", 3) then
					ClearPedSecondaryTask(player)
				else
					TaskPlayAnim(player, "move_m@intimidation@cop@unarmed", "idle", 2.0, 2.5, -1, 49, 0, 0, 0, 0 )
					RemoveAnimDict("move_m@intimidation@cop@unarmed")
				end
			end
		end
	end
end)

RegisterNetEvent('Radiant_Animations:KillProps')
AddEventHandler('Radiant_Animations:KillProps', function()
	for _,v in pairs(playerPropList) do
		DeleteEntity(v)
	end

	playerCurrentlyHasProp = false
end)

RegisterNetEvent('Radiant_Animations:AttachProp')
AddEventHandler('Radiant_Animations:AttachProp', function(prop_one, boneone, x1, y1, z1, r1, r2, r3)
	local player = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(player))

	if not HasModelLoaded(prop_one) then
		loadPropDict(prop_one)
	end

	prop = CreateObject(GetHashKey(prop_one), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(prop, player, GetPedBoneIndex(player, boneone), x1, y1, z1, r1, r2, r3, true, true, false, true, 1, true)
	SetModelAsNoLongerNeeded(prop_one)
	table.insert(playerPropList, prop)
	playerCurrentlyHasProp = true
end)

local firstAnim = true
RegisterNetEvent('Radiant_Animations:Animation')
AddEventHandler('Radiant_Animations:Animation', function(ad, anim, body)
	local player = PlayerPedId()
	if playerCurrentlyAnimated then -- Cancel Old Animation

		loadAnimDict(ad)
		TaskPlayAnim( player, ad, "exit", 8.0, 1.0, -1, body, 0, 0, 0, 0 )
		Wait(750)
		ClearPedSecondaryTask(player)
		RemoveAnimDict(LastAD)
		RemoveAnimDict(ad)
		LastAD = ad
		playerCurrentlyAnimated = false
		TriggerEvent('Radiant_Animations:KillProps')
		return
	end

	if firstAnim then
		LastAD = ad
		firstAnim = false
	end

	loadAnimDict(ad)
	TaskPlayAnim(player, ad, anim, 4.0, 1.0, -1, body, 0, 0, 0, 0 )  --- We actually play the animation here
	RemoveAnimDict(ad)
	playerCurrentlyAnimated = true

end)

RegisterNetEvent('Radiant_Animations:StopAnimations')
AddEventHandler('Radiant_Animations:StopAnimations', function()
	local player = PlayerPedId()
	if playerCurrentlyAnimated then
		RemoveAnimDict(LastAD)
		ClearPedSecondaryTask(player)
		TriggerEvent('Radiant_Animations:KillProps')
		playerCurrentlyHasProp = false
		playerCurrentlyAnimated = false
	end
end)

RegisterNetEvent('Radiant_Animations:Surrender')  -- Too many waits to make it work properly within the config
AddEventHandler('Radiant_Animations:Surrender', function()
	local player = PlayerPedId()
	local surrendered = false

	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 
		loadAnimDict( "random@arrests" )
		loadAnimDict( "random@arrests@busted" )
		if ( IsEntityPlayingAnim( player, "random@arrests@busted", "idle_a", 3 ) ) then 
			TaskPlayAnim( player, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (3000)
			TaskPlayAnim( player, "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )
			surrendered = false
			RemoveAnimDict("random@arrests" )
			RemoveAnimDict("random@arrests@busted")
		else
			TaskPlayAnim( player, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (4000)
			TaskPlayAnim( player, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (500)
			TaskPlayAnim( player, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (1000)
			TaskPlayAnim( player, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
			Wait(100)
			surrendered = true
		end     
	end

	Citizen.CreateThread(function() --disabling controls while surrendering
		while surrendered do
			Citizen.Wait(1000)
			if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests@busted", "idle_a", 3) then
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
				DisableControlAction(0,21,true)
			end
		end
	end)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('Radiant_Animations:KillProps')
		playerCurrentlyHasProp = false
	end
end)

RegisterCommand("e", function(source, args)

	local player = PlayerPedId()
	local argh = tostring(args[1])

	if argh == 'help' then -- List Anims in Chat Command
		TriggerEvent('chat:addMessage', { args = { '[^1Animations^0]: salute, finger, finger2, phonecall, surrender, facepalm, notes, brief, brief2, foldarms, foldarms2, damn, fail, gang1, gang2, no, pickbutt, grabcrotch, peace, cigar, cigar2, joint, cig, holdcigar, holdcig, holdjoint, dead, holster, aim, aim2, slowclap, box, cheer, bum, leanwall, copcrowd, copcrowd2, copidle, shotbar, drunkbaridle, djidle, djidle2, fdance1, fdance2, mdance1, mdance2' } })
	elseif argh == 'stuckprop' then -- Deletes Clients Props Command
		TriggerEvent('Radiant_Animations:KillProps')
	elseif argh == 'surrender' then -- I'll figure out a better way to do animations with this much depth later.
		TriggerEvent('Radiant_Animations:Surrender')
	elseif argh == 'stop' then -- Cancel Animations
		TriggerEvent('Radiant_Animations:StopAnimations')
	else
		for i = 1, #Config.Anims, 1 do
			local name = Config.Anims[i].name
			if argh == name then				
				local prop_one = Config.Anims[i].data.prop
				local boneone = Config.Anims[i].data.boneone
				if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 

					if playerCurrentlyHasProp then --- Delete Old Prop

						TriggerEvent('Radiant_Animations:KillProps')
					end

					if Config.Anims[i].data.type == 'prop' then

						TriggerEvent('Radiant_Animations:AttachProp', prop_one, boneone, Config.Anims[i].data.x, Config.Anims[i].data.y, Config.Anims[i].data.z, Config.Anims[i].data.xa, Config.Anims[i].data.yb, Config.Anims[i].data.zc)

					elseif Config.Anims[i].data.type == 'brief' then

						if name == 'brief' then
							GiveWeaponToPed(player, 0x88C78EB7, 1, false, true)
						else
							GiveWeaponToPed(player, 0x01B79F17, 1, false, true)
						end
						return
					elseif Config.Anims[i].data.type == 'scenario' then
						if vehiclecheck() then
							if IsPedActiveInScenario(player) then
								ClearPedTasks(player)
							else
								TaskStartScenarioInPlace(player, 'WORLD_HUMAN_COP_IDLES', 0, 1)   
							end 
						end
					else

						if vehiclecheck() then
							local ad = Config.Anims[i].data.ad
							local anim = Config.Anims[i].data.anim
							local body = Config.Anims[i].data.body
							
							TriggerEvent('Radiant_Animations:Animation', ad, anim, body) -- Load/Start animation

							if prop_one ~= 0 then
								local prop_two = Config.Anims[i].data.proptwo
								local bonetwo = nil

								loadPropDict(prop_one)
								TriggerEvent('Radiant_Animations:AttachProp', prop_one, boneone, Config.Anims[i].data.x, Config.Anims[i].data.y, Config.Anims[i].data.z, Config.Anims[i].data.xa, Config.Anims[i].data.yb, Config.Anims[i].data.zc)
								if prop_two ~= 0 then
									bonetwo = Config.Anims[i].data.bonetwo
									prop_two = Config.Anims[i].data.proptwo
									loadPropDict(prop_two)
									TriggerEvent('Radiant_Animations:AttachProp', prop_two, bonetwo, Config.Anims[i].data.twox, Config.Anims[i].data.twoy, Config.Anims[i].data.twoz, Config.Anims[i].data.twoxa, Config.Anims[i].data.twoyb, Config.Anims[i].data.twozc)
								end
							end
						end
					end
				end
			end
		end
	end
end)

function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(50)
	end
end

function loadPropDict(model)
	while not HasModelLoaded(GetHashKey(model)) do
		RequestModel(GetHashKey(model))
		Citizen.Wait(50)
	end
end

function vehiclecheck()
	local player = PlayerPedId()
	if IsPedInAnyVehicle(player, false) then
		return false
	end
	return true
end

isDead = false
RegisterCommand('personnages', function()
	if not isDead then
		TriggerEvent('kashactersC:ReloadCharacters')
	end
end)

-- Besoins
RegisterCommand('pipi', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        --checks female or male
        if skin.sex == 0 then
            TriggerServerEvent('esx-qalle-needs:sync', GetPlayerServerId(PlayerId()), 'pee', 'male')
        else
            TriggerServerEvent('esx-qalle-needs:sync', GetPlayerServerId(PlayerId()), 'pee', 'female')
        end
    end)
end, false)

RegisterCommand('caca', function()
     TriggerServerEvent('esx-qalle-needs:sync', GetPlayerServerId(PlayerId()), 'poop')
 end)

RegisterNetEvent('esx-qalle-needs:syncCL')
AddEventHandler('esx-qalle-needs:syncCL', function(ped, need, sex)
    if need == 'pee' then
        Pee(ped, sex)
    else
        Poop(ped)
    end
end)

local peeing = false
local pooping = false

function Pee(ped, sex)
    local Player = ped
    local PlayerPed = GetPlayerPed(GetPlayerFromServerId(ped))

    local particleDictionary = "core"
    local particleName = "ent_amb_peeing"
    local animDictionary = 'missbigscore1switch_trevor_piss'
    local animName = 'piss_loop'

    RequestNamedPtfxAsset(particleDictionary)

    while not HasNamedPtfxAssetLoaded(particleDictionary) do
        Citizen.Wait(1)
    end

    RequestAnimDict(animDictionary)

    while not HasAnimDictLoaded(animDictionary) do
        Citizen.Wait(1)
    end

    RequestAnimDict('missfbi3ig_0')

    while not HasAnimDictLoaded('missfbi3ig_0') do
        Citizen.Wait(1)
    end

    if sex == 'male' then
        peeing = true

        SetPtfxAssetNextCall(particleDictionary)

        bone   = GetPedBoneIndex(PlayerPed, 11816)

        local heading = GetEntityPhysicsHeading(PlayerPed)

        TaskPlayAnim(PlayerPed, animDictionary, animName, 8.0, -8.0, -1, 0, 0, false, false, false)

        local effect = StartParticleFxLoopedOnPedBone(particleName, PlayerPed, 0.0, 0.0, -0.1, -90.0, 0.0, 20.0, bone, 2.0, false, false, false)

        Citizen.Wait(3500)
        peeing = false

        StopParticleFxLooped(effect, 0)
    else
        peeing = true

        SetPtfxAssetNextCall(particleDictionary)

        bone = GetPedBoneIndex(PlayerPed, 11816)

        local heading = GetEntityPhysicsHeading(PlayerPed)

        TaskPlayAnim(PlayerPed, 'missfbi3ig_0', 'shit_loop_trev', 8.0, -8.0, -1, 0, 0, false, false, false)

        local effect = StartParticleFxLoopedOnPedBone(particleName, PlayerPed, 0.0, 0.0, -0.55, 0.0, 0.0, 20.0, bone, 2.0, false, false, false)

        Citizen.Wait(3500)
        peeing = false

        Citizen.Wait(100)
        StopParticleFxLooped(effect, 0)
    end
end

function Poop(ped)
    local Player = ped
    local PlayerPed = GetPlayerPed(GetPlayerFromServerId(ped))

    local particleDictionary = "scr_amb_chop"
    local particleName = "ent_anim_dog_poo"
    local animDictionary = 'missfbi3ig_0'
    local animName = 'shit_loop_trev'

    RequestNamedPtfxAsset(particleDictionary)

    while not HasNamedPtfxAssetLoaded(particleDictionary) do
        Citizen.Wait(1)
    end

    RequestAnimDict(animDictionary)

    while not HasAnimDictLoaded(animDictionary) do
        Citizen.Wait(1)
    end

    pooping = true

    SetPtfxAssetNextCall(particleDictionary)

    --gets bone on specified ped
    bone = GetPedBoneIndex(PlayerPed, 11816)

    --animation
    TaskPlayAnim(PlayerPed, animDictionary, animName, 8.0, -8.0, -1, 0, 0, false, false, false)

    --2 effets for more shit
    effect = StartParticleFxLoopedOnPedBone(particleName, PlayerPed, 0.0, 0.0, -0.6, 0.0, 0.0, 20.0, bone, 2.0, false, false, false)
    Citizen.Wait(3500)
    effect2 = StartParticleFxLoopedOnPedBone(particleName, PlayerPed, 0.0, 0.0, -0.6, 0.0, 0.0, 20.0, bone, 2.0, false, false, false)
    Citizen.Wait(1000)

    pooping = false

    StopParticleFxLooped(effect, 0)
    Citizen.Wait(10)
    StopParticleFxLooped(effect2, 0)
end

-- Monter chevaux
local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end
	
		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
	
		local next = true
		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next
	
		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

--]]

local Deer = {
	Handle = nil,
	Invincible = false,
	Ragdoll = false,
	Marker = false,
	Speed = {
		Walk = 10.5,
		Run = 26.5,
	},
}

function GetNearbyPeds(X, Y, Z, Radius)
	local NearbyPeds = {}
	for Ped in EnumeratePeds() do
		if DoesEntityExist(Ped) then
			local PedPosition = GetEntityCoords(Ped, false)
			if Vdist(X, Y, Z, PedPosition.x, PedPosition.y, PedPosition.z) <= Radius then
				table.insert(NearbyPeds, Ped)
			end
		end
	end
	return NearbyPeds
end

function GetCoordsInfrontOfEntityWithDistance(Entity, Distance, Heading)
	local Coordinates = GetEntityCoords(Entity, false)
	local Head = (GetEntityHeading(Entity) + (Heading or 0.0)) * math.pi / 180.0
	return {x = Coordinates.x + Distance * math.sin(-1.0 * Head), y = Coordinates.y + Distance * math.cos(-1.0 * Head), z = Coordinates.z}
end

function GetGroundZ(X, Y, Z)
	if tonumber(X) and tonumber(Y) and tonumber(Z) then
		local _, GroundZ = GetGroundZFor_3dCoord(X + 0.0, Y + 0.0, Z + 0.0, Citizen.ReturnResultAnyway())
		return GroundZ
	else
		return 0.0
	end
end

function Deer.Destroy()
	local Ped = PlayerPedId()

	DetachEntity(Ped, true, false)
	ClearPedTasksImmediately(Ped)

	SetEntityAsNoLongerNeeded(Deer.Handle)
	DeletePed(Deer.Handle)

	if DoesEntityExist(Deer.Handle) then
		SetEntityCoords(Deer.Handle, 601.28948974609, -4396.9853515625, 384.98565673828)
	end

	Deer.Handle = nil
end

function Deer.Create()
	local Model = GetHashKey("a_c_deer")
	RequestModel(Model)
	while not HasModelLoaded(Model) do
		Citizen.Wait(10)
	end

	local Ped = PlayerPedId()
	local PedPosition = GetEntityCoords(Ped, false)

	Deer.Handle = CreatePed(28, Model, PedPosition.x, PedPosition.y, PedPosition.z, GetEntityHeading(Ped), true, false)

	SetPedCanRagdoll(Deer.Handle, Deer.Ragdoll)
	SetEntityInvincible(Deer.Handle, Deer.Invincible)

	SetModelAsNoLongerNeeded(Model)
end

function Deer.Attach()
	local Ped = PlayerPedId()

	FreezeEntityPosition(Deer.Handle, true)
	FreezeEntityPosition(Ped, true)

	local DeerPosition = GetEntityCoords(Deer.Handle, false)
	SetEntityCoords(Ped, DeerPosition.x, DeerPosition.y, DeerPosition.z)

	AttachEntityToEntity(Ped, Deer.Handle, GetPedBoneIndex(Deer.Handle, 24816), -0.3, 0.0, 0.24, 0.0, 0.0, 90.0, false, false, false, true, 2, true)

	TaskPlayAnim(Ped, "rcmjosh2", "josh_sitting_loop", 8.0, 1, -1, 2, 1.0, 0, 0, 0)

	FreezeEntityPosition(Deer.Handle, false)
	FreezeEntityPosition(Ped, false)
end

function Deer.Ride()
	local Ped = PlayerPedId()
	local PedPosition = GetEntityCoords(Ped, false)
	if IsPedSittingInAnyVehicle(Ped) or IsPedGettingIntoAVehicle(Ped) then
		return
	end

	local AttachedEntity = GetEntityAttachedTo(Ped)

	if IsEntityAttached(Ped) and GetEntityModel(AttachedEntity) == GetHashKey("a_c_deer") then
		local SideCoordinates = GetCoordsInfrontOfEntityWithDistance(AttachedEntity, 1.0, 90.0)
		local SideHeading = GetEntityHeading(AttachedEntity)

		SideCoordinates.z = GetGroundZ(SideCoordinates.x, SideCoordinates.y, SideCoordinates.z)

		Deer.Handle = nil
		DetachEntity(Ped, true, false)
		ClearPedTasksImmediately(Ped)

		SetEntityCoords(Ped, SideCoordinates.x, SideCoordinates.y, SideCoordinates.z)
		SetEntityHeading(Ped, SideHeading)
	else
		for _, Ped in pairs(GetNearbyPeds(PedPosition.x, PedPosition.y, PedPosition.z, 2.0)) do
			if GetEntityModel(Ped) == GetHashKey("a_c_deer") then
				Deer.Handle = Ped
				Deer.Attach()
				break
			end
		end
	end
end

Citizen.CreateThread(function()
	RequestAnimDict("rcmjosh2")
	while not HasAnimDictLoaded("rcmjosh2") do
		Citizen.Wait(10)
	end
	while true do
		Citizen.Wait(5)

		if IsControlJustPressed(1, 51) then
			Deer.Ride()
		end

		local Ped = PlayerPedId()
		local AttachedEntity = GetEntityAttachedTo(Ped)

		if (not IsPedSittingInAnyVehicle(Ped) or not IsPedGettingIntoAVehicle(Ped)) and IsEntityAttached(Ped) and AttachedEntity == Deer.Handle then
			if DoesEntityExist(Deer.Handle) then
				local LeftAxisXNormal, LeftAxisYNormal = GetControlNormal(2, 218), GetControlNormal(2, 219)
				local Speed, Range = Deer.Speed.Walk, 15.25

				if IsControlPressed(0, 21) then
					Speed = Deer.Speed.Run
					Range = 8.25
				end

				local GoToOffset = GetOffsetFromEntityInWorldCoords(Deer.Handle, LeftAxisXNormal * Range, LeftAxisYNormal * -1.0 * Range, 0.0)

				TaskLookAtCoord(Deer.Handle, GoToOffset.x, GoToOffset.y, GoToOffset.z, 0, 0, 2)
				TaskGoStraightToCoord(Deer.Handle, GoToOffset.x, GoToOffset.y, GoToOffset.z, Speed, 20000, 40000.0, 0.5)

				if Deer.Marker then
					DrawMarker(6, GoToOffset.x, GoToOffset.y, GoToOffset.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 255, 0, 0, 2, 0, 0, 0, 0)
				end
			end
		end
	end
end)