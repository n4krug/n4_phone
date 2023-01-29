ChirpPosts = Chirp.SaveBetweenSessions and json.decode(LoadResourceFile(GetCurrentResourceName(), "apps/[chirp]/ChirpPosts.json") or "{}") or {}

RegisterServerCallback('varp_phone:chirp:addPost', function (source, cb, data)

    local post = {
        id = data.id,
        text = data.text,
        name = FWFuncs.SV.GetName(source).first .. ' ' .. FWFuncs.SV.GetName(source).last,
        username = string.lower(string.sub(FWFuncs.SV.GetName(source).first, 1, 2)) .. '.' .. string.lower(string.sub(FWFuncs.SV.GetName(source).last, 1, 5)),
        personalnumber = FWFuncs.SV.GetIdentifier(source),
        likedBy = {},
        reposting = data.reposting,
        comments = {},
    }

    table.insert(ChirpPosts, post)

    local cbPost = deepcopy(post)

    cbPost = PropagateFields(cbPost, FWFuncs.SV.GetIdentifier(source))

    cb(cbPost)

    if Chirp.SaveBetweenSessions then
        SaveResourceFile(GetCurrentResourceName(), "apps/[chirp]/ChirpPosts.json", json.encode(ChirpPosts), -1)
    end
end)

RegisterServerEvent('varp_phone:chirp:removePost')
AddEventHandler('varp_phone:chirp:removePost', function (data)
    for i = 1, #ChirpPosts do
        if ChirpPosts[i].id == data.id then
            table.remove(ChirpPosts, i)
            break
        end
    end

    if Chirp.SaveBetweenSessions then
        SaveResourceFile(GetCurrentResourceName(), "apps/[chirp]/ChirpPosts.json", json.encode(ChirpPosts), -1)
    end
end)

RegisterServerCallback('varp_phone:chirp:getPosts', function (source, cb)
    print(source, cb)
    local posts = {}
    for i = 1, #ChirpPosts do
        local post = deepcopy(ChirpPosts[i])

        post = PropagateFields(post, FWFuncs.SV.GetIdentifier(source))

        table.insert(posts, post)
    end
    cb(posts)
end)

RegisterServerCallback('varp_phone:chirp:likePost', function (source, cb, data)
    for i = 1, #ChirpPosts do
        if ChirpPosts[i].id == data.id then
            if ChirpPosts[i].likedBy[FWFuncs.SV.GetIdentifier(source)] then
                ChirpPosts[i].likedBy[FWFuncs.SV.GetIdentifier(source)] = nil
            else
                ChirpPosts[i].likedBy[FWFuncs.SV.GetIdentifier(source)] = true
            end
            local post = deepcopy(ChirpPosts[i])

            post = PropagateFields(post, FWFuncs.SV.GetIdentifier(source))

            cb(post)
            break
        end
    end

    if Chirp.SaveBetweenSessions then
        SaveResourceFile(GetCurrentResourceName(), "apps/[chirp]/ChirpPosts.json", json.encode(ChirpPosts), -1)
    end
end)

function PropagateFields(post, personalnumber)
    if post.likedBy[personalnumber] then
        post.liked = true
    else
        post.liked = false
    end

    if post.reposting then
        local repostId = post.reposting
        for i = 1, #ChirpPosts do
            if ChirpPosts[i].id == repostId then
                post.reposting = ChirpPosts[i]
                break
            end
        end
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

function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end