Script = GetCurrentResourceName()
RegisterServerEvent(Script .. ':settings:settingChanged', function (data)
    local category = SettingsCFG.Categories[data['category'] + 1]
    local setting = category.Settings[data['setting'] + 1]
    setting.svFunc(source, data.value)
end)