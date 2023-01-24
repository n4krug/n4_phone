Script = GetCurrentResourceName()

RegisterNetEvent(Script .. ':show_message')
AddEventHandler(Script .. ':show_message', function(messageData)
    if Phone.PhoneData.Personal.Settings.do_not_disturb == 1 then return end
    PlaySoundFrontend(-1, 'Boss_Message_Orange', 'GTAO_Boss_Goons_FM_Soundset')

    SendNUIMessage({
        type = 'notification',
        app = messageData.app,
        title = messageData.title,
        message = messageData.message,
        id = messageData.id,
        onClick = messageData.onClick
    })
end)
