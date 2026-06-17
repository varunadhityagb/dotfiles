pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Networking

Item {
    visible: false
    width: 0
    height: 0

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

    property string icon: {
        if (wiredConnected) return "󰈀"
        if (!connectedNetwork) return "󰤭"

        let s = signalStrength
        if (s > 0.75) return "󰤨"
        if (s > 0.50) return "󰤥"
        if (s > 0.25) return "󰤢"
        return "󰤟"
    }

    property bool connected: wiredConnected || (wifiDev && wifiDev.state === ConnectionState.Connected)

    property string tooltipText: {
        var base = ipAddress
        if (wiredDev) {
            return base
        } else if (connectedNetwork) {
            return base + " (" + Math.round(signalStrength * 100) + "%) " + WifiSecurityType.toString(connectedNetwork.security)
        }
        return "No network connected"
    }

    Process {
        id: ipProc
        property string deviceName : {
            if (wiredDev) return wiredDev.name
            else if (wifiDev) return wifiDev.name
            return ""
        }
        command: ["nmcli", "-g", "IP4.ADDRESS", "device", "show", ipProc.deviceName]

        stdout: SplitParser {
            onRead: line => {
                ipAddress = line.trim()
            }
        }
    }

    Component.onCompleted: ipProc.running = true
}
