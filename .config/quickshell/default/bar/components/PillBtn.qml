import QtQuick
import QtQuick.Controls

Rectangle {
    id: rootBtn
    property var rootBar
    property bool active: false
    property alias content: contentLoader.sourceComponent
    signal tap()

    height: 28
    implicitWidth: contentLoader.implicitWidth + 16
    radius: 8
    color: active ? Qt.alpha(rootBar.blue, 0.2) : (btnMa.containsMouse ? "#1affffff" : "transparent")
    Behavior on color { ColorAnimation { duration: 150 } }

    Loader {
        id: contentLoader
        anchors.centerIn: parent
    }

    MouseArea {
        id: btnMa
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: parent.tap()
    }
}
