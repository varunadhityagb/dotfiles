import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtCore
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Wayland._WlrLayerShell
import "."

PanelWindow {
    id: root
    exclusiveZone: 0
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    implicitWidth: 420 + 24
    implicitHeight: 500 + 24
    color: "transparent"
    anchors { top: true; bottom: false; left: false; right: true }

    MouseArea {
        anchors.fill: parent
        z: 0
        onClicked: Qt.quit()
    }

    Item {
        anchors.fill: parent
        anchors.margins: 12

        MouseArea {
            anchors.fill: parent
            z: 1
            onClicked: {}
        }

        Shortcut {
            sequence: "Escape"
            onActivated: Qt.quit()
        }

        CalendarPanel {
            anchors.fill: parent
            z: 2
        }
    }
}
