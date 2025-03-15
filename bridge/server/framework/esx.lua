---@diagnostic disable: duplicate-set-field, lowercase-global

if GetResourceState("es_extended") ~= "started" then return end

local ESX = exports["es_extended"]:getSharedObject()

server = {}

function server.Notify(source, msg, type)
    TriggerClientEvent("esx:showNotification", source, msg, type)
end