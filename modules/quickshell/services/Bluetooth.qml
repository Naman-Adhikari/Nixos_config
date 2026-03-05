pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property bool powered: false
    property bool connected: false
    property string deviceName: ""   // connected device name (first one), or ""

    function refresh() {
        poweredProc.running = false
        poweredProc.running = true

        connectedDevProc.running = false
        connectedDevProc.running = true
    }

    Timer {
        interval: 3000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    // Powered: yes/no
    Process {
        id: poweredProc
        command: ["bash", "-lc", "bluetoothctl show | awk -F': ' '/Powered/ {print $2; exit}'"]

        stdout: StdioCollector {
            onStreamFinished: {
                var v = text.trim().toLowerCase()
                root.powered = (v === "yes" || v === "true" || v === "on")
                if (!root.powered) {
                    root.connected = false
                    root.deviceName = ""
                }
            }
        }
    }

    // First connected device line:
    // "Device AA:BB:CC:DD:EE:FF Some Device Name"
    Process {
        id: connectedDevProc
        command: ["bash", "-lc", "bluetoothctl devices Connected | head -n1"]

        stdout: StdioCollector {
            onStreamFinished: {
                var line = text.trim()

                if (!root.powered || line.length === 0) {
                    root.connected = false
                    root.deviceName = ""
                    return
                }

                if (line.indexOf("Device ") === 0) {
                    var rest = line.slice(7) // after "Device "
                    var firstSpace = rest.indexOf(" ")
                    if (firstSpace > 0) {
                        var name = rest.slice(firstSpace + 1).trim()
                        root.deviceName = name
                        root.connected = name.length > 0
                        return
                    }
                }

                // fallback
                root.connected = false
                root.deviceName = ""
            }
        }
    }
}
