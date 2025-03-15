---@diagnostic disable: duplicate-set-field, lowercase-global

if GetResourceState("qbx_core") ~= "started" then return end

local QBCore = exports["qb-core"]:GetCoreObject()

server = {}

function server.Notify(source, msg, type)
    TriggerClientEvent("QBCore:Notify", source, msg, type)
end