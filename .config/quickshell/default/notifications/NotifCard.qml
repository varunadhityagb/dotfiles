pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: card

    property var notifData: null
    signal dismissed(int id)

    property color urgencyColor: {
        if (!notifData) return root.blue
        if (notifData.urgency === 0) return root.subtext0
        if (notifData.urgency === 2) return root.red
        return root.blue
    }

    // extra padding for shadow
    property int shadowPad: 12

    height: innerCol.implicitHeight + 32 + shadowPad
    width: parent ? parent.width : 500
    color: "transparent"
    clip: false

    opacity: 0
    scale: 0.92

    property real slideOffset: -20
    property real swipeOffset: 0
    property bool isSwiping: false

    transform: [
        Translate { x: card.swipeOffset; y: card.slideOffset }
    ]

    Component.onCompleted: {
        opacity = 1
        scale = 1
        slideOffset = 0
        autoDismiss.start()
    }

    Behavior on opacity {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }
    Behavior on scale {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }
    Behavior on slideOffset {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }
    Behavior on swipeOffset {
        enabled: !card.isSwiping
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    HoverHandler {
        onHoveredChanged: {
            if (hovered) autoDismiss.stop()
            else autoDismiss.restart()
        }
    }

    // swipe drag
    property real dragStartX: 0
    property real swipeDismissThreshold: 120

    MouseArea {
        id: dragArea
        anchors.fill: cardBg
        propagateComposedEvents: true

        onPressed: mouse => {
            card.dragStartX = mouse.x
            card.isSwiping = false
        }

        onPositionChanged: mouse => {
            var delta = mouse.x - card.dragStartX
            if (Math.abs(delta) > 8) {
                card.isSwiping = true
                card.swipeOffset = delta
                // fade as dragged
                card.opacity = Math.max(0.3, 1 - Math.abs(delta) / 300)
            }
        }

        onReleased: mouse => {
            if (!card.isSwiping) return
            if (Math.abs(card.swipeOffset) >= card.swipeDismissThreshold) {
                // fling out
                card.swipeOffset = card.swipeOffset > 0 ? 600 : -600
                card.opacity = 0
                closeDelay.start()
            } else {
                // snap back
                card.isSwiping = false
                card.swipeOffset = 0
                card.opacity = 1
            }
        }
    }

    Timer {
        id: autoDismiss
        interval: 5000
        repeat: false
        onTriggered: card.close()
    }

    Timer {
        id: closeDelay
        interval: 200
        repeat: false
        onTriggered: card.dismissed(card.notifData ? card.notifData.id : -1)
    }

    function close() {
        autoDismiss.stop()
        opacity = 0
        scale = 0.92
        slideOffset = 20
        closeDelay.start()
    }

    // relative timestamp
    property string relativeTime: "now"
    property date notifTime: notifData ? notifData.time : new Date()

    function updateRelativeTime() {
        var diff = Math.floor((new Date() - notifTime) / 1000)
        if (diff < 60) relativeTime = "now"
        else if (diff < 3600) relativeTime = Math.floor(diff / 60) + "m ago"
        else relativeTime = Math.floor(diff / 3600) + "h ago"
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: card.updateRelativeTime()
    }

    // shadow
    MultiEffect {
        source: cardBg
        anchors.fill: cardBg
        shadowEnabled: true
        shadowColor: "#80000000"
        shadowBlur: 0.6
        shadowVerticalOffset: 4
        shadowHorizontalOffset: 0
    }

    // actual card background
    Rectangle {
        id: cardBg
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            bottomMargin: card.shadowPad
        }
        radius: 12
        color: Qt.alpha(root.base, 0.92)
        border.color: notifData && notifData.urgency === 2
                      ? Qt.alpha(root.red, 0.5) : root.surface1

        ColumnLayout {
            id: innerCol
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 16
            }
            spacing: 6

            // header
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Rectangle {
                    width: 6
                    height: 6
                    radius: 3
                    color: card.urgencyColor
                    Layout.alignment: Qt.AlignVCenter
                }

                Image {
                    source: {
                        if (!card.notifData || card.notifData.appIcon === "") return ""
                        return card.notifData.appIcon.startsWith("/")
                            ? card.notifData.appIcon
                            : "image://icon/" + card.notifData.appIcon
                    }
                    Layout.preferredWidth: 16
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignCenter
                    visible: source !== ""
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: card.notifData ? card.notifData.appName : ""
                    color: card.urgencyColor
                    font.pixelSize: root.fontSize - 2
                    font.family: root.fontFamily
                    font.bold: true
                    Layout.fillWidth: true
                }

                Text {
                    text: card.relativeTime
                    color: root.subtext0
                    font.pixelSize: root.fontSize - 4
                    font.family: root.fontFamily
                }

                Text {
                    text: "✕"
                    color: root.subtext0
                    font.pixelSize: root.fontSize - 2
                    font.family: root.fontFamily
                    MouseArea {
                        anchors.fill: parent
                        onClicked: card.close()
                    }
                }
            }

            // notification image (album art, avatars etc)
            RowLayout {
                visible: card.notifData && card.notifData.image !== ""
                Layout.fillWidth: true
                spacing: 10

                // circular image for non-spotify
                Rectangle {
                    visible: !card.notifData.appIcon.toLowerCase().includes("spotify")
                    width: 48
                    height: 48
                    radius: 24
                    color: root.surface1
                    clip: true
                    Layout.alignment: Qt.AlignVCenter

                    Image {
                        anchors.fill: parent
                        source: card.notifData ? card.notifData.image : ""
                        fillMode: Image.PreserveAspectCrop
                    }
                }

                // spotify full width image
                Image {
                    id: notifImage
                    visible: card.notifData.appIcon.toLowerCase().includes("spotify")
                    source: card.notifData ? card.notifData.image : ""
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    fillMode: Image.PreserveAspectCrop
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        maskEnabled: true
                        maskThresholdMin: 0.5
                        maskSpreadAtMin: 1.0
                        maskSource: ShaderEffectSource {
                            sourceItem: Rectangle {
                                width: notifImage.width
                                height: notifImage.height
                                radius: 8
                            }
                        }
                    }
                }

                // text next to circular image for non-spotify
                ColumnLayout {
                    visible: !card.notifData.appIcon.toLowerCase().includes("spotify")
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: card.notifData ? card.notifData.summary : ""
                        color: root.text
                        font.pixelSize: root.fontSize
                        font.family: root.fontFamily
                        font.bold: true
                        wrapMode: Text.WordWrap
                        textFormat: Text.StyledText
                        Layout.fillWidth: true
                        visible: text !== ""
                    }

                    Text {
                        text: card.notifData ? card.notifData.body : ""
                        color: root.subtext0
                        font.pixelSize: root.fontSize - 1
                        font.family: root.fontFamily
                        wrapMode: Text.WordWrap
                        textFormat: Text.StyledText
                        Layout.fillWidth: true
                        visible: text !== ""
                    }
                }
            }

            // summary + body for spotify (or when no image)
            Text {
                visible: (card.notifData && card.notifData.image === "") ||
                        (card.notifData && card.notifData.appIcon.toLowerCase().includes("spotify"))
                text: card.notifData ? card.notifData.summary : ""
                color: root.text
                font.pixelSize: root.fontSize
                font.family: root.fontFamily
                font.bold: true
                wrapMode: Text.WordWrap
                textFormat: Text.StyledText
                Layout.fillWidth: true
            }

            Text {
                visible: (card.notifData && card.notifData.image === "") ||
                        (card.notifData && card.notifData.appIcon.toLowerCase().includes("spotify"))
                text: card.notifData ? card.notifData.body : ""
                color: root.subtext0
                font.pixelSize: root.fontSize - 1
                font.family: root.fontFamily
                wrapMode: Text.WordWrap
                textFormat: Text.StyledText
                Layout.fillWidth: true
            }

            // progress bar
            Rectangle {
                Layout.fillWidth: true
                height: 4
                radius: 2
                color: root.surface2
                visible: card.notifData !== null && card.notifData.progress >= 0

                Rectangle {
                    width: parent.width * (card.notifData ? Math.max(0, card.notifData.progress) : 0)
                    height: parent.height
                    radius: parent.radius
                    color: card.urgencyColor

                    Behavior on width {
                        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                    }
                }
            }

            // actions
            RowLayout {
                spacing: 8
                visible: card.notifData !== null && card.notifData.actionTexts.length > 0
                Layout.bottomMargin: 4

                Repeater {
                    model: card.notifData ? card.notifData.actionTexts : []

                    Rectangle {
                        required property var modelData
                        height: 28
                        radius: 6
                        color: root.surface1
                        implicitWidth: actionLabel.implicitWidth + 16

                        Text {
                            id: actionLabel
                            anchors.centerIn: parent
                            text: modelData.text
                            color: card.urgencyColor
                            font.pixelSize: root.fontSize - 1
                            font.family: root.fontFamily
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                try { modelData.invoke() } catch(e) {}
                                card.close()
                            }
                        }
                    }
                }
            }
        }
    }
}
