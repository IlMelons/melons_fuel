Config = lib.load("config.config")

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

RegisterNetEvent("melons_fuel:server:RefuelVehicle", function(data)
	if not source or not data.entity then return end
	local playerState = Player(source).state
	if playerState.holding ~= "jerrycan" then return end

	local vehicle = NetworkGetEntityFromNetworkId(data.entity)
	if vehicle == 0 or GetEntityType(vehicle) ~= 2 then return end

	local vehicleState = Entity(vehicle)?.state
	local fuelLevel = math.ceil(vehicleState.fuel)
	local requiredFuel = 100 - fuelLevel
	if requiredFuel <= 0 then return server.Notify(source, locale("notify.vehicle_full"), "error") end

	local item, durability = inventory.GetJerrycan(source)
	if not item or durability <= 0 then return end

	local newDurability = math.floor(durability - requiredFuel)
	inventory.UpdateJerrycan(source, item, newDurability)

	setFuel(data.entity, requiredFuel)
	TriggerClientEvent("melons_fuel:client:PlayRefuelAnim", source, {netID = data.entity, amount = requiredFuel}, false)
end)


RegisterNetEvent("melons_fuel:server:ConfirmMenu", function(data)
	if not source or not data.netID or not data.amount or not data.cost then return end
	local playerState = Player(source).state
	if not playerState.inGasStation then return end

	---@description Checks if the player has enough money and validates client data
	local fuelCost = math.ceil(data.amount * GlobalState.fuelPrice)
	if fuelCost ~= data.cost then return end

	local playerMoney = inventory.GetPlayerMoney(source)
	if playerMoney < fuelCost then return server.Notify(source, locale("notify.not_enough_money"), "error") end

	TriggerClientEvent("melons_fuel:client:PlayRefuelAnim", source, {netID = data.netID, amount = data.amount, cost = fuelCost}, true)
end)

RegisterNetEvent("melons_fuel:server:Pay", function(netID, fuelAmount)
	local fuelCost = math.ceil(fuelAmount * GlobalState.fuelPrice)
	if not inventory.Pay(source, fuelCost) then return end

	fuelAmount = math.floor(fuelAmount)
	setFuel(netID, fuelAmount)

	server.Notify(source, locale("notify.refuel_success"):format(totalCost), "success")
end)

RegisterNetEvent("melons_fuel:server:BuyJerrycan", function()
    if not source then return end
	local playerState = Player(source).state
	local jerrycanCost = Config.JerrycanPrice
	if playerState.holding == "jerrycan" then
		local item, durability = inventory.GetJerrycan(source)
		if not item or item.name ~= "WEAPON_PETROLCAN" then return end

		if durability > 0 then return server.Notify(source, locale("notify.jerrycan_not_empty"), "error") end

		if not inventory.Pay(source, jerrycanCost) then return end
		inventory.UpdateJerrycan(source, item, 100)
	else
		if not inventory.CanCarry(source, "WEAPON_PETROLCAN") then
			return server.Notify(source, locale("notify.not_enough_space"), "error")
		end
		local money = inventory.GetItem(source, "money")
		if money.count < jerrycanCost then return server.Notify(source, locale("notify.not_enough_money"), "error") end
		if not inventory.Pay(source, jerrycanCost) then return end
		inventory.AddItem(source, "WEAPON_PETROLCAN", 1)
	end
end)