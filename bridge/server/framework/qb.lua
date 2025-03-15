if GetResourceState("qbx_core") ~= "started" then return end

local QBCore = exports["qb-core"]:GetCoreObject()

---@diagnostic disable: duplicate-set-field, lowercase-global
server = {}

function server.Notify(source, msg, type)
    TriggerClientEvent("QBCore:Notify", source, msg, type)
end

function server.GetPlayerMoney(source)
    local Player = QBCore.Functions.GetPlayer(source)
    local cashMoney = Player.PlayerData.money["cash"]
    local bankMoney = Player.PlayerData.money["bank"]

    return cashMoney, bankMoney
end

function server.PayMoney(source, paymentMethod, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    local paymentSuccess = Player.Functions.RemoveMoney(paymentMethod, amount)

    return paymentSuccess
end