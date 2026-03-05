// modules/PowerMenu.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.theme as Theme

PopupWindow {
    id: pop

    // controlled by Power.qml
    property bool open: false
    property Item anchorItem: null
    property int gap: 10
    signal requestClose()

    // Keep window alive while closing animation plays
    visible: (open && anchorItem !== null) || closing
    color: "transparent"

    // ---------- icons ----------
    property url iconDir: Qt.resolvedUrl("../assets/icons")
    property url lockIcon:     iconDir + "/lock.svg"
    property url sleepIcon:    iconDir + "/sleep.svg"
    property url logoutIcon:   iconDir + "/logout.svg"
    property url rebootIcon:   iconDir + "/reboot.svg"
    property url shutdownIcon: iconDir + "/power.svg"

    // ---------- commands ----------
    property var lockCommand: ["qs", "ipc", "call", "lockscreen", "lock"]
    property var sleepCommand:    ["systemctl", "suspend"]
    property var logoutCommand:   ["hyprctl", "dispatch", "exit"]
    property var rebootCommand:   ["systemctl", "reboot"]
    property var shutdownCommand: ["systemctl", "poweroff"]

    // ---------- theme ----------
    property color panelBg: Theme.Theme.bg
    property color itemHover: "#000000"
    property int panelRadius: 16

    // ---------- shadow (small + clean corners) ----------
    property int shadowPad: 10          // padding so shadow won't get clipped
    property real shadowOpacity: 0.28
    property real shadowBlur: 0.55
    property int shadowOffsetY: 6

    // --- open/close animation state ---
    property real animY: 0
    property real animScale: 1
    property real animOpacity: 1
    property bool closing: false

    function playOpenAnim() {
        closing = false
        animY = -14
        animScale = 0.975
        animOpacity = 0
        openAnim.restart()
    }

    function playCloseAnim() {
        if (closing) return
        closing = true
        focusGrab.active = false
        requestClose() // ask Power.qml to set open=false
        closeAnim.restart()
    }

    // run helper (runs the specific Process you pass in)
    function run(proc) {
        proc.running = false
        proc.running = true
        playCloseAnim()
    }

    // one Process per command
    Process { id: lockProc;     command: pop.lockCommand }
    Process { id: sleepProc;    command: pop.sleepCommand }
    Process { id: logoutProc;   command: pop.logoutCommand }
    Process { id: rebootProc;   command: pop.rebootCommand }
    Process { id: shutdownProc; command: pop.shutdownCommand }

    // If parent toggles open false directly, animate out
    onOpenChanged: {
        if (open && anchorItem !== null) {
            // opening: handled by onVisibleChanged
        } else if (!open && visible && !closing) {
            playCloseAnim()
        }
    }

    onVisibleChanged: {
        if (visible && open) playOpenAnim()
    }

    LazyLoader {
        id: backdropLoader
        activeAsync: pop.visible   // stay alive while close anim plays too

        PanelWindow {
            id: backdrop
            color: "transparent"
            visible: true
            exclusiveZone: -1

            anchors { top: true; bottom: true; left: true; right: true }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                hoverEnabled: true
                onPressed: pop.playCloseAnim()
            }
        }
    }

    // Click outside to close (focus based, keep as extra fallback)
    HyprlandFocusGrab {
        id: focusGrab
        windows: [ pop ]
        active: pop.visible && !pop.closing
        onCleared: pop.playCloseAnim()
    }

    // Esc closes
    Item {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: pop.playCloseAnim()
    }

    // --- bounce IN (same as your popup) ---
    ParallelAnimation {
        id: openAnim

        SequentialAnimation {
            NumberAnimation { target: pop; property: "animY"; from: -14; to: 3; duration: 140; easing.type: Easing.OutCubic }
            NumberAnimation { target: pop; property: "animY"; from: 3; to: 0; duration: 170; easing.type: Easing.OutBack; easing.overshoot: 1.35 }
        }

        SequentialAnimation {
            NumberAnimation { target: pop; property: "animScale"; from: 0.975; to: 1.03; duration: 140; easing.type: Easing.OutCubic }
            NumberAnimation { target: pop; property: "animScale"; from: 1.03; to: 1.0; duration: 190; easing.type: Easing.OutBack; easing.overshoot: 1.25 }
        }

        NumberAnimation { target: pop; property: "animOpacity"; from: 0; to: 1; duration: 160; easing.type: Easing.OutCubic }
    }

    // --- bounce OUT (same as your popup) ---
    ParallelAnimation {
        id: closeAnim

        SequentialAnimation {
            NumberAnimation { target: pop; property: "animY"; from: 0; to: 2; duration: 70; easing.type: Easing.OutCubic }
            NumberAnimation { target: pop; property: "animY"; from: 2; to: -10; duration: 140; easing.type: Easing.InCubic }
        }

        NumberAnimation { target: pop; property: "animScale"; from: 1.0; to: 0.98; duration: 170; easing.type: Easing.InCubic }
        NumberAnimation { target: pop; property: "animOpacity"; from: 1; to: 0; duration: 150; easing.type: Easing.InCubic }

        onStopped: pop.closing = false
    }

    // ---- centered-under-button anchoring ----
    anchor.item: anchorItem
    Connections {
        target: pop.anchor
        function onAnchoring() {
            if (!pop.anchorItem) return
            pop.anchor.rect.x = Math.round(pop.anchorItem.width / 2 - pop.width / 2)
            // subtract shadowPad so the *card* starts at gap (not the padded window)
            pop.anchor.rect.y = Math.round(pop.anchorItem.height + pop.gap - pop.shadowPad)
            pop.anchor.rect.width = 1
            pop.anchor.rect.height = 1
        }
    }

    // size to content + shadow padding (prevents shadow being clipped)
    width:  Math.round(row.implicitWidth  + 20 + pop.shadowPad * 2)
    height: Math.round(row.implicitHeight + 20 + pop.shadowPad * 2)

    // animate the whole card (shadow + clip move together)
    Item {
        id: animWrap
        anchors.fill: parent
        anchors.margins: pop.shadowPad
        y: pop.animY
        scale: pop.animScale
        opacity: pop.animOpacity
        transformOrigin: Item.Top

        // Shadow + background (NO clip here)
        Rectangle {
            id: card
            anchors.fill: parent
            radius: pop.panelRadius
            color: pop.panelBg
            antialiasing: true

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowOpacity: pop.shadowOpacity
                shadowVerticalOffset: pop.shadowOffsetY
                shadowBlur: pop.shadowBlur
            }
        }

        // Content clip (rounded corners, NO shadow here)
        Rectangle {
            id: clipper
            anchors.fill: parent
            radius: pop.panelRadius
            color: "transparent"
            clip: true
            antialiasing: true

            // eat clicks inside so they don't fall through to the backdrop
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                hoverEnabled: true
                propagateComposedEvents: false
                onPressed: mouse.accepted = true
                onClicked: mouse.accepted = true
            }

            RowLayout {
                id: row
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                ActionItem { icon: pop.lockIcon;     onTriggered: pop.run(lockProc) }
                ActionItem { icon: pop.sleepIcon;    onTriggered: pop.run(sleepProc) }
                ActionItem { icon: pop.logoutIcon;   onTriggered: pop.run(logoutProc) }
                ActionItem { icon: pop.rebootIcon;   onTriggered: pop.run(rebootProc) }
                ActionItem { icon: pop.shutdownIcon; onTriggered: pop.run(shutdownProc) }
            }
        }
    }

    component ActionItem : Item {
        id: it
        implicitWidth: 76
        implicitHeight: 76

        property url icon: ""
        signal triggered()

        property bool hovered: false
        property bool pressed: false

        scale: pressed ? 0.94 : (hovered ? 1.06 : 1.0)
        Behavior on scale { NumberAnimation { duration: 130; easing.type: Easing.OutCubic } }

        Rectangle {
            anchors.fill: parent
            radius: 12
            color: pressed ? pop.itemPressed : (hovered ? pop.itemHover : "transparent")
        }

        Rectangle {
            anchors.fill: parent
            radius: 12
            color: "#ffffff"
            opacity: hovered ? 0.06 : 0.0
            Behavior on opacity { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
        }

        Image {
            anchors.centerIn: parent
            width: 40
            height: 40
            source: it.icon
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
            sourceSize.width: 64
            sourceSize.height: 64

            scale: pressed ? 0.92 : (hovered ? 1.04 : 1.0)
            Behavior on scale { NumberAnimation { duration: 130; easing.type: Easing.OutCubic } }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: it.hovered = true
            onExited: { it.hovered = false; it.pressed = false }
            onPressed: it.pressed = true
            onReleased: it.pressed = false
            onClicked: it.triggered()
        }
    }
}
