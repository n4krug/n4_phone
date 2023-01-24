LinkedInPosts = LinkedIn.SaveBetweenSessions and json.decode(LoadResourceFile(GetCurrentResourceName(), "apps/[linkedin]/LinkedInPosts.json") or "{}") or {}
-- print(dump(LinkedInPosts))

ESX.RegisterServerCallback('varp_phone:linkedin:addPost', function (source, cb, data)
    local xPlayer = FWFuncs.SV.PlayerFromId(source)

    local post = {
        id = data.id,
        text = data.text,
        number = Phone.Phones[FWFuncs.SV.GetIdentifier(source)].Personal.Phonenumber,
        name = xPlayer.name,
        personalnumber = FWFuncs.SV.GetIdentifier(source),
    }

    table.insert(LinkedInPosts, post)
    print(dump(LinkedInPosts))

    cb(post)

    if LinkedIn.SaveBetweenSessions then
        SaveResourceFile(GetCurrentResourceName(), "apps/[linkedin]/LinkedInPosts.json", json.encode(LinkedInPosts), -1)
    end
end)

RegisterServerEvent('varp_phone:linkedin:removePost')
AddEventHandler('varp_phone:linkedin:removePost', function (data)
    print(data.id)
    for i = 1, #LinkedInPosts do
        print(LinkedInPosts[i].id)
        if LinkedInPosts[i].id == data.id then
            table.remove(LinkedInPosts, i)
            break
        end
    end

    if LinkedIn.SaveBetweenSessions then
        SaveResourceFile(GetCurrentResourceName(), "apps/[linkedin]/LinkedInPosts.json", json.encode(LinkedInPosts), -1)
    end
end)

-- RegisterServerEvent('varp_phone:linkedin:getPosts')
-- AddEventHandler('varp_phone:linkedin:getPosts', function (cb)
--     -- print(dump(source))
--     print(dump(cb))
--     cb(Posts)
-- end)

ESX.RegisterServerCallback('varp_phone:linkedin:getPosts', function (source, cb)
    -- print(dump(source))
    -- print(dump(cb))
    print(dump(LinkedInPosts))
    cb(LinkedInPosts)
end)

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
-- Phone.Phones[xPlayer.character.personalnumber].Personal.Phonenumber