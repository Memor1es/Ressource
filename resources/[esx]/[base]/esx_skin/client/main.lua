local lastSkin, playerLoaded, cam, isCameraActive
local firstSpawn, zoomOffset, camOffset, heading = true, 0.0, 0.0, 90.0
local zoom = 0

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    PlayerData = ESX.GetPlayerData()
end)

function OpenMenu(submitCb, cancelCb, restrict)
    local playerPed = PlayerPedId()

    TriggerEvent('skinchanger:getSkin', function(skin)
        LastSkin = skin
    end)

    TriggerEvent('skinchanger:getData', function(components, maxVals)
        local elements = {}
        local _components = {}

        -- Restrict menu
        if restrict == nil then
            for i = 1, #components, 1 do
                _components[i] = components[i]
            end
        else
            for i = 1, #components, 1 do
                local found = false

                for j = 1, #restrict, 1 do
                    if components[i].name == restrict[j] then
                        found = true
                    end
                end

                if found then
                    table.insert(_components, components[i])
                end
            end
        end

        -- Insert elements
        for i = 1, #_components, 1 do
            local value = _components[i].value
            local componentId = _components[i].componentId

            if componentId == 0 then
                value = GetPedPropIndex(playerPed, _components[i].componentId)
            end

            local data = {
                label = _components[i].label,
                name = _components[i].name,
                value = value,
                min = _components[i].min,
                textureof = _components[i].textureof,
                zoomOffset = _components[i].zoomOffset,
                camOffset = _components[i].camOffset,
                type = 'slider'
            }

            for k, v in pairs(maxVals) do
                if k == _components[i].name then
                    data.max = v
                    break
                end
            end

            table.insert(elements, data)
        end

        CreateSkinCam()
        zoomOffset = _components[1].zoomOffset
        camOffset = _components[1].camOffset

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'skin', {
            css 	= 'Hollidays',
            title = 'Personnalisation',
            align = 'top-left',
            elements = elements
        }, function(data, menu)

            TriggerEvent('skinchanger:getSkin', function(skin)
                LastSkin = skin
            end)

            submitCb(data, menu)
            DeleteSkinCam()
        end, function(data, menu)
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                if skin == nil then
                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'confirm_escape', {
                        css 	= 'Hollidays',
                        title = ('Voulez-vous vraiment quitter ? (Tous les changements seront perdus)'),
                        align = 'top-left',
                        elements = {
                            { label = 'Non', value = 'no' },
                            { label = 'Oui', value = 'yes' }
                        }
                    }, function(data2, menu2)
                        if data2.current.value == 'yes' then
                            menu.close()
                            DeleteSkinCam()
                            TriggerEvent('skinchanger:loadSkin', LastSkin)
                            Citizen.Wait(1000)
                            TriggerEvent('skinchanger:getSkin', function(skin)

                                if skin.hair_1 == 0 and skin.tshirt_1 == 0 and skin.shoes_1 == 0 and skin.torso_1 == 0 then
                                    Citizen.Wait(1000)
                                    ESX.ShowNotification("Vous devez personnaliser votre personnage..")
                                    Citizen.Wait(1000)
                                    TriggerEvent('skinchanger:loadSkin', { sex = 0 }, OpenSaveableMenu)
                                end
                            end)
                        end

                        menu2.close()
                    end)
                else
                    DeleteSkinCam()
                    menu.close()
                end
            end)

            if cancelCb ~= nil then
                cancelCb(data, menu)
            end
        end, function(data, menu)
            TriggerEvent('skinchanger:getSkin', function(skin)
                zoomOffset = data.current.zoomOffset
                camOffset = data.current.camOffset

                if skin[data.current.name] ~= data.current.value then
                    -- Change skin element
                    TriggerEvent('skinchanger:change', data.current.name, data.current.value)

                    -- Update max values
                    TriggerEvent('skinchanger:getData', function(components, maxVals)
                        for i = 1, #elements, 1 do
                            local newData = {}

                            newData.max = maxVals[elements[i].name]

                            if elements[i].textureof ~= nil and data.current.name == elements[i].textureof then
                                newData.value = 0
                            end

                            menu.update({ name = elements[i].name }, newData)
                        end

                        menu.refresh()
                    end)
                end
            end)
        end, function(data, menu)
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

                if skin == nil then

                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'confirm_escape', {
                        css 	= 'Hollidays',
                        title = ('Voulez-vous vraiment valider ce skin ?'),
                        align = 'top-left',
                        elements = {
                            { label = 'Non', value = 'no' },
                            { label = 'Oui', value = 'yes' }
                        }
                    }, function(data3, menu3)
                        if data3.current.value == 'yes' then
                            menu3.close()
                            DeleteSkinCam()
                            TriggerEvent('skinchanger:loadSkin', LastSkin)
                            Citizen.Wait(1000)
                            TriggerEvent('skinchanger:getSkin', function(skin)

                                if skin.hair_1 == 0 and skin.tshirt_1 == 0 and skin.shoes_1 == 0 and skin.torso_1 == 0 then
                                    Citizen.Wait(1000)
                                    ESX.ShowNotification("Vous devez personnaliser votre personnage..")
                                    Citizen.Wait(1000)
                                    TriggerEvent('skinchanger:loadSkin', { sex = 0 }, OpenSaveableMenu)
                                end
                            end)
                        else
                            TriggerEvent('skinchanger:loadSkin', { sex = 0 }, OpenSaveableMenu)
                        end

                        menu3.close()
                        menu.close()
                    end)
                end
            end)
        end)
    end)
end

function CreateSkinCam()
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)

    isCameraActive = true
    SetCamRot(cam, 0.0, 0.0, 270.0, true)
    SetEntityHeading(playerPed, 90.0)
end

function DeleteSkinCam()
    isCameraActive = false
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    cam = nil
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if isCameraActive then

            HideHudAndRadarThisFrame()

            DisableControlAction(2, 30, true)
            DisableControlAction(2, 31, true)
            DisableControlAction(2, 33, true)
            DisableControlAction(2, 34, true)
            DisableControlAction(2, 35, true)
            DisableControlAction(0, 25, true) -- Input Aim
            DisableControlAction(0, 24, true) -- Input Attack

            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)

            local angle = heading * math.pi / 180.0
            local theta = {
                x = math.cos(angle),
                y = math.sin(angle)
            }

            local pos = {
                x = coords.x + ((zoomOffset + zoom) * theta.x),
                y = coords.y + ((zoomOffset + zoom) * theta.y)
            }

            local angleToLook = heading - 140.0
            if angleToLook > 360 then
                angleToLook = angleToLook - 360
            elseif angleToLook < 0 then
                angleToLook = angleToLook + 360
            end

            angleToLook = angleToLook * math.pi / 180.0
            local thetaToLook = {
                x = math.cos(angleToLook),
                y = math.sin(angleToLook)
            }

            local posToLook = {
                x = coords.x + ((zoomOffset + zoom) * thetaToLook.x),
                y = coords.y + ((zoomOffset + zoom) * thetaToLook.y)
            }

            SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
            PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)

        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    local angle = 90

    while true do
        Citizen.Wait(0)

        if isCameraActive then
            angle = Citizen.InvokeNative(0x837765A25378F0BB, 0, Citizen.ResultAsVector()).z
            if IsControlJustPressed(0, 32) then -- Scrollup
                zoom = zoom - 0.05
                if zoom < -0.3 then zoom = -0.3 end
            end
            if IsControlJustPressed(0, 8) then
                zoom = zoom + 0.05 -- ScrollDown
                if zoom > 2.2 then zoom = 2.2 end
            end
            if IsControlJustPressed(0, 241) then -- Scrollup
                zoom = zoom - 0.05
                if zoom < -0.3 then zoom = -0.3 end
            end
            if IsControlJustPressed(0, 242) then
                zoom = zoom + 0.05 -- ScrollDown
                if zoom > 2.2 then zoom = 2.2 end
            end
            heading = angle + 0.0
        else
            Citizen.Wait(500)
        end
    end
end)

function OpenSaveableMenu(submitCb, cancelCb, restrict)
    TriggerEvent('skinchanger:getSkin', function(skin)
        LastSkin = skin
    end)

    OpenMenu(function(data, menu)
        menu.close()
        DeleteSkinCam()

        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerServerEvent('esx_skin:save', skin)
            if submitCb ~= nil then
                submitCb(data, menu)
            end
        end)
    end, cancelCb, restrict)
end

AddEventHandler('playerSpawned', function()
	Citizen.CreateThread(function()
		while not playerLoaded do
			Citizen.Wait(100)
		end

		if firstSpawn then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin == nil then
					TriggerEvent('skinchanger:loadSkin', {sex = 0}, OpenSaveableMenu)
				else
					TriggerEvent('skinchanger:loadSkin', skin)
				end
			end)

			ESX.TriggerServerCallback('esx_skin:getPlayerSkinFaction', function(skin, factionSkin)
				if skin == nil then
					TriggerEvent('skinchanger:loadSkin', {sex = 0}, OpenSaveableMenu)
				else
					TriggerEvent('skinchanger:loadSkin', skin)
				end
			end)

			firstSpawn = false
		end
	end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	playerLoaded = true
end)

AddEventHandler('esx_skin:getLastSkin', function(cb)
	cb(lastSkin)
end)

AddEventHandler('esx_skin:setLastSkin', function(skin)
	lastSkin = skin
end)

RegisterNetEvent('esx_skin:openMenu')
AddEventHandler('esx_skin:openMenu', function(submitCb, cancelCb)
	OpenMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('esx_skin:openRestrictedMenu')
AddEventHandler('esx_skin:openRestrictedMenu', function(submitCb, cancelCb, restrict)
	OpenMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('esx_skin:openSaveableMenu')
AddEventHandler('esx_skin:openSaveableMenu', function(submitCb, cancelCb)
    --OpenSaveableMenu(submitCb, cancelCb, nil)
    local restrict = {}
    restrict = {
        'sex',
        'face',
        'skin',
        'age_1',
        'age_2',
        'glasses_1',
        'glasses_2',
        'beard_1',
        'beard_2',
        'beard_3',
        'beard_4',
        'hair_1',
        'hair_2',
        'hair_color_1',
        'hair_color_2',
        'eye_color',
        'eyebrows_1',
        'eyebrows_2',
        'eyebrows_3',
        'eyebrows_4',
        'makeup_1',
        'makeup_2',
        'makeup_3',
        'makeup_4',
        'lipstick_1',
        'lipstick_2',
        'lipstick_3',
        'lipstick_4',
        'blemishes_1',
        'blemishes_2',
        'blush_1',
        'blush_2',
        'blush_3',
        'complexion_1',
        'complexion_2',
        'sun_1',
        'sun_2',
        'moles_1',
        'moles_2',
        'tshirt_1',
        'tshirt_2',
        'torso_1',
        'torso_2',
        'chain_1',
        'chain_2',
        'decals_1',
        'decals_2',
        'arms',
        'watches_1',
        'watches_2',
        'pants_1',
        'pants_2',
        'shoes_1',
        'shoes_2',
        'bproof_1',
        'bproof_2'
    }
    OpenSaveableMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('esx_skin:openSaveableRestrictedMenu')
AddEventHandler('esx_skin:openSaveableRestrictedMenu', function(submitCb, cancelCb, restrict)
	OpenSaveableMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('esx_skin:requestSaveSkin')
AddEventHandler('esx_skin:requestSaveSkin', function()
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerServerEvent('esx_skin:responseSaveSkin', skin)
	end)
end)