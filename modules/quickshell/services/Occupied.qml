import QtQuick
import Quickshell.Hyprland

QtObject {
    id: svc

    property var occupiedIds: []

    function recompute() {
        const out = []

        // Hyprland.toplevels is the REAL-TIME list of all windows
        const tl = Hyprland.toplevels
        if (!tl) {
            occupiedIds = []
            return
        }

        for (let i = 0; i < tl.count; i++) {
            const win = tl.get(i)
            if (!win || !win.workspace)
                continue

            const wsId = win.workspace.id
            if (out.indexOf(wsId) === -1)
                out.push(wsId)
        }

        occupiedIds = out
    }

    function isOccupied(id) {
        return occupiedIds.indexOf(id) !== -1
    }

    Connections {
        target: Hyprland

        // This fires CONSTANTLY… but now recompute() works
        onRawEvent: {
            svc.recompute()
        }
    }

    Component.onCompleted: recompute()
}
