local Config = lib.load("config.config")

Stations = {}

local function InitTargets()
	target.AddGlobalVehicle()

	for pumpmodel in pairs(Config.Pumps) do
		target.AddModel(pumpmodel)
	end
end

local function CreateFuelZone(stationName, stationData)
	Stations[stationName] = lib.zones.box({
		coords = vec3(stationData.coords.x, stationData.coords.y, stationData.coords.z),
		size = stationData.size,
		rotation = stationData.coords.w,
		onEnter = function(self)
			local playerState = LocalPlayer.state
			playerState:set("inGasStation", true, true)
		end,
		onExit = function(self)
			local playerState = LocalPlayer.state
			playerState:set("inGasStation", false, true)
		end,
		debug = stationData.debug,
	})
end

local function CreateFuelBlips(points)
	exports.melons_mapsutility:CreateMultiBlips("melons_fuel", {
		points = points,
		sprite = 361,
		color = 1,
		label = locale("blips.name"),
		scale = 0.6,
	})
end

function InitGasStations()
	local points = {}
	for stationName, stationData in pairs(Config.GasStations) do
		CreateFuelZone(stationName, stationData)
		points[#points + 1] = vec3(stationData.coords.x, stationData.coords.y, stationData.coords.z)
	end
	CreateFuelBlips(points)
	InitTargets()
end