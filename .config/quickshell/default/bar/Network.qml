pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Networking

Text {
    id: networkText
    property var ccPopup: null
    Layout.rightMargin: 12

    property var wifiDev: {
        var d = Networking.devices.values.find(d => d.type === DeviceType.Wifi)
        return d ? d as WifiDevice : null
    }

    property var wiredDev: {
        var d = Networking.devices.values.find(d => d.type === DeviceType.Wired)
        return d ? d as WiredDevice : null
    }

    property bool wiredConnected: wiredDev !== null && wiredDev.state === ConnectionState.Connected

    property var connectedNetwork: wifiDev ? wifiDev.networks.values.find(n => n.connected) : null

    property real signalStrength: connectedNetwork ? connectedNetwork.signalStrength : 0

    property string ipAddress: ""

    property string wifiIcon: {
        if (!connectedNetwork) return "󰤭"

        let s = connectedNetwork.signalStrength
        if (s > 0.75) return "󰤨"
        if (s > 0.50) return "󰤥"
        if (s > 0.25) return "󰤢"
        return "󰤟"
    }

    text: {
        if (wiredConnected) return "󰈀 Wired"
        if (wifiDev && wifiDev.state === ConnectionState.Connected)
            return wifiIcon + "  " + (wifiDev ? connectedNetwork.name : "")
        return "󰤭 No Network"
    }

    color: {
        if (wiredConnected || (wifiDev && wifiDev.state === ConnectionState.Connected))
            return root.blue
        return root.red
    }

    font.pixelSize: root.fontSize
    font.family: root.fontFamily
    font.bold: true

    Process {
        id: ipProc

        property string deviceName : {
            if (networkText.wiredDev) return networkText.wiredDev.name
            else if (networkText.wifiDev) return networkText.wifiDev.name
            return ""
        }
        command: ["nmcli", "-g", "IP4.ADDRESS", "device", "show", ipProc.deviceName]

        stdout: SplitParser {
            onRead: line => {
                networkText.ipAddress = line.trim()
            }
        }
    }

    Component.onCompleted: ipProc.running = true

    Tooltip {
        id: networkTooltip
        targetItem: networkText
        text: networkText.wiredDev ? networkText.ipAddress : networkText.ipAddress + " (" + Math.round(networkText.signalStrength*100) + "%) " + WifiSecurityType.toString(networkText.connectedNetwork.security)
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: networkTooltip.visible = true
        onExited: networkTooltip.visible = false
        onClicked: {
            if (networkText.ccPopup) {
                networkText.ccPopup.targetItem = networkText
                networkText.ccPopup.visible = !networkText.ccPopup.visible
            }
        }
    }
}
