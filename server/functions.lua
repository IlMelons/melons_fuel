if GetResourceState("ox_lib") ~= "started" then return end

SHConfig = require "config.config"

server = {}

function server.Notify(msg, type)
    TriggerClientEvent("ox_lib:notify", source, {
        title = SHConfig.Notify.title,
        description = msg,
        position = SHConfig.Notify.position,
        type = type,
    })
end