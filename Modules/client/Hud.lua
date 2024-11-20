--[[REQUIRE]]
local Notify = require "Modules.client.Notify"
local Config = require "Shared.Config"

--[[VARS]]
local lang = Config.Lang

--[[NATIVES]]
local CreateThread = CreateThread
local GetGameTimer = GetGameTimer
local PlayerId = PlayerId
local GetPlayerServerId = GetPlayerServerId
local PlayerPedId = PlayerPedId
local IsPedSwimming = IsPedSwimming
local GetEntityHealth = GetEntityHealth
local GetPedArmour = GetPedArmour
local NetworkIsPlayerTalking = NetworkIsPlayerTalking
local GetPlayerUnderwaterTimeRemaining = GetPlayerUnderwaterTimeRemaining
local Wait = Wait

--[[FUNCTIONS]]

---@param state boolean | Enable or disable the HUD.
local function BuildHUD(state)
    LocalPlayer.state.HudBusy = state
    CreateThread(function()
        local lastUpdate = 0
        local lastProx = LocalPlayer.state.proximity.distance
        while LocalPlayer.state.HudBusy do
            local currentTime = GetGameTimer()
            if currentTime - lastUpdate >= 1000 then
                lastUpdate = currentTime
                PlayerID = cache?.playerId or PlayerId()
                ServerID = cache?.serverId or GetPlayerServerId(PlayerID)
                PlayerPed = cache?.ped or PlayerPedId()

                local InSwim = IsPedSwimming(PlayerPed)

                local playerData = {
                    Thirst = math.ceil(Framework.GetPlayerThirst()),
                    Hunger = math.ceil(Framework.GetPlayerHunger()),
                    Health = GetEntityHealth(PlayerPed) / 2,
                    PlayerID = ServerID,
                    Armor = math.ceil(GetPedArmour(PlayerPed)),
                    Stamina = GetPlayerStamina(PlayerID),
                    Street = Functions.GetHashKeyStreet(),
                    IsTalking = NetworkIsPlayerTalking(PlayerID) == 1,
                    Prox = LocalPlayer.state.proximity.distance,
                }

                playerData.Oxygen = InSwim and GetPlayerUnderwaterTimeRemaining(PlayerID) * 10 or 0

                if playerData.Prox ~= lastProx then
                    lastProx = playerData.Prox

                    Notify.sendNotification({
                        Title = Locales[lang].Proximity,
                        Message = string.format(Locales[lang].ProximityChanged, playerData.Prox),
                        Type = "info",
                        Duration = 3000,
                        Position = "top-right",
                        Effect = "progress",
                    })
                end

                Nui.toggleNui("openHud", {
                    Visible = state,
                    PlayerData = playerData,
                })
            end

            Wait(500)
        end
    end)
end

--[[EVENTS]]
RegisterNetEvent("LGF_Hud:PlayerLoaded", function()
    -- prevent premature loading
    Wait(700)
    BuildHUD(true)
    Functions.loadMinimap(true)
    if Config.EnableNotificationEvent then
        Notify.sendNotification({ Title = "HUD Loaded", Message = Locales[lang].HUDLoaded, Type = "success",  Duration = 3000,Position = "top-left", Effect = "progress", })
    end
end)



RegisterNetEvent("LGF_Hud:PlayerUnloaded", function()
    Nui.toggleNui("openHud", { Visible = false, PlayerData = {} })
    BuildHUD(false)
    Functions.loadMinimap(false)
    if Config.EnableNotificationEvent then
        Notify.sendNotification({Title = "HUD Unloaded", Message = Locales[lang].HUDUnloaded, Type = "success", Duration = 3000, Position = "top-left", Effect = "progress", })
    end
end)

--[[COMMANDS]]
RegisterCommand("hud", function(source, args)
    local state = args[1]
    if state == "off" then
        Nui.toggleNui("openHud", { Visible = false, PlayerData = {} })
        BuildHUD(false)
        Functions.loadMinimap(false)
        Notify.sendNotification({ Title = "HUD Disabled", Message = Locales[lang].HUDDisabled, Type = "info", Duration = 3000, Position = "top-right", Effect = "progress", })
    elseif state == "on" then
        BuildHUD(true)
        Functions.loadMinimap(true)
        Notify.sendNotification({ Title = "HUD Enabled", Message = Locales[lang].HUDEnabled, Type = "warning", Duration = 3000, Position = "top-right",  Effect = "progress", })
    else
        Notify.sendNotification({ Title = "Error",  Message = Locales[lang].Error,  Type = "error", Duration = 3000, Position = "top-right", Effect = "progress", })
    end
end)

--[[EXPORTS]]
exports("toggleHUD", function(state)
    if type(state) ~= "boolean" then
        warn("Invalid parameter. Expected 'true' or 'false'.")
        return
    end
    if state then
        BuildHUD(true)
        Functions.loadMinimap(true)
    else
        Nui.toggleNui("openHud", { Visible = false, PlayerData = {} })
        BuildHUD(false)
        Functions.loadMinimap(false)
    end
end)
