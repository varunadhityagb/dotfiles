pragma Singleton
import QtQuick
import Quickshell.Bluetooth

QtObject {
    property var adapter: Bluetooth.defaultAdapter
    property var connectedDevices: adapter ? adapter.devices.values.filter(d => d.connected) : []

    property bool enabled: adapter ? adapter.enabled : false
    property real batteryPercent: (connectedDevices.length > 0 && connectedDevices[0].batteryAvailable) ? connectedDevices[0].battery : 0

    property string icon: {
        if (!adapter || !enabled)
            return "󰂲"

        if (connectedDevices.length > 0)
            return "󰂱"

        return "󰂯"
    }

    property string tooltipText: {
        if (!adapter)
            return "Bluetooth unavailable"

        var deviceList = ""
        if (connectedDevices.length === 0) {
            deviceList = "No connected devices"
        } else {
            deviceList = connectedDevices
                .map(d => "• " + d.name)
                .join("\n")
        }

        return "Bluetooth: "
            + (enabled ? "On" : "Off")
            + "\n\n"
            + deviceList
    }
}
