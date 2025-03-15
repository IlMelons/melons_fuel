function InitFuelStates()
    local playerState = LocalPlayer.state
    playerState:set("holdingNozzle", false, true)
    playerState:set("refueling", false, true)
    playerState:set("inGasStation", false, true)
end

function CheckFuelState(action)
    local playerPed = cache.ped or PlayerPedId()
    local playerState = LocalPlayer.state

    if not playerState.inGasStation then
        return false
    end

    if action == "insert_nozzle" then
        return playerState.holdingNozzle and not playerState.refueling
    elseif action == "grab_nozzle" or action == "buy_jerrycan" then
        return not playerState.refueling and not playerState.holdingNozzle and not IsPedInAnyVehicle(playerPed)
    elseif action == "return_nozzle" then
        return playerState.holdingNozzle and not playerState.refueling
    end

    return false
end