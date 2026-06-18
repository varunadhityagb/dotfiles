pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: osd

    anchors.bottom: true
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    implicitWidth: 250
    implicitHeight: 50


    margins.bottom: 100

    visible: osdVisible
    property bool osdVisible: false

    property string icon: "󰕾"
    property real value: 0.5
    property string label: "Volume"
    property bool muted: false

    Timer {
        id: hideTimer
        interval: 2000
        repeat: false
        onTriggered: osd.osdVisible = false
    }

    function show(ico, val, lbl) {
        icon = ico
        value = val
        label = lbl
        osdVisible = true
        hideTimer.restart()
    }

    IpcHandler {
        target: "osd"

        function volume(val: string, muted: string) {
            console.log()
            var v = parseFloat(val) / 100
            var isMuted = muted === "true" || muted === "1" || muted === "yes"
            var ico = isMuted ? "󰝟" : v === 0 ? "󰝟" : v < 0.33 ? "󰕿" : v < 0.66 ? "󰖀" : "󰕾"
            osd.muted = isMuted
            osd.show(ico, v, "Volume")
        }

        function brightness(val: string) {
            var v = parseFloat(val) / 100
            var ico = v < 0.33 ? "󰃞" : v < 0.66 ? "󰃟" : "󰃠"
            osd.show(ico, v, "Brightness")
        }

        function monitor(val: string) {
            var v = parseFloat(val) / 100
            var ico = v < 0.33 ? "󰃞" : v < 0.66 ? "󰃟" : "󰃠"
            osd.show(ico, v, "Monitor")
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.alpha(root.base, 0.8)
        radius: 25
        border.color: root.surface1

        opacity: osd.osdVisible ? 1 : 0
        scale: osd.osdVisible ? 1 : 0.95

        Behavior on opacity {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }
        Behavior on scale {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 12

            Text {
                text: osd.icon
                color: root.blue
                font.pixelSize: 24
                font.family: root.fontFamily
                Layout.leftMargin: 8
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6

                Text {
                    text: osd.label + "  " + (osd.muted ? "Muted" : Math.round(osd.value * 100) + "%")
                    color: root.text
                    font.pixelSize: root.fontSize
                    font.family: root.fontFamily
                    font.bold: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.rightMargin: 8
                    height: 6
                    radius: 3
                    color: root.surface2

                    Rectangle {
                        width: parent.width * Math.min(osd.value, 1.0)
                        height: parent.height
                        radius: parent.radius
                        color: osd.muted ? root.subtext0 : osd.value > 1.0 ? root.red : root.blue

                        Behavior on width {
                            NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
                        }
                    }
                }
            }
        }
    }
}
