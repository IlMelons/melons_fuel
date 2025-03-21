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

function target.AddModel(model)
    ox_target:addModel(model, {
        {
            label = locale("target.take-nozzle"),
            name = "cdn-fuel:modelOptions:option_1",
            icon = "fas fa-gas-pump",
            distance = 3.0,
            canInteract = function()
                return CheckFuelState("take_nozzle")
            end,
            event = "melons_fuel:client:TakeNozzle",
        },
        {
            label = locale("target.return-nozzle"),
            name = "cdn-fuel:modelOptions:option_2",
            icon = "fas fa-hand",
            distance = 3.0,
            canInteract = function()
                return CheckFuelState("return_nozzle")
            end,
            event = "melons_fuel:client:ReturnNozzle",
        },
        {
            label = locale("target.buy-jerrycan"),
            name = "cdn-fuel:modelOptions:option_3",
            icon = "fas fa-fire-flame-simple",
            distance = 3.0,
            canInteract = function()
                return CheckFuelState("buy_jerrycan")
            end,
            serverEvent = "melons_fuel:server:BuyJerrycan",
        },
    })
end