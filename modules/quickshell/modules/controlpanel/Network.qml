import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import qs.services as Services

// uses: theme/Theme.qml (pragma Singleton, root Singleton { ... })
import qs.theme as Theme

Item {
    id: root
    implicitHeight: 60
    Layout.fillWidth: true

    property var onActivate: function() {}

    readonly property bool isConnected: Services.Network.connected
    property bool wifiEnabled: true

    // Direct bindings to Theme properties - 3 states: connected/disconnected/off
    readonly property color bgColor: {
        if (!wifiEnabled) return Theme.Theme.gridBttn_off_bg
        return isConnected ? Theme.Theme.accent : Theme.Theme.gridBttn_disc_bg
    }
    readonly property color borderColor: Theme.Theme.border
    readonly property color iconColor: {
        if (!wifiEnabled) return Theme.Theme.gridBttn_off_ttl
        return isConnected ? Theme.Theme.gridBttn_on_ttl : Theme.Theme.gridBttn_disc_ttl
    }
    readonly property color titleColor: {
        if (!wifiEnabled) return Theme.Theme.gridBttn_off_ttl
        return isConnected ? Theme.Theme.gridBttn_on_ttl : Theme.Theme.gridBttn_disc_ttl
    }
    readonly property color subtitleColor: {
        if (!wifiEnabled) return Theme.Theme.gridBttn_off_subt
        return isConnected ? Theme.Theme.gridBttn_on_subt : Theme.Theme.gridBttn_disc_subt
    }

    Component.onCompleted: {
        console.log("[Network] theme =", Theme.Theme.current)
    }

    function wifiIcon(enabled, connected, strength) {
        if (!enabled) return "󰤭"
        if (!connected) return "󰤮"
        if (strength >= 75) return "󰤨"
        if (strength >= 50) return "󰤥"
        if (strength >= 25) return "󰤢"
        return "󰤟"
    }

    function subtitleText() {
        if (!wifiEnabled) return "Off"
        return isConnected ? "Connected" : "Disconnected"
    }

    Process {
        id: wifiStateProc
        command: ["bash", "-lc", "nmcli -t -f WIFI general 2>/dev/null || echo enabled"]
        stdout: StdioCollector {
            onStreamFinished: {
                const s = text.trim().toLowerCase()
                root.wifiEnabled = (s === "enabled")
            }
        }
    }

    Timer {
        interval: 1200
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            wifiStateProc.running = false
            wifiStateProc.running = true
        }
    }

    Process {
        id: wifiToggleProc
        command: ["bash", "-lc", "nmcli radio wifi " + (root.wifiEnabled ? "off" : "on")]
    }

    Rectangle {
        id: card
        anchors.fill: parent
        radius: 16
        color: bgColor
        border.width: 1
        border.color: borderColor

        property bool hovered: false
        property bool pressed: false
        scale: pressed ? 0.98 : (hovered ? 1.01 : 1.0)

        Behavior on scale { NumberAnimation { duration: 110; easing.type: Easing.OutCubic } }
        Behavior on color { ColorAnimation { duration: 120 } }
        Behavior on border.color { ColorAnimation { duration: 120 } }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10

            Text {
                text: wifiIcon(root.wifiEnabled, root.isConnected, Services.Network.signalStrength)
                color: iconColor
                font.pixelSize: 18
                font.family: "Hack Nerd Font"
                opacity: wifiEnabled ? 1.0 : 0.85
                Layout.alignment: Qt.AlignVCenter
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: -3
                Layout.alignment: Qt.AlignVCenter

                Text {
                    Layout.fillWidth: true
                    text: root.wifiEnabled ? (Services.Network.connectedSsid || "Wi-Fi") : "Wi-Fi"
                    color: titleColor
                    font.pixelSize: 14
                    font.weight: 600
                    elide: Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true
                    text: subtitleText()
                    color: subtitleColor
                    opacity: 0.9
                    font.pixelSize: 12
                    elide: Text.ElideRight
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: card.hovered = true
            onExited: card.hovered = false
            onPressed: card.pressed = true
            onReleased: card.pressed = false
            onClicked: {
                wifiToggleProc.running = false
                wifiToggleProc.running = true
                wifiStateProc.running = false
                wifiStateProc.running = true
                root.onActivate()
            }
        }
    }
}