ESX.RegisterServerCallback('va_swish:swishSend', function(source, cb, data)
    local sourceAmount = Swish.Funcs.SV.GetBankMoney(FWFuncs.SV.GetIdentifier(source))
    local amount = tonumber(data.amount)
    ESX.TriggerServerCallback(Script .. ':getPlayerFromPhone', source, data.number, function(player)
        if player then

            if amount == nil or amount <= 0 or amount > sourceAmount then
                TriggerEvent(Script .. ':send_notification', FWFuncs.SV.GetIdentifier(source), {
                    app = 'swish',
                    title = 'Swish - Error',
                    message = 'Felaktigt belopp, testa igen.',
                    id = GetGameTimer(),
                    onClick = 'none'
                })
            else
                Swish.Funcs.SV.RemoveBankMoney(FWFuncs.SV.GetIdentifier(source), amount)

                Swish.Funcs.SV.AddBankMoney(player.personalnumber, amount)
                cb({
                    status = 'ok',
                    name = player.name,
                })

                TriggerEvent(Script .. ':send_notification', player.personalnumber, {
                    app = 'swish',
                    title = 'Swish - ' .. player.name,
                    message = 'har swishat ' .. amount .. ' kr',
                    id = GetGameTimer(),
                    onClick = 'none'
                })

                TriggerEvent(
                    'n4_bank:addTransaction',
                    FWFuncs.SV.GetIdentifier(source),
                    player.personalnumber,
                    'Swish',
                    amount
                )
            end
        end
    end)
end)



-- * Dev functions * --

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end
