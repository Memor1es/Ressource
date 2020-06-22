ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx-qalle-needs:sync')
AddEventHandler('esx-qalle-needs:sync', function(ped, need, sex)
    TriggerClientEvent('esx-qalle-needs:syncCL', -1, ped, need, sex)
end)