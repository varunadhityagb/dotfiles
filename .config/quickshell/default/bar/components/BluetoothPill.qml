import QtQuick
import QtQuick.Layouts
import "./PillBtn.qml"
import "../models"

PillBtn {
    content: RowLayout {
        spacing: 4
        Text { text: BluetoothModel.icon; font.family: rootBar.fontFamily; font.pixelSize: rootBar.fontSize; font.bold: true
            color: BluetoothModel.enabled ? (BluetoothModel.connectedDevices.length > 0 ? "#55CC55" : rootBar.blue) : rootBar.red
        }
    }
}
