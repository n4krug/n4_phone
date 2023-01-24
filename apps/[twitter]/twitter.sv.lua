TwitterPosts = Twitter.SaveBetweenSessions and json.decode(LoadResourceFile(GetCurrentResourceName(), "apps/[twitter]/TwitterPosts.json") or "{}") or {}
-- print(dump(TwitterPosts))

ESX.RegisterServerCallback('varp_phone:twitter:addPost', function (source, cb, data)
    local xPlayer = FWFuncs.SV.PlayerFromId(source)

    local post = {
        id = data.id,
        text = data.text,
        name = xPlayer.name,
        username = string.lower(string.sub(split(xPlayer.name, " ")[1], 1, 2)) .. '.' .. string.lower(string.sub(split(xPlayer.name, " ")[2], 1, 5)),
        personalnumber = FWFuncs.SV.GetIdentifier(source),
        likedBy = {},
    }

    table.insert(TwitterPosts, post)

    local cbPost = deepcopy(post)

    cbPost = PropagateFields(cbPost, FWFuncs.SV.GetIdentifier(source))

    cb(cbPost)

    if Twitter.SaveBetweenSessions then
        SaveResourceFile(GetCurrentResourceName(), "apps/[twitter]/TwitterPosts.json", json.encode(TwitterPosts), -1)
    end
end)

RegisterServerEvent('varp_phone:twitter:removePost')
AddEventHandler('varp_phone:twitter:removePost', function (data)
    for i = 1, #TwitterPosts do
        if TwitterPosts[i].id == data.id then
            table.remove(TwitterPosts, i)
            break
        end
    end

    if Twitter.SaveBetweenSessions then
        SaveResourceFile(GetCurrentResourceName(), "apps/[twitter]/TwitterPosts.json", json.encode(TwitterPosts), -1)
    end
end)

ESX.RegisterServerCallback('varp_phone:twitter:getPosts', function (source, cb)
    local posts = {}
    for i = 1, #TwitterPosts do
        local post = deepcopy(TwitterPosts[i])

        post = PropagateFields(post, FWFuncs.SV.GetIdentifier(source))

        table.insert(posts, post)
    end
    cb(posts)
end)

ESX.RegisterServerCallback('varp_phone:twitter:likePost', function (source, cb, data)

    for i = 1, #TwitterPosts do
        if TwitterPosts[i].id == data.id then
            if TwitterPosts[i].likedBy[FWFuncs.SV.GetIdentifier(source)] then
                TwitterPosts[i].likedBy[FWFuncs.SV.GetIdentifier(source)] = nil
            else
                TwitterPosts[i].likedBy[FWFuncs.SV.GetIdentifier(source)] = true
            end
            local post = deepcopy(TwitterPosts[i])

            post = PropagateFields(post, FWFuncs.SV.GetIdentifier(source))

            cb(post)
            break
        end
    end

    if Twitter.SaveBetweenSessions then
        SaveResourceFile(GetCurrentResourceName(), "apps/[twitter]/TwitterPosts.json", json.encode(TwitterPosts), -1)
    end
end)

function PropagateFields(post, personalnumber)
    if post.likedBy[personalnumber] then
        post.liked = true
    else
        post.liked = false
    end

    -- count likes
    post.likes = 0
    for k, v in pairs(post.likedBy) do
        post.likes = post.likes + 1
    end

    return post
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

function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function split (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end