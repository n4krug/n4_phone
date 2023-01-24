RegisterNUICallback('addTwitterPost', function (data, cb)
    ESX.TriggerServerCallback('varp_phone:twitter:addPost', function(svData)
        cb(svData)
    end, data)
end)

RegisterNUICallback('deleteTwitterPost', function (data, cb)
    TriggerServerEvent('varp_phone:twitter:removePost', data)
    cb({})
end)

RegisterNUICallback('getTwitterPosts', function (data, cb)
    ESX.TriggerServerCallback('varp_phone:twitter:getPosts', function (posts)
        cb(posts)
    end)
end)

RegisterNUICallback('likeTwitterPost', function (data, cb)
    ESX.TriggerServerCallback('varp_phone:twitter:likePost', function(svData)
        cb(svData)
    end, data)
end)