import Quickshell
import QtQuick

PopupWindow {
    id: tooltip
    property alias text: label.text
    property var targetItem: null

    visible: false
    color: "transparent"

    anchor.item: targetItem
    anchor.edges: Edges.Bottom
    anchor.margins.top: 4

    Rectangle {
        anchors.fill: parent
        color: root.surface1
        radius: 6
        border.color: root.surface2

        Text {
            id: label
            anchors.centerIn: parent
            color: root.text
            font.pixelSize: root.fontSize - 1
            font.family: root.fontFamily
            padding: 8
        }
    }

    implicitWidth: label.implicitWidth + 16
    implicitHeight: label.implicitHeight + 12
}
