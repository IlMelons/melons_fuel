---@diagnostic disable: lowercase-global
if GetResourceState("ox_target") ~= "started" then return end

local ox_target = exports.ox_target

target = {}

function target.AddGlobalVehicle()
    ox_target:addGlobalVehicle({
        {
            label = locale("target.insert-nozzle"),
            name = "melons_fuel:veh_option",
            icon = "fas fa-gas-pump",
            canInteract = function()
                return CheckFuelState("insert_nozzle")
            end,
            event = "melons_fuel:client:RefuelVehicle"
        },
    })
end

function target.RemoveGlobalVehicle()
    ox_target:removeGlobalVehicle("melons_fuel:veh_option")
end

function target.AddModel(model)
    ox_target:addModel(model, {
        {
            label = locale("target.grab-nozzle"),
            name = "cdn-fuel:modelOptions:option_1",
            icon = "fas fa-gas-pump",
            canInteract = function()
                return CheckFuelState("grab_nozzle")
            end,
            event = "melons_fuel:client:TakeNozzle",
        },
        {
            label = locale("target.return-nozzle"),
            name = "cdn-fuel:modelOptions:option_2",
            icon = "fas fa-hand",
            canInteract = function()
                return CheckFuelState("return_nozzle")
            end,
            event = "melons_fuel:client:ReturnNozzle",
        },
        {
            label = locale("target.buy-jerrycan"),
            name = "cdn-fuel:modelOptions:option_3",
            icon = "fas fa-fire-flame-simple",
            canInteract = function()
                return CheckFuelState("buy_jerrycan")
            end,
            event = "cdn-fuel:client:purchasejerrycan",
        },
    })
end