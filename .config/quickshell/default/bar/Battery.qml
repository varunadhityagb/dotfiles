pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

Text {
    id: batteryText
    Layout.rightMargin: 8

    visible: device !== null && device.ready

    property var device: {
        var bat = UPower.devices.values.find(d => d.isLaptopBattery)
        return bat ?? UPower.displayDevice
    }
    property string icon: {
        if (!device.ready) return "󰂄"
        var p = device.percentage
        if (device.state === UPowerDeviceState.Charging) return "󰂄"
        if (p > 0.9) return "󰁹"
        if (p > 0.7) return "󰂀"
        if (p > 0.5) return "󰁾"
        if (p > 0.3) return "󰁼"
        if (p > 0.1) return "󰁺"
        return "󰂃"
    }

    text: icon + " " + Math.round(device.percentage * 100) + "%"
    color: {
        if (device.state === UPowerDeviceState.Charging) return "#55CC55"
        if (device.percentage < 0.2) return root.red
        return root.blue
    }
    font.pixelSize: root.fontSize
    font.family: root.fontFamily
    font.bold: true

    Tooltip {
        id: batteryTooltip
        targetItem: batteryText
        property string timeText : {
            var seconds = 0
            if (batteryText.device.timeToFull == 0 && batteryText.device.state === UPowerDeviceState.Charging ) {
                seconds = batteryText.device.timeToEmpty
                return "\nTime to Empty: " + Math.floor(seconds / 3600) + "h " + Math.floor((seconds % 3600) / 60) + "m "
            } else if (batteryText.device.state !== UPowerDeviceState.Charging) {
                return ""
            } else {
                seconds = batteryText.device.timeToFull
                return "\nTime to Full: " + Math.floor(seconds / 3600) + "h " + Math.floor((seconds % 3600) / 60) + "m "
            }
        }
        text: "Health: " + Math.round(batteryText.device.healthPercentage) + "%" + timeText
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: batteryTooltip.visible = true
        onExited: batteryTooltip.visible = false
    }
}
