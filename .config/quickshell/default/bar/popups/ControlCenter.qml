pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris

PopupWindow {
    id: controlCenter
    property Item targetItem: null
    visible: false
    anchor.item: targetItem
    anchor.edges: Edges.Bottom
    anchor.margins.top: 8
    // anchor.window: parentWin
    // anchor.rect.x: parentWin ? parentWin.width - controlCenter.implicitWidth - 16 : 0
    // anchor.rect.y: parentWin ? parentWin.height : 0
    color: "transparent"

    implicitWidth: 320
    implicitHeight: 480

    // move all state to popup root
    property var player: Mpris.players.values.find(p => p.playbackState === MprisPlaybackState.Playing)
                         ?? Mpris.players.values[0]
                         ?? null

    property var wifiDev: {
        var d = Networking.devices.values.find(d => d.type === DeviceType.Wifi)
        return d ? d as WifiDevice : null
    }
    property var connectedNetwork: wifiDev ? wifiDev.networks.values.find(n => n.connected) : null
    property bool wifiConnected: wifiDev !== null && wifiDev.state === ConnectionState.Connected

    property var btAdapter: Bluetooth.defaultAdapter
    property var btConnected: (btAdapter && btAdapter.devices) ? btAdapter.devices.values.filter(d => d.connected) : []

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
    property real vol: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.volume : 0
    property bool muted: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.muted : false

    Rectangle {
        anchors.fill: parent
        color: root.base
        radius: 16
        border.color: root.surface1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // ── MEDIA ──
            Rectangle {
                Layout.fillWidth: true
                height: 80
                radius: 12
                color: root.surface0
                visible: controlCenter.player !== null

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text {
                            text: controlCenter.player ? controlCenter.player.trackTitle : ""
                            color: root.text
                            font.pixelSize: root.fontSize
                            font.family: root.fontFamily
                            font.bold: true
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        Text {
                            text: controlCenter.player ? controlCenter.player.trackArtist : ""
                            color: root.subtext0
                            font.pixelSize: root.fontSize - 2
                            font.family: root.fontFamily
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Text {
                            text: "󰒮"
                            color: root.mauve
                            font.pixelSize: 18
                            font.family: root.fontFamily
                            MouseArea {
                                anchors.fill: parent
                                onClicked: if (controlCenter.player) controlCenter.player.previous()
                            }
                        }
                        Text {
                            text: controlCenter.player && controlCenter.player.playbackState === MprisPlaybackState.Playing ? "󰏤" : "󰐊"
                            color: root.mauve
                            font.pixelSize: 18
                            font.family: root.fontFamily
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (!controlCenter.player) return
                                    controlCenter.player.playbackState === MprisPlaybackState.Playing
                                        ? controlCenter.player.pause()
                                        : controlCenter.player.play()
                                }
                            }
                        }
                        Text {
                            text: "󰒭"
                            color: root.mauve
                            font.pixelSize: 18
                            font.family: root.fontFamily
                            MouseArea {
                                anchors.fill: parent
                                onClicked: if (controlCenter.player) controlCenter.player.next()
                            }
                        }
                    }
                }
            }

            // ── WIFI ──
            Rectangle {
                Layout.fillWidth: true
                height: 54
                radius: 12
                color: root.surface0

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 10

                    Text {
                        text: controlCenter.wifiConnected ? "󰤨" : "󰤭"
                        color: controlCenter.wifiConnected ? root.blue : root.subtext0
                        font.pixelSize: 18
                        font.family: root.fontFamily
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        Text {
                            text: "Wi-Fi"
                            color: root.text
                            font.pixelSize: root.fontSize
                            font.family: root.fontFamily
                            font.bold: true
                        }
                        Text {
                            text: controlCenter.connectedNetwork ? controlCenter.connectedNetwork.name : "Disconnected"
                            color: root.subtext0
                            font.pixelSize: root.fontSize - 2
                            font.family: root.fontFamily
                        }
                    }

                    Rectangle {
                        width: 40
                        height: 22
                        radius: 11
                        color: controlCenter.wifiConnected ? root.blue : root.surface2
                        Text {
                            anchors.centerIn: parent
                            text: controlCenter.wifiConnected ? "On" : "Off"
                            color: controlCenter.wifiConnected ? root.base : root.subtext0
                            font.pixelSize: root.fontSize - 3
                            font.family: root.fontFamily
                        }
                    }
                }
            }

            // ── BLUETOOTH ──
            Rectangle {
                Layout.fillWidth: true
                height: 54
                radius: 12
                color: root.surface0

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 10

                    Text {
                        text: controlCenter.btConnected.length > 0 ? "󰂱" : (controlCenter.btAdapter && controlCenter.btAdapter.enabled ? "󰂯" : "󰂲")
                        color: (controlCenter.btAdapter && controlCenter.btAdapter.enabled) ? root.blue : root.subtext0
                        font.pixelSize: 18
                        font.family: root.fontFamily
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        Text {
                            text: "Bluetooth"
                            color: root.text
                            font.pixelSize: root.fontSize
                            font.family: root.fontFamily
                            font.bold: true
                        }
                        Text {
                            text: controlCenter.btConnected.length > 0
                                  ? controlCenter.btConnected.map(d => d.name).join(", ")
                                  : "No devices"
                            color: root.subtext0
                            font.pixelSize: root.fontSize - 2
                            font.family: root.fontFamily
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }

                    Rectangle {
                        width: 40
                        height: 22
                        radius: 11
                        color: (controlCenter.btAdapter && controlCenter.btAdapter.enabled) ? root.blue : root.surface2
                        MouseArea {
                            anchors.fill: parent
                            onClicked: if (controlCenter.btAdapter) controlCenter.btAdapter.enabled = !controlCenter.btAdapter.enabled
                        }
                        Text {
                            anchors.centerIn: parent
                            text: (controlCenter.btAdapter && controlCenter.btAdapter.enabled) ? "On" : "Off"
                            color: (controlCenter.btAdapter && controlCenter.btAdapter.enabled) ? root.base : root.subtext0
                            font.pixelSize: root.fontSize - 3
                            font.family: root.fontFamily
                        }
                    }
                }
            }

            // ── AUDIO ──
            Rectangle {
                Layout.fillWidth: true
                height: 54
                radius: 12
                color: root.surface0

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 10

                    Text {
                        text: controlCenter.muted ? "󰝟" : (controlCenter.vol > 0.5 ? "󰕾" : "󰖀")
                        color: root.blue
                        font.pixelSize: 18
                        font.family: root.fontFamily
                        MouseArea {
                            anchors.fill: parent
                            onClicked: if (Pipewire.defaultAudioSink) Pipewire.defaultAudioSink.audio.muted = !controlCenter.muted
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4

                        Text {
                            text: "Volume  " + Math.round(controlCenter.vol * 100) + "%"
                            color: root.text
                            font.pixelSize: root.fontSize
                            font.family: root.fontFamily
                            font.bold: true
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 6
                            radius: 3
                            color: root.surface2

                            Rectangle {
                                width: parent.width * Math.min(controlCenter.vol, 1.0)
                                height: parent.height
                                radius: parent.radius
                                color: root.blue
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: mouse => {
                                    if (Pipewire.defaultAudioSink)
                                        Pipewire.defaultAudioSink.audio.volume = mouse.x / width
                                }
                            }
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true }
        }
    }
}
