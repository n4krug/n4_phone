Script = GetCurrentResourceName()

RegisterNUICallback('getSMSConversations', function(data, cb)
    ESX.TriggerServerCallback('n4_sms:get_conversations', function(conversations)
        cb(conversations)
    end)
end)

RegisterNUICallback('getTexts', function(data, cb)
    ESX.TriggerServerCallback('n4_sms:get_texts', function(texts)
        cb(texts)
    end, data)
end)

RegisterNUICallback('createConvo', function(data, cb)
    ESX.TriggerServerCallback(Script .. ':GetPhone', function(phoneData, globalData)

        local conversationData = {
            ConversationId = Utils.GenerateUUID(),
            Numbers = { [1] = phoneData.Personal['Phonenumber'], [2] = data.targetNumber },
            Messages = { [1] = data.message } or {}
        }
        ESX.TriggerServerCallback('n4_sms:create_conversation', function(conversation)
            cb(conversation)
        end, conversationData)
    end, FWFuncs.CL.GetIdentifier())
end)

RegisterNUICallback('sendText', function(data, cb)

    ESX.TriggerServerCallback('n4_sms:send_text', function(cbData)
        cb(cbData)
    end, data)
end)

RegisterNUICallback('markRead', function(data, cb)

    ESX.TriggerServerCallback('n4_sms:markRead', function(cbData)
        cb(cbData)
    end, data)
end)

RegisterNUICallback('smsNumberToIdentifier', function(data, cb)
    ESX.TriggerServerCallback('n4_sms:number_to_identifier', function(identifier)
        cb(identifier)
    end, data)
end)

-- RegisterCommand('testSMS', function()
--     ESX.TriggerServerCallback('n4_sms:send_text', function()

--     end, {
--         targetNumber = '769111938',
--         message = 'testing'
--     })
-- end)
