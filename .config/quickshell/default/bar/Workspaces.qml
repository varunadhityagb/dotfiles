pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

RowLayout {
    spacing: 0

    Repeater {
        model: {
            var ids = Hyprland.workspaces.values.map(ws => ws.id).filter(id => id > 0)
            var min = [1,2,3,4,5]
            var merged = [...new Set([...min, ...ids])].sort((a,b) => a - b)
            return merged
        }

        Rectangle {
            required property int modelData
            id: workspaceIndicator
            Layout.preferredWidth: 20
            Layout.preferredHeight: 40
            Layout.leftMargin: 16
            color: "transparent"

            property bool isActive: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id === modelData : false
            property var wsObj: Hyprland.workspaces.values.find(ws => ws.id === modelData) ?? null
            property bool isUrgent: wsObj ? wsObj.urgent : false

            Rectangle {
                visible: parent.isActive
                width: 25
                height: 25
                radius: 25
                anchors.centerIn: parent
                color: root.blue
                opacity: 0.08
            }

            Rectangle {
                visible: parent.isActive
                width: 20
                height: 20
                radius: 20
                anchors.centerIn: parent
                color: root.blue
                opacity: 0.15
            }

            Rectangle {
                visible: parent.isUrgent
                width: 25
                height: 25
                radius: 25
                anchors.centerIn: parent
                color: root.red
                opacity: 0.3
            }

            Text {
                text: workspaceIndicator.modelData
                color: parent.isActive ? root.blue : (parent.isUrgent ? root.red : root.text)
                font.pixelSize: root.fontSize
                font.family: root.fontFamily
                font.weight: parent.isActive ? 900 : 400
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + workspaceIndicator.modelData + " })")
            }
        }
    }

    // Text {
    //     id: windowCount
    //     Layout.rightMargin: 8
    //     Layout.leftMargin: 16

    //     property int count: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.toplevels.values.length : 0

    //     text: (count <= 1 ? "" : "󰣆  " + count)
    //     color: root.blue
    //     font.pixelSize: root.fontSize
    //     font.family: root.fontFamily
    //     font.bold: true
    // }

    Text {
        id: submapText
        Layout.rightMargin: 0
        Layout.leftMargin: 16

        property string submap: ""
        visible: submap !== ""

        text: "󰘳 " + submap
        color: root.peach
        font.pixelSize: root.fontSize
        font.family: root.fontFamily
        font.bold: true

        Connections {
            target: Hyprland
            function onRawEvent(event) {
                if (event.name === "submap") {
                    submapText.submap = event.parse(1)[0]
                }
            }
        }
    }

    Text {
        text: "󱂬"
        color: root.subtext0
        font.pixelSize: root.fontSize
        font.family: root.fontFamily
        Layout.leftMargin: 8
        MouseArea {
            anchors.fill: parent
            onClicked: if (bar.overviewPopup) bar.overviewPopup.visible = !bar.overviewPopup.visible
        }
    }
}
