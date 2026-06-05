pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

Text {
    id: volumeText
    Layout.rightMargin: 12

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property real volume: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.volume : 0
    property bool muted: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.muted : false

    property string icon: {
        if (volume > 0.6)
            return "󰕾 ";
        else if (volume > 0.3)
            return "󰖀 ";
        else
            return "󰕿 ";

    }

    text: muted ? "󰝟" : icon + Math.round(volume * 100) + "%"
    color: root.blue
    font.pixelSize: root.fontSize
    font.family: root.fontFamily
    font.bold: true

    Tooltip {
        id: volumeTooltip
        targetItem: volumeText
        text: Pipewire.defaultAudioSink.description
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: volumeTooltip.visible = true
        onExited: volumeTooltip.visible = false
        onClicked: Pipewire.defaultAudioSink.audio.muted = !volumeText.muted
        onWheel: wheel => {
            var sink = Pipewire.defaultAudioSink
            if (!sink) return
            var delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05
            sink.audio.volume = Math.max(0, Math.min(1.5, sink.audio.volume + delta))
        }
    }
}
