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

    // slideout theme
    property color tipBg: Theme.Theme.bttnbg
    property color tipText: Theme.Theme.text

    // ring tuning
    property int ringWidth: 3
    property real ringInset: 0.5

    // data
    property real usedFrac: 0.0           // 0..1
    property real usedGiB: 0.0
    property real totalGiB: 0.0
    readonly property int percent: Math.round(usedFrac * 100)

    // optional click hook
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
        renderTarget: Canvas.FramebufferObject

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        Component.onCompleted: requestPaint()

        onPaint: {
            const ctx = getContext("2d")

            const w = width
            const h = height
            if (w <= 0 || h <= 0) return

            ctx.clearRect(0, 0, w, h)

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

    // center icon
    Text {
        anchors.centerIn: parent
        text: ""
        font.family: "Hack Nerd Font"
        font.pixelSize: 12
        color: root.iconColor
        opacity: 1
    }

    // ---------- SLIDEOUT TIP (LEFT SIDE, NO FLICKER) ----------
    Item {
        id: tipWrap
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.left

        // tuning
        property int gap: 3
        property int hiddenOffset: 2
        property int minClosedWidth: 0

        anchors.rightMargin: root.hovered ? gap : (gap - hiddenOffset)

        width: root.hovered ? tipPill.implicitWidth : minClosedWidth
        height: tipPill.implicitHeight
        clip: true

        Behavior on anchors.rightMargin { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
        Behavior on width              { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }

        Rectangle {
            id: tipPill
            implicitHeight: 26
            implicitWidth: tipTextItem.implicitWidth + 18
            radius: 13
            color: root.tipBg
            antialiasing: true

            anchors.right: parent.right
            anchors.rightMargin: 0

            Text {
                id: tipTextItem
                anchors.centerIn: parent
                text: "Mem: " + root.percent + "% - " + root.usedGiB.toFixed(1) + "GiB Used"
                color: root.tipText
                font.pixelSize: 11
                font.weight: 600
                elide: Text.ElideRight
            }
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

    // ---- read memory ----
    Process {
        id: memProc
        command: ["bash", "-lc", "awk '/MemTotal:/ {t=$2} /MemAvailable:/ {a=$2} END{print t\" \"a}' /proc/meminfo"]
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = text.trim().split(/\s+/)
                if (parts.length < 2) return

                const totalKB = parseFloat(parts[0])
                const availKB = parseFloat(parts[1])
                if (isNaN(totalKB) || isNaN(availKB) || totalKB <= 0) return

                const usedKB = Math.max(0, totalKB - availKB)
                root.totalGiB = totalKB / (1024 * 1024)
                root.usedGiB = usedKB / (1024 * 1024)
                root.usedFrac = Math.max(0, Math.min(1, usedKB / totalKB))
            }
        }
    }

    Timer {
        interval: 1500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            memProc.running = false
            memProc.running = true
        }
    }
}
