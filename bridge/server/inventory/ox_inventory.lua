---@diagnostic disable: duplicate-set-field, lowercase-global

if GetResourceState("ox_inventory") ~= "started" then return end

local ox_inventory = exports.ox_inventory

inventory = {}

function inventory.GetItem(source, itemName)
    local item = ox_inventory:GetItem(source, itemName, nil, false)
    return item
end

function inventory.CanCarry(source, itemName, amount)
    local success = ox_inventory:CanCarryItem(source, itemName, amount)
    return success
end

function inventory.AddItem(source, itemName, count)
    ox_inventory:AddItem(source, itemName, count)
end

function inventory.GetJerrycan(source)
    local weapon = ox_inventory:GetCurrentWeapon(source)
    local durability = weapon.metadata.durability
    return weapon, durability
end

function inventory.UpdateJerrycan(source, item, newDurability)
    local metadata = {durability = newDurability, ammo = newDurability}
    ox_inventory:SetMetadata(source, item.slot, metadata)
end