import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "./../components"

Rectangle {
    id: root
    width: 400
    radius: 16
    color: Qt.alpha(rootBar.base, 0.97)
    border.color: rootBar.surface1
    border.width: 1
    implicitHeight: calBody.implicitHeight + 32
    height: implicitHeight
    clip: true

    // Properties to be wired from Bar
    property var rootBar
    property int viewMonth: new Date().getMonth()
    property int viewYear: new Date().getFullYear()
    property int today: new Date().getDate()
    property int todayMonth: new Date().getMonth()
    property int todayYear: new Date().getFullYear()
    property var history: []

    readonly property var monthNames: [
        "January","February","March","April","May","June",
        "July","August","September","October","November","December"
    ]

    readonly property var calDays: {
        let days = []
        let firstDay   = new Date(viewYear, viewMonth, 1).getDay()
        let daysInMonth= new Date(viewYear, viewMonth + 1, 0).getDate()
        let daysInPrev = new Date(viewYear, viewMonth, 0).getDate()
        for (let i = firstDay - 1; i >= 0; i--)
            days.push({ day: daysInPrev - i, month: "prev", isToday: false })
        for (let d = 1; d <= daysInMonth; d++)
            days.push({ day: d, month: "cur",
                isToday: d === today && viewMonth === todayMonth && viewYear === todayYear })
        let rem = 42 - days.length
        for (let n = 1; n <= rem; n++)
            days.push({ day: n, month: "next", isToday: false })
        return days
    }

    ColumnLayout {
        id: calBody
        anchors.fill: parent
        anchors.margins: 16
        spacing: 6

        // Month nav
        RowLayout {
            Layout.fillWidth: true
            Rectangle {
                width: 28; height: 28; radius: 8
                color: prevMonMa.containsMouse ? "#1affffff" : "transparent"
                Text { anchors.centerIn: parent; text: "󰍞"; font.family: rootBar.fontFamily; font.pixelSize: 14; color: rootBar.overlay0 }
                MouseArea { id: prevMonMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                    onClicked: { if (root.viewMonth === 0) { root.viewMonth = 11; root.viewYear-- } else root.viewMonth-- } }
            }
            Item { Layout.fillWidth: true }
            Text {
                text: root.monthNames[root.viewMonth] + "  " + root.viewYear
                font.family: rootBar.fontFamily; font.pixelSize: 15; font.bold: true; color: rootBar.text
            }
            Item { Layout.fillWidth: true }
            Rectangle {
                width: 28; height: 28; radius: 8
                color: nextMonMa.containsMouse ? "#1affffff" : "transparent"
                Text { anchors.centerIn: parent; text: "󰍟"; font.family: rootBar.fontFamily; font.pixelSize: 14; color: rootBar.overlay0 }
                MouseArea { id: nextMonMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                    onClicked: { if (root.viewMonth === 11) { root.viewMonth = 0; root.viewYear++ } else root.viewMonth++ } }
            }
        }

        // Day headers
        Row {
            Layout.fillWidth: true; spacing: 0
            Repeater {
                model: ["Su","Mo","Tu","We","Th","Fr","Sa"]
                delegate: Item {
                    readonly property int cellSize: 52
                    width: cellSize
                    height: cellSize
                    Text {
                        anchors.centerIn: parent; text: modelData
                        font.family: rootBar.fontFamily; font.pixelSize: 11; font.bold: true
                        color: (index === 0 || index === 6) ? rootBar.mauve : rootBar.subtext0
                        opacity: 0.8
                    }
                }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#14ffffff" }

        // Calendar grid
        Grid {
            Layout.fillWidth: true
            columns: 7; spacing: 2
            Repeater {
                model: root.calDays
                delegate: Item {
                    property bool isCur: modelData.month === "cur"
                    property bool isToday: modelData.isToday
                    readonly property int cellSize: 52
                    width: cellSize
                    height: cellSize
                    Rectangle {
                        anchors.fill: parent; radius: width/2
                        color: isToday ? rootBar.mauve : "transparent"
                    }
                    Text {
                        anchors.centerIn: parent; text: modelData.day
                        font.family: rootBar.fontFamily; font.pixelSize: 12
                        font.bold: isToday
                        color: isToday ? rootBar.crust : (isCur ? rootBar.text : rootBar.overlay0)
                        opacity: isCur ? 1.0 : 0.3
                    }
                }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#14ffffff" }

        // Notification history header
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 10
            Text {
                text: "NOTIFICATIONS"; color: rootBar.subtext0
                font.family: rootBar.fontFamily; font.pixelSize: 14; font.bold: true; font.letterSpacing: 1.2
                Layout.fillWidth: true
            }
            Text {
                text: "Clear all"; color: rootBar.red
                font.family: rootBar.fontFamily; font.pixelSize: 10
                visible: root.history.length > 0
                MouseArea { anchors.fill: parent; onClicked: rootBar.clearAllHistory() }
            }
        }

        // History list
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(notifList.contentHeight, 180)
            Layout.minimumHeight: 60
            clip: true

            ListView {
                id: notifList
                anchors.fill: parent
                model: root.history
                spacing: 4
                clip: true
                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                delegate: Rectangle {
                    required property var modelData
                    width: notifList.width; height: 44; radius: 8
                    color: "#08ffffff"
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 10; spacing: 8
                        ColumnLayout {
                            Layout.fillWidth: true; spacing: 2
                            Text {
                                text: modelData.summary !== "" ? modelData.summary : "(no summary)"
                                color: rootBar.text; font.family: rootBar.fontFamily; font.pixelSize: 12; font.bold: true
                                elide: Text.ElideRight; Layout.fillWidth: true
                            }
                            Text {
                                text: (modelData.appName || "Unknown") + "  ·  " + Qt.formatTime(modelData.time, "hh:mm AP")
                                color: rootBar.subtext0; font.family: rootBar.fontFamily; font.pixelSize: 10
                            }
                        }
                        Text {
                            text: "✕"; color: rootBar.subtext0; font.pixelSize: 11; font.family: rootBar.fontFamily
                            MouseArea { anchors.fill: parent; onClicked: rootBar.removeHistory(modelData.id) }
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: root.history.length === 0
                    text: "No notifications"
                    color: rootBar.surface2; font.family: rootBar.fontFamily; font.pixelSize: 12
                }
            }
        }

        Item { height: 4 }
    }
}
