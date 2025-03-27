---@diagnostic disable: duplicate-set-field, lowercase-global

if GetResourceState("es_extended") ~= "started" then return end

local ESX = exports["es_extended"]:getSharedObject()

server = {}

function server.Notify(source, msg, type)
    TriggerClientEvent("esx:showNotification", source, msg, type)
end

function server.GetPlayerMoney(source, account)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cashMoney = xPlayer.accounts.cash
    local bankMoney = xPlayer.accounts.bank

    if account == "bank" then
        return bankMoney
    elseif account == "cash" then
        return cashMoney
    else
        return cashMoney, bankMoney
    end
end

function server.PayMoney(source, paymentMethod, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeAccountMoney(paymentMethod, amount)

    return true
end