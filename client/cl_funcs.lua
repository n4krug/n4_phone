Script = GetCurrentResourceName()

if not Phone then Phone = {} end

Phone.PlayAnim = function(State)
    if not Phone.CurrentState then Phone.CurrentState = 'out' end

    local Player = PlayerPedId();

    local PhoneModel = 'prop_phone_ing';
    local Dict = IsPedInAnyVehicle(Player, false) and 'anim@cellphone@in_car@ps' or 'cellphone@';
    local Name = Config.Animations[Dict][Phone.CurrentState or 'out'][State];
    local Flag = 50;

    if Phone.CurrentState ~= 'out' then
        StopAnimTask(Player, Phone.LastDict, Phone.LastAnim, 1.0);
        Phone.LastDict, Phone.LastAnim = nil, nil
    end

    Utils.LoadAnimDict(Dict);

    TaskPlayAnim(Player, Dict, Name, 3.0, -1, -1, Flag, 0, false, false, false);

    if State ~= 'out' and Phone.CurrentState == 'out' then
        Citizen.Wait(400);

        Utils.LoadModel(PhoneModel);

        Phone.PhoneProp = CreateObject(GetHashKey(PhoneModel), 1.0, 1.0, 1.0, 1, 1, 0);

        AttachEntityToEntity(Phone.PhoneProp, Player, GetPedBoneIndex(Player, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1
            , 0, 0, 2, 1)
    end

    Phone.LastDict, Phone.LastAnim = Dict, Name;
    Phone.CurrentState = State;

    if State == 'out' then
        StopAnimTask(Player, Phone.LastDict, Phone.LastAnim, 1.0);

        Citizen.Wait(500);

        Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(Phone.PhoneProp));

        Citizen.Wait(600);

        ClearPedTasks(Player);

        Phone.LastDict, Phone.LastAnim = nil, nil
    end
end


Phone.PlayRingtone = function(Ringtone)
    if Phone.RingtoneTest then
        Phone.StopRingtone()
    end

    Phone.RingtoneTest = exports['n4_sounds']:PlaySound({
        Name = ('ringtonetest-%s'):format(GetPlayerServerId(PlayerId())),
        SoundFile = Ringtone,
        Player = GetPlayerServerId(PlayerId()),
        MaxDistance = 12.5,
        MaxVolume = 0.15
    })
end

Phone.StopRingtone = function()
    if not Phone.RingtoneTest then return end

    Phone.RingtoneTest.StopSound();
    Phone.RingtoneTest = nil
end


RegisterCommand('stopsound', function()
    Phone.StopRingtone()
end)

Phone.EventHandler = function(Event, Data)
    TriggerServerEvent(Script .. ':EventHandler', Event, Data)
end

-- exports('InDuty', Phone.InDuty)
