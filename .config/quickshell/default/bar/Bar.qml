pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import Quickshell.Networking
import Quickshell.Bluetooth
import Quickshell.Services.Mpris
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import "./"
import "./components"
import "./panels"
import "./models"

PanelWindow {
    id: bar

    property bool dnd: false
    property int historyCount: 0

    property var notifHistory: []
    signal removeHistory(int id)
    signal clearAllHistory()

    anchors.top: true
    implicitWidth: screen ? screen.width : 1920
    color: "transparent"
    exclusiveZone: 44

    implicitHeight: {
        if (expandedPill === "middle") return 44 + 6 + calendarContent.height
        if (expandedPill === "right") return 44 + 6 + ccContent.implicitHeight
        return 44
    }

    Behavior on implicitHeight { NumberAnimation { duration: 250; easing.type: Easing.OutQuart } }

    margins { top: 5; left: 0; right: 0 }

    // ── Theme Properties ──────────────────────────────────────────────────
    property color base: root.base
    property color crust: root.crust
    property color mantle: root.mantle
    property color text: root.text
    property color subtext0: root.subtext0
    property color overlay0: root.overlay0
    property color overlay2: root.overlay2
    property color surface0: root.surface0
    property color surface1: root.surface1
    property color surface2: root.surface2
    property color mauve: root.mauve
    property color red: root.red
    property color peach: root.peach
    property color blue: root.blue
    property color green: root.green
    property string fontFamily: root.fontFamily
    property int fontSize: root.fontSize

    // ── Expansion state ──────────────────────────────────────────────────
    property string expandedPill: ""

    function toggleMiddle() {
        expandedPill = (expandedPill === "middle") ? "" : "middle"
    }
    function toggleRight() {
        expandedPill = (expandedPill === "right") ? "" : "right"
    }

    // ── Clock ────────────────────────────────────────────────────────────
    property string clockDate: Qt.formatDateTime(new Date(), "ddd MMM dd")
    property string clockTime: Qt.formatDateTime(new Date(), "hh:mm AP")
    property string clockSec:  Qt.formatDateTime(new Date(), "hh:mm:ss AP")
    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {
            bar.clockDate = Qt.formatDateTime(new Date(), "ddd MMM dd")
            bar.clockTime = Qt.formatDateTime(new Date(), "hh:mm AP")
            bar.clockSec  = Qt.formatDateTime(new Date(), "hh:mm:ss AP")
        }
    }

    // ════════════════════════════════════════════════════════════════════
    Item {
        id: pillRow
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 44

        // ── LEFT PILL: Workspaces ──────────────────────────────────────
        Rectangle {
            id: leftPill
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 8
            height: 38
            radius: 19
            color: Qt.alpha(root.base, 0.85)
            border.color: root.surface1
            border.width: 1
            z: 10

            implicitWidth: leftPillRow.implicitWidth + 16
            width: implicitWidth

            RowLayout {
                id: leftPillRow
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 4
                spacing: 0

                Workspaces {}
            }
        }

        // ── MIDDLE PILL: Clock ────────────────────────────────────────
        Item {
            id: middleAnchor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            width: middlePill.width
            z: 20

            Rectangle {
                id: middlePill
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                height: 38
                radius: 19
                color: Qt.alpha(root.base, 0.85)
                border.color: bar.expandedPill === "middle" ? root.mauve : root.surface1
                border.width: 1
                Behavior on border.color { ColorAnimation { duration: 200 } }
                Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutQuart } }

                width: bar.expandedPill === "middle"
                    ? (expandedHeader.implicitWidth + 40)
                    : (collapsedContent.implicitWidth + 32)

                RowLayout {
                    id: collapsedContent
                    anchors.centerIn: parent
                    spacing: 8
                    visible: bar.expandedPill !== "middle"

                    Text { text: "󰃰"; font.family: root.fontFamily; font.pixelSize: 13; color: root.mauve }
                    Text { text: bar.clockDate; font.family: root.fontFamily; font.pixelSize: 13; font.bold: true; color: root.subtext0 }
                    Text { text: bar.clockTime; font.family: root.fontFamily; font.pixelSize: 13; font.bold: true; color: root.blue }
                    Text {
                        visible: bar.dnd || bar.historyCount > 0
                        text: bar.dnd ? "󰂛" : "󰂚 " + bar.historyCount
                        color: root.blue; font.family: root.fontFamily; font.pixelSize: 13; font.bold: true
                    }
                }

                RowLayout {
                    id: expandedHeader
                    anchors.centerIn: parent
                    spacing: 10
                    visible: bar.expandedPill === "middle"

                    Text { text: bar.clockSec; font.family: root.fontFamily; font.pixelSize: 15; font.bold: true; color: root.blue }
                    Rectangle { width: 1; height: 16; color: root.surface2 }
                    Text { text: bar.clockDate; font.family: root.fontFamily; font.pixelSize: 13; color: root.subtext0 }
                    Rectangle {
                        width: 1; height: 16; color: root.surface2
                        visible: bar.dnd || bar.historyCount > 0
                    }
                    Text {
                        visible: bar.dnd || bar.historyCount > 0
                        text: bar.dnd ? "󰂛 DND" : "󰂚 " + bar.historyCount
                        color: root.blue; font.family: root.fontFamily; font.pixelSize: 12
                    }
                    Text {
                        text: "✕"; color: root.overlay0; font.pixelSize: 12; font.family: root.fontFamily
                        MouseArea { anchors.fill: parent; onClicked: bar.expandedPill = "" }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: bar.toggleMiddle()
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }

        // ── RIGHT PILL: System ────────────────────────────────────────
        Item {
            id: rightAnchor
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 8
            width: rightPill.width
            z: 20

            Rectangle {
                id: rightPill
                anchors.top: parent.top
                anchors.right: parent.right
                height: 38
                radius: 19
                color: Qt.alpha(root.base, 0.85)
                border.color: bar.expandedPill === "right" ? root.blue : root.surface1
                border.width: 1
                Behavior on border.color { ColorAnimation { duration: 200 } }
                Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutQuart } }
                width: rightPillRow.implicitWidth + 20

                RowLayout {
                    id: rightPillRow
                    anchors.centerIn: parent
                    spacing: 2

                    Tray {}

                    Rectangle { width: 1; height: 16; color: root.surface2; Layout.leftMargin: 2; Layout.rightMargin: 2 }

                    NetworkPill {
                        rootBar: root
                        active: bar.expandedPill === "right"
                        onTap: bar.toggleRight()
                    }

                    BluetoothPill {
                        rootBar: root
                        active: bar.expandedPill === "right"
                        onTap: bar.toggleRight()
                    }

                    VolumePill {
                        rootBar: root
                        active: bar.expandedPill === "right"
                        onTap: bar.toggleRight()
                    }

                    BatteryPill {
                        rootBar: root
                        active: bar.expandedPill === "right"
                        onTap: bar.toggleRight()
                        visible: BatteryModel.device !== null
                    }
                }
            }
        }
    }

    // ── PANELS: outside pillRow, never hidden, opacity-only ───────────────
    CalendarPanel {
        id: calendarContent
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: bar.expandedPill === "middle" ? 1 : 0
        // always rendered so implicitHeight is always known
        Behavior on opacity { NumberAnimation { duration: 200 } }

        rootBar: bar
        history: bar.notifHistory
    }

    ControlCenter {
        id: ccContent
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.right: parent.right
        anchors.rightMargin: 8
        opacity: bar.expandedPill === "right" ? 1 : 0
        // always rendered so implicitHeight is always known
        Behavior on opacity { NumberAnimation { duration: 200 } }

        rootBar: bar
        Component.onCompleted: {
            console.log("CC height =", height)
            console.log("CC implicitHeight =", implicitHeight)
        }
        }
}
