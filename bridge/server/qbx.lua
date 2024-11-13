if GetResourceState("qbx_core") ~= "started" then return end

QBX = exports.qbx_core

SHConfig = require "config.config"

---@diagnostic disable: duplicate-set-field
server = {}

function server.Notify(source, msg, type)
    TriggerClientEvent("ox_lib:notify", source, {
        title = SHConfig.Notify.title,
        description = msg,
        position = SHConfig.Notify.position,
        type = type,
    })
end