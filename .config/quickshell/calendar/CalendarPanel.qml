import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import "../"

Item {
    id: root

    MatugenColors { id: _theme }
    readonly property color base:     _theme.base
    readonly property color mantle:   _theme.mantle
    readonly property color crust:    _theme.crust
    readonly property color text:     _theme.text
    readonly property color subtext0: _theme.subtext0
    readonly property color overlay0: _theme.overlay0
    readonly property color surface0: _theme.surface0
    readonly property color surface1: _theme.surface1
    readonly property color surface2: _theme.surface2
    readonly property color mauve:    _theme.mauve
    readonly property color blue:     _theme.blue
    readonly property color green:    _theme.green
    readonly property color red:      _theme.red
    readonly property color peach:    _theme.peach
    readonly property color sapphire: _theme.sapphire
    readonly property color pink:     _theme.pink
    readonly property color yellow:   _theme.yellow

    // -------------------------------------------------------------------------
    // STATE
    // -------------------------------------------------------------------------
    property int today:        new Date().getDate()
    property int todayMonth:   new Date().getMonth()
    property int todayYear:    new Date().getFullYear()

    property int viewMonth:    todayMonth
    property int viewYear:     todayYear

    property int slideDir: 0  // -1 = going back, 1 = going forward

    readonly property var monthNames: [
        "January","February","March","April","May","June",
        "July","August","September","October","November","December"
    ]
    readonly property var dayNames: ["Su","Mo","Tu","We","Th","Fr","Sa"]

    // Build the days array for the current view
    readonly property var calDays: {
        let days = []
        let firstDay = new Date(viewYear, viewMonth, 1).getDay()
        let daysInMonth = new Date(viewYear, viewMonth + 1, 0).getDate()
        let daysInPrev = new Date(viewYear, viewMonth, 0).getDate()

        // Prev month trailing days
        for (let i = firstDay - 1; i >= 0; i--) {
            days.push({ day: daysInPrev - i, month: "prev", isToday: false })
        }
        // Current month
        for (let d = 1; d <= daysInMonth; d++) {
            let isToday = d === root.today && viewMonth === root.todayMonth && viewYear === root.todayYear
            days.push({ day: d, month: "cur", isToday: isToday })
        }
        // Next month leading days
        let remaining = 42 - days.length
        for (let n = 1; n <= remaining; n++) {
            days.push({ day: n, month: "next", isToday: false })
        }
        return days
    }

    function prevMonth() {
        slideDir = -1
        slideAnim.restart()
        if (viewMonth === 0) { viewMonth = 11; viewYear-- }
        else viewMonth--
    }

    function nextMonth() {
        slideDir = 1
        slideAnim.restart()
        if (viewMonth === 11) { viewMonth = 0; viewYear++ }
        else viewMonth++
    }

    function prevYear() {
        slideDir = -1
        slideAnim.restart()
        viewYear--
    }

    function nextYear() {
        slideDir = 1
        slideAnim.restart()
        viewYear++
    }

    function goToday() {
        slideDir = 0
        viewMonth = todayMonth
        viewYear  = todayYear
    }

    // Slide animation state
    property real slideOffset: 0
    property real gridOpacity: 1.0

    SequentialAnimation {
        id: slideAnim
        NumberAnimation { target: root; property: "gridOpacity"; to: 0; duration: 120; easing.type: Easing.OutQuad }
        NumberAnimation { target: root; property: "slideOffset"; to: root.slideDir * 30; duration: 0 }
        ParallelAnimation {
            NumberAnimation { target: root; property: "gridOpacity"; to: 1.0; duration: 250; easing.type: Easing.OutQuart }
            NumberAnimation { target: root; property: "slideOffset"; to: 0; duration: 250; easing.type: Easing.OutQuart }
        }
    }

    // Ambient animation
    property real globalOrbitAngle: 0
    NumberAnimation on globalOrbitAngle {
        from: 0; to: Math.PI * 2; duration: 90000
        loops: Animation.Infinite; running: true
    }

    // Intro
    property real introMain: 0
    NumberAnimation on introMain {
        from: 0; to: 1.0; duration: 700; easing.type: Easing.OutQuart; running: true
    }

    // -------------------------------------------------------------------------
    // UI
    // -------------------------------------------------------------------------
    opacity: introMain
    transform: Scale {
        origin.x: root.width / 2; origin.y: root.height / 2
        xScale: 0.92 + 0.08 * root.introMain
        yScale: 0.92 + 0.08 * root.introMain
    }

    Rectangle {
        anchors.fill: parent
        radius: 18
        color: root.base
        border.color: root.surface0
        border.width: 1
        clip: true

        // Ambient blobs
        Rectangle {
            width: parent.width * 0.8; height: width; radius: width / 2
            x: (parent.width/2 - width/2) + Math.cos(root.globalOrbitAngle * 2) * 100
            y: (parent.height/2 - height/2) + Math.sin(root.globalOrbitAngle * 2) * 80
            opacity: 0.07; color: root.mauve
            Behavior on color { ColorAnimation { duration: 1000 } }
        }
        Rectangle {
            width: parent.width * 0.9; height: width; radius: width / 2
            x: (parent.width/2 - width/2) + Math.sin(root.globalOrbitAngle * 1.5) * -100
            y: (parent.height/2 - height/2) + Math.cos(root.globalOrbitAngle * 1.5) * -80
            opacity: 0.05; color: root.blue
            Behavior on color { ColorAnimation { duration: 1000 } }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16

            // =============================================
            // HEADER — Year navigation
            // =============================================
            RowLayout {
                Layout.fillWidth: true

                // Prev year
                NavBtn { icon: "󰙣"; onTapped: root.prevYear() }

                Item { Layout.fillWidth: true }

                Text {
                    text: root.viewYear
                    font.family: "JetBrains Mono"
                    font.pixelSize: 15
                    font.weight: Font.Bold
                    color: root.subtext0
                }

                Item { Layout.fillWidth: true }

                // Next year
                NavBtn { icon: "󰙡"; onTapped: root.nextYear() }
            }

            // =============================================
            // MONTH ROW
            // =============================================
            RowLayout {
                Layout.fillWidth: true

                // Prev month
                NavBtn { icon: "󰍞"; onTapped: root.prevMonth() }

                Item { Layout.fillWidth: true }

                Text {
                    text: root.monthNames[root.viewMonth]
                    font.family: "JetBrains Mono"
                    font.pixelSize: 26
                    font.weight: Font.Black
                    color: root.text
                    opacity: root.gridOpacity
                    transform: Translate { x: root.slideOffset }
                }

                Item { Layout.fillWidth: true }

                // Next month
                NavBtn { icon: "󰍟"; onTapped: root.nextMonth() }
            }

            // =============================================
            // TODAY BUTTON
            // =============================================
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                visible: root.viewMonth !== root.todayMonth || root.viewYear !== root.todayYear
                height: 26
                width: todayBtnRow.width + 20
                radius: 8
                color: todayBtnMa.containsMouse ? "#1affffff" : "#0dffffff"
                border.color: todayBtnMa.containsMouse ? root.mauve : "#1affffff"
                border.width: 1
                Behavior on color { ColorAnimation { duration: 150 } }

                RowLayout {
                    id: todayBtnRow
                    anchors.centerIn: parent
                    spacing: 6
                    Text { text: "󰃰"; font.family: "Iosevka Nerd Font"; font.pixelSize: 13; color: root.mauve }
                    Text { text: "Today"; font.family: "JetBrains Mono"; font.pixelSize: 12; font.weight: Font.Bold; color: root.text }
                }
                MouseArea {
                    id: todayBtnMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.goToday()
                }
            }

            // =============================================
            // DAY HEADERS
            // =============================================
            Row {
                Layout.fillWidth: true
                spacing: 0

                Repeater {
                    model: root.dayNames
                    delegate: Item {
                        width: (root.width - 40) / 7
                        height: 28
                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            font.family: "JetBrains Mono"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            color: (index === 0 || index === 6) ? root.mauve : root.subtext0
                            opacity: 0.8
                        }
                    }
                }
            }

            // Thin separator
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#1affffff"
            }

            // =============================================
            // CALENDAR GRID
            // =============================================
            Grid {
                Layout.fillWidth: true
                columns: 7
                spacing: 4

                opacity: root.gridOpacity
                transform: Translate { x: root.slideOffset }

                Repeater {
                    model: root.calDays

                    delegate: Item {
                        width: (root.width - 40 - 6 * 4) / 7
                        height: width

                        property bool isCur:   modelData.month === "cur"
                        property bool isToday: modelData.isToday
                        property bool isWeekend: {
                            // figure out day of week for this cell
                            let firstDay = new Date(root.viewYear, root.viewMonth, 1).getDay()
                            let dow = (index) % 7
                            return dow === 0 || dow === 6
                        }

                        Rectangle {
                            anchors.fill: parent
                            radius: width / 2
                            color: isToday ? root.mauve : (dayMa.containsMouse && isCur ? "#1affffff" : "transparent")
                            Behavior on color { ColorAnimation { duration: 150 } }

                            // Today ring pulse
                            Rectangle {
                                visible: isToday
                                anchors.centerIn: parent
                                width: parent.width + 6
                                height: width; radius: width / 2
                                color: "transparent"
                                border.color: root.mauve
                                border.width: 2
                                opacity: todayPulse
                                property real todayPulse: 0.5
                                SequentialAnimation on todayPulse {
                                    loops: Animation.Infinite; running: isToday
                                    NumberAnimation { to: 0.0; duration: 1200; easing.type: Easing.InOutSine }
                                    NumberAnimation { to: 0.5; duration: 1200; easing.type: Easing.InOutSine }
                                }
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: modelData.day
                            font.family: "JetBrains Mono"
                            font.pixelSize: 14
                            font.weight: isToday ? Font.Black : (isCur ? Font.Bold : Font.Normal)
                            color: {
                                if (isToday) return root.crust
                                if (!isCur) return root.overlay0
                                if (isWeekend) return root.mauve
                                return root.text
                            }
                            opacity: isCur ? 1.0 : 0.35
                        }

                        MouseArea {
                            id: dayMa
                            anchors.fill: parent
                            hoverEnabled: isCur
                            cursorShape: isCur ? Qt.PointingHandCursor : Qt.ArrowCursor
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true }

            // =============================================
            // FOOTER — current date
            // =============================================
            Rectangle {
                Layout.fillWidth: true
                height: 36
                radius: 10
                color: "#0dffffff"
                border.color: "#1affffff"
                border.width: 1

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        text: "󰃭"
                        font.family: "Iosevka Nerd Font"
                        font.pixelSize: 16
                        color: root.mauve
                    }
                    Text {
                        text: {
                            let d = new Date()
                            let days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
                            return days[d.getDay()] + ", " + root.monthNames[root.todayMonth] + " " + root.today + " " + root.todayYear
                        }
                        font.family: "JetBrains Mono"
                        font.pixelSize: 13
                        font.weight: Font.Bold
                        color: root.text
                    }
                }
            }
        }
    }

    // ── Nav button component ───────────────────────────────────────────────
    component NavBtn : Rectangle {
        property string icon: ""
        signal tapped()

        width: 32; height: 32; radius: 8
        color: navMa.containsMouse ? "#1affffff" : "transparent"
        border.color: navMa.containsMouse ? root.mauve : "transparent"
        border.width: 1
        Behavior on color { ColorAnimation { duration: 150 } }

        scale: navMa.pressed ? 0.9 : 1.0
        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }

        Text {
            anchors.centerIn: parent
            text: parent.icon
            font.family: "Iosevka Nerd Font"
            font.pixelSize: 16
            color: navMa.containsMouse ? root.mauve : root.overlay0
            Behavior on color { ColorAnimation { duration: 150 } }
        }

        MouseArea {
            id: navMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.tapped()
        }
    }
}
