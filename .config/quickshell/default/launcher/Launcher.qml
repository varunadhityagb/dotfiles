pragma ComponentBehavior: Bound
//@ pragma UseQApplication
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

PanelWindow {
    id: launcher

    visible: false
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    focusable: true
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    // anchor all sides to cover full screen, then use margins to center content
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    // dimmed background
    Rectangle {
        anchors.fill: parent
        color: Qt.alpha("#000000", 0.0)
        visible: launcher.visible
        radius: 20

        // close on background click
        MouseArea {
            anchors.fill: parent
            onClicked: launcher.close()
        }
    }

    IpcHandler {
        target: "launcher"
        function toggle() {
            if (launcher.visible) launcher.close()
            else launcher.open()
        }
    }

    function open() {
        searchInput.text = ""
        visible = true
        Qt.callLater(() => searchInput.forceActiveFocus())
    }

    function close() {
        visible = false
        searchInput.text = ""
    }

    property string query: searchInput.text
    property string mode: {
        if (query.startsWith("=")) return "calc"
        if (query.startsWith("!")) return "cmd"
        return "apps"
    }

    property var allApps: DesktopEntries.applications.values
    property var filteredApps: {
        var sortedApps = allApps.slice().sort(function(a,b) {
            return a.name.localeCompare(b.name)
        })
        if (query === "" || mode !== "apps")
            return sortedApps

        var q = query.toLowerCase()

        return sortedApps.filter(function(a) {
            return a.name.toLowerCase().includes(q) ||
                (a.genericName && a.genericName.toLowerCase().includes(q))
        })
    }

    property var recentApps: []

    function launchApp(entry) {
        entry.execute()
        var id = entry.id
        var updated = [id, ...recentApps.filter(i => i !== id)].slice(0, 6)
        recentApps = updated
        launcher.close()
    }

    property var modes: ["apps", "cmd", "calc"]

    function cycleMode(direction) {
        var idx = modes.indexOf(mode)
        idx = (idx + direction + modes.length) % modes.length

        switch (modes[idx]) {
        case "apps":
            searchInput.text = searchInput.text.replace(/^[!=]/, "")
            break
        case "cmd":
            searchInput.text = "!" + searchInput.text.replace(/^[!=]/, "")
            break
        case "calc":
            searchInput.text = "=" + searchInput.text.replace(/^[!=]/, "")
            break
        }

        searchInput.cursorPosition = searchInput.text.length
    }

    // centered card
    Item {
        anchors.centerIn: parent
        width: 680
        height: 520

        Rectangle {
            anchors.fill: parent
            color: Qt.alpha(root.base, 0.5)
            radius: 20
            border.color: root.surface1

            // stop background clicks from propagating
            MouseArea {
                anchors.fill: parent
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 16

                // search input
                Rectangle {
                    id: searchBox
                    Layout.fillWidth: true
                    height: 56
                    radius: 20
                    color: root.surface0
                    Layout.alignment: Qt.AlignTop
                    border.color: root.surface2
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 10

                        Text {
                            text: launcher.mode === "calc" ? "󰃬" :
                                  launcher.mode === "cmd"  ? "" : "󰍉"
                            color: root.blue
                            font.pixelSize: 22
                            font.family: root.fontFamily
                        }

                        TextInput {
                            id: searchInput
                            Layout.fillWidth: true
                            color: root.text
                            font.pixelSize: 22
                            font.family: root.fontFamily
                            selectionColor: Qt.alpha(root.blue, 0.3)

                            Keys.onPressed: event => {
                                if (event.modifiers & Qt.ControlModifier) {
                                    if (event.key === Qt.Key_J) {
                                        if (launcher.mode === "apps") {
                                            appList.forceActiveFocus()
                                            appList.currentIndex = 0
                                        } else if (launcher.mode === "cmd") {
                                            cmdList.forceActiveFocus()
                                            cmdList.currentIndex = 0
                                        } else if (launcher.mode === "calc") {
                                            calcList.forceActiveFocus()
                                            calcList.currentIndex = 0
                                        }
                                        event.accepted = true
                                    } else if (event.key === Qt.Key_L) {
                                        launcher.cycleMode(+1)
                                        event.accepted = true
                                    } else if (event.key === Qt.Key_H) {
                                        launcher.cycleMode(-1)
                                        event.accepted = true
                                    }
                                }
                            }

                            Text {
                                anchors.fill: parent
                                text: "Search apps • = calculator • ! command"
                                color: root.subtext0
                                font.pixelSize: 22
                                font.family: root.fontFamily
                                visible: parent.text === ""
                            }

                            Keys.onEscapePressed: launcher.close()
                            Keys.onReturnPressed: {
                                if (launcher.mode === "cmd") {
                                    var cmd = searchInput.text.substring(1).trim()
                                    console.log(cmd)
                                    Quickshell.execDetached([
                                        "sh",
                                        "-c",
                                        cmd + " "
                                    ])
                                    launcher.close()
                                } else if (launcher.mode === "apps" && launcher.filteredApps.length > 0) {
                                    launcher.launchApp(launcher.filteredApps[0])
                                }
                            }
                            Keys.onDownPressed: appList.forceActiveFocus()
                        }

                        Text {
                            text: "✕"
                            color: root.subtext0
                            font.pixelSize: root.fontSize - 2
                            font.family: root.fontFamily
                            visible: searchInput.text !== ""
                            MouseArea {
                                anchors.fill: parent
                                onClicked: searchInput.text = ""
                            }
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true

                    text: launcher.filteredApps.length + " results"

                    color: root.subtext0
                    font.pixelSize: root.fontSize
                    font.family: root.fontFamily

                    visible: launcher.mode === "apps" &&
                            launcher.query !== ""
                }

                // calc result
                Rectangle {
                    id: calcResult
                    Layout.fillWidth: true
                    height: 48
                    radius: 10
                    color: root.surface0
                    border.color: Qt.alpha(root.green, 0.5)
                    visible: launcher.mode === "calc" && launcher.query.length > 1
                    Layout.alignment: Qt.AlignBottom
                    Layout.topMargin: 5

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        Text {
                            text: "="
                            color: root.green
                            font.pixelSize: root.fontSize
                            font.family: root.fontFamily
                            font.bold: true
                        }

                        Text {
                            Layout.fillWidth: true
                            text: CalcEngine.evaluate(launcher.query.substring(1).trim())
                            color: root.text
                            font.pixelSize: root.fontSize
                            font.family: root.fontFamily
                        }
                    }
                }

                // apps area
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignTop
                    Layout.topMargin: 12

                    // ── APPS ──
                    Rectangle {
                        anchors.fill: parent
                        radius: 14
                        color: Qt.alpha(root.surface0, 0.7)
                        visible: launcher.mode === "apps"

                        ScrollView {
                            anchors.fill: parent
                            anchors.margins: 8
                            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                            ListView {
                                id: appList
                                model: launcher.filteredApps
                                spacing: 6
                                clip: true
                                keyNavigationEnabled: true

                                Keys.onPressed: event => {
                                    // vim-style navigation with ctrl
                                    if (event.modifiers & Qt.ControlModifier) {
                                        if (event.key === Qt.Key_J) {
                                            currentIndex = Math.min(count - 1, currentIndex + 1)
                                            event.accepted = true
                                        } else if (event.key === Qt.Key_K) {
                                            if (currentIndex <= 0) searchInput.forceActiveFocus()
                                            else currentIndex--
                                            event.accepted = true
                                        } else if (event.key === Qt.Key_L) {
                                            launcher.cycleMode(+1)
                                            event.accepted = true
                                        } else if (event.key === Qt.Key_H) {
                                            launcher.cycleMode(-1)
                                            event.accepted = true
                                        }
                                    }
                                }

                                Keys.onReturnPressed: {
                                    if (currentIndex >= 0)
                                        launcher.launchApp(model[currentIndex])
                                }
                                Keys.onEscapePressed: launcher.close()
                                Keys.onUpPressed: {
                                    if (currentIndex <= 0) searchInput.forceActiveFocus()
                                    else currentIndex--
                                }
                                Keys.onDownPressed: currentIndex = Math.min(count - 1, currentIndex + 1)

                                delegate: Rectangle {
                                    required property var modelData
                                    required property int index

                                    width: appList.width
                                    height: 60
                                    radius: 12
                                    color: appList.currentIndex === index ? Qt.alpha(root.blue, 0.18) : "transparent"
                                    border.color: appList.currentIndex === index ? root.blue : "transparent"

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        spacing: 12

                                        Item {
                                            Layout.preferredWidth: 40
                                            Layout.preferredHeight: 40

                                            Image {
                                                anchors.centerIn: parent
                                                source: modelData.icon !== "" ? "image://icon/" + modelData.icon : ""
                                                width: 32
                                                height: 32
                                                fillMode: Image.PreserveAspectFit
                                            }
                                        }

                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            Layout.alignment: Qt.AlignVCenter
                                            spacing: 2

                                            Text {
                                                text: modelData.name
                                                color: root.text
                                                font.pixelSize: root.fontSize + 1
                                                font.family: root.fontFamily
                                                font.bold: true
                                                horizontalAlignment: Text.AlignLeft
                                                Layout.fillWidth: true
                                            }

                                            Text {
                                                text: modelData.genericName ?? ""
                                                color: root.subtext0
                                                font.pixelSize: root.fontSize - 3
                                                visible: text !== ""
                                                horizontalAlignment: Text.AlignLeft
                                                Layout.fillWidth: true
                                            }
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onEntered: appList.currentIndex = index
                                        onClicked: launcher.launchApp(modelData)
                                    }
                                }
                            }
                        }
                    }

                    // ── CMD ──
                    Rectangle {
                        id: cmdListBox
                        anchors.fill: parent
                        radius: 14
                        color: Qt.alpha(root.surface0, 0.7)
                        visible: launcher.mode === "cmd"

                        // load commands once
                        property var allCommands: []

                        Process {
                            id: cmdLoader
                            property var commands: []

                            command: ["bash", "-c", "compgen -c | sort -u | grep -vE '(^\\W|^[A-Z])'"]

                            stdout: SplitParser {
                                onRead: line => {
                                    line = line.trim()
                                    if (line)
                                        cmdLoader.commands.push(line)
                                }
                            }

                            onExited: {
                                cmdListBox.allCommands = commands
                            }

                            Component.onCompleted: running = true
                        }

                        property var filteredCmds: {
                            var q = launcher.query.substring(1).trim().toLowerCase()
                            if (q === "") return allCommands.slice(0, 50)
                            return allCommands.filter(c => c.toLowerCase().startsWith(q)).slice(0, 50)
                        }

                        ScrollView {
                            anchors.fill: parent
                            anchors.margins: 8
                            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                            ListView {
                                id: cmdList
                                model: parent.parent.filteredCmds
                                spacing: 4
                                clip: true
                                focus: true
                                keyNavigationEnabled: true


                                Keys.onPressed: event => {
                                    // vim-style navigation with ctrl
                                    if (event.modifiers & Qt.ControlModifier) {
                                        if (event.key === Qt.Key_J) {
                                            currentIndex = Math.min(count - 1, currentIndex + 1)
                                            event.accepted = true
                                        } else if (event.key === Qt.Key_K) {
                                            if (currentIndex <= 0) searchInput.forceActiveFocus()
                                            else currentIndex--
                                            event.accepted = true
                                        } else if (event.key === Qt.Key_L) {
                                            launcher.cycleMode(+1)
                                            event.accepted = true
                                        } else if (event.key === Qt.Key_H) {
                                            launcher.cycleMode(-1)
                                            event.accepted = true
                                        }
                                    }
                                }

                                Keys.onReturnPressed: {
                                    if (currentIndex >= 0) {
                                        Quickshell.execDetached(["sh", "-c", model[currentIndex]])
                                        launcher.close()
                                    }
                                }
                                Keys.onEscapePressed: launcher.close()
                                Keys.onUpPressed: {
                                    if (currentIndex <= 0) searchInput.forceActiveFocus()
                                    else currentIndex--
                                }
                                Keys.onDownPressed: currentIndex = Math.min(count - 1, currentIndex + 1)

                                delegate: Rectangle {
                                    required property string modelData
                                    required property int index

                                    width: cmdList.width
                                    height: 40
                                    radius: 8
                                    color: cmdList.currentIndex === index ? Qt.alpha(root.blue, 0.18) : "transparent"
                                    border.color: cmdList.currentIndex === index ? root.blue : "transparent"

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        spacing: 10

                                        Text {
                                            text: ""
                                            color: root.subtext0
                                            font.pixelSize: root.fontSize - 2
                                            font.family: root.fontFamily
                                        }

                                        Text {
                                            text: modelData
                                            color: root.text
                                            font.pixelSize: root.fontSize
                                            font.family: root.fontFamily
                                            Layout.fillWidth: true
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onEntered: cmdList.currentIndex = index
                                        onClicked: {
                                            Quickshell.execDetached(["sh", "-c", modelData])
                                            launcher.close()
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // ── CALC TEMPLATES ──
                    Rectangle {
                        anchors.fill: parent
                        radius: 14
                        color: Qt.alpha(root.surface0, 0.7)
                        visible: launcher.mode === "calc"

                        property var templates: [
                            // Basic Math
                            { label: "Math", example: "= 2 + 2" },
                            { label: "Math", example: "= (12 + 8) * 3 / 4" },
                            { label: "Math", example: "= 2^10" },
                            { label: "Math", example: "= 17 % 5" },
                            { label: "Math", example: "= ans * 5" },

                            // Constants
                            { label: "Constants", example: "= pi" },
                            { label: "Constants", example: "= 2 * pi * 10" },
                            { label: "Constants", example: "= pi * 5^2" },
                            { label: "Constants", example: "= tau" },
                            { label: "Constants", example: "= e^2" },

                            // Functions
                            { label: "Functions", example: "= sqrt(144)" },
                            { label: "Functions", example: "= cbrt(27)" },
                            { label: "Functions", example: "= abs(-42)" },
                            { label: "Functions", example: "= floor(3.9)" },
                            { label: "Functions", example: "= ceil(3.1)" },
                            { label: "Functions", example: "= round(3.14159)" },

                            // Trigonometry
                            { label: "Trig", example: "= sin(90)" },
                            { label: "Trig", example: "= cos(45)" },
                            { label: "Trig", example: "= tan(30)" },
                            { label: "Trig", example: "= asin(1)" },
                            { label: "Trig", example: "= acos(0.5)" },
                            { label: "Trig", example: "= atan(1)" },

                            // Logarithms
                            { label: "Log", example: "= log(100)" },
                            { label: "Log", example: "= log(1000)" },
                            { label: "Log", example: "= ln(10)" },

                            // Min / Max
                            { label: "Advanced", example: "= min(10,20,30)" },
                            { label: "Advanced", example: "= max(10,20,30)" },
                            { label: "Advanced", example: "= pow(2,16)" },

                            // Random
                            { label: "Random", example: "= rand()" },

                            // Factorial
                            { label: "Factorial", example: "= 5!" },
                            { label: "Factorial", example: "= 10!" },

                            // Percentages
                            { label: "Percent", example: "= 20% of 500" },
                            { label: "Percent", example: "= 15% of 2000" },
                            { label: "Percent", example: "= 500 increased by 10%" },
                            { label: "Percent", example: "= 500 decreased by 10%" },
                            { label: "Percent", example: "= 50%" },

                            // Length
                            { label: "Length", example: "= 10 km in miles" },
                            { label: "Length", example: "= 5 ft in cm" },
                            { label: "Length", example: "= 100 m in yards" },
                            { label: "Length", example: "= 25 in in mm" },
                            { label: "Length", example: "= 1 mi in km" },

                            // Weight
                            { label: "Weight", example: "= 70 kg in lbs" },
                            { label: "Weight", example: "= 5 lb in kg" },
                            { label: "Weight", example: "= 500 g in oz" },
                            { label: "Weight", example: "= 1 oz in g" },

                            // Temperature
                            { label: "Temp", example: "= 100 c in f" },
                            { label: "Temp", example: "= 98.6 f in c" },
                            { label: "Temp", example: "= 300 k in c" },
                            { label: "Temp", example: "= 0 c in k" },

                            // Speed
                            { label: "Speed", example: "= 60 mph in kph" },
                            { label: "Speed", example: "= 100 kph in mph" },
                            { label: "Speed", example: "= 10 m/s in mph" },
                            { label: "Speed", example: "= 100 km/h in m/s" },

                            // Time
                            { label: "Time", example: "= 120 sec in min" },
                            { label: "Time", example: "= 2 hr in min" },
                            { label: "Time", example: "= 7 day in hour" },
                            { label: "Time", example: "= 1 week in day" },
                            { label: "Time", example: "= 48 hour in day" },

                            // Storage
                            { label: "Storage", example: "= 10 gb in mb" },
                            { label: "Storage", example: "= 1 tb in gb" },
                            { label: "Storage", example: "= 1024 kb in mb" },
                            { label: "Storage", example: "= 2048 mib in gib" },
                            { label: "Storage", example: "= 1 gib in mib" },

                            // Programmer
                            { label: "Programmer", example: "= hex(255)" },
                            { label: "Programmer", example: "= hex(4096)" },
                            { label: "Programmer", example: "= bin(255)" },
                            { label: "Programmer", example: "= oct(255)" },
                            { label: "Programmer", example: "= dec(0xFF)" },
                            { label: "Programmer", example: "= dec(0o777)" },
                            { label: "Programmer", example: "= dec(10101010)" },

                            // Scientific
                            { label: "Scientific", example: "= 1e6" },
                            { label: "Scientific", example: "= 6.022e23" },
                            { label: "Scientific", example: "= 3e8 * 10" },

                            { label: "BMI", example: "= bmi 70kg 175cm" },
                            { label: "BMI", example: "= bmi 90kg 180cm" },

                            { label: "Age", example: "= age 2004-03-18" },

                            { label: "Date", example: "= today + 30 days" },
                            { label: "Date", example: "= today + 2 weeks" },
                            { label: "Date", example: "= 2026-01-01 - 2025-01-01" },

                            { label: "Color", example: "= color #89b4fa" },
                            { label: "Color", example: "= color #ff0000" },
                            { label: "Color", example: "= color rgb(255,0,0)" }
                        ]

                        ScrollView {
                            anchors.fill: parent
                            anchors.margins: 8
                            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                            ListView {
                                id: calcList
                                model: parent.parent.templates
                                spacing: 4
                                clip: true
                                focus: true
                                keyNavigationEnabled: true

                                Keys.onPressed: event => {
                                    // vim-style navigation with ctrl
                                    if (event.modifiers & Qt.ControlModifier) {
                                        if (event.key === Qt.Key_J) {
                                            currentIndex = Math.min(count - 1, currentIndex + 1)
                                            event.accepted = true
                                        } else if (event.key === Qt.Key_K) {
                                            if (currentIndex <= 0) searchInput.forceActiveFocus()
                                            else currentIndex--
                                            event.accepted = true
                                        } else if (event.key === Qt.Key_L) {
                                            launcher.cycleMode(+1)
                                            event.accepted = true
                                        } else if (event.key === Qt.Key_H) {
                                            launcher.cycleMode(-1)
                                            event.accepted = true
                                        }
                                    }
                                }

                                Keys.onReturnPressed: {
                                    if (currentIndex < 0)
                                        return

                                    var example = model[currentIndex].example

                                    searchInput.text = example
                                    searchInput.forceActiveFocus()

                                    var match = example.match(/\d+(\.\d+)?/)
                                    if (match) {
                                        searchInput.select(
                                            match.index,
                                            match.index + match[0].length
                                        )
                                    }
                                }

                                delegate: Rectangle {
                                    required property var modelData
                                    required property int index

                                    width: parent ? parent.width : 0
                                    height: 40
                                    radius: 8
                                    color: calcList.currentIndex === index
                                        ? Qt.alpha(root.blue, 0.18)
                                        : "transparent"

                                    border.color: calcList.currentIndex === index
                                                ? root.blue
                                                : "transparent"

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        spacing: 10

                                        Rectangle {
                                            width: 60
                                            height: 22
                                            radius: 6
                                            color: root.surface1

                                            Text {
                                                anchors.centerIn: parent
                                                text: modelData.label
                                                color: root.subtext0
                                                font.pixelSize: root.fontSize - 3
                                                font.family: root.fontFamily
                                            }
                                        }

                                        Text {
                                            text: modelData.example
                                            color: root.blue
                                            font.pixelSize: root.fontSize - 1
                                            font.family: "monospace"
                                            Layout.fillWidth: true
                                        }

                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            searchInput.text = modelData.example
                                            searchInput.forceActiveFocus()

                                            var match = modelData.example.match(/\d+(\.\d+)?/)
                                            if (match) {
                                                searchInput.select(match.index,
                                                                match.index + match[0].length)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // command mode hint
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: launcher.mode === "cmd"

                    Text {
                        anchors.centerIn: parent
                        text: "Press Enter to run: " + launcher.query.substring(1).trim()
                        color: root.subtext0
                        font.pixelSize: root.fontSize
                        font.family: root.fontFamily
                    }
                }
            }
        }
    }
}
