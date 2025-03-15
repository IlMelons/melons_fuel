local Config = lib.load("config.config")

local function GlobalTax(value)
	local tax = (value / 100 * Config.GlobalTax)
	return tax
end

lib.callback.register("melons_fuel:server:GetPlayerMoney", function(source)
	local cashMoney, bankMoney = server.GetPlayerMoney(source)

	return cashMoney, bankMoney
end)

local function setFuel(netID, fuelAmount)
	local vehicle = NetworkGetEntityFromNetworkId(netID)
	if vehicle == 0 or GetEntityType(vehicle) ~= 2 then return end

	local vehicleState = Entity(vehicle)?.state
	local fuelLevel = vehicleState.fuel

	local fuel = fuelLevel + fuelAmount

	vehicleState:set("fuel", fuel, true)
end

RegisterNetEvent("melons_fuel:server:ConfirmMenu", function(netID, paymentMethod, fuelAmount)
	if not source or not netID or not fuelAmount then return end
	local playerState = Player(source).state
	if not playerState.inGasStation then return end

	local fuelCost = fuelAmount * Config.MinimumFuelPrice
	local tax = GlobalTax(fuelCost)
	local totalCost = tonumber(fuelCost + tax)
	TriggerClientEvent("melons_fuel:client:ConfirmMenu", source, netID, paymentMethod, fuelAmount, totalCost)
end)

RegisterNetEvent("melons_fuel:server:Pay", function(netID, fuelAmount, paymentMethod)
	local fuelCost = fuelAmount * Config.MinimumFuelPrice
	local tax = GlobalTax(fuelCost)
	local totalCost = tonumber(fuelCost + tax)
	if not server.PayMoney(source, paymentMethod, totalCost) then return end

	fuelAmount = math.floor(fuelAmount)
	setFuel(netID, fuelAmount)

	server.Notify(source, locale("notify.refuel_success"):format(totalCost), "success")
end)