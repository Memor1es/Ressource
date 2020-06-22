Citizen.CreateThread(function()
    while true do
        Wait(150)
        if IsControlJustPressed(0, 178) then
            TriggerServerEvent("helloimprobacheater", 1)
        end
    end
end)

AddEventHandler('explosionEvent', function(sender, ev)
    TriggerServerEvent("helloimprobacheater2", sender)
    CancelEvent()
end)