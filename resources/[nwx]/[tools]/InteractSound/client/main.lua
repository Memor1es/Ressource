local standardVolumeOutput = 1.0;

RegisterNetEvent('InteractSoundC:PlayOnOne')
AddEventHandler('InteractSoundC:PlayOnOne', function(soundFile, soundVolume)
    SendNUIMessage({
        transactionType = 'playSound',
        transactionFile = soundFile,
        transactionVolume = soundVolume
    })
end)

RegisterNetEvent('InteractSoundC:PlayOnAll')
AddEventHandler('InteractSoundC:PlayOnAll', function(soundFile, soundVolume)
    SendNUIMessage({
        transactionType = 'playSound',
        transactionFile = soundFile,
        transactionVolume = soundVolume
    })
end)

RegisterNetEvent('InteractSoundC:PlayWithinDistance')
AddEventHandler('InteractSoundC:PlayWithinDistance', function(playerNetId, maxDistance, soundFile, soundVolume)
    local lCoords = GetEntityCoords(GetPlayerPed(-1))
    local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerNetId)))
    local distIs = Vdist(lCoords.x, lCoords.y, lCoords.z, eCoords.x, eCoords.y, eCoords.z)
    if(distIs <= maxDistance) then
        SendNUIMessage({
            transactionType = 'playSound',
            transactionFile = soundFile,
            transactionVolume = soundVolume
        })
    end
end)