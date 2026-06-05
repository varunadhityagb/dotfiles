pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

RowLayout {
    spacing: 4
    Layout.rightMargin: 8

    Repeater {
        model: SystemTray.items

        delegate: Item {
            required property var modelData

            implicitWidth: 18
            implicitHeight: 18

            Image {
                anchors.fill: parent
                source: modelData.icon
                fillMode: Image.PreserveAspectFit
            }

            QsMenuAnchor {
                id: menuAnchor
                menu: modelData.menu
                anchor.item: trayItem
                anchor.margins.top: 10
            }

            MouseArea {
                id: trayItem
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouse => {menuAnchor.open()}
            }
        }
    }
}
