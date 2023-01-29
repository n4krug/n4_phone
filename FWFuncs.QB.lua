local QBCore = exports['qb-core']:GetCoreObject()

FWFuncs = {
    SV = { -- Server Functions
        SendNotification = function (target, message, type, time, icon, color) -- Send a notification to a player
            TriggerClientEvent('QBCore:Notify', target, message, type, time)
        end,

        GetIdentifier = function(source) -- Get the identifier of a player
            return QBCore.Functions.GetPlayer(source).PlayerData.citizenid
        end,

        IDFromIdentifier = function (identifier) -- Get the ID of a player from their identifier
            return QBCore.Functions.GetPlayerByCitizenId(identifier).source
        end,

        PlayerFromIdentifier = function(identifier)
            return QBCore.Functions.GetPlayerByCitizenId(identifier)
        end,

        PlayerFromId = function(source)
            return QBCore.Functions.GetPlayer(source)
        end,

        GetPlayers = function()
            return QBCore.Functions.GetPlayers()
        end,

        GetName = function(source) -- expects result in format {first = "Firstname", last = "Lastname"}
            return {first = QBCore.Functions.GetPlayer(source).PlayerData.charinfo.firstname, last = QBCore.Functions.GetPlayer(source).PlayerData.charinfo.lastname}
        end,
    },

    CL = { -- Client Functions
        GetIdentifier = function() -- Get the identifier of the player
            return QBCore.Functions.GetPlayerData().citizenid
        end,

        HasItem = function(item) -- Check if the player has an item
            return QBCore.Functions.HasItem(item)
        end,

        HasJob = function(job) -- Check if the player has a job
            return QBCore.Functions.GetPlayerData().job.name == job
        end,

        GetJob = function()
            return QBCore.Functions.GetPlayerData().job.name
        end
    }
}
