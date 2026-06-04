pragma ComponentBehavior: Bound
//@ pragma UseQApplication
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "./"

ShellRoot {
    id: root

    MatugenColors { id: _theme }
    readonly property color base: _theme.base
    readonly property color crust: _theme.crust
    readonly property color mantle: _theme.mantle
    readonly property color text: _theme.text
    readonly property color subtext0: _theme.subtext0
    readonly property color overlay0: _theme.overlay0
    readonly property color overlay2: _theme.overlay2
    readonly property color surface0: _theme.surface0
    readonly property color surface1: _theme.surface1
    readonly property color surface2: _theme.surface2

    readonly property color mauve: _theme.mauve
    readonly property color red: _theme.red
    readonly property color peach: _theme.peach
    readonly property color blue: _theme.blue
    readonly property color green: _theme.green

    // Font
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14


    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData

            anchors {
                top: true
            }

            implicitHeight: 50
            implicitWidth: 1200
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

                    // hyprland
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
                            Layout.preferredHeight: parent.height
                            Layout.leftMargin: 16
                            color: "transparent"

                            property var workspace: Hyprland.workspaces.values.find(ws => ws.id === modelData) ?? null
                            property bool isActive: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id === modelData : false

                            Text {
                                text: workspaceIndicator.modelData
                                color: parent.isActive ? root.blue : root.text
                                font.pixelSize: root.fontSize
                                font.family: root.fontFamily
                                font.weight: parent.isActive ? 900 : 400
                                anchors.centerIn: parent
                            }

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

                            MouseArea {
                                anchors.fill: parent
                                onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + workspaceIndicator.modelData + " })")
                            }
                        }
                    }

                    // middle space
                    Item {
                        Layout.leftMargin: 8
                        Layout.rightMargin: 8
                        Layout.fillWidth: true
                    }

                    // system tray
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
                                onClicked: mouse => {
                                    if (mouse.button === Qt.RightButton)
                                        menuAnchor.open()
                                    else
                                        modelData.activate()
                                }
                            }
                        }

                        }
                    }

                    // separator
                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: 16
                        Layout.alignment: Qt.AlignVCenter
                        Layout.leftMargin: 0
                        Layout.rightMargin: 8
                        color: root.surface2
                    }

                    // clock
                    Text {
                        id: clockText
                        text: Qt.formatDateTime(new Date(), "ddd MMM dd \n hh:mm AP")
                        color: root.blue
                        font.pixelSize: root.fontSize
                        font.family: root.fontFamily
                        font.bold: true
                        Layout.rightMargin: 16


                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            onTriggered: clockText.text = Qt.formatDateTime(new Date(), "ddd MMM dd \n hh:mm AP")
                        }
                    }

                }
            }
        }
    }
}
