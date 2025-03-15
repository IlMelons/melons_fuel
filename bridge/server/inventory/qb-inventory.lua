---@diagnostic disable: duplicate-set-field, lowercase-global

if GetResourceState("qb-inventory") ~= "started" then return end

local qb_inventory = exports["qb-inventory"]

inventory = {}

function inventory.GetPlayerMoney(source)
    local money = qb_inventory:GetItemCount(source, "money")
    return money
end

function inventory.Pay(source, amount)
    local success = qb_inventory:RemoveItem(source, "money", amount)
    return success
end