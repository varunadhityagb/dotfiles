import QtQuick
import QtQuick.Layouts
import "./../components"
import "../models"

Rectangle {
    id: root
    width: 320
    implicitHeight: 280
    height: 280
    radius: 25
    color: Qt.alpha(rootBar.base, 0.97)
    border.color: rootBar.surface1
    border.width: 1
    clip: true

    property var rootBar

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            Text { text: NetworkModel.icon; font.family: rootBar.fontFamily; font.pixelSize: 18; color: NetworkModel.connected ? rootBar.blue : rootBar.subtext0 }
            Text { text: "Wi-Fi"; color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 13; font.bold: true; Layout.fillWidth: true }
            Text { text: "󰑐"; color: rootBar.blue; font.family: rootBar.fontFamily; font.pixelSize: 13
                MouseArea { anchors.fill: parent; onClicked: if (NetworkModel.wifiDev) NetworkModel.wifiDev.requestScan() } }
            Rectangle {
                width: 40; height: 22; radius: 11
                color: NetworkModel.connected ? rootBar.blue : rootBar.surface2
                Text { anchors.centerIn: parent; text: NetworkModel.connected ? "On" : "Off"; color: NetworkModel.connected ? rootBar.base : rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 10 }
            }
        }
        Repeater {
            model: NetworkModel.wifiDev ? NetworkModel.wifiDev.networks.values.slice().sort((a,b) => b.signalStrength - a.signalStrength).slice(0,5) : []
            delegate: Rectangle {
                required property var modelData
                width: parent ? parent.width : 0; height: 32; radius: 8
                color: modelData.connected ? Qt.alpha(rootBar.blue, 0.15) : "transparent"
                RowLayout { anchors.fill: parent; anchors.margins: 8; spacing: 8
                    Text { text: modelData.signalStrength > 0.75 ? "󰤨" : modelData.signalStrength > 0.5 ? "󰤥" : "󰤢"; color: modelData.connected ? rootBar.blue : rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 12 }
                    Text { text: modelData.name; color: modelData.connected ? rootBar.blue : rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 11; font.bold: modelData.connected; Layout.fillWidth: true; elide: Text.ElideRight }
                    Text { text: modelData.connected ? "󰅙" : "󰅒"; color: modelData.connected ? rootBar.red : rootBar.blue; font.family: rootBar.fontFamily; font.pixelSize: 12
                        MouseArea { anchors.fill: parent; onClicked: modelData.connected ? modelData.disconnect() : modelData.connectNetwork() } }
                }
            }
        }
    }
}
