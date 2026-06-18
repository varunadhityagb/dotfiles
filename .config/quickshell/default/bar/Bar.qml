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
        if (expandedPanel === "calendar") return 44 + 6 + calendarContent.height
        if (expandedPanel === "network") return 44 + 6 + networkContent.implicitHeight
        if (expandedPanel === "bluetooth") return 44 + 6 + bluetoothContent.implicitHeight
        if (expandedPanel === "volume") return 44 + 6 + volumeContent.implicitHeight
        if (expandedPanel === "battery") return 44 + 6 + batteryContent.implicitHeight
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
    property string expandedPanel: ""

    function toggleMiddle() {
        expandedPanel = (expandedPanel === "calendar") ? "" : "calendar"
    }
    function toggleNetwork() {
        expandedPanel = (expandedPanel === "network") ? "" : "network"
    }
    function toggleBluetooth() {
        expandedPanel = (expandedPanel === "bluetooth") ? "" : "bluetooth"
    }
    function toggleVolume() {
        expandedPanel = (expandedPanel === "volume") ? "" : "volume"
    }
    function toggleBattery() {
        console.log(batteryContent.height, batteryContent.implicitHeight)
        expandedPanel = (expandedPanel === "battery") ? "" : "battery"
        console.log(batteryContent.height, batteryContent.implicitHeight)
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
            height: 40
            radius: 25
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

        Item {
            id: mediaAnchor

            anchors.top: parent.top
            anchors.left: leftPill.right
            anchors.right: parent.right

            MediaPill {
                rootBar: bar
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
                height: 40
                radius: 25
                color: Qt.alpha(root.base, 0.85)
                border.color: bar.expandedPanel === "calendar" ? root.mauve : root.surface1
                border.width: 1
                Behavior on border.color { ColorAnimation { duration: 200 } }
                Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutQuart } }

                width: bar.expandedPanel === "calendar"
                    ? (expandedHeader.implicitWidth + 40)
                    : (collapsedContent.implicitWidth + 32)

                RowLayout {
                    id: collapsedContent
                    anchors.centerIn: parent
                    spacing: 8
                    visible: bar.expandedPanel !== "calendar"

                    Text { text: bar.clockDate; font.family: root.fontFamily; font.pixelSize: 14; font.bold: true; color: root.subtext0 }
                    Text { text: bar.clockTime; font.family: root.fontFamily; font.pixelSize: 14; font.bold: true; color: root.blue }
                    Text {
                        visible: bar.dnd || bar.historyCount > 0
                        text: bar.dnd ? "󰂛" : "󰂚 " + bar.historyCount
                        color: root.blue; font.family: root.fontFamily; font.pixelSize: 14; font.bold: true
                    }
                }

                RowLayout {
                    id: expandedHeader
                    anchors.centerIn: parent
                    spacing: 10
                    visible: bar.expandedPanel === "calendar"

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
                height: 40
                radius: 25
                color: Qt.alpha(root.base, 0.85)
                border.color: bar.expandedPanel !== "" && bar.expandedPanel !== "calendar" ? root.blue : root.surface1
                border.width: 1
                Behavior on border.color { ColorAnimation { duration: 200 } }
                Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutQuart } }
                width: rightPillRow.implicitWidth + 20

                RowLayout {
                    id: rightPillRow
                    anchors.centerIn: parent
                    spacing: 2

                    Tray {}


                    PrivacyPill {
                        rootBar: bar
                    }

                    NetworkPill {
                        rootBar: root
                        active: bar.expandedPanel === "network"
                        onTap: bar.toggleNetwork()
                    }

                    BluetoothPill {
                        rootBar: root
                        active: bar.expandedPanel === "bluetooth"
                        onTap: bar.toggleBluetooth()
                    }

                    VolumePill {
                        rootBar: root
                        active: bar.expandedPanel === "volume"
                        onTap: bar.toggleVolume()
                    }

                    BatteryPill {
                        rootBar: root
                        active: bar.expandedPanel === "battery"
                        onTap: bar.toggleBattery()
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
        opacity: bar.expandedPanel === "calendar" ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }

        rootBar: bar
        history: bar.notifHistory
    }

    NetworkPanel {
        id: networkContent
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.right: parent.right
        anchors.rightMargin: 8
        opacity: bar.expandedPanel === "network" ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }

        rootBar: bar
    }

    BluetoothPanel {
        id: bluetoothContent
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.right: parent.right
        anchors.rightMargin: 8
        opacity: bar.expandedPanel === "bluetooth" ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }

        rootBar: bar
    }

    VolumePanel {
        id: volumeContent
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.right: parent.right
        anchors.rightMargin: 8
        opacity: bar.expandedPanel === "volume" ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }

        rootBar: bar
    }

    BatteryPanel {
        id: batteryContent
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.right: parent.right
        anchors.rightMargin: 8
        opacity: bar.expandedPanel === "battery" ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }

        rootBar: bar
        Component.onCompleted: {
            console.log(batteryContent.height, batteryContent.implicitHeight)
        }
    }
}
