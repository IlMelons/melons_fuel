lib.callback.register("melons_fuel:server:GetPlayerMoney", function(source)
	local money = inventory.GetPlayerMoney(source)
	return money
end)

local function setFuel(netID, fuelAmount)
	local vehicle = NetworkGetEntityFromNetworkId(netID)
	if vehicle == 0 or GetEntityType(vehicle) ~= 2 then return end

	local vehicleState = Entity(vehicle)?.state
	local fuelLevel = vehicleState.fuel

	local fuel = fuelLevel + fuelAmount

	vehicleState:set("fuel", fuel, true)
end

RegisterNetEvent("melons_fuel:server:ConfirmMenu", function(data)
	if not source or not data.netID or not data.amount or not data.cost then return end
	local playerState = Player(source).state
	if not playerState.inGasStation then return end

	---@description Checks if the player has enough money and validates client data
	local fuelCost = math.ceil(data.amount * GlobalState.fuelPrice)
	if fuelCost ~= data.cost then return end

	local playerMoney = inventory.GetPlayerMoney(source)
	if playerMoney < fuelCost then return server.Notify(source, locale("notify.not_enough_money"), "error") end

	TriggerClientEvent("melons_fuel:client:PlayRefuelAnim", source, {netID = data.netID, amount = data.amount, cost = fuelCost})
end)

RegisterNetEvent("melons_fuel:server:Pay", function(netID, fuelAmount)
	local fuelCost = math.ceil(fuelAmount * GlobalState.fuelPrice)
	if not inventory.Pay(source, fuelCost) then return end

	fuelAmount = math.floor(fuelAmount)
	setFuel(netID, fuelAmount)

	server.Notify(source, locale("notify.refuel_success"):format(totalCost), "success")
end)