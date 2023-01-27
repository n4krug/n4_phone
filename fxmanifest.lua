game "gta5"

fx_version "cerulean"

author "n4kruG"

lua54 'yes'

Framework = 'QB' -- FWFuncs file to use, QB, ESX or Custom

escrow_ignore {
    'config.lua',
    'FWFuncs.Custom.lua',
    'FWFuncs.QB.lua',
    'FWFuncs.ESX.lua',
    'apps/**/cfg.lua'
}

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_script {
    'client/cl_main.lua',
    'client/cl_funcs.lua',
    'client/cl_events.lua',
    'client/cl_camera.lua',
    'client/cl_alarms.lua',
    'client/cl_utils.lua',
    'client/n4_client/cl_main.lua',
    'client/n4_client/cl_notifications.lua',
    'apps/**/*.cl.lua',
}

server_script {
    'server/sv_main.lua',
    'server/sv_funcs.lua',
    '@mysql-async/lib/MySQL.lua',
    'server/n4_server/sv_main.lua',
    'server/n4_server/sv_notifications.lua',
    'apps/**/*.sv.lua',
}

shared_scripts {
    'config.lua',
    'apps/**/cfg.lua',
    '@es_extended/imports.lua',
}

ui_page 'nui/ui.html'

files {
    'nui/**/*',
    'nui/ui.html',
    'nui/js/listener.js',
    'nui/js/notifications.js',
    'nui/css/ui.css',
    'nui/css/reset.css',
    'nui/images/phone.png',
    'apps/**/*.html',
    'apps/**/*.js',
    'apps/**/*.css',
    'apps/**/*.webp',
}

dependencies {
    'screenshot-basic',
    'n4_sounds',
    'pma-voice'
}

if Framework == 'QB' then
    shared_script 'FWFuncs.QB.lua'

elseif Framework == 'ESX' then
    shared_script 'FWFuncs.ESX.lua'
    dependencies {
        'es_extended'
    }
elseif Framework == 'Custom' then
    shared_script 'FWFuncs.Custom.lua'
else
    print('No framework specified in fxmanifest.lua')
end