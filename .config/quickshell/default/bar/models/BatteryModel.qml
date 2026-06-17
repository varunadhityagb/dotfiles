pragma Singleton
import QtQuick
import Quickshell.Services.UPower

QtObject {
    property var device: {
        var bat = UPower.devices.values.find(d => d.isLaptopBattery)
        return bat ?? UPower.displayDevice
    }

    property real percentage: device ? device.percentage : 0
    property bool charging: device ? device.state === UPowerDeviceState.Charging : false
    property real health: device ? device.healthPercentage : 0

    property string icon: {
        if (!device || !device.ready) return "󰂄"
        var p = percentage
        if (charging) return "󰂄"
        if (p > 0.9) return "󰁹"
        if (p > 0.7) return "󰂀"
        if (p > 0.5) return "󰁾"
        if (p > 0.3) return "󰁼"
        if (p > 0.1) return "󰁺"
        return "󰂃"
    }

    property string tooltipText: {
        if (!device || !device.ready) return "Battery unavailable"

        var seconds = 0
        var timeText = ""
        if (device.timeToFull == 0 && charging) {
            seconds = device.timeToEmpty
            timeText = "\nTime to Empty: " + Math.floor(seconds / 3600) + "h " + Math.floor((seconds % 3600) / 60) + "m "
        } else if (!charging) {
            timeText = ""
        } else {
            seconds = device.timeToFull
            timeText = "\nTime to Full: " + Math.floor(seconds / 3600) + "h " + Math.floor((seconds % 3600) / 60) + "m "
        }

        return "Health: " + Math.round(health) + "%" + timeText
    }
}
