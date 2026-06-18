pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Item {
    visible: false
    width: 0
    height: 0

    property bool micActive: false
    property bool screenShareActive: false

    property string micApp: ""
    property string screenApp: ""

    property string tooltipText: {
        let parts = []

        if (micActive)
            parts.push("󰍬 Microphone: " + micApp)

        if (screenShareActive)
            parts.push("󰹑 Screen Share: " + screenApp)

        return parts.join("\n")
    }

    Process {
        id: proc

        command: [
            "bash",
            "-c",
            `
pw-dump | jq -c '
{
  mic: [
    .[]
    | select(.type=="PipeWire:Interface:Node")
    | select(.info.props["media.class"]=="Stream/Input/Audio")
    | {
        app: (
          .info.props["application.process.binary"]
          // .info.props["application.name"]
          // "Unknown"
        )
      }
  ],

  screen: [
    .[]
    | select(.type=="PipeWire:Interface:Node")
    | select(.info.props["media.class"]=="Stream/Input/Video")
    | {
        app: (
            .info.props["application.process.binary"]
            // .info.props["application.name"]
            // ""
        ),
        node: (
            .info.props["node.name"]
            // ""
        )
        }
  ]
}'
`
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text)

                    micActive = data.mic.length > 0
                    micApp = micActive
                        ? data.mic[0].app
                        : ""

                    screenShareActive = data.screen.length > 0

                    screenApp = screenShareActive
                        ? (data.screen[0].app || data.screen[0].node || "Unknown")
                        : ""

                } catch (e) {
                    console.log("PrivacyModel:", e)
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true

        onTriggered: {
            proc.running = true
        }
    }

    Component.onCompleted: {
        proc.running = true
    }
}
