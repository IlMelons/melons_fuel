---@diagnostic disable: duplicate-set-field, lowercase-global

if GetResourceState("qb-target") ~= "started" then return end

local qb_target = exports["qb-target"]

target = {}

function target.AddGlobalVehicle()
    qb_target:AddGlobalVehicle({
        options = {
            {
                label = locale("target.refuel-nozzle"),
                icon = "fas fa-gas-pump",
                canInteract = function()
                    return CheckFuelState("refuel_nozzle")
                end,
                action = function(entity)
                    TriggerEvent("melons_fuel:client:RefuelVehicle", {entity = entity})
                end,
            },
        },
        distance = 3.0,
    })
end

function target.RemoveGlobalVehicle()
    qb_target:RemoveGlobalVehicle(locale("target.insert-nozzle"))
end

function target.AddModel(model)
    qb_target:AddTargetModel(model, {
        options = {
            {
                num = 1,
                label = locale("target.take-nozzle"),
                icon = "fas fa-gas-pump",
                canInteract = function()
                    return CheckFuelState("take_nozzle")
                end,
                action = function(entity)
                    TriggerEvent("melons_fuel:client:TakeNozzle", {entity = entity})
                end,
            },
            {
                num = 2,
                label = locale("target.return-nozzle"),
                icon = "fas fa-hand",
                canInteract = function()
                    return CheckFuelState("return_nozzle")
                end,
                action = function(entity)
                    TriggerEvent("melons_fuel:client:ReturnNozzle", {entity = entity})
                end,
            },
            {
                num = 3,
                label = locale("target.buy-jerrycan"),
                icon = "fas fa-fire-flame-simple",
                canInteract = function()
                    return CheckFuelState("buy_jerrycan")
                end,
                action = function(entity)
                    TriggerEvent("melons_fuel:client:BuyJerrycan", {entity = entity})
                end,
            },
        },
        distance = 3.0,
    })
end