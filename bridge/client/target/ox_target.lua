---@diagnostic disable: duplicate-set-field, lowercase-global

if GetResourceState("ox_target") ~= "started" then return end

local ox_target = exports.ox_target

target = {}

function target.AddGlobalVehicle()
    ox_target:addGlobalVehicle({
        {
            label = locale("target.refuel-nozzle"),
            name = "melons_fuel:veh_option_1",
            icon = "fas fa-gas-pump",
            distance = 3.0,
            canInteract = function()
                return CheckFuelState("refuel_nozzle")
            end,
            event = "melons_fuel:client:RefuelVehicle"
        },
        {
            label = locale("target.refuel-jerrycan"),
            name = "melons_fuel:veh_option_2",
            icon = "fas fa-gas-pump",
            canInteract = function()
                return CheckFuelState("refuel_jerrycan")
            end,
            serverEvent = "melons_fuel:server:RefuelVehicle"
        },
    })
end

function target.RemoveGlobalVehicle()
    ox_target:removeGlobalVehicle("melons_fuel:veh_option")
end

function target.AddModel(model, isEV)
    ox_target:addModel(model, {
        {
            label = locale(isEV and "target.take-charger" or "target.take-nozzle"),
            name = "melons_fuel:pump_option_1",
            icon = isEV and "fas fa-bolt" or "fas fa-gas-pump",
            distance = 3.0,
            canInteract = function()
                return CheckFuelState("take_nozzle")
            end,
            onSelect = function(data)
                local pumpType = isEV and "ev" or "fuel"
                TriggerEvent("melons_fuel:client:TakeNozzle", data, pumpType)
            end,
        },
        {
            label = locale(isEV and "target.return-charger" or "target.return-nozzle"),
            name = "melons_fuel:pump_option_2",
            icon = "fas fa-hand",
            distance = 3.0,
            canInteract = function()
                return CheckFuelState("return_nozzle")
            end,
            onSelect = function(data)
                local pumpType = isEV and "ev" or "fuel"
                TriggerEvent("melons_fuel:client:ReturnNozzle", data, pumpType)
            end,
        },
        {
            label = locale("target.buy-jerrycan"),
            name = "melons_fuel:pump_option_3",
            icon = "fas fa-fire-flame-simple",
            distance = 3.0,
            canInteract = function()
                return CheckFuelState("buy_jerrycan")
            end,
            serverEvent = "melons_fuel:server:BuyJerrycan",
        },
    })
end