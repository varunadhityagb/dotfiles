import QtQuick
import QtQuick.Layouts
import "./../components"
import "../models"

Rectangle {
    id: root
    width: 320
    implicitHeight: 140
    height: 140
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
            Text { text: BluetoothModel.icon; font.family: rootBar.fontFamily; font.pixelSize: 20; color: BluetoothModel.enabled ? rootBar.blue : rootBar.subtext0 }
            ColumnLayout { Layout.fillWidth: true; spacing: 1
                Text { text: "Bluetooth"; color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 13; font.bold: true }
                Text { text: BluetoothModel.connectedDevices.length > 0 ? BluetoothModel.connectedDevices.map(d => d.name).join(", ") : "No devices"; color: rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 11; elide: Text.ElideRight; Layout.fillWidth: true }
            }
            Rectangle { width: 40; height: 22; radius: 11; color: BluetoothModel.enabled ? rootBar.blue : rootBar.surface2
                MouseArea { anchors.fill: parent; onClicked: BluetoothModel.adapter.enabled = !BluetoothModel.adapter.enabled }
                Text { anchors.centerIn: parent; text: BluetoothModel.enabled ? "On" : "Off"; color: BluetoothModel.enabled ? rootBar.base : rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 10 }
            }
        }
    }
}
