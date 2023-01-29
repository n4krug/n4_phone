Phone = {};
Alarms = {}
Script = GetCurrentResourceName()

Citizen.CreateThread(function()
	Citizen.Wait(1000)

	TriggerServerCallback(Script .. ':GetPhone', function(Response, GlobalData, Calls)
		Phone.PhoneData = Response;
		Phone.GlobalData = GlobalData;
		Phone.Calls = Calls
	end, FWFuncs.CL.GetIdentifier())
end)

RegisterNetEvent('closeallui')
AddEventHandler('closeallui', function()
	SendNUIMessage({
		Event = 'ClosePhone'
	})
end)

RegisterCommand('telefonnummer', function(source)
	if (Phone.PhoneData and Phone.PhoneData['Personal']) then
		TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.6vw; margin: 0.3vw; background-color: rgba(177, 97, 22, 0.8); border-radius: 8px; font-size: 15px"><span style="font-weight: 700; padding-left: 2px">Ditt telefonnummer</span>: {0}</div>',
			args = { Phone.PhoneData['Personal'].Phonenumber }
		})
	end
end)

RegisterNetEvent(Script .. ':EventHandler')
AddEventHandler(Script .. ':EventHandler', function(Event, Data)
	-- if (Event == 'TransferMoney') then
	-- 	if (Data.Receiver == Phone.PhoneData['Personal'].Phonenumber) then
	-- 		if Phone.IsOpened then
	-- 			SendNUIMessage({
	-- 				App = 'Swedbank',
	-- 				Function = 'AddAmount',
	-- 				Data = Data.Amount
	-- 			})
	-- 		else
	-- 			Phone.EventHandler('Bank-AddAmount', Data.Amount)
	-- 		end

	-- 		ESX.ShowNotification(('Du mottog ~lg~%s SEK~w~ från %s.%s'):format(Data.Amount, Data.Sender,
	-- 			Data.Message and ('\n\nMeddelande: %s'):format(Data.Message) or ''), {
	-- 			icon = 'smartphone',
	-- 			color = '#0cc6bf'
	-- 		});
	-- 	end
	-- end

	if (Event == 'CreateCall') then
		if (Data.Number == Phone.PhoneData['Personal'].Phonenumber) then
			if (FWFuncs.CL.HasItem(Config.Item)) and not Phone.PhoneData['Settings']['do_not_disturb'] then
				Phone.Ringtone = exports['n4_utils']:PlaySound({
					Name = ('ringtone-%s'):format(GetPlayerServerId(PlayerId())),
					SoundFile = Phone.PhoneData['Settings']['ringtone'] and Config.Ringtones[Phone.PhoneData['Settings']['ringtone']] or
						'opening',
					Player = GetPlayerServerId(PlayerId()),
					MaxDistance = 12.5,
					MaxVolume = 0.15
				})

				if Data.HiddenNumber then
					Data.CallerLabel = 'Okänt nummer'
				end

				if Phone.IsOpened then
					SendNUIMessage({
						App = 'Incomingcall',
						Function = 'Open',
						Data = Data
					})
				else
					-- ESX.ShowNotification('Du har ett inkommande samtal.', {
					-- 	icon = 'smartphone',
					-- 	color = '#0cc6bf'
					-- });

					Phone.Incomingcall = Data
				end
			end
		elseif (Data.Caller == Phone.PhoneData['Personal'].Phonenumber) then
			Data.State = 'Calling';

			SendNUIMessage({
				App = 'Call',
				Function = 'Open',
				Data = Data
			})

			-- exports['pma-voice']:SetCallChannel(Data.Caller)

			Phone.CallSound = exports['n4_utils']:PlaySound({
				Name = 'calling',
				SoundFile = 'calling',
				Source = GetPlayerServerId(PlayerId()),
				Volume = 0.5
			})

			Phone.PlayAnim('call')
		end
	elseif (Event == 'EndCall') then
		if (Data.Number == Phone.PhoneData['Personal'].Phonenumber) then
			if Phone.Ringtone then
				Phone.Ringtone.StopSound()
				Phone.Ringtnoe = nil
			end

			if Phone.IsOpened then
				SendNUIMessage({
					App = 'Call',
					Function = 'EndCall',
					Data = Data
				})

				SendNUIMessage({
					App = 'Incomingcall',
					Function = 'EndCall',
					Data = Data
				})

				Phone.PlayAnim('text')
			end

			Phone.Incomingcall = nil

			exports['pma-voice']:SetCallChannel(0)
			--exports['tokovoip_script']:removePlayerFromRadio('Call-' .. Data.Caller)
		elseif (Data.Caller == Phone.PhoneData['Personal'].Phonenumber) then
			if Phone.CallSound then
				Phone.CallSound.StopSound()
				Phone.CallSound = nil
			end

			SendNUIMessage({
				App = 'Call',
				Function = 'EndCall',
				Data = Data
			})

			if Phone.IsOpened then
				Phone.PlayAnim('text')
			end

			exports['pma-voice']:SetCallChannel(0)
			--exports['tokovoip_script']:removePlayerFromRadio('Call-' .. Data.Caller)
		end
	elseif (Event == 'JoinCall') then
		if (Data.Number == Phone.PhoneData['Personal'].Phonenumber) then
			if Phone.Ringtone then
				Phone.Ringtone.StopSound()
				Phone.Ringtnoe = nil
			end

			SendNUIMessage({
				App = 'Call',
				Function = 'Open',
				Data = Data
			})

			Phone.Incomingcall = nil

			exports['pma-voice']:SetCallChannel(Data.Caller)
			--exports['tokovoip_script']:addPlayerToRadio('Call-' .. Data.Caller)

			Phone.PlayAnim('call')
		elseif (Data.Caller == Phone.PhoneData['Personal'].Phonenumber) then
			if Phone.CallSound then
				Phone.CallSound.StopSound()
				Phone.CallSound = nil
			end

			SendNUIMessage({
				App = 'Call',
				Function = 'SetState',
				Data = 'InCall'
			})

			if Phone.IsOpened then
				exports['pma-voice']:SetCallChannel(Data.Caller)
				--exports['tokovoip_script']:addPlayerToRadio('Call-' .. Data.Caller)
			end
		end
	end

end)

RegisterCommand('+openPhone', function ()

end)
RegisterCommand('-openPhone', function ()
	if not IsPlayerDead(PlayerId()) and not Phone.IsOpened and Phone.PhoneData then
		if FWFuncs.CL.HasItem(Config.Item) then
			N4_PHONE.SetDisplay(true)
			Phone.PlayAnim('text')
		end
	end
end)

RegisterKeyMapping('+openPhone', 'Öppna Telefon', 'Keyboard', Config.DefaultButton)

Citizen.CreateThread(function()
	while true do
		local sleepThread, Player = 0, PlayerPedId();

		if Phone.IsOpened and not Phone.Camera then
			if not IsEntityPlayingAnim(Player, Phone.LastDict, Phone.LastAnim, 3) and Phone.LastDict then
				TaskPlayAnim(Player, Phone.LastDict, Phone.LastAnim, 3.0, -1, -1, 50, 0, false, false, false);
			end
		end

		if Phone.IsOpened then
			if Phone.UsingMouse then
				DisableControlAction(0, 1, true) -- Disable looking horizontally
				DisableControlAction(0, 2, true) -- Disable looking vertically
				DisableControlAction(0, 106, true) -- Disable in-game mouse controls
				DisableControlAction(0, 81, true) -- Disabling next radio with scrollwheel
				DisableControlAction(0, 82, true) -- Disabling previous radio with scrollwheel
			end

			DisablePlayerFiring(Player, true) -- Disable weapon firing
			DisableControlAction(0, 142, true) -- Disable aiming
			DisableControlAction(0, 37, true)
			DisableControlAction(0, 38, true)
			DisableControlAction(0, 288, true)
			DisableControlAction(0, 200, true) --pause
			DisableControlAction(0, 245, true) -- chat
			DisableControlAction(0, 36, true) -- crouch
			DisableControlAction(0, 48, true) -- prone
		end

		Citizen.Wait(sleepThread)
	end
end)

-- Quicksettings

RegisterNUICallback('quicksettingToggled', function (data, cb)
	if data.type == 'flash' then
		print(data.state)
		Flash = data.state
		Phone.PlayAnim(data.state and 'photo' or 'text')
	end
    cb({})
end)

Citizen.CreateThread(function()
	while true do
		local sleepThread = 100

		if Flash then
			sleepThread = 0
			DrawFlashlight()
		end

		Citizen.Wait(sleepThread)
	end
end)

function DrawFlashlight()
	local sourcePed = GetPlayerPed(-1);
	local heading = GetEntityHeading(sourcePed) + 90.0;
	local Pos = GetEntityCoords(sourcePed) -- GetPedBoneCoords(sourcePed, 6286, 0, 0, 0);
	local Dir = vector3(math.cos(math.rad(heading)), math.sin(math.rad(heading)), -0.1) -- GetPedBoneCoords(sourcePed, 6286, 0.5, 0, 0);
	DrawSpotLight(Pos.x, Pos.y, Pos.z, Dir.x, Dir.y, Dir.z, 255, 255, 255, 100.0, 1.0, 0.0, 33.0, 15.0 )
end