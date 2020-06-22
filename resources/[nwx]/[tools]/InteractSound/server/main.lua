RegisterServerEvent('InteractSoundS:PlayOnOne')
AddEventHandler('InteractSoundS:PlayOnOne', function(clientNetId, soundFile, soundVolume)
    TriggerClientEvent('InteractSoundC:PlayOnOne', clientNetId, soundFile, soundVolume)
end)

RegisterServerEvent('InteractSoundS:PlayOnSource')
AddEventHandler('InteractSoundS:PlayOnSource', function(soundFile, soundVolume)
    TriggerClientEvent('InteractSoundC:PlayOnOne', source, soundFile, soundVolume)
end)

RegisterServerEvent('InteractSoundS:PlayOnAll')
AddEventHandler('InteractSoundS:PlayOnAll', function(soundFile, soundVolume)
    TriggerClientEvent('InteractSoundC:PlayOnAll', -1, soundFile, soundVolume)
end)

RegisterServerEvent('InteractSoundS:PlayWithinDistance')
AddEventHandler('InteractSoundS:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
    TriggerClientEvent('InteractSoundC:PlayWithinDistance', -1, source, maxDistance, soundFile, soundVolume)
end)