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
    implicitWidth: 1020
    implicitHeight: 720
    color: "transparent"
    anchors { top: false; bottom: false; left: false; right: false }

    MouseArea {
        anchors.fill: parent
        z: 0
        onClicked: Qt.quit()
    }

    Item {
        anchors.fill: parent
        anchors.margins: 10

        MouseArea {
            anchors.fill: parent
            z: 1
            onClicked: {}
        }

        Shortcut {
            sequence: "Escape"
            onActivated: Qt.quit()
        }

        UpdatesPanel {
            anchors.fill: parent
            z: 2
        }
    }
}
