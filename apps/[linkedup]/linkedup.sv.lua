LinkedUpPosts = LinkedUp.SaveBetweenSessions and json.decode(LoadResourceFile(GetCurrentResourceName(), "apps/[linkedup]/LinkedUpPosts.json") or "{}") or {}
-- print(dump(LinkedUpPosts))

RegisterServerCallback('varp_phone:linkedup:addPost', function (source, cb, data)
    print(source)
    print(FWFuncs.SV.GetIdentifier(source))

    local xPlayer = FWFuncs.SV.PlayerFromId(source)

    local post = {
        id = data.id,
        text = data.text,
        number = Phone.Phones[FWFuncs.SV.GetIdentifier(source)].Personal.Phonenumber,
        name = FWFuncs.SV.GetName(source).first .. ' ' .. FWFuncs.SV.GetName(source).last,
        personalnumber = FWFuncs.SV.GetIdentifier(source),
    }

    table.insert(LinkedUpPosts, post)
    print(dump(LinkedUpPosts))

    cb(post)

    if LinkedUp.SaveBetweenSessions then
        SaveResourceFile(GetCurrentResourceName(), "apps/[linkedup]/LinkedUpPosts.json", json.encode(LinkedUpPosts), -1)
    end
end)

RegisterServerEvent('varp_phone:linkedup:removePost')
AddEventHandler('varp_phone:linkedup:removePost', function (data)
    print(data.id)
    for i = 1, #LinkedUpPosts do
        print(LinkedUpPosts[i].id)
        if LinkedUpPosts[i].id == data.id then
            table.remove(LinkedUpPosts, i)
            break
        end
    end

    if LinkedUp.SaveBetweenSessions then
        SaveResourceFile(GetCurrentResourceName(), "apps/[linkedup]/LinkedUpPosts.json", json.encode(LinkedUpPosts), -1)
    end
end)

-- RegisterServerEvent('varp_phone:linkedup:getPosts')
-- AddEventHandler('varp_phone:linkedup:getPosts', function (cb)
--     -- print(dump(source))
--     print(dump(cb))
--     cb(Posts)
-- end)

RegisterServerCallback('varp_phone:linkedup:getPosts', function (source, cb)
    -- print(dump(source))
    -- print(dump(cb))
    print(dump(LinkedUpPosts))
    cb(LinkedUpPosts)
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