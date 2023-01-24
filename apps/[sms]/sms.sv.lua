Script = GetCurrentResourceName()

ESX.RegisterServerCallback('n4_sms:create_conversation', function(source, cb, data)
    cb(CreateConversation(source, data))
end)

function CreateConversation(source, data)
    if not Phone.GlobalData then return nil end
    if not Phone.GlobalData['Conversations'] then Phone.GlobalData['Conversations'] = {} end

    local conversationId = data.ConversationId

    local conversation = FindConvo(data.Numbers)
    if not conversation then
        table.insert(Phone.GlobalData['Conversations'], data);
    else
        for i = 1, #Phone.GlobalData['Conversations'] do
            if Phone.GlobalData['Conversations'][i].ConversationId == conversation.ConversationId then
                conversationId = conversation.ConversationId
                local MessageData = {
                    ConversationId = conversation.ConversationId,
                    message = data.Messages[1] or {}
                }
                SMS.SendText(source, MessageData)
            end
        end
    end

    SaveResourceFile(Script, 'GlobalData.json', json.encode(Phone.GlobalData), -1)
    return conversationId
end

ESX.RegisterServerCallback('n4_sms:get_conversations', function(source, cb)
    if not Phone.GlobalData['Conversations'] then Phone.GlobalData['Conversations'] = {} end

    local conversations = {}

    for i = 1, #Phone.GlobalData['Conversations'] do
        local numbers = Set(Phone.GlobalData['Conversations'][i].Numbers)
        if numbers[Phone.Phones[FWFuncs.SV.GetIdentifier(source)].Personal.Phonenumber] then
            table.insert(conversations, Phone.GlobalData['Conversations'][i])
        end
    end

    cb(conversations)
end)

function Set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

ESX.RegisterServerCallback('n4_sms:find_convo', function(cb, numbers)
    cb(FindConvo(numbers))
end)

function FindConvo(numbers)
    if not Phone.GlobalData['Conversations'] then Phone.GlobalData['Conversations'] = {} end

    local conversation = false

    for i = 1, #Phone.GlobalData['Conversations'] do
        local convoNumbers = Set(Phone.GlobalData['Conversations'][i].Numbers)
        local matchingNumbers = 0
        for j = 1, #numbers do
            if (convoNumbers[numbers[j]]) then
                matchingNumbers = matchingNumbers + 1
            end
        end
        if matchingNumbers == #numbers then
            conversation = Phone.GlobalData['Conversations'][i]
            break
        end
    end
    return conversation
end

SMS = {}

SMS.SendText = function(source, data)
    if not Phone.GlobalData['Conversations'] then Phone.GlobalData['Conversations'] = {} end

    local cbData

    for i = 1, #Phone.GlobalData['Conversations'] do
        if (Phone.GlobalData['Conversations'][i].ConversationId == data.ConversationId) then
            table.insert(Phone.GlobalData['Conversations'][i].Messages, data.message)
            cbData = Phone.GlobalData['Conversations'][i]
            break
        end
    end

    SaveResourceFile(Script, 'GlobalData.json', json.encode(Phone.GlobalData), -1)

    ESX.TriggerServerCallback(Script .. ':getPlayerFromPhone', source, data.message.From, function(fromPlayer)
        for i = 1, #cbData.Numbers do
            if cbData.Numbers[i] ~= data.message.From then
                ESX.TriggerServerCallback(Script .. ':getPlayerFromPhone', source, cbData.Numbers[i],
                    function(player)
                        local name = data.message.From
                        if fromPlayer and fromPlayer.name then
                            name = fromPlayer.name
                        end
                        TriggerEvent(Script .. ':send_notification', player.personalnumber, {
                            app = 'sms',
                            title = 'SMS - ' .. name,
                            message = data.message.Text,
                            id = GetGameTimer(),
                            onClick = "openConversation:" .. data.ConversationId
                        })
                    end)
            end
        end
    end)


    return cbData.Messages
end

ESX.RegisterServerCallback('n4_sms:send_text', function(source, cb, data)
    cb(SMS.SendText(source, data))
end)

ESX.RegisterServerCallback('n4_sms:markRead', function(source, cb, data)
    if not Phone.GlobalData['Conversations'] then Phone.GlobalData['Conversations'] = {} end

    for i = 1, #Phone.GlobalData['Conversations'] do
        if Phone.GlobalData['Conversations'][i].ConversationId == data.ConversationId then
            for j = 1, #Phone.GlobalData['Conversations'][i].Messages do
                if not
                    Set(Phone.GlobalData['Conversations'][i].Messages[j].ReadBy)[
                    Phone.Phones[FWFuncs.SV.GetIdentifier(source)].Personal.Phonenumber] then
                    table.insert(Phone.GlobalData['Conversations'][i].Messages[j].ReadBy,
                        Phone.Phones[FWFuncs.SV.GetIdentifier(source)].Personal.Phonenumber)
                        
                end
            end
            break
        end
    end

    SaveResourceFile(Script, 'GlobalData.json', json.encode(Phone.GlobalData), -1)

    cb()
end)

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end
