local Config = lib.load("config.config")

local function InitFuelPrice()
    GlobalState:set("fuelPrice", Config.FuelPrice, true)
end

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        InitFuelPrice()
    end
end)
