---@diagnostic disable: duplicate-set-field, lowercase-global

if GetResourceState("qbx_core") ~= "started" then return end

local QBX = exports.qbx_core

server = {}

function server.Notify(source, msg, type)
    TriggerClientEvent("ox_lib:notify", source, {
        title = "Melons Fuel",
        description = msg,
        position = "top",
        type = type or "inform",
    })
end