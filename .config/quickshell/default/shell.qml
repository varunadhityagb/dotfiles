pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "./"
import "./launcher"
import "./bar"
import "./osd"
import "./notifications"

ShellRoot {
    id: root
    MatugenColors { id: _theme }
    readonly property color base: _theme.base
    readonly property color crust: _theme.crust
    readonly property color mantle: _theme.mantle
    readonly property color text: _theme.text
    readonly property color subtext0: _theme.subtext0
    readonly property color overlay0: _theme.overlay0
    readonly property color overlay2: _theme.overlay2
    readonly property color surface0: _theme.surface0
    readonly property color surface1: _theme.surface1
    readonly property color surface2: _theme.surface2
    readonly property color mauve: _theme.mauve
    readonly property color red: _theme.red
    readonly property color peach: _theme.peach
    readonly property color blue: _theme.blue
    readonly property color green: _theme.green
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 14

    Osd { id: osd }
    NotifServer { id: notifServer }
    Launcher { id: launcher }

    Variants {
        model: Quickshell.screens
        Bar {
            required property var modelData
            screen: modelData
            dnd: notifServer.dnd
            historyCount: notifServer.history.length
            notifHistory: notifServer.history
            onRemoveHistory: id => {
                notifServer.remove(id)
                notifServer.removeHistory(id)
            }
            onClearAllHistory: notifServer.history = []
        }
    }
}
