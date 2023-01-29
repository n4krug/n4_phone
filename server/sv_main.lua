Phone = {};

Script = GetCurrentResourceName()

RegisterServerCallback(Script .. ':GetPhone', function(Source, Callback, Personalnumber)
	while not Phone.Phones do
		Phone.Phones = json.decode(LoadResourceFile(Script, 'Phones.json') or "{}");

		Citizen.Wait(100)
	end

	if not Phone.Phones[Personalnumber] then
		local Contacts = {};

		local Settings = {
			darkmode = 0,
			bg_image = "https://cdn.wallpapersafari.com/85/60/2gq78p.png",
			do_not_disturb = 0,
			ringtone = 'opening',
			blips = {
				store = true,
				gas = true,
				cloth = true,
				hair = true,
				atm = true,
				bank = true,
				garage = true,
				tattoo = true,
			}
		}

		if Config.JobNumbers then
			for Number, Data in pairs(Config.JobNumbers) do
				table.insert(Contacts, {
					Name = Data.Name,
					Number = Number
				})
			end
		end

		Phone.Phones[Personalnumber] = {
			Personal = {
				Phonenumber = Phone.GenerateNumber(),
				Settings = Settings,
			},
			Contacts = Contacts,
			Photos = {}
		}
	end

	while not Phone.GlobalData do
		Phone.GlobalData = json.decode(LoadResourceFile(Script, 'GlobalData.json') or "{}");

		Citizen.Wait(100)
	end
	SaveResourceFile(Script, 'Phones.json', json.encode(Phone.Phones), -1)

	Callback(Phone.Phones[Personalnumber], Phone.GlobalData, Phone.Calls or {})
end)

RegisterServerEvent(Script .. ':EventHandler')
AddEventHandler(Script .. ':EventHandler', function(Event, Data)
	if (Event == 'SavePhone') then
		Phone.Phones[Data.Personalnumber] = Data.Data;

		SaveResourceFile(Script, 'Phones.json', json.encode(Phone.Phones), -1)
	end

	TriggerClientEvent(Script .. ':EventHandler', -1, Event, Data);
end)

RegisterServerCallback(Script .. ':getPlayerFromPhone', function (source, Phonenumber, cb)
	for personalnumber, data in pairs(Phone.Phones) do
		if data.Personal.Phonenumber == Phonenumber then
			local xPlayer = FWFuncs.SV.PlayerFromIdentifier(personalnumber)

			if xPlayer then
				xPlayer.personalnumber = personalnumber
				cb(xPlayer)
			end
		end
	end
end)
