import QtQuick
import QtQuick.Layouts
import "./PillBtn.qml"
import "../models"

PillBtn {
    content: RowLayout {
        spacing: 4
        Text { text: VolumeModel.icon; font.family: rootBar.fontFamily; font.pixelSize: rootBar.fontSize; font.bold: true; color: rootBar.blue }
        Text { text: VolumeModel.muted ? "Muted" : Math.round(VolumeModel.volume * 100) + "%"; font.family: rootBar.fontFamily; font.pixelSize: rootBar.fontSize - 1; font.bold: true; color: rootBar.blue }
    }
}
