import QtQuick
import QtQuick.Layouts
import "./../components"
import "../models"

Rectangle {
    id: root
    width: 320
    implicitHeight: 180
    height: 180
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

        RowLayout { Layout.fillWidth: true; spacing: 14
            Text { text: BatteryModel.icon; font.family: rootBar.fontFamily; font.pixelSize: 32; color: BatteryModel.charging ? "#55CC55" : (BatteryModel.percentage < 0.2 ? rootBar.red : rootBar.blue) }
            ColumnLayout { Layout.fillWidth: true; spacing: 4
                Text { text: BatteryModel.device ? Math.round(BatteryModel.percentage * 100) + "%" : "—"; color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 24; font.bold: true }
                Text { text: BatteryModel.charging ? "Charging" : (BatteryModel.percentage < 0.2 ? "Low" : "On battery"); color: BatteryModel.charging ? "#55CC55" : (BatteryModel.percentage < 0.2 ? rootBar.red : rootBar.subtext0); font.family: rootBar.fontFamily; font.pixelSize: 11 }
            }
        }
        Rectangle { Layout.fillWidth: true; height: 8; radius: 4; color: rootBar.surface2
            Rectangle { width: parent.width * (BatteryModel.device ? BatteryModel.percentage : 0); height: parent.height; radius: parent.radius; color: BatteryModel.charging ? "#55CC55" : (BatteryModel.percentage < 0.2 ? rootBar.red : rootBar.blue); Behavior on width { NumberAnimation { duration: 500 } } }
        }
        RowLayout { Layout.fillWidth: true
            Text { text: "Health: " + Math.round(BatteryModel.health) + "%"; color: rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 11; Layout.fillWidth: true }
            Text {
                text: {
                    if (!BatteryModel.device) return ""
                    var s = BatteryModel.charging ? BatteryModel.device.timeToFull : BatteryModel.device.timeToEmpty
                    if (!s || s === 0) return ""
                    return Math.floor(s/3600) + "h " + Math.floor((s % 3600) / 60) + "m"
                }
                color: rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 11
            }
        }
    }
}
