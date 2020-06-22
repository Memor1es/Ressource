ESX = nil
local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local GUI = {}
GUI.Time = 0
local Weed = {}
local generalLoaded = false

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
  Citizen.Wait(1000)
  CreateWeed()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  CreateWeed()
end)

RegisterNetEvent('nwx_weed:PlantationWeed')
AddEventHandler('nwx_weed:PlantationWeed', function()
  local currentPos = GetEntityCoords(GetPlayerPed(-1))
  local id = math.random(01,999999)

    x, y, z = table.unpack(currentPos);
    TriggerServerEvent('nwx_weed:CreateWeed', x, y, z -1,id)
    TaskStartScenarioInPlace(GetPlayerPed(-1), "world_human_gardener_plant", 0, false)
    Citizen.Wait(10000)
    ClearPedTasks(GetPlayerPed(-1))
    Citizen.Wait(2000)
    CreateWeed()
end)

function CreateWeed()
  ESX.TriggerServerCallback('nwx_weed:CheckWeed', function(data)
    for i=1, #data, 1 do
      local data = data[i]
      DeleteObject(Weed[data.x])
      if data.percent <= 25 then 
        Weed[data.x] = CreateObject(GetHashKey("prop_weed_01"), data.x, data.y, data.z -1.4, false, false, false)    
	    SetEntityAsMissionEntity(Weed[data.x],true,true)
        SetEntityAlwaysPrerender(Weed[data.x],true)
        FreezeEntityPosition(Weed[data.x],true)
      elseif data.percent >= 26 and data.percent <= 50 then
        Weed[data.x] = CreateObject(GetHashKey("prop_weed_01"), data.x, data.y, data.z -1.2, false, false, false)    
	    SetEntityAsMissionEntity(Weed[data.x],true,true)
        SetEntityAlwaysPrerender(Weed[data.x],true)
        FreezeEntityPosition(Weed[data.x],true)
      elseif data.percent >= 51 and data.percent <= 75 then 
        Weed[data.x] = CreateObject(GetHashKey("prop_weed_01"), data.x, data.y, data.z - 0.8 , false, false, false)    
	    SetEntityAsMissionEntity(Weed[data.x],true,true)
        SetEntityAlwaysPrerender(Weed[data.x],true)
        FreezeEntityPosition(Weed[data.x],true)
      elseif data.percent >= 76 or data.percent >= 150 then 
        Weed[data.x] = CreateObject(GetHashKey("prop_weed_01"), data.x , data.y, data.z, false, false, false)    
	    SetEntityAsMissionEntity(Weed[data.x],true,true)
        SetEntityAlwaysPrerender(Weed[data.x],true)
        FreezeEntityPosition(Weed[data.x],true)
      end
    end
  end)
end

RegisterNetEvent('nwx_weed:UseTruelle')
AddEventHandler('nwx_weed:UseTruelle', function(x)
  ESX.TriggerServerCallback('nwx_weed:CheckWeed', function(data)
    for i=1, #data, 1 do
      local data = data[i]
        
        distance = GetDistanceBetweenCoords(data.x, data.y, data.z, GetEntityCoords(GetPlayerPed(-1)))

        if distance < 1 then 
          if data.percent < 99 then 
            ESX.ShowNotification('~r~ Le plan n\'est pas mature')
          elseif data.percent >= 100 or data.percent <= 150 then
            TriggerServerEvent('nwx_weed:DeleteWeed', data.x)
            TaskStartScenarioInPlace(GetPlayerPed(-1), "world_human_gardener_plant", 0, false)
            Citizen.Wait(5000)
            TriggerEvent('nwx_weed:DeleteWeed', data.x)
            Weed[data.x] = CreateObject(GetHashKey("prop_weed_01"), data.x, data.y, data.z - 0.8 , false, false, false)    
            Citizen.Wait(5000)
            TriggerEvent('nwx_weed:DeleteWeed', data.x)
            Weed[data.x] = CreateObject(GetHashKey("prop_weed_01"), data.x, data.y, data.z - 1.2 , false, false, false) 
            Citizen.Wait(5000)
            TriggerEvent('nwx_weed:DeleteWeed', data.x)
            Weed[data.x] = CreateObject(GetHashKey("prop_weed_01"), data.x, data.y, data.z - 1.4 , false, false, false) 
            Citizen.Wait(5000)
            ClearPedTasks(GetPlayerPed(-1))
            TriggerServerEvent('nwx_weed:GiveWeed',data.x)
          end
        end
    end
  end)
end)

RegisterNetEvent('nwx_weed:DeleteWeed')
AddEventHandler('nwx_weed:DeleteWeed', function(x)
  DeleteObject(Weed[x])
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(60*1000*10)
    CreateWeed()
  end
end)

RegisterNetEvent('nwx_weed:UsePelle')
AddEventHandler('nwx_weed:UsePelle', function(x)
  ESX.TriggerServerCallback('nwx_weed:CheckWeed', function(data)
    for i=1, #data, 1 do
      local data = data[i]
        distance = GetDistanceBetweenCoords(data.x, data.y, data.z, GetEntityCoords(GetPlayerPed(-1)))
        if distance < 2 then 
          TriggerServerEvent('nwx_weed:DeleteWeed', data.x)
        end
    end
  end)
end)

local WeedPNJ = {
	{id=1, Name=PnjWeed, VoiceName="GENERIC_INSULT_HIGH", Ambiance="AMMUCITY", Weapon=1649403952, modelHash="A_F_Y_Hippie_01", x = -2293.3349609375, y = 1287.0333251953, z = 313.82509155273, heading=197.01868286133},
}

Citizen.CreateThread(function()
	Citizen.Wait(1)
	if (not generalLoaded) then
		for i=1, #WeedPNJ do
			RequestModel(GetHashKey(WeedPNJ[i].modelHash))
			while not HasModelLoaded(GetHashKey(WeedPNJ[i].modelHash)) do
			Citizen.Wait(1)
			end

			RequestAnimDict('creatures@rottweiler@amb@world_dog_sitting@base')
			while not HasAnimDictLoaded('creatures@rottweiler@amb@world_dog_sitting@base') do
				Citizen.Wait(1)
			end

      WeedPNJ[i].id = CreatePed(28, WeedPNJ[i].modelHash, WeedPNJ[i].x, WeedPNJ[i].y, WeedPNJ[i].z, WeedPNJ[i].heading, false, false)
      TaskStartScenarioInPlace(WeedPNJ[i].id,'world_human_gardener_plant', 0 , false )
    end
	end
  generalLoaded = true  
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
    for i=1, #WeedPNJ do

      distanceWeedPNJ = GetDistanceBetweenCoords(WeedPNJ[i].x, WeedPNJ[i].y, WeedPNJ[i].z, GetEntityCoords(GetPlayerPed(-1)))

      if distanceWeedPNJ <= 2 then
        headsUp('Appuyez sur ~INPUT_CONTEXT~ pour faire des achats')
        if IsControlJustPressed(1, Keys["E"]) then
          OpenMenuWeed()
        end
      end

    end
  end
end)

function OpenMenuWeed()

  local elements = {
    {label = 'Acheter des graines de weed - 40$', value = 'SeedWeed'},
    {label = 'Pot de Terre - 65$', value = 'BuyPot'},
    {label = 'Acheter truelle - 100$', value = 'Truelle'}
  }

  ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'weed_shop',
    {
      title    = 'Achats',
      elements = elements
    },
    function(data, menu)
      if data.current.value == 'SeedWeed' then
        menu.close()
        TriggerServerEvent('nwx_weed:BuySeedWeed')
      elseif data.current.value == 'Truelle' then
        menu.close()
        TriggerServerEvent('nwx_weed:BuyTruelle')
      elseif data.current.value == 'BuyPot' then
        menu.close()
        TriggerServerEvent('nwx_weed:BuyPot')
      end
    end,
    function(data, menu)
      menu.close()
    end
  )
end

function headsUp(text)
	SetTextComponentFormat('STRING')
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
