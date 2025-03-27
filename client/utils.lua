---@diagnostic disable: lowercase-global

local utils = {}

function utils.CreateBlip(coords, ev)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipAlpha(blip, 255)
    SetBlipSprite(blip, ev and 354 or 361)
    SetBlipColour(blip, ev and 5 or 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(locale(ev and "blips.name-ev" or "blips.name-fuel"))
    EndTextCommandSetBlipName(blip)
    SetBlipDisplay(blip, 2)
    SetBlipScale(blip, ev and 1.0 or 0.6)

    return blip
end

function utils.RotateOffset(offset, heading)
    local rad = math.rad(heading)
    local cosH = math.cos(rad)
    local sinH = math.sin(rad)

    local newX = offset.x * cosH - offset.y * sinH
    local newY = offset.x * sinH + offset.y * cosH

    return vec3(newX, newY, offset.z)
end

return utils