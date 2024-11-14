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

function server.GetPlayer(source)
    return exports.qbx_core:GetPlayer(source)
end

function server.PayFuel(Player, type, total, payText)
    local balance = Player.Functions.GetMoney(type)
    if balance < total then
        return server.Notify(source, "You don't have enough money", "error")
    else
        Player.Functions.RemoveMoney(type, total, payText)
    end
end