import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: row
    height: 72

    property string iconText:    "󰕾"
    property string label:       "Volume"
    property int    volume:      50
    property bool   muted:       false
    property color  accentColor: "#cba6f7"
    property color  textColor:   "#cdd6f4"
    property color  subColor:    "#a6adc8"
    property color  surfaceColor:"#313244"
    property color  baseColor:   "#1e1e2e"

    signal volumeUpdated(int v)
    signal muteToggled()

    // Glassy card background
    Rectangle {
        anchors.fill: parent
        radius: 12
        color: "#0dffffff"
        border.color: "#1affffff"
        border.width: 1
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 12

        // Icon button
        Rectangle {
            width: 36; height: 36; radius: 10
            color: iconMa.containsMouse ? "#1affffff" : "transparent"
            border.color: iconMa.containsMouse ? row.accentColor : "transparent"
            border.width: 1
            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                anchors.centerIn: parent
                text: row.iconText
                font.family: "Iosevka Nerd Font"
                font.pixelSize: 20
                color: row.muted ? row.subColor : row.accentColor
                opacity: row.muted ? 0.5 : 1.0
                Behavior on color { ColorAnimation { duration: 200 } }
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }

            MouseArea {
                id: iconMa
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: row.muteToggled()
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            RowLayout {
                Layout.fillWidth: true

                Text {
                    Layout.fillWidth: true
                    text: row.label
                    color: row.textColor
                    font.family: "JetBrains Mono"
                    font.pixelSize: 13
                    font.bold: true
                    elide: Text.ElideRight
                    opacity: row.muted ? 0.5 : 1.0
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }

                Text {
                    text: row.muted ? "Muted" : (row.volume + "%")
                    color: row.muted ? row.subColor : row.accentColor
                    font.family: "JetBrains Mono"
                    font.pixelSize: 12
                    font.bold: true
                    Behavior on color { ColorAnimation { duration: 200 } }
                }
            }

            // Slider
            Item {
                Layout.fillWidth: true
                height: 20

                // Track background
                Rectangle {
                    id: trackBg
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 6
                    radius: 3
                    color: row.surfaceColor
                }

                // Filled portion
                Item {
                    anchors.verticalCenter: trackBg.verticalCenter
                    width: Math.max(thumb.width / 2, (row.volume / 100) * trackBg.width)
                    height: trackBg.height
                    clip: true

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        maskEnabled: true
                        maskSource: fillMask
                    }

                    Rectangle {
                        id: fillMask
                        anchors.fill: parent
                        radius: 3
                        visible: false
                        layer.enabled: true
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: row.muted ? Qt.darker(row.accentColor, 1.5) : row.accentColor
                        opacity: row.muted ? 0.4 : 1.0
                        Behavior on color { ColorAnimation { duration: 200 } }
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                    }
                }

                // Thumb
                Rectangle {
                    id: thumb
                    anchors.verticalCenter: trackBg.verticalCenter
                    x: Math.max(0, Math.min(
                        (row.volume / 100) * (trackBg.width - width),
                        trackBg.width - width))
                    Behavior on x { NumberAnimation { duration: 80 } }
                    width: 18; height: 18; radius: 9
                    color: row.muted ? row.subColor : row.accentColor
                    Behavior on color { ColorAnimation { duration: 200 } }

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: "#000000"
                        shadowOpacity: 0.4
                        shadowBlur: 0.8
                        shadowVerticalOffset: 2
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    function calcVolume(mx) {
                        return Math.max(0, Math.min(100, Math.round(mx / trackBg.width * 100)))
                    }
                    onPressed: (mouse) => row.volumeUpdated(calcVolume(mouse.x))
                    onPositionChanged: (mouse) => { if (pressed) row.volumeUpdated(calcVolume(mouse.x)) }
                    onWheel: (wheel) => {
                        let delta = wheel.angleDelta.y > 0 ? 5 : -5
                        row.volumeUpdated(Math.max(0, Math.min(100, row.volume + delta)))
                    }
                }
            }
        }
    }
}
