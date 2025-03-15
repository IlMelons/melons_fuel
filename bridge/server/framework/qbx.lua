if GetResourceState("qbx_core") ~= "started" then return end

local QBX = exports.qbx_core

---@diagnostic disable: duplicate-set-field, lowercase-global
server = {}

function server.Notify(source, msg, type)
    TriggerClientEvent("ox_lib:notify", source, {
        title = "Melons Fuel",
        description = msg,
        position = "top",
        type = type or "inform",
    })
end

function server.GetPlayerMoney(source)
    local player = QBX:GetPlayer(source)
    local cashMoney = player.PlayerData.money["cash"]
    local bankMoney = player.PlayerData.money["bank"]

    return cashMoney, bankMoney
end

function server.PayMoney(source, paymentMethod, amount)
    local player = QBX:GetPlayer(source)
    local paymentSuccess = player.Functions.RemoveMoney(paymentMethod, amount)

    return paymentSuccess
end