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

function inventory.GetItem(source, itemName)
    local item = qb_inventory:GetItemByName(source, itemName)
    return item
end

function inventory.CanCarry(source, itemName, amount)
    local success = qb_inventory:CanAddItem(source, itemName, amount)
    return success
end

function inventory.AddItem(source, itemName, amount, metadata)
    qb_inventory:AddItem(source, itemName, amount, false, metadata)
end