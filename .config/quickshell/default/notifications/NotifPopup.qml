pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick
import "./"

PanelWindow {
    id: popup

    property var notifications: []
    signal dismiss(int id)

    // limit to 5 visible
    property var visibleNotifications: notifications.slice(-5)

    visible: notifications.length > 0
    color: "transparent"

    anchors.top: true
    anchors.right: true
    exclusionMode: ExclusionMode.Ignore

    implicitWidth: 500
    implicitHeight: cardCol.height + 60

    margins.top: 5
    margins.right: 5

    Column {
        id: cardCol
        anchors.top: parent.top
        anchors.right: parent.right
        width: 500
        spacing: 8

        move: Transition {
            NumberAnimation {
                properties: "y"
                duration: 180
                easing.type: Easing.OutCubic
            }
        }

        add: Transition {
            NumberAnimation {
                properties: "y"
                duration: 180
                easing.type: Easing.OutCubic
            }
        }
    }

    Instantiator {
        model: popup.visibleNotifications
        delegate: NotifCard {
            required property var modelData
            notifData: modelData
            width: 500
            parent: cardCol
            onDismissed: id => popup.dismiss(id)
        }
    }
}
