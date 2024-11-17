---@class NotifyData
---@field Title string The title of the notification.
---@field Message string The message body of the notification.
---@field Type "success"|"error"|"info"|"warning" The type of notification.
---@field Duration number Duration of the notification in milliseconds.
---@field Position "top"|"top-left"|"top-right"|"bottom-left"|"bottom-right"|"bottom" Position of the notification
---@field NotifyID string A unique identifier for the notification.
---@field Effect "line"|"progress" The visual effect for the notification.


---@class Notify
local Notify = {}

---@param data NotifyData
function Notify.sendNotification(data)
    ---@type NotifyData
    local NotifyData = {
        Title = data.Title or "LGF_Hud",
        Message = data.Message or "Forza Juve",
        Type = data.Type or "info",
        Duration = data.Duration or 5000,
        Position = data.Position or "top-left",
        NotifyID = data.NotifyID or ("%s_%s"):format(cache.resource, math.random(1000, 9999)),
        Effect = data.Effect or "progress"
    }

    Nui.toggleNui("sendNoty", {
        NotifyData = NotifyData,
        Visible = true,
    })
end

RegisterNetEvent("LGF_HudV2:addNotify", Notify.sendNotification)

exports("sendNotify", Notify.sendNotification)

return Notify

