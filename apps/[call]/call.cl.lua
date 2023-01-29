Script = GetCurrentResourceName()

RegisterNetEvent(Script .. ':createCall')
AddEventHandler(Script .. ':createCall', function(data)
    local Data = data
    if (Data.Number == Phone.PhoneData['Personal'].Phonenumber) then
        if (FWFuncs.CL.HasItem(Config.Item)) and Phone.PhoneData.Personal['Settings']['do_not_disturb'] == 0 then
            Phone.Ringtone = exports['n4_utils']:PlaySound({
                Name = ('ringtone-%s'):format(GetPlayerServerId(PlayerId())),
                SoundFile = Phone.PhoneData.Personal['Settings']['ringtone'] and
                    Config.Ringtones[Phone.PhoneData.Personal['Settings']['ringtone']] or
                    'opening',
                Player = GetPlayerServerId(PlayerId()),
                MaxDistance = 12.5,
                MaxVolume = 0.15
            })

            local contacts = {}

            for i = 1, #Phone.PhoneData.Contacts do
                contacts[Phone.PhoneData.Contacts[i].Number] = Phone.PhoneData.Contacts[i].Name
            end

            if Data.HiddenNumber then
                Data.CallerLabel = 'Okänt nummer'
            else
                Data.CallerLabel = contacts[Data.Caller] or Data.Caller
            end

            N4_PHONE.SetDisplay(true)

            SendNUIMessage({
                type = 'Incomingcall',
                Function = 'Open',
                Data = Data
            })
        end
    elseif (Data.Caller == Phone.PhoneData['Personal'].Phonenumber) then
        Data.State = 'Calling';

        local contacts = {}

        for i = 1, #Phone.PhoneData.Contacts do
            contacts[Phone.PhoneData.Contacts[i].Number] = Phone.PhoneData.Contacts[i].Name
        end

        Data.CallerLabel = contacts[Data.Number] or Data.Number

        SendNUIMessage({
            type = 'Call',
            Function = 'Open',
            Data = Data
        })

        -- exports['pma-voice']:SetCallChannel(Data.Caller)

        Phone.CallSound = exports['n4_utils']:PlaySound({
            Name = 'calling',
            SoundFile = 'calling',
            Source = GetPlayerServerId(PlayerId()),
            Volume = 0.5
        })

        Phone.PlayAnim('call')
    end
    -- end)

end)

RegisterNetEvent(Script .. ':endCall')
AddEventHandler(Script .. ':endCall', function(data)
    local Data = data
    if (Data.Number == Phone.PhoneData['Personal'].Phonenumber) then
        if Phone.Ringtone then
            Phone.Ringtone.StopSound()
            Phone.Ringtnoe = nil
        end

        if Phone.IsOpened then
            SendNUIMessage({
                type = 'Call',
                Function = 'EndCall',
                Data = Data
            })

            SendNUIMessage({
                type = 'Incomingcall',
                Function = 'EndCall',
                Data = Data
            })

            Phone.PlayAnim('text')
        end

        Phone.Incomingcall = nil

        exports['pma-voice']:SetCallChannel(0)
        --exports['tokovoip_script']:removePlayerFromRadio('Call-' .. Data.Caller)
    elseif (Data.Caller == Phone.PhoneData['Personal'].Phonenumber) then
        if Phone.CallSound then
            Phone.CallSound.StopSound()
            Phone.CallSound = nil
        end

        SendNUIMessage({
            type = 'Call',
            Function = 'EndCall',
            Data = Data
        })

        if Phone.IsOpened then
            Phone.PlayAnim('text')
        end

        exports['pma-voice']:SetCallChannel(0)
        --exports['tokovoip_script']:removePlayerFromRadio('Call-' .. Data.Caller)
    end
end)

RegisterNetEvent(Script .. ':joinCall')
AddEventHandler(Script .. ':joinCall', function(data)
    local Data = data
    if (Data.Number == Phone.PhoneData['Personal'].Phonenumber) then
        if Phone.Ringtone then
            Phone.Ringtone.StopSound()
            Phone.Ringtnoe = nil
        end

        SendNUIMessage({
            type = 'Call',
            Function = 'Open',
            state = 'InCall',
            Data = Data
        })

        Phone.Incomingcall = nil

        exports['pma-voice']:SetCallChannel(Data.Caller)
        --exports['tokovoip_script']:addPlayerToRadio('Call-' .. Data.Caller)

        Phone.PlayAnim('call')
    elseif (Data.Caller == Phone.PhoneData['Personal'].Phonenumber) then
        if Phone.CallSound then
            Phone.CallSound.StopSound()
            Phone.CallSound = nil
        end

        SendNUIMessage({
            type = 'Call',
            Function = 'SetState',
            state = 'InCall'
        })

        if Phone.IsOpened then
            exports['pma-voice']:SetCallChannel(Data.Caller)
            --exports['tokovoip_script']:addPlayerToRadio('Call-' .. Data.Caller)
        end
    end
end)

RegisterNUICallback('createCall', function(data, cb)
    TriggerServerEvent(Script .. ':createCall', data)
    cb({})
end)
RegisterNUICallback('endCall', function(data, cb)
    TriggerServerEvent(Script .. ':endCall', data)
    cb({})
end)
RegisterNUICallback('joinCall', function(data, cb)
    TriggerServerEvent(Script .. ':joinCall', data)
    cb({})
end)

RegisterCommand('testXplayer', function()
    TriggerServerEvent(Script .. ':createCall', { Number = "0731109898" })
end)
