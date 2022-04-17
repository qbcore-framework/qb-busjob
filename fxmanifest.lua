fx_version 'cerulean'
game 'gta5'

description 'QB-BusJob'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
	'locales/en.lua',
    'config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/main.lua'
}

server_script 'server/main.lua'

lua54 'yes'
