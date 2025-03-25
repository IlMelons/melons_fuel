local Config = lib.load("config.config")
local utils = lib.load("client.utils")

Stations = {Blips = {}, Zones = {}}

local function InitTargets()
	target.AddGlobalVehicle()

	for pumpModel, pumpData in pairs(Config.Pumps) do
		target.AddModel(pumpModel, pumpData.type == "ev")
	end
end

local function CreateStationZone(stationName, stationData)
	Stations.Zones[stationName] = lib.zones.box({
		coords = vec3(stationData.coords.x, stationData.coords.y, stationData.coords.z),
		size = stationData.size,
		rotation = stationData.coords.w,
		onEnter = function(self)
			SetFuelState("inGasStation", true)
		end,
		onExit = function(self)
			SetFuelState("inGasStation", false)
		end,
		debug = stationData.debug,
	})
end

local function CreateStationBlip(coords, id, ev)
	Stations.Blips[id] = utils.CreateBlip(coords, ev)
end

function InitGasStations()
	for stationName, stationData in pairs(Config.GasStations) do
		CreateStationZone(stationName, stationData)
		CreateStationBlip(stationData.coords, stationName, stationData.type == "ev")
	end
	InitTargets()
end

function RemoveStationBlips()
	for _, blip in pairs(Stations.Blips) do
		RemoveBlip(blip)
	end
end