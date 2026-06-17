pragma Singleton
import QtQuick
import Quickshell.Services.Pipewire

Item {
    visible: false
    width: 0
    height: 0
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property real volume: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.volume : 0
    property bool muted: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.muted : false

    property string icon: {
        if (muted) return "󰝟"
        if (volume > 0.6) return "󰕾 "
        if (volume > 0.3) return "󰖀 "
        return "󰕿 "
    }

    property string outputDevice: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.description : "Unknown"
    property string tooltipText: outputDevice

    function toggleMute() {
        if (Pipewire.defaultAudioSink) {
            Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
        }
    }

    function setVolume(percent) {
        var sink = Pipewire.defaultAudioSink
        if (!sink) return
        sink.audio.volume = Math.max(0, Math.min(1.5, percent))
    }
}
