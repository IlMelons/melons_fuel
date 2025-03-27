Config = lib.load("config.config")

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

local function Pay(source, data)
	local fuelCost = math.ceil(data.Amount * GlobalState.fuelPrice)
	if not server.PayMoney(source, data.PM, fuelCost) then return end

	local fuelAmount = math.floor(data.Amount)
	setFuel(data.NetID, fuelAmount)
end


RegisterNetEvent("melons_fuel:server:ElaborateAction", function(data)
	if not source then return end
	local playerState = Player(source).state
	if not playerState.inGasStation then return end

	if not data.Amount or not data.Cost then return end
	local fuelCost = math.ceil(data.Amount * GlobalState.fuelPrice)
	if fuelCost ~= data.Cost then return end

	local playerMoney = server.GetPlayerMoney(source, data.PM)
	if playerMoney < fuelCost then return server.Notify(source, locale("notify.not-enough-money"), "error") end

	Pay(source, data)
	TriggerClientEvent("melons_fuel:client:PlayRefuelAnim", source, {NetID = data.NetID, Amount = data.Amount}, true)
end)

RegisterNetEvent("melons_fuel:server:RefuelVehicle", function(data)
	if not source or not data.entity then return end
	local playerState = Player(source).state
	if playerState.holding ~= "jerrycan" then return end

	local vehicle = NetworkGetEntityFromNetworkId(data.entity)
	if vehicle == 0 or GetEntityType(vehicle) ~= 2 then return end

	local vehicleState = Entity(vehicle)?.state
	local fuelLevel = math.ceil(vehicleState.fuel)
	local requiredFuel = 100 - fuelLevel
	if requiredFuel <= 0 then return server.Notify(source, locale("notify.vehicle-full"), "error") end

	local item, durability = inventory.GetJerrycan(source)
	if not item or durability <= 0 then return end

	local newDurability = math.floor(durability - requiredFuel)
	inventory.UpdateJerrycan(source, item, newDurability)

	setFuel(data.entity, requiredFuel)
	TriggerClientEvent("melons_fuel:client:PlayRefuelAnim", source, {netID = data.entity, amount = requiredFuel}, false)
end)

RegisterNetEvent("melons_fuel:server:BuyJerrycan", function()
    if not source then return end
	local playerState = Player(source).state
	local jerrycanCost = Config.JerrycanPrice
	if playerState.holding == "jerrycan" then
		local item, durability = inventory.GetJerrycan(source)
		if not item or item.name ~= "WEAPON_PETROLCAN" then return end

		if durability > 0 then return server.Notify(source, locale("notify.jerrycan-not-empty"), "error") end

		if not inventory.Pay(source, jerrycanCost) then return end
		inventory.UpdateJerrycan(source, item, 100)
	else
		if not inventory.CanCarry(source, "WEAPON_PETROLCAN") then
			return server.Notify(source, locale("notify.not-enough-space"), "error")
		end
		local money = inventory.GetItem(source, "money")
		if money.count < jerrycanCost then return server.Notify(source, locale("notify.not-enough-money"), "error") end
		if not inventory.Pay(source, jerrycanCost) then return end
		inventory.AddItem(source, "WEAPON_PETROLCAN", 1)
	end
end)