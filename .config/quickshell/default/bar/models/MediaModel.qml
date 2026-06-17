pragma Singleton
import QtQuick
import Quickshell.Services.Mpris

QtObject {
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
    ) ?? null

    property string title: player?.trackTitle ?? ""
    property string artist: player?.trackArtist ?? ""
    property string playerName: player?.identity ?? ""

    property string icon: {
        if (!player) return "󰎆"
        switch (player.desktopEntry) {
            case "spotify":
                return ""
            default:
                return "󰎆"
        }
    }

    property string tooltipText: {
        var s = ""
        if (artist) {
            s += "By " + artist
        }
        if (playerName) {
            s += (s ? "\n" : "") + "On " + playerName
        }
        return s || "No media info"
    }

    function playPause() {
        if (player) player.playPause()
    }

    function next() {
        if (player) player.next()
    }

    function previous() {
        if (player) player.previous()
    }
}
