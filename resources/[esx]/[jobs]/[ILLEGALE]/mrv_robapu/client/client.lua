ESX = nil

holdupon = false

robfoodmax = 0

canrobfood = false

canotif = false

epicerie = nil

robbed = {}



Citizen.CreateThread(function()

    while ESX == nil do

        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

        Citizen.Wait(0)

    end



    if Config.EnableBlips then

        for i, e in pairs(Config.Epiceries) do

            blip = AddBlipForCoord(e.x, e.y, e.z)

            SetBlipSprite(blip, 52)

            SetBlipDisplay(blip, 4)

            SetBlipScale(blip, 0.9)

            SetBlipColour(blip, 50)

            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")

            AddTextComponentString("Apu")

            EndTextCommandSetBlipName(blip)

        end

    end



    local hash = GetHashKey("mp_m_shopkeep_01")

    while not HasModelLoaded(hash) do

        RequestModel(hash)

        Citizen.Wait(20)

    end

    for i, e in pairs(Config.Epiceries) do

        e.ped = CreatePed("PED_TYPE_CIVMALE", "mp_m_shopkeep_01",  e.x, e.y, e.z, e.heading, false, true)

        SetBlockingOfNonTemporaryEvents(ped, true)

        FreezeEntityPosition(ped, true)

        SetEntityInvincible(ped, true)

    end



    while true do

        Citizen.Wait(5)

        _menuPool:ProcessMenus()



        local coords = GetEntityCoords(PlayerPedId(), false)

        local letSleep = true



        for i, e in pairs(Config.Epiceries) do

            SetBlockingOfNonTemporaryEvents(e.ped, true)

            FreezeEntityPosition(e.ped, true)

            SetEntityInvincible(e.ped, true)

            local dist = Vdist(coords.x, coords.y, coords.z, e.x, e.y, e.z)



            if dist < 10 then

                letSleep = false

            end



            if dist <= 2 and holdupon == false then

                epicerie = e

                epicerie.k = i

                

                ESX.ShowHelpNotification(_U("talkwith_apu"))

                if IsControlJustPressed(1,51) then 

                    mainMenu:Visible(not mainMenu:Visible())

                end

            end



            -- local v1 = vector3(e.x, e.y, e.z)



            -- if Vdist2(GetEntityCoords(PlayerPedId(), false), v1) < Config.Distance then

            --     Draw3DText(v1.x, v1.y, v1.z + 2, "Apu")

            -- end



            if robfoodmax >= Config.RobFoodMax then

                canrobfood = false

            else

                canrobfood = true

            end

        end



        if letSleep then

            Citizen.Wait(500)

        end

    end

--

end)



function Draw3DText(x, y, z, text)

    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    local p = GetGameplayCamCoords()

    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)

    local scale = (1 / distance) * 2

    local fov = (1 / GetGameplayCamFov()) * 100

    local scale = scale * fov

    if onScreen then

        SetTextScale(0.0, 0.35)

        SetTextFont(0)

        SetTextProportional(1)

        SetTextColour(255, 255, 255, 255)

        SetTextDropshadow(0, 0, 0, 0, 255)

        SetTextEdge(2, 0, 0, 0, 150)

        SetTextDropShadow()

        SetTextOutline()

        SetTextEntry("STRING")

        SetTextCentre(1)

        AddTextComponentString(text)

        DrawText(_x,_y)

    end

end



function missionText(text, time)

    ClearPrints()

    SetTextEntry_2("STRING")

    AddTextComponentString(text)

    DrawSubtitleTimed(time, 1)

end



function startAnim(entity, lib, anim)

	ESX.Streaming.RequestAnimDict(lib, function()

		TaskPlayAnim(entity, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

	end)

end



function spawnbag()

    local object = GetHashKey("p_poly_bag_01_s")



    RequestModel(object)

    while (not HasModelLoaded(object)) do

        Wait(50)

    end



    bagprop = CreateObject(object, epicerie.x, epicerie.y, epicerie.z, true, true, true)

    AttachEntityToEntity(bagprop, epicerie.ped, GetPedBoneIndex(epicerie.ped, 18905), 0, 0, -0.1, 0, 0, 0)

end



function spawncash()

    local object = GetHashKey("prop_cash_pile_01")



    RequestModel(object)

    while (not HasModelLoaded(object)) do

        Wait(50)

    end

    

    epicerie.cancollect = true

    local heading = (epicerie.heading - 20) % 360

    local x = epicerie.x - 0.75 * math.sin(math.rad(heading))

    local y = epicerie.y + 0.75 * math.cos(math.rad(heading))



    epicerie.cashprop = CreateObject(object, x, y, epicerie.z + 1.1, true, true, true)

    -- AttachEntityToEntity(epicerie.cashprop, epicerie.ped, GetPedBoneIndex(epicerie.ped, 18905), 0, 0, -0.1, 0, 0, 0)

    PlaceObjectOnGroundProperly(epicerie.cashprop)

end



function collectcash()

    DeleteEntity(epicerie.cashprop)

    epicerie.cancollect = false

    TriggerServerEvent('mrv_robapu:rewards', math.random(Config.MinReward, Config.MaxReward))

end



function setRobbed()

    local key = epicerie.k

    table.insert(robbed, key)

    Citizen.SetTimeout(Config.Cooldown, function() 

        for k, v in pairs(robbed) do

            if v.k == key then

                table.remove(robbed, k)

                break

            end

        end

    end)

end



function isRobbed(key)

    for k, v in pairs(robbed) do

        if v == key then

            return true

        end

    end

    return false

end