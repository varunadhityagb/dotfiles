pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts

PopupWindow {
    id: calendarPopup
    property var parentWin: null
    property Item targetItem: null
    visible: false
    anchor.item: targetItem
    anchor.edges: Edges.Bottom
    anchor.margins.top: 8

    // anchor.window: parentWin
    // anchor.rect.x: parentWin ? parentWin.width - calendarPopup.implicitWidth - 16 : 0
    // anchor.rect.y: parentWin ? parentWin.height : 0
    color: "transparent"

    implicitWidth: 280
    implicitHeight: 300

    // calendar state lives here on the root
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

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
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

                // day cells
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
        }
    }
}
