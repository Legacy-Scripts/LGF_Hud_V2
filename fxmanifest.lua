fx_version 'cerulean'
game 'gta5'
version '1.0.0'
lua54 'yes'
description 'Modern Hud for Various Framework (LGF/ ESX / QB OR QBOX / OX CORE )'
author 'ENT510'


shared_scripts {
  '@ox_lib/init.lua',
  'Shared/Config.lua',
  'Shared/Locale.lua',
  'Shared/Core.lua',

}

client_scripts {
  'Modules/client/Functions.lua',
  'Modules/client/Nui.lua',
  'Modules/client/Hud.lua',
  'Modules/client/Vehicle.lua',
  'Modules/client/Notify.lua',
}

server_scripts { 'server/**/*' }

files { 'web/build/index.html', 'web/build/**/*', }

ui_page 'web/build/index.html'
