import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import "../models"
import "./PillBtn.qml"

PillBtn {
    visible: MediaModel.playing
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.leftMargin: 12
    height: 40
    radius: 25
    color: Qt.alpha(root.base, 0.85)
    border.color: root.surface1
    border.width: 1

    content: RowLayout {
        spacing: 6

        Text {
            id: playerIcon
            anchors.left : parent.left
            anchors.leftMargin: 3
            text: MediaModel.icon
            color: rootBar.blue
            font.pixelSize: rootBar.fontSize + 4
            font.family: rootBar.fontFamily
        }

        Item {
            id: clipper

            Layout.maximumWidth: 250
            implicitHeight: mediaText.height
            implicitWidth: Math.min(mediaText.contentWidth, 260)

            anchors.left: playerIcon.right
            anchors.leftMargin: 3

            clip: true

            Text {
                id: mediaText

                text: MediaModel.title

                color: rootBar.text
                font.pixelSize: rootBar.fontSize
                font.family: rootBar.fontFamily

                x: marquee.running ? -marqueeOffset : 0

                property real marqueeOffset: 0

                SequentialAnimation on marqueeOffset {
                    id: marquee

                    running: mediaText.contentWidth > clipper.width

                    loops: Animation.Infinite

                    PauseAnimation {
                        duration: 1000
                    }

                    NumberAnimation {
                        from: 0
                        to: mediaText.contentWidth - clipper.width + 20
                        duration: 8000
                        easing.type: Easing.Linear
                    }

                    PauseAnimation {
                        duration: 1000
                    }

                    ScriptAction {
                        script: mediaText.marqueeOffset = 0
                    }
                }
            }
        }
    }
}
