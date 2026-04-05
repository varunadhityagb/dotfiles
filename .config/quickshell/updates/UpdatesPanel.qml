import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import "../"

Item {
    id: root

    MatugenColors { id: _theme }
    readonly property color base: _theme.base
    readonly property color mantle: _theme.mantle
    readonly property color crust: _theme.crust
    readonly property color text: _theme.text
    readonly property color subtext0: _theme.subtext0
    readonly property color overlay0: _theme.overlay0
    readonly property color overlay1: _theme.overlay1
    readonly property color surface0: _theme.surface0
    readonly property color surface1: _theme.surface1
    readonly property color surface2: _theme.surface2
    readonly property color mauve: _theme.mauve
    readonly property color blue: _theme.blue
    readonly property color green: _theme.green
    readonly property color yellow: _theme.yellow
    readonly property color red: _theme.red
    readonly property color maroon: _theme.maroon
    readonly property color peach: _theme.peach
    readonly property color sapphire: _theme.sapphire

    // -------------------------------------------------------------------------
    // STATE
    // -------------------------------------------------------------------------
    property int totalUpdates: 0
    property int pacmanUpdates: 0
    property int aurUpdates: 0
    property var packageList: []
    property var aurPackageList: []
    property string activeFilter: "all" // "all", "pacman", "aur"
    property bool isUpdating: false
    property string updateStatus: ""

    readonly property color accentColor: {
        if (totalUpdates === 0) return root.green
        if (totalUpdates > 100) return root.red
        if (totalUpdates > 25) return root.yellow
        return root.blue
    }

    readonly property color accentSecondary: Qt.lighter(accentColor, 1.2)

    // -------------------------------------------------------------------------
    // ANIMATIONS
    // -------------------------------------------------------------------------
    property real globalOrbitAngle: 0
    NumberAnimation on globalOrbitAngle {
        from: 0; to: Math.PI * 2; duration: 90000
        loops: Animation.Infinite; running: true
    }

    property real introMain: 0
    property real introCore: 0
    property real introList: 0
    property real introDock: 0

    ParallelAnimation {
        running: true
        NumberAnimation { target: root; property: "introMain"; from: 0; to: 1.0; duration: 800; easing.type: Easing.OutQuart }
        SequentialAnimation {
            PauseAnimation { duration: 100 }
            NumberAnimation { target: root; property: "introCore"; from: 0; to: 1.0; duration: 900; easing.type: Easing.OutBack; easing.overshoot: 1.2 }
        }
        SequentialAnimation {
            PauseAnimation { duration: 250 }
            NumberAnimation { target: root; property: "introList"; from: 0; to: 1.0; duration: 800; easing.type: Easing.OutExpo }
        }
        SequentialAnimation {
            PauseAnimation { duration: 400 }
            NumberAnimation { target: root; property: "introDock"; from: 0; to: 1.0; duration: 800; easing.type: Easing.OutBack }
        }
    }

    // -------------------------------------------------------------------------
    // DATA
    // -------------------------------------------------------------------------
    Process {
        id: updatePoller
        command: ["bash", Qt.resolvedUrl("updates_info.sh").toString().replace("file://", "")]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let d = JSON.parse(this.text.trim())
                    root.totalUpdates = d.total || 0
                    root.pacmanUpdates = d.pacman || 0
                    root.aurUpdates = d.aur || 0
                    root.packageList = d.packages || []
                    root.aurPackageList = d.aurPackages || []
                } catch(e) {}
            }
        }
    }

    Process {
        id: cacheReader
        command: ["bash", "-c", "cat ${XDG_CACHE_HOME:-$HOME/.cache}/qs-updates 2>/dev/null"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let raw = this.text.trim()
                if (raw.length === 0) {
                    // No cache at all, do a live fetch
                    updatePoller.running = true
                    return
                }
                try {
                    let d = JSON.parse(raw)
                    root.totalUpdates = d.total || 0
                    root.pacmanUpdates = d.pacman || 0
                    root.aurUpdates = d.aur || 0
                    root.packageList = d.packages || []
                    root.aurPackageList = d.aurPackages || []
                } catch(e) {
                    // Cache malformed, fetch fresh
                    updatePoller.running = true
                }
            }
        }
    }



    Timer {
        interval: 30000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: { if (!updatePoller.running) updatePoller.running = true }
    }

    // Filtered list for display
    readonly property var displayList: {
        let all = []
        if (activeFilter === "all" || activeFilter === "pacman") {
            for (let i = 0; i < packageList.length; i++) all.push(packageList[i])
        }
        if (activeFilter === "all" || activeFilter === "aur") {
            for (let i = 0; i < aurPackageList.length; i++) all.push(aurPackageList[i])
        }
        return all
    }

    function runUpdate(cmd) {
        isUpdating = true
        updateStatus = "Launched..."
        // Close the panel and open a terminal with the update command
        Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                command: ["bash", "-c", "ghostty --class='floating-update' -e bash -c '${cmd}; echo; echo Done! Press Enter to exit.; read' &"]
                running: true
                onExited: destroy()
            }
        `, root)

        // Reset status and close panel after short delay
        statusResetTimer.restart()
        Qt.callLater(() => Qt.quit())
    }

    Timer {
        id: statusResetTimer
        interval: 3000
        onTriggered: root.updateStatus = ""
    }

    // -------------------------------------------------------------------------
    // UI
    // -------------------------------------------------------------------------
    Item {
        anchors.fill: parent
        scale: 0.92 + (0.08 * root.introMain)
        opacity: root.introMain
        transform: Translate { y: 15 * (1 - root.introMain) }

        Rectangle {
            anchors.fill: parent
            radius: 20
            color: root.base
            border.color: root.surface0
            border.width: 1
            clip: true

            // Ambient blobs
            Rectangle {
                width: parent.width * 0.8; height: width; radius: width / 2
                x: (parent.width / 2 - width / 2) + Math.cos(root.globalOrbitAngle * 2) * 150
                y: (parent.height / 2 - height / 2) + Math.sin(root.globalOrbitAngle * 2) * 100
                opacity: 0.07
                color: root.accentColor
                Behavior on color { ColorAnimation { duration: 1000 } }
            }
            Rectangle {
                width: parent.width * 0.9; height: width; radius: width / 2
                x: (parent.width / 2 - width / 2) + Math.sin(root.globalOrbitAngle * 1.5) * -150
                y: (parent.height / 2 - height / 2) + Math.cos(root.globalOrbitAngle * 1.5) * -100
                opacity: 0.05
                color: root.accentSecondary
                Behavior on color { ColorAnimation { duration: 1000 } }
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 25
                anchors.bottomMargin: 90
                spacing: 25

                // =============================================
                // LEFT: CENTRAL CORE
                // =============================================
                Item {
                    Layout.preferredWidth: 260
                    Layout.fillHeight: true

                    opacity: root.introCore
                    scale: 0.9 + (0.1 * root.introCore)
                    transform: Translate { y: 20 * (1 - root.introCore) }

                    // Radar rings
                    Repeater {
                        model: 3
                        Rectangle {
                            anchors.centerIn: parent
                            width: 160 + (index * 60)
                            height: width; radius: width / 2
                            color: "transparent"
                            border.color: root.accentColor
                            border.width: 1
                            opacity: 0.06 - (index * 0.015)
                            Behavior on border.color { ColorAnimation { duration: 800 } }
                        }
                    }

                    // Glow halo
                    Rectangle {
                        anchors.centerIn: centralCore
                        width: centralCore.width + 40
                        height: width; radius: width / 2
                        color: root.accentColor
                        opacity: 0.15
                        Behavior on color { ColorAnimation { duration: 800 } }
                        SequentialAnimation on scale {
                            loops: Animation.Infinite; running: true
                            NumberAnimation { to: 1.08; duration: 2000; easing.type: Easing.InOutSine }
                            NumberAnimation { to: 1.0; duration: 2000; easing.type: Easing.InOutSine }
                        }
                    }

                    Rectangle {
                        id: centralCore
                        width: 200; height: width
                        anchors.centerIn: parent
                        radius: width / 2

                        gradient: Gradient {
                            orientation: Gradient.Vertical
                            GradientStop { position: 0.0; color: root.surface0 }
                            GradientStop { position: 1.0; color: root.base }
                        }
                        border.color: root.accentColor
                        border.width: 2
                        Behavior on border.color { ColorAnimation { duration: 800 } }

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 4

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                font.family: "Iosevka Nerd Font"
                                font.pixelSize: 42
                                color: root.accentColor
                                text: root.totalUpdates === 0 ? "󰗡" : "󰚰"
                                Behavior on color { ColorAnimation { duration: 400 } }
                            }
                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                font.family: "JetBrains Mono"
                                font.weight: Font.Black
                                font.pixelSize: 42
                                color: root.text
                                text: root.totalUpdates
                            }
                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                font.family: "JetBrains Mono"
                                font.weight: Font.Bold
                                font.pixelSize: 12
                                color: root.subtext0
                                text: root.totalUpdates === 1 ? "UPDATE" : "UPDATES"
                            }
                        }
                    }

                    // Pacman / AUR breakdown pills
                    ColumnLayout {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 20
                        spacing: 8

                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter
                            width: pillRow1.width + 20; height: 28; radius: 8
                            color: "#0dffffff"
                            border.color: root.blue; border.width: 1
                            visible: root.pacmanUpdates > 0

                            RowLayout {
                                id: pillRow1
                                anchors.centerIn: parent
                                spacing: 6
                                Text { text: "󰮯"; font.family: "Iosevka Nerd Font"; font.pixelSize: 14; color: root.blue }
                                Text { text: root.pacmanUpdates + " Pacman"; font.family: "JetBrains Mono"; font.pixelSize: 12; font.weight: Font.Bold; color: root.text }
                            }
                        }

                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter
                            width: pillRow2.width + 20; height: 28; radius: 8
                            color: "#0dffffff"
                            border.color: root.mauve; border.width: 1
                            visible: root.aurUpdates > 0

                            RowLayout {
                                id: pillRow2
                                anchors.centerIn: parent
                                spacing: 6
                                Text { text: "󱓞"; font.family: "Iosevka Nerd Font"; font.pixelSize: 14; color: root.mauve }
                                Text { text: root.aurUpdates + " AUR"; font.family: "JetBrains Mono"; font.pixelSize: 12; font.weight: Font.Bold; color: root.text }
                            }
                        }

                        // Status text
                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            visible: root.updateStatus !== ""
                            text: root.updateStatus
                            font.family: "JetBrains Mono"
                            font.pixelSize: 13
                            font.weight: Font.Bold
                            color: root.updateStatus === "Done!" ? root.green :
                                   root.updateStatus === "Error!" ? root.red : root.yellow
                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }
                }

                // =============================================
                // RIGHT: PACKAGE LIST
                // =============================================
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 12

                    opacity: root.introList
                    transform: Translate { x: 30 * (1 - root.introList) }

                    // Filter tabs
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Repeater {
                            model: [
                                { id: "all", label: "All", count: root.totalUpdates },
                                { id: "pacman", label: "Pacman", count: root.pacmanUpdates },
                                { id: "aur", label: "AUR", count: root.aurUpdates }
                            ]

                            delegate: Rectangle {
                                Layout.preferredHeight: 32
                                width: tabLabel.width + 28
                                radius: 8
                                color: root.activeFilter === modelData.id ? root.accentColor : "#0dffffff"
                                border.color: root.activeFilter === modelData.id ? root.accentColor : root.surface2
                                border.width: 1
                                Behavior on color { ColorAnimation { duration: 200 } }

                                RowLayout {
                                    id: tabLabel
                                    anchors.centerIn: parent
                                    spacing: 6
                                    Text {
                                        text: modelData.label
                                        font.family: "JetBrains Mono"; font.pixelSize: 12; font.weight: Font.Bold
                                        color: root.activeFilter === modelData.id ? root.crust : root.text
                                        Behavior on color { ColorAnimation { duration: 200 } }
                                    }
                                    Rectangle {
                                        width: countTxt.width + 10; height: 18; radius: 6
                                        color: root.activeFilter === modelData.id ? "#33000000" : root.surface1
                                        Text {
                                            id: countTxt
                                            anchors.centerIn: parent
                                            text: modelData.count
                                            font.family: "JetBrains Mono"; font.pixelSize: 10; font.weight: Font.Bold
                                            color: root.activeFilter === modelData.id ? root.crust : root.subtext0
                                        }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.activeFilter = modelData.id
                                }
                            }
                        }

                        Item { Layout.fillWidth: true }

                        // Refresh button
                        Rectangle {
                            width: 32; height: 32; radius: 8
                            color: refreshMa.containsMouse ? "#1affffff" : "#0dffffff"
                            border.color: refreshMa.containsMouse ? root.accentColor : root.surface2
                            border.width: 1
                            Behavior on color { ColorAnimation { duration: 150 } }

                            Text {
                                anchors.centerIn: parent
                                text: "󰑓"
                                font.family: "Iosevka Nerd Font"; font.pixelSize: 16
                                color: refreshMa.containsMouse ? root.accentColor : root.overlay0
                                Behavior on color { ColorAnimation { duration: 150 } }

                                RotationAnimation on rotation {
                                    from: 0; to: 360; duration: 800
                                    loops: Animation.Infinite
                                    running: updatePoller.running
                                }
                            }

                            MouseArea {
                                id: refreshMa
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: updatePoller.running = true
                            }
                        }
                    }

                    // Package list
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 12
                        color: "#05ffffff"
                        border.color: "#1affffff"
                        border.width: 1
                        clip: true

                        // Empty state
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 10
                            visible: root.displayList.length === 0

                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "󰗡"
                                font.family: "Iosevka Nerd Font"; font.pixelSize: 48
                                color: root.green
                            }
                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                text: "All up to date!"
                                font.family: "JetBrains Mono"; font.pixelSize: 14; font.weight: Font.Bold
                                color: root.subtext0
                            }
                        }

                        ListView {
                            id: pkgListView
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 4
                            clip: true
                            model: root.displayList

                            ScrollBar.vertical: ScrollBar {
                                policy: ScrollBar.AsNeeded
                            }

                            delegate: Rectangle {
                                width: pkgListView.width
                                height: 44
                                radius: 8
                                color: pkgMa.containsMouse ? "#1affffff" : "transparent"
                                Behavior on color { ColorAnimation { duration: 150 } }

                                // Staggered entry
                                opacity: root.introList
                                transform: Translate { x: 20 * (1 - root.introList) + (index * 3 * (1 - root.introList)) }

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 12
                                    spacing: 10

                                    // Type badge
                                    Rectangle {
                                        width: 52; height: 20; radius: 5
                                        color: modelData.type === "aur" ? "#1a" + root.mauve.toString().substring(1) : "#1a" + root.blue.toString().substring(1)

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.type === "aur" ? "AUR" : "PKG"
                                            font.family: "JetBrains Mono"; font.pixelSize: 10; font.weight: Font.Black
                                            color: modelData.type === "aur" ? root.mauve : root.blue
                                        }
                                    }

                                    // Package name
                                    Text {
                                        Layout.fillWidth: true
                                        text: modelData.name || ""
                                        font.family: "JetBrains Mono"; font.pixelSize: 13; font.weight: Font.Bold
                                        color: root.text
                                        elide: Text.ElideRight
                                    }

                                    // Version arrow
                                    RowLayout {
                                        spacing: 6
                                        Text {
                                            text: modelData.from || ""
                                            font.family: "JetBrains Mono"; font.pixelSize: 11
                                            color: root.overlay0
                                        }
                                        Text {
                                            text: "→"
                                            font.family: "JetBrains Mono"; font.pixelSize: 11
                                            color: root.accentColor
                                        }
                                        Text {
                                            text: modelData.to || ""
                                            font.family: "JetBrains Mono"; font.pixelSize: 11
                                            color: root.accentColor
                                        }
                                    }
                                }

                                MouseArea {
                                    id: pkgMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                }
                            }
                        }
                    }
                }
            }

            // =============================================
            // BOTTOM DOCK
            // =============================================
            RowLayout {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 25
                anchors.bottomMargin: 20
                spacing: 12
                height: 54

                opacity: root.introDock
                transform: Translate { y: 20 * (1 - root.introDock) }

                Repeater {
                    model: [
                        { label: "Pacman Only", icon: "󰮯", color: "blue", cmd: "sudo pacman -Syu --noconfirm" },
                        { label: "AUR Only", icon: "󱓞", color: "mauve", cmd: "yay -Sua --noconfirm" },
                        { label: "Update All", icon: "󰚰", color: "green", cmd: "sudo pacman -Syu --noconfirm && yay -Sua --noconfirm" }
                    ]

                    delegate: Rectangle {
                        id: actionBtn
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 12

                        property color btnColor: root[modelData.color] || root.blue
                        property real fillLevel: 0.0
                        property bool triggered: false

                        color: btnMa.containsMouse ? "#1affffff" : "#0dffffff"
                        border.color: btnMa.containsMouse ? btnColor : "#1affffff"
                        border.width: btnMa.containsMouse ? 2 : 1
                        Behavior on color { ColorAnimation { duration: 200 } }
                        Behavior on border.color { ColorAnimation { duration: 200 } }

                        scale: btnMa.pressed ? 0.97 : (btnMa.containsMouse ? 1.03 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }

                        // Wave fill canvas
                        Canvas {
                            id: btnWave
                            anchors.fill: parent
                            property real wavePhase: 0.0
                            NumberAnimation on wavePhase {
                                running: actionBtn.fillLevel > 0 && actionBtn.fillLevel < 1
                                loops: Animation.Infinite; from: 0; to: Math.PI * 2; duration: 800
                            }
                            onWavePhaseChanged: requestPaint()
                            Connections { target: actionBtn; function onFillLevelChanged() { btnWave.requestPaint() } }

                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)
                                if (actionBtn.fillLevel <= 0.001) return

                                var r = 12
                                var fillY = height * (1.0 - actionBtn.fillLevel)
                                ctx.save()
                                ctx.beginPath()
                                ctx.moveTo(r, 0); ctx.lineTo(width-r, 0)
                                ctx.arcTo(width, 0, width, r, r)
                                ctx.lineTo(width, height-r)
                                ctx.arcTo(width, height, width-r, height, r)
                                ctx.lineTo(r, height)
                                ctx.arcTo(0, height, 0, height-r, r)
                                ctx.lineTo(0, r)
                                ctx.arcTo(0, 0, r, 0, r)
                                ctx.closePath(); ctx.clip()

                                ctx.beginPath()
                                ctx.moveTo(0, fillY)
                                if (actionBtn.fillLevel < 0.99) {
                                    var amp = 8 * Math.sin(actionBtn.fillLevel * Math.PI)
                                    ctx.bezierCurveTo(width*0.33, fillY + Math.sin(wavePhase)*amp,
                                                      width*0.66, fillY + Math.cos(wavePhase+Math.PI)*amp,
                                                      width, fillY)
                                    ctx.lineTo(width, height); ctx.lineTo(0, height)
                                } else {
                                    ctx.lineTo(width, 0); ctx.lineTo(width, height); ctx.lineTo(0, height)
                                }
                                ctx.closePath()
                                var grad = ctx.createLinearGradient(0, 0, 0, height)
                                grad.addColorStop(0, actionBtn.btnColor.toString())
                                grad.addColorStop(1, Qt.lighter(actionBtn.btnColor, 1.2).toString())
                                ctx.fillStyle = grad; ctx.fill(); ctx.restore()
                            }
                        }

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 8
                            Text {
                                text: modelData.icon
                                font.family: "Iosevka Nerd Font"; font.pixelSize: 18
                                color: actionBtn.fillLevel > 0.5 ? root.crust : actionBtn.btnColor
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                            Text {
                                text: root.isUpdating && actionBtn.triggered ? "Updating..." : modelData.label
                                font.family: "JetBrains Mono"; font.pixelSize: 13; font.weight: Font.Black
                                color: actionBtn.fillLevel > 0.5 ? root.crust : root.text
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                        }

                        // Hold hint
                        Text {
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottomMargin: 4
                            text: actionBtn.fillLevel > 0.01 ? "Hold..." : "Hold to confirm"
                            font.family: "JetBrains Mono"; font.pixelSize: 9
                            color: actionBtn.fillLevel > 0.5 ? "#99000000" : root.overlay0
                            opacity: btnMa.containsMouse ? 1.0 : 0.0
                            Behavior on opacity { NumberAnimation { duration: 200 } }
                        }

                        MouseArea {
                            id: btnMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: actionBtn.triggered ? Qt.ArrowCursor : Qt.PointingHandCursor
                            onPressed: { if (!actionBtn.triggered && !root.isUpdating) { drainAnim.stop(); fillAnim.start() } }
                            onReleased: { if (!actionBtn.triggered && actionBtn.fillLevel < 1.0) { fillAnim.stop(); drainAnim.start() } }
                        }

                        NumberAnimation {
                            id: fillAnim; target: actionBtn; property: "fillLevel"; to: 1.0
                            duration: 800 * (1.0 - actionBtn.fillLevel); easing.type: Easing.InSine
                            onFinished: {
                                actionBtn.triggered = true
                                root.runUpdate(modelData.cmd)
                            }
                        }
                        NumberAnimation {
                            id: drainAnim; target: actionBtn; property: "fillLevel"; to: 0.0
                            duration: 1000 * actionBtn.fillLevel; easing.type: Easing.OutQuad
                        }
                    }
                }
            }
        }
    }
}
