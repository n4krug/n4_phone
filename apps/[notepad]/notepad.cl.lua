Script = GetCurrentResourceName()

RegisterNUICallback('getNotes', function (data, cb)
    ESX.TriggerServerCallback(Script .. ':getNotes', function (notes)
        cb(notes)
    end)
end)

RegisterNUICallback('saveNotes', function (data, cb)
    ESX.TriggerServerCallback(Script .. ':saveNotes', function (notes)
        cb(notes)
    end, data)
end)