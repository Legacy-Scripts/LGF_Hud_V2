Nui = {}
LocalPlayer.state.HudBusy = false

function Nui.toggleNui(action, data)
    if action == "openHud" then
        SendNUIMessage({ action = action, data = { Visible = data.Visible, PlayerData = data.PlayerData } })
    end
    if action == "openSpeedometer" then
        SendNUIMessage({ action = action, data = { Visible = data.Visible, VehicleData = data.VehicleData } })
    end
    if action == "sendNoty" then
        SendNUIMessage({ action = action, data = { NotifyData = data.NotifyData, Visible = data.Visible } })
    end
end
