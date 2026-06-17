import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "./../components"
import "../models"

Rectangle {
    id: root
    width: 320
    radius: 16
    color: Qt.alpha(rootBar.base, 0.97)
    border.color: rootBar.surface1
    border.width: 1
    implicitHeight: 600
    clip: true

    property var rootBar

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 20

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: parent.width
                spacing: 20

                // ── QUICK TOGGLES ─────────────────────────────────────────────────
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        text: "QUICK TOGGLES"; color: rootBar.subtext0
                        font.family: rootBar.fontFamily; font.pixelSize: 10; font.bold: true; font.letterSpacing: 1.2
                    }

                    RowLayout {
                        Layout.fillWidth: true; spacing: 6

                        // DND Toggle (placeholder for actual implementation)
                        Rectangle {
                            width: 44; height: 28; radius: 8
                            color: rootBar.blue; opacity: 0.5
                            Text { anchors.centerIn: parent; text: "󰂛"; color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 14 }
                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
                        }

                        // Example other toggle
                        Rectangle {
                            width: 44; height: 28; radius: 8
                            color: rootBar.surface2
                            Text { anchors.centerIn: parent; text: "󰏵"; color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 14 }
                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
                        }
                    }
                }

                // ── NETWORKS ──────────────────────────────────────────────────────
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: NetworkModel.icon; font.family: rootBar.fontFamily; font.pixelSize: 18; color: NetworkModel.connected ? rootBar.blue : rootBar.subtext0 }
                        Text { text: "Wi-Fi"; color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 13; font.bold: true; Layout.fillWidth: true }
                        Text { text: "󰑐"; color: rootBar.blue; font.family: rootBar.fontFamily; font.pixelSize: 13
                            MouseArea { anchors.fill: parent; onClicked: if (NetworkModel.wifiDev) NetworkModel.wifiDev.requestScan() } }
                        Rectangle {
                            width: 40; height: 22; radius: 11
                            color: NetworkModel.connected ? rootBar.blue : rootBar.surface2
                            Text { anchors.centerIn: parent; text: NetworkModel.connected ? "On" : "Off"; color: NetworkModel.connected ? rootBar.base : rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 10 }
                        }
                    }
                    Repeater {
                        model: NetworkModel.wifiDev ? NetworkModel.wifiDev.networks.values.slice().sort((a,b) => b.signalStrength - a.signalStrength).slice(0,5) : []
                        delegate: Rectangle {
                            required property var modelData
                            width: parent ? parent.width : 0; height: 32; radius: 8
                            color: modelData.connected ? Qt.alpha(rootBar.blue, 0.15) : "transparent"
                            RowLayout { anchors.fill: parent; anchors.margins: 8; spacing: 8
                                Text { text: modelData.signalStrength > 0.75 ? "󰤨" : modelData.signalStrength > 0.5 ? "󰤥" : "󰤢"; color: modelData.connected ? rootBar.blue : rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 12 }
                                Text { text: modelData.name; color: modelData.connected ? rootBar.blue : rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 11; font.bold: modelData.connected; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.connected ? "󰅙" : "󰅒"; color: modelData.connected ? rootBar.red : rootBar.blue; font.family: rootBar.fontFamily; font.pixelSize: 12
                                    MouseArea { anchors.fill: parent; onClicked: modelData.connected ? modelData.disconnect() : modelData.connectNetwork() } }
                            }
                        }
                    }
                }

                // ── BLUETOOTH ─────────────────────────────────────────────────────
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: BluetoothModel.icon; font.family: rootBar.fontFamily; font.pixelSize: 20; color: BluetoothModel.enabled ? rootBar.blue : rootBar.subtext0 }
                        ColumnLayout { Layout.fillWidth: true; spacing: 1
                            Text { text: "Bluetooth"; color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 13; font.bold: true }
                            Text { text: BluetoothModel.connectedDevices.length > 0 ? BluetoothModel.connectedDevices.map(d => d.name).join(", ") : "No devices"; color: rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 11; elide: Text.ElideRight; Layout.fillWidth: true }
                        }
                        Rectangle { width: 40; height: 22; radius: 11; color: BluetoothModel.enabled ? rootBar.blue : rootBar.surface2
                            MouseArea { anchors.fill: parent; onClicked: BluetoothModel.adapter.enabled = !BluetoothModel.adapter.enabled }
                            Text { anchors.centerIn: parent; text: BluetoothModel.enabled ? "On" : "Off"; color: BluetoothModel.enabled ? rootBar.base : rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 10 }
                        }
                    }
                }

                // ── VOLUME ─────────────────────────────────────────────────────────
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    RowLayout {
                        Layout.fillWidth: true; spacing: 10
                        Text { text: VolumeModel.icon; font.family: rootBar.fontFamily; font.pixelSize: 22; color: rootBar.blue
                            MouseArea { anchors.fill: parent; onClicked: VolumeModel.toggleMute() } }
                        ColumnLayout { Layout.fillWidth: true; spacing: 6
                            Text { text: "Volume  " + Math.round(VolumeModel.volume * 100) + "%"; color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 13; font.bold: true }
                            Rectangle { Layout.fillWidth: true; height: 6; radius: 3; color: rootBar.surface2
                                Rectangle { width: parent.width * Math.min(VolumeModel.volume, 1.0); height: parent.height; radius: parent.radius; color: rootBar.blue }
                                MouseArea { anchors.fill: parent; onClicked: mouse => { VolumeModel.setVolume(mouse.x / width) } }
                            }
                        }
                    }
                    // Media
                    Rectangle {
                        Layout.fillWidth: true; height: 58; radius: 10; color: rootBar.surface0
                        visible: MediaModel.player !== null
                        RowLayout { anchors.fill: parent; anchors.margins: 10; spacing: 8
                            ColumnLayout { Layout.fillWidth: true; spacing: 2
                                Text { text: MediaModel.title; color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 11; font.bold: true; elide: Text.ElideRight; Layout.fillWidth: true }
                                Text { text: MediaModel.artist; color: rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 10; elide: Text.ElideRight; Layout.fillWidth: true }
                            }
                            RowLayout { spacing: 8
                                Text { text: "󰒮"; color: rootBar.mauve; font.family: rootBar.fontFamily; font.pixelSize: 15; MouseArea { anchors.fill: parent; onClicked: MediaModel.previous() } }
                                Text { text: MediaModel.player && MediaModel.player.playbackState === MprisPlaybackState.Playing ? "󰏤" : "󰐊"; color: rootBar.mauve; font.family: rootBar.fontFamily; font.pixelSize: 15
                                    MouseArea { anchors.fill: parent; onClicked: MediaModel.playPause() } }
                                Text { text: "󰒭"; color: rootBar.mauve; font.family: rootBar.fontFamily; font.pixelSize: 15; MouseArea { anchors.fill: parent; onClicked: MediaModel.next() } }
                            }
                        }
                    }
                }

                // ── BATTERY ───────────────────────────────────────────────────────
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    RowLayout { Layout.fillWidth: true; spacing: 14
                        Text { text: BatteryModel.icon; font.family: rootBar.fontFamily; font.pixelSize: 32; color: BatteryModel.charging ? "#55CC55" : (BatteryModel.percentage < 0.2 ? rootBar.red : rootBar.blue) }
                        ColumnLayout { Layout.fillWidth: true; spacing: 4
                            Text { text: BatteryModel.device ? Math.round(BatteryModel.percentage * 100) + "%" : "—"; color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 24; font.bold: true }
                            Text { text: BatteryModel.charging ? "Charging" : (BatteryModel.percentage < 0.2 ? "Low" : "On battery"); color: BatteryModel.charging ? "#55CC55" : (BatteryModel.percentage < 0.2 ? rootBar.red : rootBar.subtext0); font.family: rootBar.fontFamily; font.pixelSize: 11 }
                        }
                    }
                    Rectangle { Layout.fillWidth: true; height: 8; radius: 4; color: rootBar.surface2
                        Rectangle { width: parent.width * (BatteryModel.device ? BatteryModel.percentage : 0); height: parent.height; radius: parent.radius; color: BatteryModel.charging ? "#55CC55" : (BatteryModel.percentage < 0.2 ? rootBar.red : rootBar.blue); Behavior on width { NumberAnimation { duration: 500 } } }
                    }
                    RowLayout { Layout.fillWidth: true
                        Text { text: "Health: " + Math.round(BatteryModel.health) + "%"; color: rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 11; Layout.fillWidth: true }
                        Text {
                            text: {
                                if (!BatteryModel.device) return ""
                                var s = BatteryModel.charging ? BatteryModel.device.timeToFull : BatteryModel.device.timeToEmpty
                                if (!s || s === 0) return ""
                                return Math.floor(s/3600) + "h " + Math.floor((s/3600)/60) + "m"
                            }
                            color: rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 11
                        }
                    }
                }
            }
        }
    }

    // Close button (floating)
    Text {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 10
        anchors.rightMargin: 10
        text: "✕"; color: rootBar.overlay0; font.pixelSize: 12; font.family: rootBar.fontFamily
        MouseArea { anchors.fill: parent; onClicked: rootBar.expandedPill = "" }
    }
}
