AddEventHandler("onClientResourceStart", function(resourceName)
    local scriptName = cache.resource or GetCurrentResourceName()
    if resourceName ~= scriptName then return end
    InitFuelStates()
    InitGasStations()
end)

AddEventHandler("onResourceStop", function(resourceName)
	local scriptName = cache.resource or GetCurrentResourceName()
	if resourceName ~= scriptName then return end
	main.SecureEntityDeletion()
	target.RemoveGlobalVehicle()
	RemoveStationBlips()
end)
