FWFuncs = {
    SV = { -- Server Functions
        SendNotification = function (target, message, type, time, icon, color) -- Send a notification to a player
            return nil
        end,

        GetIdentifier = function(source) -- Get the unique identifier of a player
            return nil
        end,

        IDFromIdentifier = function (identifier) -- Get the ID of a player from their identifier
            return nil
        end,

        PlayerFromIdentifier = function(identifier) -- Get the player object from their identifier
            return nil
        end,

        PlayerFromId = function(source) -- Get the player object from their ID
            return nil
        end,

        GetPlayers = function() -- Get all players
            return nil
        end,

        GetName = function(source) -- expects result in format {first = "Firstname", last = "Lastname"}
            return nil
        end,
    },

    CL = { -- Client Functions
        GetIdentifier = function() -- Get the identifier of the player
            return nil
        end,

        HasItem = function(item) -- Check if the player has an item
            return nil
        end,

        HasJob = function(job) -- Check if the player has a job
            return nil
        end,

        GetJob = function() -- Get the job of the player
            return nil
        end
    }
}

-- For example usage see other FWFuncs.XX.lua