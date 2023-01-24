Phone.GenerateNumber = function()
    math.randomseed(os.time())

    local Number = '07' .. math.random(2, 6);

    for i = 1, 7 do
        Number = Number .. math.random(0, 9)
    end

    return Number
end

Phone.GenerateUUID = function()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'

    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end
