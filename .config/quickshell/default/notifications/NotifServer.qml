pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Io
import QtQuick

Scope {
    id: notifScope

    property var history: []
    property var notifications: []
    property int nextId: 0
    property bool dnd: false

    function remove(id) {
        notifications = notifications.filter(n => n.id !== id)
    }

    function removeHistory(id) {
        history = history.filter(h => h.id !== id)
    }

    // IPC socket for toggling DND
    IpcHandler {
        target: "notifications"

        function toggle_dnd() {
            notifScope.dnd = !notifScope.dnd
            // if turning on, clear all visible popups
            if (notifScope.dnd) {
                notifScope.notifications = []
            }
            console.log("DND:", notifScope.dnd)
        }

        function get_dnd() : string {
            return notifScope.dnd ? "enabled" : "disabled"
        }
    }

    NotificationServer {
        actionsSupported: true
        imageSupported: true
        bodyMarkupSupported: true
        keepOnReload: true

        onNotification: notif => {
            console.log("appName", notif.appName)
            console.log("summary", notif.summary)
            console.log("body", notif.body)
            console.log("appIcon", notif.appIcon)
            console.log("image", notif.image)
            var hints = notif.hints ?? {}
            var progress = -1
            if (hints["value"] !== undefined)
                progress = Math.max(0, Math.min(100, parseInt(hints["value"]))) / 100

            var isSpotify = (notif.appIcon || "").toLowerCase().includes("spotify")

            var entry = {
                id: notifScope.nextId++,
                replacesId: notif.replacesId ?? -1,
                appName: (notif.appName !== "") ? notif.appName : notif.appIcon,
                summary: notif.summary,
                body: notif.body,
                appIcon: notif.appIcon ?? "",
                image: notif.image ?? "",
                urgency: notif.urgency ?? 1,
                time: new Date(),
                progress: progress,
                actionTexts: notif.actions.map(a => ({
                    text: a.text,
                    invoke: () => a.invoke()
                }))
            }


            // always add to history regardless of DND
            notifScope.history = [{
                id: entry.id,
                appName: entry.appName,
                summary: entry.summary,
                body: entry.body,
                time: entry.time
            }, ...notifScope.history]

            // skip popup if DND
            if (notifScope.dnd) return

            // handle replacesId
            if (entry.replacesId > 0) {
                var existingIdx = notifScope.notifications.findIndex(
                    n => n.replacesId === entry.replacesId || n.id === entry.replacesId
                )
                if (existingIdx !== -1) {
                    entry.id = notifScope.notifications[existingIdx].id
                    var updated = [...notifScope.notifications]
                    updated[existingIdx] = entry
                    notifScope.notifications = updated
                    return
                }
            }

            // Spotify grouping
            if (isSpotify) {
                var spotifyIdx = notifScope.notifications.findIndex(
                    n => n.appIcon.toLowerCase().includes("spotify")
                )
                if (spotifyIdx !== -1) {
                    entry.id = notifScope.notifications[spotifyIdx].id
                    var updatedSpotify = [...notifScope.notifications]
                    updatedSpotify[spotifyIdx] = entry
                    notifScope.notifications = updatedSpotify
                    return
                }
            }

            notifScope.notifications = [...notifScope.notifications, entry]
        }
    }

    NotifPopup {
        notifications: notifScope.notifications
        onDismiss: id => notifScope.remove(id)
    }
}
