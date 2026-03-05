import QtQuick
import Quickshell
import Quickshell.Io
import qs.theme as Theme

Item {
    id: root
    implicitWidth: 28
    implicitHeight: 28

    // theme
    property color ringBg: "#cdd6f4"
    property color ringFg: Theme.Theme.accent
    property color iconColor: Theme.Theme.accent

    // ring tuning
    property int ringWidth: 3
    property real ringInset: 0.5

    // temperature tuning
    property real maxTempC: 100.0
    property int tempYOffset: 1

    // data
    property real tempC: 0.0
    property real usedFrac: 0.0
    readonly property int tempRounded: Math.round(tempC)

    property var onActivate: function() {}

    // hover/press
    property bool hovered: false
    property bool pressed: false
    scale: pressed ? 0.96 : (hovered ? 1.03 : 1.0)
    Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

    // ---------- RING ----------
    Canvas {
        id: ring
        anchors.fill: parent
        antialiasing: true

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        Component.onCompleted: requestPaint()

        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()

            const w = width
            const h = height
            if (w <= 0 || h <= 0) return

            const cx = w / 2
            const cy = h / 2
            const r = Math.max(
                0,
                Math.min(w, h) / 2 - (root.ringWidth / 2) - root.ringInset
            )

            const start = -Math.PI / 2
            const span  = Math.PI * 2
            const eps   = 0.001

            // background track
            ctx.beginPath()
            ctx.lineWidth = root.ringWidth
            ctx.lineCap = "butt"
            ctx.strokeStyle = root.ringBg
            ctx.globalAlpha = 0.22
            ctx.arc(cx, cy, r, start, start + span, false)
            ctx.stroke()

            // progress arc
            const p = Math.max(0, Math.min(1, root.usedFrac))
            if (p > 0) {
                let end = start + (span * p)
                if (p >= 0.9999) end = start + span - eps

                ctx.beginPath()
                ctx.globalAlpha = 1.0
                ctx.lineWidth = root.ringWidth
                ctx.lineCap = "round"
                ctx.strokeStyle = root.ringFg
                ctx.shadowBlur = 0
                ctx.arc(cx, cy, r, start, end, false)
                ctx.stroke()
            }

            ctx.globalAlpha = 1.0
        }

        Connections {
            target: root
            function onUsedFracChanged() { ring.requestPaint() }
            function onRingWidthChanged() { ring.requestPaint() }
            function onRingInsetChanged() { ring.requestPaint() }
        }
    }

    // ---------- CENTER CONTENT (ICON -> TEMP ON HOVER) ----------
    Item {
        id: center
        anchors.centerIn: parent
        width: parent.width
        height: parent.height

        property real swap: root.hovered ? 1.0 : 0.0
        Behavior on swap { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

        Text {
            id: iconText
            anchors.centerIn: parent
            text: ""
            font.family: "Hack Nerd Font"
            font.pixelSize: 12
            color: root.iconColor
            opacity: 0.95 * (1.0 - center.swap)

            transform: [
                Translate { y: -3 * center.swap },
                Scale {
                    origin.x: iconText.width / 2
                    origin.y: iconText.height / 2
                    xScale: 1.0 - 0.08 * center.swap
                    yScale: 1.0 - 0.08 * center.swap
                }
            ]
        }

        Text {
            id: tempText
            anchors.centerIn: parent
            anchors.verticalCenterOffset: root.tempYOffset
            text: root.tempRounded + "°"
            color: root.iconColor
            font.pixelSize: 10
            font.weight: 700
            font.family: "Adwaita Sans"
            renderType: Text.NativeRendering

            opacity: center.swap
            transform: [
                Translate { y: 3 * (1.0 - center.swap) },
                Scale {
                    origin.x: tempText.width / 2
                    origin.y: tempText.height / 2
                    xScale: 0.92 + 0.08 * center.swap
                    yScale: 0.92 + 0.08 * center.swap
                }
            ]
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: root.hovered = true
        onExited: { root.hovered = false; root.pressed = false }
        onPressed: root.pressed = true
        onReleased: root.pressed = false
        onClicked: root.onActivate()
    }

    // ---- read temperature ----
    Process {
        id: tempProc
        command: ["bash", "-lc",
            "best=0; " +
            "for f in /sys/class/thermal/thermal_zone*/temp; do " +
            "  [ -r \"$f\" ] || continue; " +
            "  v=$(cat \"$f\" 2>/dev/null); " +
            "  [ -n \"$v\" ] || continue; " +
            "  if [ \"$v\" -gt 1000 ] 2>/dev/null; then v=$((v/1000)); fi; " +
            "  [ \"$v\" -gt \"$best\" ] && best=$v; " +
            "done; " +
            "echo \"$best\""
        ]
        stdout: StdioCollector {
            onStreamFinished: {
                const t = parseFloat(text.trim())
                if (isNaN(t) || t <= 0) return

                root.tempC = t
                const frac = (root.maxTempC > 0) ? (t / root.maxTempC) : 0
                root.usedFrac = Math.max(0, Math.min(1, frac))
            }
        }
    }

    Timer {
        interval: 1500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            tempProc.running = false
            tempProc.running = true
        }
    }
}
