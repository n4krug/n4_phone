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

        PlayerFromIdentifier = function(identifier)
            return nil
        end,
        PlayerFromId = function(source)
            return nil
        end
    },

    CL = { -- Client Functions
        GetIdentifier = function() -- Get the identifier of the player
            return nil
        end,

        HasItem = function(item) -- Check if the player has an item
            return nil
        end,
    }
}

-- For example usage see other FWFuncs.XX.lua