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

function inventory.GetItem(source, itemName)
    local item = ox_inventory:GetItem(source, itemName, nil, false)
    return item
end

function inventory.CanCarry(source, itemName, amount)
    local success = ox_inventory:CanCarryItem(source, itemName, amount)
    return success
end

function inventory.AddItem(source, itemName, count, metadata)
    ox_inventory:AddItem(source, itemName, count, metadata)
end