import QtQuick
import QtQuick.Layouts
import "./PillBtn.qml"
import "../models"

PillBtn {
    content: RowLayout {
        spacing: 4
        Text { text: BatteryModel.icon; font.family: rootBar.fontFamily; font.pixelSize: rootBar.fontSize; font.bold: true; color: BatteryModel.charging ? "#55CC55" : (BatteryModel.percentage < 0.2 ? rootBar.red : rootBar.blue) }
        Text { text: BatteryModel.device ? Math.round(BatteryModel.percentage * 100) + "%" : ""; font.family: rootBar.fontFamily; font.pixelSize: rootBar.fontSize - 1; font.bold: true; color: BatteryModel.charging ? "#55CC55" : (BatteryModel.percentage < 0.2 ? rootBar.red : rootBar.blue) }
    }
}
