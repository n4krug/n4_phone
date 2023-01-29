Script = GetCurrentResourceName()
PhoneData = nil


-- * Main Script * --
local display = false

RegisterNUICallback("exit", function(data, cb)
    N4_PHONE.SetDisplay(false)
    Phone.PlayAnim('out')
    cb({})
end)

RegisterNUICallback("saveSettings", function(data, cb)
    -- TriggerServerEvent(Script .. ':savePhoneSettings', data)
    Phone.PhoneData.Personal.Settings = data
    -- Phone.EventHandler('SavePhone', Phone)
    -- TriggerEvent("SetBlipsVisible", data.blips)
    Phone.EventHandler('SavePhone', {
        Personalnumber = FWFuncs.CL.GetIdentifier(),
        Data = Phone.PhoneData
    })
    cb({})
end)

Citizen.CreateThread(function()
    while not (Phone and Phone.PhoneData and Phone.PhoneData.Personal and Phone.PhoneData.Personal.Settings and Phone.PhoneData.Personal.Settings.blips) do
        Citizen.Wait(100)
    end
    TriggerEvent("SetBlipsVisible", Phone.PhoneData.Personal.Settings.blips)
end)

local function deepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            v = deepCopy(v)
        end
        copy[k] = v
    end
    return copy
end

N4_PHONE = {}

N4_PHONE.SetDisplay = function(bool)

    Phone.IsOpened = bool
    display = bool

    TriggerServerCallback(Script .. ':GetPhone', function(phoneData, globalData)
        PhoneData = phoneData

        local apps = {}

        for _, app in ipairs(Config.Apps) do
            if app.job ~= nil then
                if FWFuncs.CL.HasJob(app.job) then
                    apps[#apps + 1] = app
                end
            else
                apps[#apps + 1] = app
            end
        end

        SetNuiFocus(bool, bool)
        SetNuiFocusKeepInput(bool)
        SendNUIMessage({
            script = GetCurrentResourceName(),
            type = "ui",
            status = bool,
            apps = apps,
            quickAcces = Config.QuickAcces,
            settings = phoneData.Personal.Settings,
            contacts = phoneData.Contacts,
            photos = phoneData.Photos,
            userNumber = phoneData.Personal.Phonenumber,
            personalnumber = FWFuncs.CL.GetIdentifier(),
            sms = globalData['Conversations'] or {},
            job = FWFuncs.CL.GetJob(),
        })
    end, FWFuncs.CL.GetIdentifier())
    
end

MouseControl = false
Citizen.CreateThread(function()
    while true do
        if display and not MouseControl then
            DisableControlAction(2, 1, true)
            DisableControlAction(2, 2, true)
            DisableControlAction(2, 3, true)
            DisableControlAction(2, 4, true)
            DisableControlAction(2, 5, true)
            DisableControlAction(2, 6, true)
        end
        Citizen.Wait(1)
    end
end)

RegisterNUICallback('mouseMove', function(data, cb)
    MouseControl = data.state

    cb({})
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if display then

            local year, month, day, hour, minute, second = GetLocalTime()


            SendNUIMessage({
                type = "time",
                time = {
                    hour = hour,
                    minute = minute,
                    second = second,
                }
            })
        end
    end
end)

RegisterNetEvent(Script .. ':BankID')
AddEventHandler(Script .. ':BankID', function(loginName)
    if not IsPlayerDead(PlayerId()) and not Phone.IsOpened and Phone.PhoneData then
		if (FWFuncs.CL.HasItem(Config.Item)) then

            TriggerServerCallback(Script .. ':GetPhone', function(phoneData)
                PhoneData = phoneData

                local apps = deepCopy(Config.Apps)

                if Config.JobApps then
                    for k, v in ipairs(Config.JobApps) do
                        if FWFuncs.CL.HasJob(v.job) then
                            apps[#apps + 1] = v
                        end
                    end
                end

                N4_PHONE.SetDisplay(true)
                Phone.PlayAnim('text')
                SendNUIMessage({
                    type = "BankID",
                    status = true,
                    apps = apps,
                    quickAcces = Config.QuickAcces,
                    settings = phoneData.Personal.Settings,
                    login = loginName,
                    contacts = phoneData.Contacts,
                    userNumber = phoneData.Personal.Phonenumber,
                    personalnumber = FWFuncs.CL.GetIdentifier(),
                })
            end, FWFuncs.CL.GetIdentifier())
        end
    end
end)

RegisterNUICallback('setNuiFocus', function (data, cb)
    SetNuiFocusKeepInput(not data.focus)
    cb({})
end)

function GetBlipEnabled(blip)
    return
    Phone and
    Phone.PhoneData and
    Phone.PhoneData.Personal and
    Phone.PhoneData.Personal.Settings and
    Phone.PhoneData.Personal.Settings.blips and
    Phone.PhoneData.Personal.Settings.blips[blip]
end

exports('GetBlipEnabled', GetBlipEnabled)

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
