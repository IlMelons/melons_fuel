-- code by (https://github.com/overextended/ox_fuel)
-- with a little but unwanted simplification (https://github.com/overextended/ox_fuel/pull/110)

local Config = lib.load("config.config")

local fuel = {LastVehicle = cache.vehicle or GetPlayersLastVehicle()}
if fuel.LastVehicle == 0 then fuel.LastVehicle = nil end

SetFuelConsumptionState(true)
SetFuelConsumptionRateMultiplier(Config.FuelUsage)

local function SetFuel(vehState, vehicle, amount, replicate)
    if DoesEntityExist(vehicle) then
		SetVehicleFuelLevel(vehicle, amount)
		vehState:set("fuel", amount, replicate)
	end
end

local function startFuelConsumption()
	local vehicle = cache.vehicle

	if not DoesVehicleUseFuel(vehicle) then return end

	local vehState = Entity(vehicle).state
	if not vehState.fuel then
		vehState:set("fuel", GetVehicleFuelLevel(vehicle), true)
		while not vehState.fuel do Wait(0) end
	end

	SetVehicleFuelLevel(vehicle, vehState.fuel)

	local fuelTick = 0

	while cache.seat == -1 do
		if GetIsVehicleEngineRunning(vehicle) then
			if not DoesEntityExist(vehicle) then return end
			SetFuelConsumptionRateMultiplier(Config.FuelUsage)

			local fuelAmount = tonumber(vehState.fuel)
			local newFuel = GetVehicleFuelLevel(vehicle)
			if fuelAmount > 0 then
				if GetVehiclePetrolTankHealth(vehicle) < 700 then
					newFuel -= math.random(10, 20) * 0.01
				end

				if fuelAmount ~= newFuel then
					SetFuel(vehState, vehicle, newFuel, fuelTick % 15 == 0)
                	fuelTick = (fuelTick + 1) % 15
				end
			end
		else
			if not DoesEntityExist(vehicle) then return end
			SetFuelConsumptionRateMultiplier(0.0)
		end
		Wait(1000)
	end
	SetFuel(vehState, vehicle, vehState.fuel, true)
end

if cache.seat == -1 then CreateThread(startFuelConsumption) end

lib.onCache("seat", function(seat)
    if cache.vehicle then
        fuel.LastVehicle = cache.vehicle
    end

    if seat == -1 then
        SetTimeout(0, startFuelConsumption)
    end
end)