pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

Text {
    id: clockText
    property var calPopup: null

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

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (clockText.calPopup) {
                clockText.calPopup.targetItem = clockText
                clockText.calPopup.visible = !clockText.calPopup.visible
            }
        }
    }
}
