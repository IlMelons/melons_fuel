if not Config.ElectricVehicleCharging then return end

-- Variables
local QBCore = exports[Config.Core]:GetCoreObject()

-- Functions
local function GlobalTax(value)
	local tax = (value / 100 * Config.GlobalTax)
	return tax
end

-- Events
RegisterNetEvent("cdn-fuel:server:electric:OpenMenu", function(amount, inGasStation, hasWeapon, purchasetype, FuelPrice)
	local src = source
	if not src then print("SRC is nil!") return end
	local player = QBCore.Functions.GetPlayer(src)
	if not player then print("Player is nil!") return end
	local FuelCost = amount*FuelPrice
	local tax = GlobalTax(FuelCost)
	local total = tonumber(FuelCost + tax)
	if not amount then if Config.FuelDebug then print("Electric Recharge Amount is invalid!") end TriggerClientEvent('QBCore:Notify', src, Lang:t("electric_more_than_zero"), 'error') return end
	Wait(50)
	if inGasStation and not hasWeapon then
		if Config.RenewedPhonePayment and purchasetype == "bank" then
			TriggerClientEvent("cdn-fuel:client:electric:phone:PayForFuel", src, amount)
		else
			TriggerClientEvent("cdn-electric:client:OpenContextMenu", src, math.ceil(total), amount, purchasetype)
		end
	end
end)