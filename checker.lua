---@description UPDATE-RENAME CHECKER
--- This part of the script is used to track script updates through ox_lib and has a built-in function that
--- detects if the script has the right name to make exports (if any) work as described in the documentation.
--- [WARNING]: Remove only if you are sure of what you are doing

---@diagnostic disable

local ExpectedName = GetResourceMetadata(GetCurrentResourceName(), "name")

lib.versionCheck(("IlMelons/%s"):format(ExpectedName))

AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    if GetCurrentResourceName() ~= ExpectedName then
        print(("^1[ERROR]: The resource name is incorrect. Please set it to %s.^0"):format(ExpectedName))
    end
    local gameBuild = GetConvarInt("sv_enforceGameBuild", 0)
    if gameBuild < 3258 then 
        print(("^1[melons_fuel] The script needs Game build 3258 or newer to work. Current Build: %d^0"):format(gameBuild))
    end
end)