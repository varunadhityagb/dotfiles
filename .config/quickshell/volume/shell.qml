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
    implicitWidth: 380 + 24
    implicitHeight: 620 + 24
    color: "transparent"
    anchors {
        top: true
        bottom: false
        left: false
        right: true
    }

    // Background dismiss
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

        VolumePanel {
            anchors.fill: parent
            z: 2
        }
    }
}
