if not lib then return end

Framework = {}
local Core = nil
local GetCore = promise.new()
local Path = lib.context

if GetResourceState("LEGACYCORE") ~= "missing" then
    Core = "LEGACYCORE"
    LGF = exports.LEGACYCORE:GetCoreData()
    GetCore:resolve({ "LEGACYCORE", "GetCoreData" })
elseif GetResourceState("es_extended") ~= "missing" then
    Core = "es_extended"
    ESX = exports.es_extended:getSharedObject()
    GetCore:resolve({ "es_extended", "getSharedObject" })
elseif GetResourceState("qb-core") ~= "missing" then
    Core = "qb-core"
    QBCore = exports['qb-core']:GetCoreObject()
    GetCore:resolve({ "qb-core", "GetCoreObject" })
elseif GetResourceState("qbx-core") ~= "missing" then
    Core = "qbx-core"
elseif GetResourceState("ox_core") ~= "missing" then
    Core = "ox"
    OxCore = require '@ox_core/lib/init'
else
    GetCore:reject("Could not find a framework!")
    return
end


if Path == 'client' then
    function Framework.GetPlayerThirst()
        if Core == "LEGACYCORE" then
            return exports.LEGACYCORE:GetPlayerThirst()
        elseif Core == "es_extended" then
            local p = promise:new()

            local thirst = nil
            TriggerEvent('esx_status:getStatus', "thirst", function(status)
                if status then
                    thirst = (status.val / 10000)
                    p:resolve(thirst)
                end
            end)
            return Citizen.Await(p)
        elseif Core == "qb-core" then
            local Data = QBCore.Functions.GetPlayerData()
            return Data and Data.metadata.thirst
        elseif Core == "qbx-core" then
            local Data = QBX.PlayerData
            return Data and Data.metadata.thirst
        elseif Core == "ox" then
            local player = OxCore.GetPlayer()
            return player.getStatus("thirst")
        end
    end

    function Framework.GetPlayerHunger()
        if Core == "LEGACYCORE" then
            return exports.LEGACYCORE:GetPlayerHunger()
        elseif Core == "es_extended" then
            local p = promise:new()

            local hunger = nil
            TriggerEvent('esx_status:getStatus', "hunger", function(status)
                if status then
                    hunger = (status.val / 10000)
                    p:resolve(hunger)
                end
            end)
            return Citizen.Await(p)
        elseif Core == "qb-core" then
            local Data = QBCore.Functions.GetPlayerData()
            return Data and Data.metadata.hunger
        elseif Core == "qbx-core" then
            local Data = QBX.PlayerData
            return Data and Data.metadata.hunger
        elseif Core == "ox" then
            local player = OxCore.GetPlayer()
            return player.getStatus("hunger")
        end
    end

    if Core == "LEGACYCORE" then
        RegisterNetEvent('LegacyCore:PlayerLoaded')
        AddEventHandler('LegacyCore:PlayerLoaded', function(...)
            TriggerEvent("LGF_Hud:PlayerLoaded", ...)
        end)
    elseif Core == "es_extended" then
        RegisterNetEvent('esx:playerLoaded')
        AddEventHandler('esx:playerLoaded', function(...)
            TriggerEvent("LGF_Hud:PlayerLoaded", ...)
        end)
    elseif Core == "qb-core" or Core == "qbx-core" then
        RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
        AddEventHandler('QBCore:Client:OnPlayerLoaded', function(...)
            TriggerEvent("LGF_Hud:PlayerLoaded", ...)
        end)
    elseif Core == "ox" then
        RegisterNetEvent('ox:playerLoaded')
        AddEventHandler('ox:playerLoaded', function(...)
            TriggerEvent("LGF_Hud:PlayerLoaded", ...)
        end)
    end

    if Core == "LEGACYCORE" then
        AddEventHandler('LegacyCore:PlayerLogout', function(...)
            TriggerEvent("LGF_Hud:PlayerUnloaded", ...)
        end)
    elseif Core == "es_extended" then
        RegisterNetEvent('esx:onPlayerLogout')
        AddEventHandler('esx:onPlayerLogout', function(...)
            TriggerEvent("LGF_Hud:PlayerUnloaded", ...)
        end)
    elseif Core == "qb-core" or Core == "qbx-core" then
        RegisterNetEvent('QBCore:Client:OnPlayerUnload')
        AddEventHandler('QBCore:Client:OnPlayerUnload', function(...)
            TriggerEvent("LGF_Hud:PlayerUnloaded", ...)
        end)
    elseif Core == "ox" then
        RegisterNetEvent('ox:playerLogout')
        AddEventHandler('ox:playerLogout', function(...)
            TriggerEvent("LGF_Hud:PlayerUnloaded", ...)
        end)
    end
end

if Path == 'server' then

end
