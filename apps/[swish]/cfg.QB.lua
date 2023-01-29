Swish = {}
Swish.Funcs = {
    SV = {
        RemoveBankMoney = function(identifier, amount)
            QBCore.Functions.GetPlayerByCitizenId(identifier).Functions.RemoveMoney('bank', amount)
        end,
        AddBankMoney = function(identifier, amount)
            QBCore.Functions.GetPlayerByCitizenId(identifier).Functions.AddMoney('bank', amount)
        end,
        GetBankMoney = function(identifier)
            QBCore.Functions.GetPlayerByCitizenId(identifier).Functions.GetMoney('bank')
        end
    }
}