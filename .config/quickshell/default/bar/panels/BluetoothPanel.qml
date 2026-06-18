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

        RowLayout {
            Layout.fillWidth: true
            Text { text: BluetoothModel.icon; font.family: rootBar.fontFamily; font.pixelSize: 20; color: BluetoothModel.enabled ? rootBar.blue : rootBar.subtext0 }
            ColumnLayout { Layout.fillWidth: true; spacing: 1
                Text { text: "Bluetooth"; color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 13; font.bold: true }
                Text { text: BluetoothModel.enabled ? "Active" : "Disabled"; color: rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 11 }
            }
            Rectangle { width: 40; height: 22; radius: 11; color: BluetoothModel.enabled ? rootBar.blue : rootBar.surface2
                MouseArea { anchors.fill: parent; onClicked: BluetoothModel.adapter.enabled = !BluetoothModel.adapter.enabled }
                Text { anchors.centerIn: parent; text: BluetoothModel.enabled ? "On" : "Off"; color: BluetoothModel.enabled ? rootBar.base : rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 10 }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8
            visible: BluetoothModel.connectedDevices.length > 0

            Text {
                text: "Connected Devices"; color: rootBar.subtext0
                font.family: rootBar.fontFamily; font.pixelSize: 10; font.bold: true; font.letterSpacing: 1.2
            }
            Repeater {
                model: BluetoothModel.connectedDevices
                delegate: RowLayout {
                    Layout.fillWidth: true
                    Text { text: modelData.name; color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 12; Layout.fillWidth: true }
                    Text {
                        text: modelData.batteryAvailable ? Math.round(modelData.battery * 100) + "%" : ""
                        color: rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 11
                    }
                }
            }
        }
    }
}
