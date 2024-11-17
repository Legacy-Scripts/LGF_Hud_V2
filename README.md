# LGF Hud

Simple HUD and Car HUD for Various Framework


## All Components
![LGF HUD1](https://i.ibb.co/qDVN2C0/2.png)

### Hud Stats
![LGF HUD2](https://i.ibb.co/mXJS9TL/image.png)

## Notifications
![LGF HUD3](https://i.ibb.co/54qn6pY/5-removebg-preview.png)
![LGF HUD4](https://i.ibb.co/LvDpLFf/3-removebg-preview.png)
![LGF HUD5](https://i.ibb.co/cQXSb3S/4-removebg-preview.png)
![LGF HUD6](https://i.ibb.co/tDSMJhH/image-removebg-preview-7.png)



## Framework Compatibility

- OX Core
- Legacy Core
- ESX
- Qbox
- Qb-Core

## Exports HUD 

```lua
---@param boolean | Enable or Disable HUD Components (no refering to Car HUD)
exports.LGF_Hud_V2:toggleHUD(true) -- Enables the HUD
exports.LGF_Hud_V2:toggleHUD(false) -- Disables the HUD
```

## Exports Notification

```lua
---@class NotifyData
---@field Title string The title of the notification.
---@field Message string The message body of the notification.
---@field Type "success"|"error"|"info" The type of notification.
---@field Duration number Duration of the notification in milliseconds.
---@field Position "top"|"top-left"|"top-right"|"bottom-left"|"bottom-right"|"bottom" Position of the notification
---@field Effect "line"|"progress" The visual effect for the notification.

exports.LGF_Hud_V2:sendNotify({
    Title = "New Notification",
    Message = "You have received a notification!",
    Type = "info",
    Duration = 5000,
    Position = "top-left",
    Effect = "progress"
})
```

## Events

### Client Side

```lua
TriggerEvent("LGF_HudV2:addNotify", {
    Title = "Notification Title",
    Message = "This is a client-triggered notification.",
    Type = "success",
    Duration = 5000,
    Position = "top-left",
    Effect = "progress"
})
```

### Server Side

```lua
TriggerClientEvent("LGF_HudV2:addNotify", targetID, {
    Title = "Server Notification",
    Message = "This notification was triggered by the server.",
    Type = "info", -- Options: "success", "error", "info"
    Duration = 5000, -- Duration in milliseconds
    Position = "top-left",
    Effect = "progress"
})
```
