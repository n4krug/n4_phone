SettingsCFG = {}

SettingsCFG.Categories = {
    -- Example Category:
    [1] = {
        title = 'Blips', -- title of the category
        Settings = {
            [1] = {
                title = 'Example Blip', -- title of the setting
                type = 'toggle', -- only toggle is supported atm
                default = false, -- default value of the setting
                cliFunc = function (state) -- client function that gets called when the setting is changed
                    print(state)
                    if state then
                        print('Add blips')
                    else
                        print('Remove blips')
                    end
                end,
                svFunc = function (source, state) -- server function that gets called when the setting is changed
                    print(source)
                    print(state)
                end,
            }
        }
    }
}