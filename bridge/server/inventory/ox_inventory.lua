---@diagnostic disable: duplicate-set-field, lowercase-global

if GetResourceState("ox_inventory") ~= "started" then return end

local ox_inventory = exports.ox_inventory

inventory = {}

function inventory.GetPlayerMoney(source)
    local money = ox_inventory:GetItemCount(source, "money")
    return money
end

function inventory.Pay(source, amount)
    local success = ox_inventory:RemoveItem(source, "money", amount)
    return success
end