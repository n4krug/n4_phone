Script = GetCurrentResourceName()

for i, category in pairs(SettingsCFG.Categories) do
    for j, setting in pairs(category.Settings) do
        SettingsCFG.Categories[i].Settings[j].state = setting.default
    end
end

RegisterNUICallback('getSettingCategories', function(data, cb)
    cb({categories = SettingsCFG.Categories})
end)

RegisterNUICallback('settingChanged', function (data, cb)
    local category = SettingsCFG.Categories[data['category'] + 1]
    local setting = category.Settings[data['setting'] + 1]
    setting.cliFunc(data.value)
    SettingsCFG.Categories[data['category'] + 1].Settings[data['setting'] + 1].state = data.value
    TriggerServerEvent(Script .. ':settings:settingChanged', data)
    cb({})
end)