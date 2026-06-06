pragma ComponentBehavior: Bound


import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth

Text {
    id: bluetoothText
    property var ccPopup: null
    Layout.rightMargin: 12


    property var adapter: Bluetooth.defaultAdapter
    property var connectedDevices: adapter ? adapter.devices.values.filter(d => d.connected) : []

    property string icon: {
        if (!adapter || !adapter.enabled)
            return "󰂲"

        if (connectedDevices.length > 0)
            return "󰂱"

        return "󰂯"
    }

    text: (connectedDevices.length && connectedDevices[0].batteryAvailable) > 0 ? icon + " " + Math.round(connectedDevices[0].battery*100) + "%": icon

    color: {
        if (!adapter || !adapter.enabled)
            return root.red

        if (connectedDevices.length > 0)
            return "#55CC55"

        return root.blue
    }

    font.pixelSize: root.fontSize
    font.family: root.fontFamily
    font.bold: true

    Tooltip {
        id: bluetoothTooltip

        targetItem: bluetoothText

        property string deviceList: {
            if (!adapter)
                return "No adapter"

            if (connectedDevices.length === 0)
                return "No connected devices"

            return connectedDevices
                .map(d => "• " + d.name)
                .join("\n")
        }

        text: {
            if (!adapter)
                return "Bluetooth unavailable"

            return "Bluetooth: "
                + (adapter.enabled ? "On" : "Off")
                + "\n\n"
                + deviceList
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: bluetoothTooltip.visible = true
        onExited: bluetoothTooltip.visible = false
        onClicked: {
            if (bluetoothText.ccPopup) {
                bluetoothText.ccPopup.targetItem = bluetoothText
                bluetoothText.ccPopup.visible = !bluetoothText.ccPopup.visible
            }
        }
    }
}
