import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Popup {
    id: menu
    width: 340
    modal: false
    focus: true
    padding: 10
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    // Theme
    property color bg: "#181825"
    property color border: "#313244"
    property color text: "#cdd6f4"
    property color subtext: "#a6adc8"
    property color btnBg: "#313244"
    property color btnHover: "#2f3042"
    property color btnPress: "#2a2b3a"

    property string statusText: ""
    property bool busy: false

    // device row fields:
    // name, mac, connected, paired, trusted
    ListModel { id: devModel }

    function openFrom(anchorItem, relativeItem) {
        menu.open()
        Qt.callLater(function() {
            const p = menu.parent ? menu.parent : (relativeItem || anchorItem)
            if (!p) return

            const anchor = anchorItem.mapToItem(p, anchorItem.width/2, anchorItem.height)
            menu.x = Math.round(anchor.x - menu.width/2)
            menu.y = Math.round(anchor.y + 8)

            if (p.width) menu.x = Math.max(6, Math.min(menu.x, Math.round(p.width - menu.width - 6)))
        })
    }

    function refresh() {
        statusText = ""
        devModel.clear()
        listProc.running = false
        listProc.running = true
    }

    function runBt(cmd) {
        // one-at-a-time to keep things sane
        busy = true
        statusText = "Working…"
        actionProc.command = ["bash", "-lc", cmd + " 2>/dev/null || true"]
        actionProc.running = false
        actionProc.running = true
    }

    function connectFlow(mac, paired, connected) {
        if (!mac || busy) return

        if (connected) {
            runBt("bluetoothctl disconnect " + mac)
            return
        }

        // If paired: connect
        if (paired) {
            runBt("bluetoothctl connect " + mac)
            return
        }

        // If not paired: pair + trust + connect (best-effort)
        runBt([
            "bluetoothctl pair " + mac,
            "bluetoothctl trust " + mac,
            "bluetoothctl connect " + mac
        ].join(" && "))
    }

    // List devices and their properties
    Process {
        id: listProc
        command: ["bash", "-lc",
            // Get paired devices list first; then for each, pull info (Connected/Paired/Trusted/Name)
            "bluetoothctl devices paired | awk '{print $2}' | while read mac; do " +
            "  info=$(bluetoothctl info $mac); " +
            "  name=$(echo \"$info\" | sed -n 's/^\\s*Name: //p' | head -n1); " +
            "  conn=$(echo \"$info\" | grep -q \"Connected: yes\" && echo yes || echo no); " +
            "  pair=$(echo \"$info\" | grep -q \"Paired: yes\" && echo yes || echo no); " +
            "  trust=$(echo \"$info\" | grep -q \"Trusted: yes\" && echo yes || echo no); " +
            "  echo \"$mac\\t${name:-Unknown}\\t$conn\\t$pair\\t$trust\"; " +
            "done"
        ]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.split("\n").map(l => l.trim()).filter(l => l.length > 0)
                for (let i = 0; i < lines.length; i++) {
                    const parts = lines[i].split("\t")
                    const mac = (parts[0] || "").trim()
                    const name = (parts[1] || "Unknown").trim()
                    const connected = (parts[2] || "no").trim() === "yes"
                    const paired = (parts[3] || "no").trim() === "yes"
                    const trusted = (parts[4] || "no").trim() === "yes"

                    if (!mac) continue
                    devModel.append({ mac, name, connected, paired, trusted })
                }
                if (devModel.count === 0) statusText = "No paired devices."
            }
        }
    }

    // Action runner (connect/disconnect/pair)
    Process {
        id: actionProc
        stdout: StdioCollector {
            onStreamFinished: {
                const msg = text.trim()
                // bluetoothctl often prints nothing on success; keep it short
                if (msg) statusText = msg
            }
        }
        onExited: {
            busy = false
            statusText = ""
            refresh()
        }
    }

    onOpened: refresh()

    background: Rectangle {
        radius: 16
        color: menu.bg
        border.width: 1
        border.color: menu.border
    }

    contentItem: ColumnLayout {
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: "Bluetooth"
                color: menu.text
                font.pixelSize: 14
                font.weight: 700
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                width: 26
                height: 26
                radius: 10
                color: refreshMouse.pressed ? menu.btnPress : (refreshMouse.containsMouse ? menu.btnHover : menu.btnBg)
                border.width: 1
                border.color: "#45475a"
                Behavior on color { ColorAnimation { duration: 120 } }

                Text {
                    anchors.centerIn: parent
                    text: "󰑓"
                    font.family: "Hack Nerd Font"
                    font.pixelSize: 14
                    color: menu.text
                    opacity: 0.95
                }

                MouseArea {
                    id: refreshMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: menu.refresh()
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            radius: 1
            color: menu.border
            opacity: 0.9
        }

        Flickable {
            Layout.fillWidth: true
            Layout.preferredHeight: 240
            clip: true
            contentWidth: width
            contentHeight: listCol.implicitHeight

            Column {
                id: listCol
                width: parent.width
                spacing: 6

                Repeater {
                    model: devModel

                    Rectangle {
                        width: parent.width
                        height: 44
                        radius: 14
                        color: rowMouse.pressed ? menu.btnPress : (rowMouse.containsMouse ? menu.btnHover : menu.btnBg)
                        border.width: 1
                        border.color: "#45475a"
                        Behavior on color { ColorAnimation { duration: 120 } }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 10

                            Text {
                                text: model.connected ? "󰂱" : "󰂯"
                                font.family: "Hack Nerd Font"
                                font.pixelSize: 18
                                color: menu.text
                                Layout.alignment: Qt.AlignVCenter
                                opacity: model.connected ? 1.0 : 0.9
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: -2

                                Text {
                                    text: model.name
                                    color: menu.text
                                    font.pixelSize: 13
                                    font.weight: model.connected ? 800 : 600
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: model.connected ? "Connected" : (model.paired ? "Paired" : "Not paired")
                                    color: menu.subtext
                                    font.pixelSize: 11
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }

                            Text {
                                text: model.connected ? "Disconnect" : "Connect"
                                color: menu.subtext
                                font.pixelSize: 11
                                opacity: 0.95
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }

                        MouseArea {
                            id: rowMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            enabled: !menu.busy
                            onClicked: menu.connectFlow(model.mac, model.paired, model.connected)
                        }
                    }
                }
            }
        }

        Text {
            Layout.fillWidth: true
            text: menu.statusText
            color: menu.subtext
            font.pixelSize: 11
            opacity: 0.95
            visible: menu.statusText.length > 0
            elide: Text.ElideRight
        }
    }
}
