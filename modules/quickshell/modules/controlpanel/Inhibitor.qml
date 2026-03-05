// modules/controlpanel/IdleInhibitToggle.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import qs.theme as Theme

Item {
    id: root
    implicitHeight: 60
    Layout.fillWidth: true

    property var onActivate: function() {}
    property string fallbackTitle: "Caffiene"

    // true while our inhibitor process is running
    readonly property bool isInhibiting: inhibitProc.running

    // Direct bindings to Theme properties - simple on/off only
    readonly property color bgColor:       isInhibiting ? Theme.Theme.accent : Theme.Theme.gridBttn_off_bg
    readonly property color borderColor:   Theme.Theme.border
    readonly property color iconColor:     isInhibiting ? Theme.Theme.gridBttn_on_ttl : Theme.Theme.gridBttn_off_ttl
    readonly property color titleColor:    isInhibiting ? Theme.Theme.gridBttn_on_ttl : Theme.Theme.gridBttn_off_ttl
    readonly property color subtitleColor: isInhibiting ? Theme.Theme.gridBttn_on_subt : Theme.Theme.gridBttn_off_subt

    function subtitleText() {
        return isInhibiting ? "Inhibiting idle" : "Idle allowed"
    }

    // Long-lived inhibitor. Toggling `running` starts/stops it (SIGTERM on stop). :contentReference[oaicite:1]{index=1}
    Process {
        id: inhibitProc
        command: [
            "bash", "-lc",
            "systemd-inhibit --what=idle --mode=block --who='Quickshell' --why='Idle inhibited (toggle)' " +
            "bash -c 'while true; do sleep 3600; done'"
        ]
        running: false
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
                text: ""
                color: iconColor
                font.pixelSize: 18
                font.family: "Hack Nerd Font"
                opacity: isInhibiting ? 1.0 : 0.9
                Layout.alignment: Qt.AlignVCenter
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: -3
                Layout.alignment: Qt.AlignVCenter

                Text {
                    Layout.fillWidth: true
                    text: root.fallbackTitle
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
                inhibitProc.running = !inhibitProc.running
                root.onActivate()
            }
        }
    }
}
