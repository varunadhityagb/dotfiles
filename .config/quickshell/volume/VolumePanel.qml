import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import "."

Item {
    id: root

    // ── Theme ──────────────────────────────────────────────────────────────
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

    // ── State ──────────────────────────────────────────────────────────────
    property int    outputVolume: 30
    property bool   outputMuted:  false
    property string outputDevice: "Loading..."

    property int    inputVolume:  30
    property bool   inputMuted:   false

    // App volumes — list of { name, volume, icon }
    property var    appVolumes:   []

    // ── Intro animation ────────────────────────────────────────────────────
    property real introMain: 0
    ParallelAnimation {
        running: true
        NumberAnimation { target: root; property: "introMain"; from: 0; to: 1; duration: 600; easing.type: Easing.OutQuart }
    }

    // ── Data polling ───────────────────────────────────────────────────────

    // Output volume + device + mute via pactl
    Process {
        id: outputPoller
        command: ["bash", "-c",
            "pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+(?=%)' | head -1; " +
            "pactl get-sink-mute @DEFAULT_SINK@ | grep -oP 'yes|no'; " +
            "pactl get-default-sink"
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.trim().split("\n")
                if (lines.length >= 1) root.outputVolume = parseInt(lines[0]) || 0
                if (lines.length >= 2) root.outputMuted  = lines[1].trim() === "yes"
                if (lines.length >= 3) {
                    // Try to get a friendly name via pactl info
                    let sink = lines[2].trim()
                    deviceNameProc.sinkName = sink
                    deviceNameProc.running = true
                }
            }
        }
    }

    Process {
        id: deviceNameProc
        property string sinkName: ""
        command: ["bash", "-c",
            "pactl list sinks | grep -A2 'Name: " + sinkName + "' | grep 'Description:' | sed 's/.*Description: //'"
        ]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                let name = this.text.trim()
                if (name.length > 0) root.outputDevice = name
                else root.outputDevice = deviceNameProc.sinkName
            }
        }
    }

    // Input volume + mute
    Process {
        id: inputPoller
        command: ["bash", "-c",
            "pactl get-source-volume @DEFAULT_SOURCE@ | grep -oP '\\d+(?=%)' | head -1; " +
            "pactl get-source-mute @DEFAULT_SOURCE@ | grep -oP 'yes|no'"
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.trim().split("\n")
                if (lines.length >= 1) root.inputVolume = parseInt(lines[0]) || 0
                if (lines.length >= 2) root.inputMuted  = lines[1].trim() === "yes"
            }
        }
    }

    // Per-app (sink-input) volumes
    Process {
        id: appPoller
        command: ["bash", "-c",
            "pactl -f json list sink-inputs 2>/dev/null"
        ]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let raw = this.text.trim()
                    if (!raw || raw.length === 0) return
                    let inputs = JSON.parse(raw)
                    let apps = []
                    for (let i = 0; i < inputs.length; i++) {
                        let inp = inputs[i]
                        let props = inp.properties || {}
                        let name = props["application.name"] || props["media.name"] || "Unknown"
                        // clean up name
                        name = name.charAt(0).toUpperCase() + name.slice(1)
                        let volMap = inp.volume || {}
                        let volKeys = Object.keys(volMap)
                        let pct = 0
                        if (volKeys.length > 0) {
                            pct = Math.round((volMap[volKeys[0]].value_percent || "0%").replace("%",""))
                        }
                        let icon = props["application.icon_name"] || ""
                        let id   = inp.index || i
                        apps.push({ name: name, volume: pct, icon: icon, id: id })
                    }
                    root.appVolumes = apps
                } catch(e) {
                    root.appVolumes = []
                }
            }
        }
    }

    // Poll every 1.5s
    Timer {
        interval: 1500; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            if (!outputPoller.running) outputPoller.running = true
            if (!inputPoller.running)  inputPoller.running  = true
            if (!appPoller.running)    appPoller.running    = true
        }
    }

    // ── Volume setters ─────────────────────────────────────────────────────
    function setOutputVolume(v) {
        root.outputVolume = v
        setOutputVolumeProc.volume = v
        setOutputVolumeProc.running = true
    }
    Process {
        id: setOutputVolumeProc
        property int volume: 0
        command: ["bash", "-c", "pactl set-sink-volume @DEFAULT_SINK@ " + volume + "%"]
        running: false
        onExited: running = false
    }

    function setInputVolume(v) {
        root.inputVolume = v
        setInputVolumeProc.volume = v
        setInputVolumeProc.running = true
    }
    Process {
        id: setInputVolumeProc
        property int volume: 0
        command: ["bash", "-c", "pactl set-source-volume @DEFAULT_SOURCE@ " + volume + "%"]
        running: false
        onExited: running = false
    }

    function setAppVolume(id, v) {
        setAppVolumeProc.sinkId = id
        setAppVolumeProc.volume = v
        setAppVolumeProc.running = true
    }
    Process {
        id: setAppVolumeProc
        property int sinkId: 0
        property int volume:  0
        command: ["bash", "-c", "pactl set-sink-input-volume " + sinkId + " " + volume + "%"]
        running: false
        onExited: running = false
    }

    function toggleOutputMute() {
        root.outputMuted = !root.outputMuted
        toggleOutputMuteProc.running = true
    }
    Process {
        id: toggleOutputMuteProc
        command: ["bash", "-c", "pactl set-sink-mute @DEFAULT_SINK@ toggle"]
        running: false
        onExited: running = false
    }

    function toggleInputMute() {
        root.inputMuted = !root.inputMuted
        toggleInputMuteProc.running = true
    }
    Process {
        id: toggleInputMuteProc
        command: ["bash", "-c", "pactl set-source-mute @DEFAULT_SOURCE@ toggle"]
        running: false
        onExited: running = false
    }

    function openPavucontrol() {
        openPavuProc.running = true
        Qt.quit()
    }
    Process {
        id: openPavuProc
        command: ["bash", "-c", "pavucontrol &"]
        running: false
        onExited: running = false
    }

// ── Orbit angle for ambient blobs ──────────────────────────────────────
    property real globalOrbitAngle: 0
    NumberAnimation on globalOrbitAngle {
        from: 0; to: Math.PI * 2; duration: 90000
        loops: Animation.Infinite; running: true
    }

    readonly property color accentColor: root.mauve

    // ── Root card ──────────────────────────────────────────────────────────
    opacity: root.introMain
    Behavior on opacity { NumberAnimation { duration: 300 } }

    transform: Scale {
        origin.x: root.width / 2
        origin.y: root.height / 2
        xScale: 0.92 + 0.08 * root.introMain
        yScale: 0.92 + 0.08 * root.introMain
    }

    Rectangle {
        id: card
        anchors.fill: parent
        radius: 18
        color: root.base
        border.color: root.surface0
        border.width: 1
        clip: true

        // Ambient blob 1
        Rectangle {
            width: card.width * 0.8; height: width; radius: width / 2
            x: (card.width / 2 - width / 2) + Math.cos(root.globalOrbitAngle * 2) * 100
            y: (card.height / 2 - height / 2) + Math.sin(root.globalOrbitAngle * 2) * 80
            opacity: 0.07
            color: root.mauve
            Behavior on color { ColorAnimation { duration: 1000 } }
        }
        Rectangle {
            width: card.width * 0.9; height: width; radius: width / 2
            x: (card.width / 2 - width / 2) + Math.sin(root.globalOrbitAngle * 1.5) * -100
            y: (card.height / 2 - height / 2) + Math.cos(root.globalOrbitAngle * 1.5) * -80
            opacity: 0.05
            color: root.blue
            Behavior on color { ColorAnimation { duration: 1000 } }
        }

        // ── Scrollable content ─────────────────────────────────────────────
        Flickable {
            id: flick
            anchors.fill: parent
            contentHeight: contentCol.implicitHeight + 24
            contentWidth: width
            clip: true
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

            ColumnLayout {
                id: contentCol
                width: parent.width
                spacing: 0

                // ── Header ──────────────────────────────────────────────────
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 56

                    RowLayout {
                        anchors.left: parent.left
                        anchors.leftMargin: 22
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        Text {
                            text: "󰕾"
                            font.family: "Iosevka Nerd Font"
                            font.pixelSize: 20
                            color: root.mauve
                        }
                        Text {
                            text: "Sound"
                            color: root.text
                            font.family: "JetBrains Mono"
                            font.pixelSize: 20
                            font.bold: true
                        }
                    }
                }

                // ── Device name pill ────────────────────────────────────────
                Rectangle {
                    Layout.leftMargin: 16
                    Layout.bottomMargin: 14
                    height: 26
                    width: deviceLabel.width + 24
                    radius: 8
                    color: "#0dffffff"
                    border.color: "#1affffff"
                    border.width: 1

                    RowLayout {
                        id: deviceLabel
                        anchors.centerIn: parent
                        spacing: 6
                        Text {
                            text: "󰋎"
                            font.family: "Iosevka Nerd Font"
                            font.pixelSize: 13
                            color: root.sapphire
                        }
                        Text {
                            text: root.outputDevice
                            color: root.subtext0
                            font.family: "JetBrains Mono"
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }
                    }
                }

                // ── Output Volume ────────────────────────────────────────────
                VolumeRow {
                    Layout.fillWidth: true
                    Layout.leftMargin: 16
                    Layout.rightMargin: 16
                    Layout.bottomMargin: 10

                    iconText: root.outputMuted ? "󰖁" : (root.outputVolume > 50 ? "󰕾" : "󰖀")
                    label: "Output"
                    volume: root.outputVolume
                    muted: root.outputMuted
                    accentColor: root.mauve
                    textColor: root.text
                    subColor: root.subtext0
                    surfaceColor: root.surface0
                    baseColor: root.surface1

                    onVolumeUpdated: (v) => root.setOutputVolume(v)
                    onMuteToggled: root.toggleOutputMute()
                }

                // ── Separator ────────────────────────────────────────────────
                Rectangle {
                    Layout.fillWidth: true
                    Layout.leftMargin: 16
                    Layout.rightMargin: 16
                    Layout.bottomMargin: 14
                    height: 1
                    color: "#1affffff"
                }

                // ── App Volume header ────────────────────────────────────────
                Text {
                    visible: root.appVolumes.length > 0
                    Layout.leftMargin: 22
                    Layout.bottomMargin: 8
                    text: "APP VOLUME"
                    color: root.subtext0
                    font.family: "JetBrains Mono"
                    font.pixelSize: 10
                    font.letterSpacing: 1.5
                }

                // ── Per-app rows ─────────────────────────────────────────────
                Repeater {
                    model: root.appVolumes

                    VolumeRow {
                        Layout.fillWidth: true
                        Layout.leftMargin: 16
                        Layout.rightMargin: 16
                        Layout.bottomMargin: 10

                        iconText: modelData.name.toLowerCase().includes("spotify") ? "󰓇"
                                : modelData.name.toLowerCase().includes("firefox") ? "󰈹"
                                : modelData.name.toLowerCase().includes("chrome")  ? "󰊯"
                                : modelData.name.toLowerCase().includes("vlc")     ? "󰕼"
                                : modelData.name.toLowerCase().includes("discord") ? "󰙯"
                                : "󰓃"
                        label: modelData.name
                        volume: modelData.volume
                        muted: false
                        accentColor: root.blue
                        textColor: root.text
                        subColor: root.subtext0
                        surfaceColor: root.surface0
                        baseColor: root.surface1

                        onVolumeUpdated: (v) => root.setAppVolume(modelData.id, v)
                        onMuteToggled: {}
                    }
                }

                // ── Separator ────────────────────────────────────────────────
                Rectangle {
                    Layout.fillWidth: true
                    Layout.leftMargin: 16
                    Layout.rightMargin: 16
                    Layout.topMargin: root.appVolumes.length > 0 ? 2 : 0
                    Layout.bottomMargin: 14
                    height: 1
                    color: "#1affffff"
                }

                // ── Input Volume ─────────────────────────────────────────────
                VolumeRow {
                    Layout.fillWidth: true
                    Layout.leftMargin: 16
                    Layout.rightMargin: 16
                    Layout.bottomMargin: 20

                    iconText: root.inputMuted ? "󰍭" : "󰍬"
                    label: "Input"
                    volume: root.inputVolume
                    muted: root.inputMuted
                    accentColor: root.green
                    textColor: root.text
                    subColor: root.subtext0
                    surfaceColor: root.surface0
                    baseColor: root.surface1

                    onVolumeUpdated: (v) => root.setInputVolume(v)
                    onMuteToggled: root.toggleInputMute()
                }

                // ── Sound Settings button ────────────────────────────────────
                Rectangle {
                    Layout.fillWidth: true
                    Layout.leftMargin: 16
                    Layout.rightMargin: 16
                    Layout.bottomMargin: 16
                    height: 44
                    radius: 12
                    color: settingsHover.containsMouse ? "#1affffff" : "#0dffffff"
                    border.color: settingsHover.containsMouse ? root.mauve : "#1affffff"
                    border.width: settingsHover.containsMouse ? 2 : 1
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Behavior on border.color { ColorAnimation { duration: 150 } }

                    scale: settingsHover.pressed ? 0.97 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Text {
                            text: "󰒓"
                            font.family: "Iosevka Nerd Font"
                            font.pixelSize: 16
                            color: settingsHover.containsMouse ? root.mauve : root.overlay0
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                        Text {
                            text: "Sound Settings"
                            color: settingsHover.containsMouse ? root.text : root.subtext0
                            font.family: "JetBrains Mono"
                            font.pixelSize: 13
                            font.bold: true
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                    }

                    MouseArea {
                        id: settingsHover
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.openPavucontrol()
                    }
                }
            }
        }
    }
}
