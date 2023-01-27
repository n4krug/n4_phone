local QBCore = exports['qb-core']:GetCoreObject()

FWFuncs = {
    SV = { -- Server Functions
        SendNotification = function (target, message, type, time, icon, color) -- Send a notification to a player
            TriggerClientEvent('QBCore:Notify', target, message, type, time)
        end,

        GetIdentifier = function(source) -- Get the identifier of a player
            return QBCore.Functions.GetIdentifier(source)
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
            return QBCore.Functions.GetPlayerByCitizenId(identifier)
        end,
        PlayerFromId = function(source)
            return QBCore.Functions.GetPlayer(source)
        end
    },

    CL = { -- Client Functions
        GetIdentifier = function() -- Get the identifier of the player
            return QBCore.Functions.GetPlayerData().citizenid
        end,

        HasItem = function(item) -- Check if the player has an item
            QBCore.Functions.HasItem(item)
        end,
    }
}
