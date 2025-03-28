fx_version "cerulean"
game "gta5"
lua54 "yes"

name "melons_fuel"
description "Fuel System for FiveM"
author "IlMelons"
version "0.1.2"
repository "https://www.github.com/IlMelons/melons_fuel"

ox_lib "locale"

shared_scripts {
    "@ox_lib/init.lua",
    "config/config.lua",
}

client_scripts {
    "bridge/client/**/*.lua",
    "client/*.lua",
}

server_scripts {
    "bridge/server/**/*.lua",
    "server/*.lua",
    "checker.lua",
}

files {
    "locales/*.json",
}
