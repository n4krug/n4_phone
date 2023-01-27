FWFuncs = {
    SV = { -- Server Functions
        SendNotification = function (target, message, type, time, icon, color) -- Send a notification to a player
            TriggerClientEvent('esx:showNotification', target, message, {
                icon = icon,
                color = color
            })
        end,

        GetIdentifier = function(source) -- Get the identifier of a player
            local xPlayer = ESX.GetPlayerFromId(source)
            return xPlayer.identifier
        end,

        IDFromIdentifier = function (identifier) -- Get the ID of a player from their identifier
            local xPlayers = ESX.GetExtendedPlayers()
            for k, v in pairs(xPlayers) do
                if v.identifier == identifier then
                    return k
                end
            end
            return false
        end,

        PlayerFromIdentifier = function(identifier)
            return ESX.GetPlayerFromIdentifier(identifier)
        end,
        PlayerFromId = function(source)
            return ESX.GetPlayerFromId(source)
        end
    },

    CL = { -- Client Functions
        GetIdentifier = function() -- Get the identifier of the player
            return ESX.PlayerData.identifier
        end,

        HasItem = function(item) -- Check if the player has an item
            local xPlayer = ESX.PlayerData
            for k, v in pairs(xPlayer.inventory) do
                if v.name == item then
                    return v.count > 0
                end
            end
            return false
        end,
    }
}