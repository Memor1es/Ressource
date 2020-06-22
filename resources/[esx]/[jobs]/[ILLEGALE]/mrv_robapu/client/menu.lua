_menuPool = NativeUI.CreatePool()

mainMenu = NativeUI.CreateMenu("", _U("welcome_apu"), 5, 300, "shopui_title_conveniencestore", "shopui_title_conveniencestore")

_menuPool:Add(mainMenu)



function ShowNotification(text)

    SetNotificationTextEntry("STRING")

    AddTextComponentString(text)

    DrawNotification(false, false)

end



function AddMenuRobApu(menu)

        

    local submenu = _menuPool:AddSubMenu(menu, "Actions", "", 5, 100, "shopui_title_conveniencestore", "shopui_title_conveniencestore")



    local robapumoney = NativeUI.CreateItem(_U("rob_apu"), "")

    submenu.SubMenu:AddItem(robapumoney)



    local robapufood = NativeUI.CreateItem(_U("stealing_food"), "")

    submenu.SubMenu:AddItem(robapufood)



    local robapucollect = NativeUI.CreateItem("Ramasser", "")

    submenu.SubMenu:AddItem(robapucollect)



    submenu.SubMenu.OnItemSelect = function(menu, item)

        

        if item == robapumoney and not isRobbed(epicerie.k) then

            _menuPool:MouseControlsEnabled (false);

            _menuPool:MouseEdgeEnabled (false);

            _menuPool:ControlDisablingEnabled(false);



            ESX.TriggerServerCallback('vdk_call:getInService', function(inService)

                local cops = #inService

                if cops > 0 then

                    if IsPedArmed(PlayerPedId(), 7) then

                        holdupon = true

                        canotif = true

                        _menuPool:CloseAllMenus()

                        startAnim(epicerie.ped, "mp_am_hold_up", "holdup_victim_20s")

                        local playerloc = GetEntityCoords(PlayerPedId(), 0)

                        TriggerServerEvent("vdk_call:makeCall", "police", playerloc, "APU: Braquage d'épicerie", true)



                        missionText(_U("save_life"), 7000)

                        

                        Citizen.Wait(12000)

                        spawnbag()

                        Citizen.Wait(9000)



                        DeleteEntity(bagprop)

        

                        spawncash()

                        ESX.ShowNotification("~y~APU~w~ à déposer de ~r~l'argent~w~ sur le comptoir!")

                        setRobbed()

                        -- local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())

                        -- TriggerServerEvent('mrv_robapu:sendSuspectPicture', mugshotStr)

                        -- UnregisterPedheadshot(mugshot)

                    else

                        canotif = false

                        startAnim(epicerie.ped, "mp_player_int_upperfinger", "mp_player_int_finger_01_enter")

                        missionText(_U("dont_scare"), 5000)

                    end

                

                    holdupon = false

                else

                    ESX.ShowNotification("~r~Pas assez de policiers en ville !")

                end

            end, 'police')

        end



        if item == robapufood and not isRobbed(epicerie.k) and canrobfood then

            ShowNotification(_U("only_rob"))

            holdupon = true

            ESX.ShowAdvancedNotification("Apu", "Message", _U("wait"), "CHAR_MULTIPLAYER", 2)

            Citizen.Wait(2000)

            robfoodmax = robfoodmax + 1

            startAnim(PlayerPedId(), "anim@am_hold_up@male", "shoplift_low")

            TriggerServerEvent('mrv_robapu:rewardsfood')

        end



        if item == robapucollect then

            if epicerie.cancollect == true then

                TriggerEvent('poggu_hud:alert', "Récupération de l'argent ...", 9000, "info")

                Citizen.Wait(9000)

                collectcash()

            else

                ESX.ShowNotification("~r~Il n'y à rien à ramasser!")

            end

        end



        -- TriggerServerEvent('mrv_robapu:callPolice')

        

        holdupon = false

    end

end



AddMenuRobApu(mainMenu)

_menuPool:MouseControlsEnabled (false);

_menuPool:MouseEdgeEnabled (false);

_menuPool:ControlDisablingEnabled(false);

_menuPool:RefreshIndex()

