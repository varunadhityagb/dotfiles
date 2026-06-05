pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import "./"

PanelWindow {
    id: bar

    anchors.top: true
    implicitHeight: 50
    implicitWidth: 1900
    color: "transparent"

    margins {
        top: 5
        bottom: 5
        left: 0
        right: 0
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.alpha(root.base, 0.7)
        radius: 20
        border.color: root.mantle

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Workspaces {}

            Media {}

            Item {
                Layout.fillWidth: true
                Layout.leftMargin: 8
                Layout.rightMargin: 8
            }

            Tray {}

            Rectangle {
                Layout.preferredWidth: 1
                Layout.preferredHeight: 16
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: 0
                Layout.rightMargin: 8
                color: root.surface2
            }

            Network {}

            Bluetooth {}

            Volume {}

            Battery {}

            Rectangle {
                Layout.preferredWidth: 1
                Layout.preferredHeight: 16
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: 0
                Layout.rightMargin: 8
                color: root.surface2
            }

            Clock {}
        }
    }
}
