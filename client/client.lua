---@diagnostic disable: lowercase-global
local Config = lib.load("config.config")
local utils = lib.load("client.utils")

local FuelEntities = {nozzle = nil, rope = nil}

main = {}

function main.SecureEntityDeletion()
    DeleteObject(FuelEntities.nozzle)
    RopeUnloadTextures()
    DeleteObject(FuelEntities.rope)
end

RegisterNetEvent("melons_fuel:client:TakeNozzle", function(data, pumpType)
	if not data.entity or not CheckFuelState("take_nozzle") then return end

	local playerPed = cache.ped or PlayerPedId()
	lib.requestAnimDict("anim@am_hold_up@male", 300)
	TaskPlayAnim(playerPed, "anim@am_hold_up@male", "shoplift_high", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
	Wait(300)
	StopAnimTask(playerPed, "anim@am_hold_up@male", "shoplift_high", 1.0)
	RemoveAnimDict("anim@am_hold_up@male")

	local pump = GetEntityModel(data.entity)
    local pumpCoords = GetEntityCoords(data.entity)
	local nozzleModel = Config.NozzleType[pumpType]
	local lefthand = GetPedBoneIndex(playerPed, 18905)
	FuelEntities.nozzle = CreateObject(nozzleModel, 1.0, 1.0, 1.0, true, true, false)
	AttachEntityToEntity(FuelEntities.nozzle, playerPed, lefthand, 0.13, 0.04, 0.01, -42.0, -115.0, -63.42, 0, 1, 0, 1, 0, 1)

    RopeLoadTextures()
    while not RopeAreTexturesLoaded() do
        Wait(0)
        RopeLoadTextures()
    end
	FuelEntities.rope = AddRope(pumpCoords.x, pumpCoords.y, pumpCoords.z, 0.0, 0.0, 0.0, 3.0, Config.RopeType["fv"], 8.0 --[[ DON'T SET TO 0.0!!! GAME CRASH!]], 0.0, 1.0, false, false, false, 1.0, true)
	while not FuelEntities.rope do
		Wait(0)
	end
	ActivatePhysics(FuelEntities.rope)
	Wait(100)

	local playerCoords = GetEntityCoords(playerPed)
	local nozzlePos = GetEntityCoords(FuelEntities.nozzle)
	nozzlePos = GetOffsetFromEntityInWorldCoords(FuelEntities.nozzle, 0.0, -0.033, -0.195)
	local pumpHeading = GetEntityHeading(data.entity)
	local rotatedPumpOffset = utils.RotateOffset(Config.Pumps[pump].offset, pumpHeading)
	local newPumpCoords = pumpCoords + rotatedPumpOffset
	AttachEntitiesToRope(FuelEntities.rope, data.entity, FuelEntities.nozzle, newPumpCoords.x, newPumpCoords.y, newPumpCoords.z, nozzlePos.x, nozzlePos.y, nozzlePos.z, length, false, false, nil, nil)

	SetFuelState("holding", ("%s_nozzle"):format(pumpType))
	CreateThread(function()
		local playerState = LocalPlayer.state
		local nozzleName = ("%s_nozzle"):format(pumpType)
		while playerState.holding == nozzleName do
			local currentcoords = GetEntityCoords(playerPed)
			local dist = #(playerCoords - currentcoords)
			if not TargetCreated then if Config.FuelTargetExport then exports["ox_target"]:AllowRefuel(true) end end
			TargetCreated = true
			if dist > 7.5 then
				if TargetCreated then if Config.FuelTargetExport then exports["ox_target"]:AllowRefuel(false) end end
				TargetCreated = true
				SetFuelState("holding", "null")
				DeleteObject(FuelEntities.nozzle)
				RopeUnloadTextures()
				DeleteRope(FuelEntities.rope)
			end
			Wait(2500)
		end
	end)
end)

RegisterNetEvent("melons_fuel:client:ReturnNozzle", function()
	if not CheckFuelState("return_nozzle") then return end
	SetFuelState("holding", "null")
	TargetCreated = false
	Wait(250)
	if Config.FuelTargetExport then exports["ox_target"]:AllowRefuel(false) end
	DeleteObject(FuelEntities.nozzle)
	RopeUnloadTextures()
	DeleteRope(FuelEntities.rope)
end)

local function SecondaryMenu(data)
	local totalCost = (data.PT == "fuel") and math.ceil(data.fuelAmount * GlobalState.fuelPrice) or Config.JerrycanPrice
	local vehNetID = (data.PT == "fuel") and NetworkGetEntityIsNetworked(data.Veh) and VehToNet(data.Veh)
	local cashMoney, bankMoney = lib.callback.await("melons_fuel:server:GetPlayerMoney", false)

	lib.registerContext({
		id = "melons_fuel:menu:payment",
		title = locale("menu.payment-title"):format(totalCost),
		options = {
			{
				title = locale("menu.payment-bank"),
				description = locale("menu.payment-bank-desc"):format(bankMoney),
				icon = "building-columns",
				onSelect = function()
					TriggerServerEvent("melons_fuel:server:ElaborateAction", {
						NetID = vehNetID or false,
						PM = "bank",
						PT = data.PT,
						Amount = data.fuelAmount,
						Cost = totalCost,
					})
				end,
			},
			{
				title = locale("menu.payment-cash"),
				description = locale("menu.payment-cash-desc"):format(cashMoney),
				icon = "money-bill",
				onSelect = function()
					TriggerServerEvent("melons_fuel:server:ElaborateAction", {
						NetID = vehNetID or false,
						PM = "cash",
						PT = data.PT,
						Amount = data.fuelAmount,
						Cost = totalCost,
					})
				end,
			},
		},
	})

	lib.registerContext({
		id = "melons_fuel:menu:confirm",
		title = locale("menu.confirm-title"):format(totalCost),
		options = {
			{
				title = locale("menu.confirm-choice-title"),
				menu = "melons_fuel:menu:payment",
				icon = "circle-check",
				iconColor = "#4CAF50",
			},
			{
				title = locale("menu.cancel-choice-title"),
				icon = "circle-xmark",
				iconColor = "#FF0000",
				onSelect = function()
					lib.hideContext()
				end,
			},
		},
	})

	lib.showContext("melons_fuel:menu:confirm")
end

RegisterNetEvent("melons_fuel:client:RefuelVehicle", function(data)
	if not data.entity or not CheckFuelState("refuel_nozzle") then return end

	---@description Electric Vehicle Check (Thanks to James [jgscripts] for a comment in a FiveM post)
	local playerState = LocalPlayer.state
	local isElectric = GetIsVehicleElectric(GetEntityModel(data.entity))
	if playerState.holding == "ev_nozzle" and not isElectric then return client.Notify(locale("notify.not-ev"), "error") end
	if playerState.holding == "fv_nozzle" and isElectric then return client.Notify(locale("notify.not-fv"), "error") end

	local vehicleState = Entity(data.entity).state
	local currentFuel = vehicleState.fuel or GetVehicleFuelLevel(data.entity)

	local input = lib.inputDialog(locale("input.select-amount"), {
		{type = "slider", label = locale("input.select-amount"), default = currentFuel, min = 0, max = 100},
	})
	if not input then return end

	local inputFuel = tonumber(input[1])
	local fuelAmount = inputFuel - currentFuel
	if not fuelAmount then return end

	SecondaryMenu({Veh = data.entity, PT = "fuel", fuelAmount = fuelAmount})
end)

RegisterNetEvent("melons_fuel:client:BuyJerrycan", function(data)
	if not data.entity or not CheckFuelState("buy_jerrycan") then return end

	SecondaryMenu({PT = "jerrycan"})
end)

RegisterNetEvent("melons_fuel:client:PlayRefuelAnim", function(data, isPump)
	local playerState = LocalPlayer.state
	if isPump and not (playerState.holding == "fv_nozzle" or playerState.holding == "ev_nozzle") then return end
	if not isPump and not playerState.holding == "jerrycan" then return end

	local vehicle = NetToVeh(data.NetID)
	local playerPed = cache.ped or PlayerPedId()

	TaskTurnPedToFaceEntity(playerPed, vehicle, 500)
	Wait(500)

	local refuelTime = data.Amount * 2000
	SetFuelState("refueling", true)
	if lib.progressCircle({
		duration = refuelTime,
		label = locale("progress.refueling-vehicle"),
		position = "bottom",
		useWhileDead = false,
		canCancel = false,
		anim = {
			dict = isPump and "timetable@gardener@filling_can" or "weapon@w_sp_jerrycan",
			clip = isPump and "gar_ig_5_filling_can" or "fire",
		},
		disable = {move = true, car = true, combat = true},
	}) then
		SetFuelState("refueling", false)
		client.Notify(locale("notify.refuel-success"), "success")
	end
end)
