Script = GetCurrentResourceName()

RegisterServerCallback(Script .. ':getNotes', function (source, cb)
    local allNotes = json.decode(LoadResourceFile(Script, 'apps/[notepad]/Notes.json') or '{}')
    -- print(dump(allNotes))

    local identifier = FWFuncs.SV.GetIdentifier(source)
    -- print(identifier)

    local notes = allNotes[identifier] or {}

    cb(notes)
end)

RegisterServerCallback(Script .. ':saveNotes', function (source, cb, data)
    -- print(dump(data))
    local allNotes = json.decode(LoadResourceFile(Script, 'Notes.json') or '{}')

    local identifier = FWFuncs.SV.GetIdentifier(source)

    allNotes[identifier] = data

    SaveResourceFile(Script, 'apps/[notepad]/Notes.json', json.encode(allNotes), -1)

    cb(data)
end)

function dump(o)
	if type(o) == 'table' then
	   local s = '{ '
	   for k,v in pairs(o) do
		  if type(k) ~= 'number' then k = '"'..k..'"' end
		  s = s .. '['..k..'] = ' .. dump(v) .. ','
	   end
	   return s .. '} '
	else
	   return tostring(o)
	end
end