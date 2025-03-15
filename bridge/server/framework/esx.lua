if GetResourceState("es_extended") ~= "started" then return end

local ESX = exports["es_extended"]:getSharedObject()

---@diagnostic disable: duplicate-set-field, lowercase-global
server = {}

function server.Notify(source, msg, type)
    TriggerClientEvent("esx:showNotification", source, msg, type)
end

function server.GetPlayerMoney(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cashMoney = xPlayer.PlayerData.money

    return cashMoney, 0
end

function server.PayMoney(source, paymentMethod, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeMoney(amount)

    return paymentSuccess
end