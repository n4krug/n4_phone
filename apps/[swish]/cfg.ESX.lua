Swish = {}
print(Framework)
Swish.Funcs = {
    SV = {
        RemoveBankMoney = function(identifier, amount)
            local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
            xPlayer.removeAccountMoney('bank', amount)
        end,
        AddBankMoney = function(identifier, amount)
            local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
            xPlayer.addAccountMoney('bank', amount)
        end,
        GetBankMoney = function(identifier)
            local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
            return xPlayer.getAccount('bank').money
        end
    }
}