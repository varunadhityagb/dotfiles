import QtQuick
import QtQuick.Layouts
import "./../components"
import "../models"
import Quickshell.Services.UPower

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

        RowLayout { Layout.fillWidth: true; spacing: 14
            Text { text: BatteryModel.icon; font.family: rootBar.fontFamily; font.pixelSize: 32; color: BatteryModel.charging ? "#55CC55" : (BatteryModel.percentage < 0.2 ? rootBar.red : rootBar.blue) }
            ColumnLayout { Layout.fillWidth: true; spacing: 4
                Text { text: BatteryModel.device ? Math.round(BatteryModel.percentage * 100) + "%" : "—"; color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 24; font.bold: true }
                Text { text: BatteryModel.charging ? "Charging" : (BatteryModel.percentage < 0.2 ? "Low" : "On battery"); color: BatteryModel.charging ? "#55CC55" : (BatteryModel.percentage < 0.2 ? rootBar.red : rootBar.subtext0); font.family: rootBar.fontFamily; font.pixelSize: 11 }
            }
            Rectangle {
                width: 54
                height: 54
                radius: 12
                Layout.leftMargin: 125

                color: Qt.alpha(rootBar.surface0, 0.8)

                Text {
                    anchors.centerIn: parent

                    text: {
                        switch (PowerProfiles.profile) {
                        case PowerProfile.PowerSaver:
                            return "󰾆"

                        case PowerProfile.Performance:
                            return "󰓅"

                        default:
                            return "󰾅"
                        }
                    }

                    font.family: rootBar.fontFamily
                    font.pixelSize: 48

                    color: {
                        switch (PowerProfiles.profile) {
                        case PowerProfile.PowerSaver:
                            return rootBar.green

                        case PowerProfile.Performance:
                            return rootBar.red

                        default:
                            return rootBar.blue
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        switch (PowerProfiles.profile) {
                        case PowerProfile.PowerSaver:
                            PowerProfiles.profile = PowerProfile.Balanced
                            break

                        case PowerProfile.Balanced:
                            if (PowerProfiles.hasPerformanceProfile)
                                PowerProfiles.profile = PowerProfile.Performance
                            else
                                PowerProfiles.profile = PowerProfile.PowerSaver
                            break

                        default:
                            PowerProfiles.profile = PowerProfile.PowerSaver
                        }
                    }
                }
            }
        }
        Rectangle { Layout.fillWidth: true; height: 8; radius: 4; color: rootBar.surface2
            Rectangle { width: parent.width * (BatteryModel.device ? BatteryModel.percentage : 0); height: parent.height; radius: parent.radius; color: BatteryModel.charging ? "#55CC55" : (BatteryModel.percentage < 0.2 ? rootBar.red : rootBar.blue); Behavior on width { NumberAnimation { duration: 500 } } }
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4
            RowLayout {
                Layout.fillWidth: true
                Text { text: "Health:"; color: rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 11 }
                Item { Layout.fillWidth: true }
                Text { text: Math.round(BatteryModel.health) + "%"; color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 11 }
            }
            RowLayout {
                Layout.fillWidth: true
                Text { text: "Remaining:"; color: rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 11 }
                Item { Layout.fillWidth: true }
                Text {
                    text: {
                        if (!BatteryModel.device) return "—"
                        var s = BatteryModel.charging ? BatteryModel.device.timeToFull : BatteryModel.device.timeToEmpty
                        if (!s || s === 0) return "Calculating..."
                        return Math.floor(s/3600) + "h " + Math.floor((s % 3600) / 60) + "m"
                    }
                    color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 11
                }
            }
        }
    }
}
