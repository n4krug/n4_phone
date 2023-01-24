Script = GetCurrentResourceName()

local cam
local camOpen
local zoomvalue
RegisterNUICallback('camApp', function (data, cb)

    if data.open then
        local lPed = PlayerPedId()
        zoomvalue = 90.0
        cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
        AttachCamToEntity(cam, lPed, 0.0, 0.7, 0.7, true)
        SetCamRot(cam, 0.0,0.0,GetEntityHeading(lPed))
        SetCamFov(cam, zoomvalue)
        RenderScriptCams(true, false, 0, 1, 0)
        SetCamActive(cam, true)
        camOpen = true
    elseif cam then
        SetCamActive(cam, false)
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
        cam = nil
        camOpen = false
    end
    Phone.PlayAnim(data.open and 'photo' or 'text')
    cb()
end)

local speed_ud = 0.2
local speed_lr = 0.2
local zoomspeed = 10.0

Citizen.CreateThread(function()
    while true do
        local time = 100
        
        if camOpen then
            time = 1
            local rightAxisX = GetControlNormal(0, 1)
            local rightAxisY = GetControlNormal(0, 2)
            local rotation = GetCamRot(cam, 2)
            if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
                local new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
                local new_x = math.max(math.min(50.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
                SetCamRot(cam, new_x, 0.0, new_z, 2)
                SetEntityHeading(PlayerPedId(),new_z)
            end

            if IsControlJustPressed(0, 15) then
                zoomvalue = math.max(zoomvalue - zoomspeed, 20.0)
                SetCamFov(cam, zoomvalue)
            elseif IsControlJustPressed(0, 14) then
                zoomvalue = math.min(zoomvalue + zoomspeed, 110.0)
                SetCamFov(cam, zoomvalue)
            end
        end

        Citizen.Wait(time)
    end
end)

RegisterNUICallback('selfieCam', function (data, cb)
    CellFrontCamActivate(data.selfie)
    cb()
end)

function CellFrontCamActivate(activate)
    CellCamDisableThisFrame(activate)
    CellCamActivate(activate, activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

RegisterNUICallback('camCapture', function (data, cb)

    exports['screenshot-basic']:requestScreenshot(function(imgData)
        SendNUIMessage({
            type = 'photoTaken',
            imgData = imgData,
            rect = data
        })
    end)
end)

RegisterNUICallback('imgCropped', function (data, cb)
    ESX.TriggerServerCallback(Script .. ':GetPhone', function(phoneData)
        if not phoneData.Photos then phoneData.Photos = {} end
        table.insert(phoneData.Photos, {
            Url = data.imgUrl,
            Timestamp = data.timestamp,
        })

        TriggerServerEvent(Script .. ':EventHandler', 'SavePhone',
            { Personalnumber = FWFuncs.CL.GetIdentifier(), Data = phoneData })

        cb({
            photos = phoneData.Photos
        })
    end, FWFuncs.CL.GetIdentifier())
end)