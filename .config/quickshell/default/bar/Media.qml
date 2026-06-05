pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris


RowLayout {
    id: rootWidget

    spacing: 6
    Layout.leftMargin: 16

    property var excludedPlayers: [
        /^brave/i,
        /^firefox/i,
        /^chromium/i
    ]

    property var players: Mpris.players.values.filter(p => {
        const targets = [
            p.desktopEntry ?? "",
            p.identity ?? ""
        ]

        return !excludedPlayers.some(pattern =>
            targets.some(value =>
                pattern instanceof RegExp
                    ? pattern.test(value)
                    : pattern.toLowerCase() === value.toLowerCase()
            )
        )
    })

    property var player: players.find(
        p => p.playbackState === MprisPlaybackState.Playing
    ) ??  null

    visible: player !== null

    function iconForPlayer(player) {
        if (!player)
            return "󰎆"

        switch (player.desktopEntry) {
        case "spotify":
            return ""
        default:
            return "󰎆"
        }
    }

    Text {
        text: iconForPlayer(player)
        color: root.blue
        font.pixelSize: root.fontSize + 5
        font.family: root.fontFamily
    }

    Item {
        id: clipper

        Layout.maximumWidth: 250
        implicitHeight: textItem.height
        implicitWidth: Math.min(textItem.contentWidth, 260)

        clip: true

        Text {
            id: textItem

            property string title: player?.trackTitle ?? ""
            property string artist: player?.trackArtist ?? ""
            property string playerName: player?.identity ?? ""

            text: playerName + " | "
                  + (artist ? artist + " — " + title : title)

            color: root.text
            font.pixelSize: root.fontSize
            font.family: root.fontFamily

            x: marquee.running ? -marqueeOffset : 0

            property real marqueeOffset: 0

            SequentialAnimation on marqueeOffset {
                id: marquee

                running: textItem.contentWidth > clipper.width

                loops: Animation.Infinite

                PauseAnimation {
                    duration: 1000
                }

                NumberAnimation {
                    from: 0
                    to: textItem.contentWidth - clipper.width + 20
                    duration: 8000
                    easing.type: Easing.Linear
                }

                PauseAnimation {
                    duration: 1000
                }

                ScriptAction {
                    script: textItem.marqueeOffset = 0
                }
            }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
        }

    }
}
