Script = GetCurrentResourceName()

RegisterServerEvent(Script .. ':createCall', function(data)
    -- local player = ESX.GetPlayerFromId(source)
    local callerPlayer = CheckOnline(data.Caller)
    if callerPlayer > -1 then
        TriggerClientEvent(Script .. ':createCall', callerPlayer, data)
    end

    local targetPlayer = CheckOnline(data.Number)
    if targetPlayer > -1 then
        TriggerClientEvent(Script .. ':createCall', targetPlayer, data)
    end
end)

RegisterServerEvent(Script .. ':endCall', function(data)
    -- local player = ESX.GetPlayerFromId(source)
    local callerPlayer = CheckOnline(data.Caller)
    if callerPlayer > -1 then
        TriggerClientEvent(Script .. ':endCall', callerPlayer, data)
    end

    local targetPlayer = CheckOnline(data.Number)
    if targetPlayer > -1 then
        TriggerClientEvent(Script .. ':endCall', targetPlayer, data)
    end
end)

RegisterServerEvent(Script .. ':joinCall', function(data)
    -- local player = ESX.GetPlayerFromId(source)
    local callerPlayer = CheckOnline(data.Caller)
    if callerPlayer > -1 then
        TriggerClientEvent(Script .. ':joinCall', callerPlayer, data)
    end

    local targetPlayer = CheckOnline(data.Number)
    if targetPlayer > -1 then
        TriggerClientEvent(Script .. ':joinCall', targetPlayer, data)
    end
end)


function CheckOnline(phone)
    local players = FWFuncs.SV.GetPlayers()

    local phones = {}

    for k, v in pairs(Phone.Phones) do
        phones[v.Personal.Phonenumber] = k
    end

    for i = 1, #players do
        if phones[phone] == FWFuncs.SV.GetIdentifier(players[i]) then
            return players[i]
        end
    end

    return -1
end
