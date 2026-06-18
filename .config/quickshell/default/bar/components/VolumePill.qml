import QtQuick
import QtQuick.Layouts
import "./PillBtn.qml"
import "../models"

PillBtn {
    content: RowLayout {
        spacing: 4

        Text {
            text: VolumeModel.icon
            font.family: rootBar.fontFamily
            font.pixelSize: rootBar.fontSize
            font.bold: true
            color: rootBar.blue
        }

        Text {
            text: VolumeModel.muted
                ? "Muted"
                : Math.round(VolumeModel.volume * 100) + "%"

            font.family: rootBar.fontFamily
            font.pixelSize: rootBar.fontSize - 1
            font.bold: true
            color: rootBar.blue
            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons:
            Qt.LeftButton |
            Qt.MiddleButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton)
                root.tap()

            if (mouse.button === Qt.MiddleButton)
                VolumeModel.toggleMute()
        }

        onWheel: wheel => {
            let delta =
                wheel.angleDelta.y > 0
                    ? 0.05
                    : -0.05

            VolumeModel.setVolume(
                VolumeModel.volume + delta
            )
        }
    }

    Tooltip {
        text: VolumeModel.tooltipText
        targetItem: parent
    }
}
