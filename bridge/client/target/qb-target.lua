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
            {
                label = locale("target.refuel-jerrycan"),
                icon = "fas fa-gas-pump",
                canInteract = function()
                    return CheckFuelState("refuel_jerrycan")
                end,
                action = function(entity)
                    local vehNetID = NetworkGetNetworkIdFromEntity(entity)
                    TriggerServerEvent("melons_fuel:server:RefuelVehicle", {entity = vehNetID})
                end,
            },
        },
        distance = 3.0,
    })
end

function target.RemoveGlobalVehicle()
    qb_target:RemoveGlobalVehicle(locale("target.insert-nozzle"))
end

function target.AddModel(model, isEV)
    qb_target:AddTargetModel(model, {
        options = {
            {
                num = 1,
                label = locale(isEV and "target.take-charger" or "target.take-nozzle"),
                icon = isEV and "fas fa-bolt" or "fas fa-gas-pump",
                canInteract = function()
                    return CheckFuelState(("take_nozzle_%s"):format(isEV and "ev" or "fv"))
                end,
                action = function(entity)
                    local pumpType = isEV and "ev" or "fv"
                    TriggerEvent("melons_fuel:client:TakeNozzle", {entity = entity}, pumpType)
                end,
            },
            {
                num = 2,
                label = locale(isEV and "target.return-charger" or "target.return-nozzle"),
                icon = "fas fa-hand",
                canInteract = function()
                    return CheckFuelState("return_nozzle")
                end,
                action = function(entity)
                    local pumpType = isEV and "ev" or "fv"
                    TriggerEvent("melons_fuel:client:ReturnNozzle", {entity = entity}, pumpType)
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
                    TriggerServerEvent("melons_fuel:server:BuyJerrycan")
                end,
            },
        },
        distance = 3.0,
    })
end