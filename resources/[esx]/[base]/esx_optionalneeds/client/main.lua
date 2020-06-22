local IsAlreadyDrunk = false
local DrunkLevel = -1

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

function Drunk(level, start)
  Citizen.CreateThread(function()
    local playerPed = GetPlayerPed(-1)

    if start then
      DoScreenFadeOut(800)
      Wait(1000)
    end

    if level == 0 then
      RequestAnimSet("move_m@drunk@slightlydrunk")
      
      while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
        Citizen.Wait(0)
      end
      SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)

    elseif level == 1 then
      RequestAnimSet("move_m@drunk@moderatedrunk")
      
      while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
        Citizen.Wait(0)
      end
      SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)

    elseif level == 2 then
      RequestAnimSet("move_m@drunk@verydrunk")
      
      while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
        Citizen.Wait(0)
      end
      SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)
    end
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(playerPed, true)
    SetPedIsDrunk(playerPed, true)
    if start then
      DoScreenFadeIn(800)
    end
  end)

end

function Reality()
  Citizen.CreateThread(function()
    local playerPed = GetPlayerPed(-1)
    DoScreenFadeOut(800)
    Wait(1000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(playerPed, 0)
    SetPedIsDrunk(playerPed, false)
    SetPedMotionBlur(playerPed, false)
    DoScreenFadeIn(800)
  end)
end

AddEventHandler('esx_status:loaded', function(status)

  TriggerEvent('esx_status:registerStatus', 'drunk', 0, '#8F15A5', 
    function(status)
      if status.val > 0 then
        return true -- Set to true to show if you drink | false to always hide
      else
        return false -- Set to true to always show | false to hide if 0
      end
    end,
    function(status)
      status.remove(1500)
    end
  )

RegisterNetEvent('esx_optionalneeds:onDrink')
AddEventHandler('esx_optionalneeds:onDrink', function()
  local playerPed = GetPlayerPed(-1)
  TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_DRINKING", 0, 1)
  Citizen.Wait(1000)
  ClearPedTasksImmediately(playerPed)
end)