
Script = GetCurrentResourceName()

-- * Main Script * --
RegisterServerEvent(Script .. ':send_notification')
AddEventHandler(Script .. ':send_notification', function(target, data)
    local id = FWFuncs.SV.IDFromIdentifier(target)

    if id ~= false then
        TriggerClientEvent(Script .. ':show_message', id, data)
    end
end)
