
RegisterNUICallback('swishSend', function (data, cb)
    ESX.TriggerServerCallback('va_swish:swishSend', function (args)
        cb(args)
    end, data)
end)

-- * Dev functions * --

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