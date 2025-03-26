---@diagnostic disable: duplicate-set-field, lowercase-global

if GetResourceState("qbx_core") ~= "started" then return end

local QBX = exports.qbx_core

client = {}

function client.Notify(msg, type)
    lib.notify({
        title = "Melons Fuel",
        description = msg,
        position = "top",
        type = type or "inform",
    })
end