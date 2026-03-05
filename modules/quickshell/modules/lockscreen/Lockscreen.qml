import QtQuick
import Quickshell.Wayland
import Quickshell.Io

Item {
    id: root

    readonly property bool secure: lock.secure
    property bool locked: lock.locked

    function lockNow() {
        lockContext.reset()
        lock.locked = true
    }

    function unlockNow() {
        lock.locked = false
        lockContext.reset()
    }

    LockContext {
        id: lockContext
        onUnlocked: root.unlockNow()
    }

    WlSessionLock {
        id: lock
        locked: false

        // This component is created once per screen when locked becomes true. :contentReference[oaicite:4]{index=4}
        WlSessionLockSurface {
            LockSurface {
                anchors.fill: parent
                context: lockContext
            }
        }
    }

    // Keybind-friendly IPC
    IpcHandler {
        target: "lockscreen"

        function lock()    { root.lockNow() }
        function unlock()  { root.unlockNow() }
        function toggle()  { root.locked ? root.unlockNow() : root.lockNow() }
        function status()  { return root.locked ? "locked" : "unlocked" }
    }
}
