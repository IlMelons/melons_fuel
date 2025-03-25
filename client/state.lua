function InitFuelStates()
    local playerState = LocalPlayer.state
    playerState:set("holding", "null", true)
    playerState:set("refueling", false, true)
    playerState:set("inGasStation", false, true)
end

function CheckFuelState(action)
    local playerPed = cache.ped or PlayerPedId()

    if IsPedInAnyVehicle(playerPed, true) then return false end

    local playerState = LocalPlayer.state
    local holding = playerState.holding
    local refueling = playerState.refueling

    if action == "refuel_jerrycan" then
        return holding == "jerrycan" and not refueling
    end

    if not playerState.inGasStation then return false end

    if action == "refuel_nozzle" or action == "return_nozzle" then
        return holding == "nozzle" and not refueling
    elseif action == "take_nozzle_ev" or action == "take_nozzle_ev" then
        return holding == "null" and not refueling
    elseif action == "buy_jerrycan" then
        return holding ~= "nozzle" and not refueling
    end

    return false
end

lib.onCache("weapon", function(weapon)
    local playerState = LocalPlayer.state
    if weapon ~= `WEAPON_PETROLCAN` and playerState.holding ~= "null" then
        playerState:set("holding", "null", true)
    elseif weapon == `WEAPON_PETROLCAN` then
        playerState:set("holding", "jerrycan", true)
    end
end)