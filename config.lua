Config = {};

Config.DefaultButton = 'F1' -- Default button to open the phone rebinding is possible for the player in settings

Config.Item = 'phone' -- Item name that is required to open the phone

Config.DiscordWebhook = "https://discord.com/api/webhooks/..."

Config.Apps = { -- Add apps here (file = name of the folder, label = name of the app shown in the phone). Numbering sets the order on homescreen
	[1] = {
		['file'] = 'contacts',
		['label'] = 'Kontakter'
	},
	[2] = {
		['file'] = 'photos',
		['label'] = 'Bilder'
	},
	[3] = {
		['file'] = 'calculator',
		['label'] = 'Kalkylator'
	},
	[4] = {
		['file'] = 'notepad',
		['label'] = 'Notes'
	},
	[5] = {
		['file'] = 'linkedin',
		['label'] = 'LinkedIn'
	},
	[6] = {
		['file'] = 'twitter',
		['label'] = 'Twitter'
	},
	[7] = {
		['file'] = 'swish',
		['label'] = 'Swish'
	},
	[8] = {
		['file'] = 'swedbank',
		['label'] = 'Swedbank'
	},
	[9] = {
		['file'] = 'bankid',
		['label'] = 'BankID'
	},
}

Config.QuickAcces = { -- 4 apps to be shown in the quick acces bar on the homescreen, numbering sets order
	[1] = {
		['file'] = 'call',
		['label'] = 'Telefon'
	},
	[2] = {
		['file'] = 'sms',
		['label'] = 'Meddelande'
	},
	[3] = {
		['file'] = 'settings',
		['label'] = 'Inställningar'
	},
	[4] = {
		['file'] = 'camera',
		['label'] = 'Kamera'
	},
}

Config.Ringtones = {
	['Öppning'] = 'opening',
	['Japansk flöjt'] = 'japaneseflutebirds',
	['Thug life'] = 'thuglife',
	['Östermalm'] = 'ostermalm',
	['Nokia'] = 'nokia',
	['Nokia Arabic'] = 'nokiaarabic',
	['Du gamla du fria'] = 'dugamladufria'
}

Config.Animations = {
	['cellphone@'] = {
		['out'] = {
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_call_listen_base',
			['photo'] = 'cellphone_photo_idle',
		},
		['text'] = {
			['out'] = 'cellphone_text_out',
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_text_to_call',
			['photo'] = 'cellphone_photo_idle',
		},
		['call'] = {
			['out'] = 'cellphone_call_out',
			['text'] = 'cellphone_call_to_text',
			['photo'] = 'cellphone_photo_idle',
			['call'] = 'cellphone_text_to_call',
		},
		['photo'] = {
			['out'] = 'cellphone_photo_exit',
			['text'] = 'cellphone_text_in',
			['photo'] = 'cellphone_photo_idle',
			['call'] = 'cellphone_text_to_call',
		}
	},

	['anim@cellphone@in_car@ps'] = {
		['out'] = {
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_call_in',
		},
		['text'] = {
			['out'] = 'cellphone_text_out',
			['text'] = 'cellphone_text_in',
			['call'] = 'cellphone_text_to_call',
		},
		['call'] = {
			['out'] = 'cellphone_horizontal_exit',
			['text'] = 'cellphone_call_to_text',
			['call'] = 'cellphone_text_to_call',
		}
	}
}
