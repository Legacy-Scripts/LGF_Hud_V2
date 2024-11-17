local Config = {}

-- Language For Notification ecc
Config.Lang = GetConvar("LGF_HudV2:Locale", "en")

-- Notification for Loaded and Unloaded events
Config.EnableNotificationEvent = false

-- Disable Car HUD For Vehicle BlackListed
Config.VehicleBlackListed = {
    joaat("bmx"),
    joaat("cruiser"),
    joaat("fixter"),
    joaat("scorcher"),
}

Config.FuelProvider = function(vehicle)
    if GetResourceState("ox_fuel"):find("start") then
        return Entity(vehicle).state.fuel

        -- elseif GetResourceState("custom_resource"):find("start") then
        -- Add your custom resource exports
        -- return exports["custom_resource"]:FuncName(vehicle)
    else
        return GetVehicleFuelLevel(vehicle)
    end
end



return Config
