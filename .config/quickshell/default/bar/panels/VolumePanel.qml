import QtQuick
import QtQuick.Layouts
import "./../components"
import "../models"

Rectangle {
    id: root
    width: 320
    implicitHeight: 200
    height: 100
    radius: 25
    color: Qt.alpha(rootBar.base, 0.97)
    border.color: rootBar.surface1
    border.width: 1
    clip: true

    property var rootBar

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

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
}
