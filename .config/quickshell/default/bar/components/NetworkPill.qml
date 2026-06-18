import QtQuick
import QtQuick.Layouts
import "./PillBtn.qml"
import "../models"

PillBtn {
    content: RowLayout {
        spacing: 4
        Text { text: NetworkModel.icon; font.family: rootBar.fontFamily; font.pixelSize: rootBar.fontSize; font.bold: true; color: NetworkModel.connected ? rootBar.blue : rootBar.red }
        Text { text: NetworkModel.connected ? (NetworkModel.connectedNetwork ? NetworkModel.connectedNetwork.name : "Wi-Fi") : "No Net"; font.family: rootBar.fontFamily; font.pixelSize: rootBar.fontSize - 1; font.bold: true; color: NetworkModel.connected ? rootBar.blue : rootBar.red }
    }
    Tooltip {
        text: NetworkModel.tooltipText
        targetItem: root
    }
}
