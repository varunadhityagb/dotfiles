pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

PopupWindow {
    id: calendarPopup

    property var parentWin: null
    property Item targetItem: null
    property var notifHistory: []
    signal removeHistory(int id)
    signal clearAllHistory()

    visible: false
    anchor.item: targetItem
    anchor.edges: Edges.Bottom
    anchor.margins.top: 8
    color: "transparent"

    implicitWidth: 300
    implicitHeight: Math.min(staticCol.implicitHeight + historyScroll.contentHeight + 48, 600)

    property date displayDate: new Date()
    property int displayMonth: displayDate.getMonth()
    property int displayYear: displayDate.getFullYear()

    function prevMonth() {
        displayDate = new Date(displayYear, displayMonth - 1, 1)
    }
    function nextMonth() {
        displayDate = new Date(displayYear, displayMonth + 1, 1)
    }

    property list<int> calDays: {
        var firstDay = new Date(displayYear, displayMonth, 1).getDay()
        var daysInMonth = new Date(displayYear, displayMonth + 1, 0).getDate()
        var cells = []
        for (var i = 0; i < firstDay; i++) cells.push(0)
        for (var d = 1; d <= daysInMonth; d++) cells.push(d)
        while (cells.length % 7 !== 0) cells.push(0)
        return cells
    }

    property int todayDay: new Date().getDate()
    property int todayMonth: new Date().getMonth()
    property int todayYear: new Date().getFullYear()

    Rectangle {
        anchors.fill: parent
        color: root.base
        radius: 16
        border.color: root.surface1
        clip: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // ── static part (calendar + clock) ──
            ColumnLayout {
                id: staticCol
                Layout.fillWidth: true
                spacing: 12

                // header
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "󰍞"
                        color: root.blue
                        font.pixelSize: root.fontSize
                        font.family: root.fontFamily
                        MouseArea {
                            anchors.fill: parent
                            onClicked: calendarPopup.prevMonth()
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        text: Qt.formatDate(calendarPopup.displayDate, "MMMM yyyy")
                        color: root.text
                        font.pixelSize: root.fontSize
                        font.family: root.fontFamily
                        font.bold: true
                    }

                    Text {
                        text: "󰍟"
                        color: root.blue
                        font.pixelSize: root.fontSize
                        font.family: root.fontFamily
                        MouseArea {
                            anchors.fill: parent
                            onClicked: calendarPopup.nextMonth()
                        }
                    }
                }

                // day headers
                GridLayout {
                    Layout.fillWidth: true
                    columns: 7
                    columnSpacing: 0
                    rowSpacing: 4

                    Repeater {
                        model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                        Text {
                            required property string modelData
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter
                            text: modelData
                            color: root.subtext0
                            font.pixelSize: root.fontSize - 2
                            font.family: root.fontFamily
                            font.bold: true
                        }
                    }

                    Repeater {
                        model: calendarPopup.calDays

                        Rectangle {
                            required property int modelData
                            required property int index
                            Layout.fillWidth: true
                            Layout.preferredHeight: 28
                            radius: 14

                            property bool isToday: modelData !== 0
                                                   && modelData === calendarPopup.todayDay
                                                   && calendarPopup.displayMonth === calendarPopup.todayMonth
                                                   && calendarPopup.displayYear === calendarPopup.todayYear

                            color: isToday ? root.blue : "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: parent.modelData === 0 ? "" : parent.modelData
                                color: parent.isToday ? root.base : root.text
                                font.pixelSize: root.fontSize - 1
                                font.family: root.fontFamily
                                font.bold: parent.isToday
                            }
                        }
                    }
                }

                // clock
                Text {
                    id: popupClock
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.formatDateTime(new Date(), "hh:mm:ss AP")
                    color: root.subtext0
                    font.pixelSize: root.fontSize - 1
                    font.family: root.fontFamily

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: popupClock.text = Qt.formatDateTime(new Date(), "hh:mm:ss AP")
                    }
                }

                // separator
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: root.surface1
                }

                // history header
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Notification History"
                        color: root.subtext0
                        font.pixelSize: root.fontSize - 2
                        font.family: root.fontFamily
                        font.bold: true
                        Layout.fillWidth: true
                    }

                    Text {
                        text: "Clear all"
                        color: root.red
                        font.pixelSize: root.fontSize - 3
                        font.family: root.fontFamily
                        visible: calendarPopup.notifHistory.length > 0
                        MouseArea {
                            anchors.fill: parent
                            onClicked: calendarPopup.clearAllHistory()
                        }
                    }
                }
            }

            // ── scrollable history ──
            ScrollView {
                id: historyScroll
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AsNeeded

                ColumnLayout {
                    width: historyScroll.width
                    spacing: 10

                    Text {
                        text: "No notifications"
                        color: root.surface2
                        font.pixelSize: root.fontSize - 2
                        font.family: root.fontFamily
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                        visible: calendarPopup.notifHistory.length === 0
                    }

                    Repeater {
                        model: calendarPopup.notifHistory

                        RowLayout {
                            required property var modelData
                            width: historyScroll.width
                            spacing: 8

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 1

                                Text {
                                    text: modelData.summary !== "" ? modelData.summary : "(no summary)"
                                    color: root.text
                                    font.pixelSize: root.fontSize - 1
                                    font.family: root.fontFamily
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: (modelData.appName !== "" ? modelData.appName : "Unknown")
                                          + " · " + Qt.formatTime(modelData.time, "hh:mm AP")
                                    color: root.subtext0
                                    font.pixelSize: root.fontSize - 3
                                    font.family: root.fontFamily
                                }
                            }

                            Text {
                                text: "✕"
                                color: root.subtext0
                                font.pixelSize: root.fontSize - 3
                                font.family: root.fontFamily
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: calendarPopup.removeHistory(modelData.id)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
