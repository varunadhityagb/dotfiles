import QtQuick
import QtQuick.Layouts
import "../models"

ColumnLayout {
    Layout.fillWidth: true
    spacing: 8

    Text {
        text: "QUICK TOGGLES"; color: rootBar.subtext0
        font.family: rootBar.fontFamily; font.pixelSize: 10; font.bold: true; font.letterSpacing: 1.2
    }

    RowLayout {
        Layout.fillWidth: true; spacing: 6

        // DND Toggle (placeholder for actual implementation)
        Rectangle {
            width: 44; height: 28; radius: 8
            color: rootBar.blue; opacity: 0.5
            Text { anchors.centerIn: parent; text: "󰂛"; color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 14 }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
        }

        // Example other toggle
        Rectangle {
            width: 44; height: 28; radius: 8
            color: rootBar.surface2
            Text { anchors.centerIn: parent; text: "󰏵"; color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 14 }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
        }
    }
}
