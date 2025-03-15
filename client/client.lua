local function InitFuel()
    InitFuelStates()
    InitGasStations()
end

AddEventHandler("onClientResourceStart", function(resourceName)
    local scriptName = cache.resource or GetCurrentResourceName()
    if resourceName ~= scriptName then return end
    InitFuel()
end)

AddEventHandler("onResourceStop", function(resourceName)
	local scriptName = cache.resource or GetCurrentResourceName()
	if resourceName ~= scriptName then return end
	main.SecureEntityDeletion()
	target.RemoveGlobalVehicle()
	exports.melons_mapsutility:DeleteMultiBlips("melons_fuel")
end)