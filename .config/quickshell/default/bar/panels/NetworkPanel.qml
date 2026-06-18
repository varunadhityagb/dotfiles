import QtQuick
import QtQuick.Layouts
import "./../components"
import "../models"

Rectangle {
    id: root
    width: 320
    implicitHeight: content.implicitHeight + 32
    height: implicitHeight
    radius: 16
    color: Qt.alpha(rootBar.base, 0.97)
    border.color: rootBar.surface1
    border.width: 1
    clip: true

    property var rootBar

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Connected Network Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4
            visible: NetworkModel.connected

            Text {
                text: "Connected"; color: rootBar.subtext0
                font.family: rootBar.fontFamily; font.pixelSize: 10; font.bold: true; font.letterSpacing: 1.2
            }
            Text {
                text: NetworkModel.connectedNetwork ? NetworkModel.connectedNetwork.name : "Wi-Fi"; color: rootBar.text
                font.family: rootBar.fontFamily; font.pixelSize: 13; font.bold: true
            }
            Text {
                text: NetworkModel.ipAddress; color: rootBar.subtext0
                font.family: rootBar.fontFamily; font.pixelSize: 11
            }
            Text {
                text: NetworkModel.connectedNetwork ? Math.round(NetworkModel.signalStrength * 100) + "%" : ""; color: rootBar.subtext0
                font.family: rootBar.fontFamily; font.pixelSize: 11
            }
        }

        // Available Networks
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8
            visible: true

            RowLayout {
                Layout.fillWidth: true
                Text { text: NetworkModel.icon; font.family: rootBar.fontFamily; font.pixelSize: 18; color: NetworkModel.connected ? rootBar.blue : rootBar.subtext0 }
                Text { text: "Available Networks"; color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 13; font.bold: true; Layout.fillWidth: true }
                Text { text: "󰑐"; color: rootBar.blue; font.family: rootBar.fontFamily; font.pixelSize: 13
                    MouseArea { anchors.fill: parent; onClicked: if (NetworkModel.wifiDev) NetworkModel.wifiDev.requestScan() } }
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
}
