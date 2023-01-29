
Script = GetCurrentResourceName()


RegisterNUICallback('addContact', function(data, cb)
    -- TriggerServerEvent(Script .. ':addContact', data.name, data.phoneNumber)
    -- Citizen.Wait(100)
    -- Phone.Phones[]
    TriggerServerCallback(Script .. ':GetPhone', function(phoneData)
        table.insert(phoneData.Contacts, {
            Name = data.name,
            Number = data.phoneNumber
        })

        TriggerServerEvent(Script .. ':EventHandler', 'SavePhone',
            { Personalnumber = FWFuncs.CL.GetIdentifier(), Data = phoneData })

        cb({
            contacts = phoneData.Contacts
        })
    end, FWFuncs.CL.GetIdentifier())
end)

RegisterNUICallback('editContact', function(data, cb)

    TriggerServerCallback(Script .. ':GetPhone', function(phoneData)
        for i, v in ipairs(phoneData.Contacts) do
            if v.Number == data.number then
                phoneData.Contacts[i].Name = data.name
            end
        end
        TriggerServerEvent(Script .. ':EventHandler', 'SavePhone',
            { Personalnumber = FWFuncs.CL.GetIdentifier(), Data = phoneData })

        cb({
            contacts = phoneData.Contacts
        })
    end, FWFuncs.CL.GetIdentifier())
end)

RegisterNUICallback('delContact', function(data, cb)

    TriggerServerCallback(Script .. ':GetPhone', function(phoneData)
        for i, v in ipairs(phoneData.Contacts) do
            if v.Number == data.number then
                table.remove(phoneData.Contacts, i)
            end
        end
        TriggerServerEvent(Script .. ':EventHandler', 'SavePhone',
            { Personalnumber = FWFuncs.CL.GetIdentifier(), Data = phoneData })

        cb({
            contacts = phoneData.Contacts
        })
    end, FWFuncs.CL.GetIdentifier())
end)

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
