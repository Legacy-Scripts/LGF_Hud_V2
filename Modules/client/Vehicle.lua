--[[REQUIRE]]
local Config = require "Shared.Config"

--[[VARS]]
local isVehicleHudVisible = false
local VehicleBlackListed = Config.VehicleBlackListed

--[[NATIVES]]
local GetEntityModel = GetEntityModel
local CreateThread = CreateThread
local Wait = Wait
local GetVehicleWheelHealth = GetVehicleWheelHealth
local GetEntitySpeed = GetEntitySpeed
local GetVehicleFuelLevel = GetVehicleFuelLevel
local GetVehicleCurrentGear = GetVehicleCurrentGear
local GetVehicleEngineHealth = GetVehicleEngineHealth
local GetIsVehicleEngineRunning = GetIsVehicleEngineRunning

--[[FUNCTIONS]]
local function isVehicleBlacklisted(model)
    for i = 1, #VehicleBlackListed do
        if VehicleBlackListed[i] == model then
            return true
        end
    end
    return false
end

--[[MAIN THREAD]]
lib.onCache('vehicle', function(value)
    local SLEEP = 1000
    if value then
        local vehicleModel = GetEntityModel(value)
        if not isVehicleHudVisible and not isVehicleBlacklisted(vehicleModel) then
            isVehicleHudVisible = true
            CreateThread(function()
                while isVehicleHudVisible do
                    Wait(SLEEP)
                    local Vehicle = value
                    if Vehicle then
                        local tireHealth = 0
                        for i = 0, 3 do
                            tireHealth = tireHealth + GetVehicleWheelHealth(Vehicle, i)
                        end

                        tireHealth = tireHealth / 4

                        Nui.toggleNui("openSpeedometer", {
                            Visible = isVehicleHudVisible,
                            VehicleData = {
                                Speed = lib.math.round(GetEntitySpeed(Vehicle) * 3.6, 0),
                                Fuel = Config.FuelProvider(Vehicle),
                                Gear = GetVehicleCurrentGear(Vehicle),
                                EngineHealth = GetVehicleEngineHealth(Vehicle),
                                EngineStatus = (GetIsVehicleEngineRunning(Vehicle) == 1 and true or false),
                                TireHealth = tireHealth
                            }
                        })
                    else
                        isVehicleHudVisible = false
                    end
                end
            end)
        end
    else
        if isVehicleHudVisible then
            isVehicleHudVisible = false
        end
    end
end)
