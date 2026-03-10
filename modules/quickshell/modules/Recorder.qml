import QtQuick
import Quickshell
import Quickshell.Io
import qs.theme as Theme

Item {
    id: root

    // Size
    implicitWidth: 28
    implicitHeight: 28

    // Theme & styling properties
    property color ringBg: "#cdd6f4"
    property color ringFg: Theme.Theme.accent
    property color iconColor: Theme.Theme.accent

    // Ring appearance
    property int ringWidth: 3
    property real ringInset: 0.5

    // Hover state for tooltip
    property bool hovered: false

    // ── Background ring (static full circle) ──
    Canvas {
        id: ringCanvas
        anchors.fill: parent
        antialiasing: true
        renderTarget: Canvas.FramebufferObject

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        Component.onCompleted: requestPaint()

        onPaint: {
            var ctx = getContext("2d")
            if (!ctx) return

            const w = width
            const h = height
            if (w <= 0 || h <= 0) return

            ctx.clearRect(0, 0, w, h)

            const cx = w / 2
            const cy = h / 2
            const radius = Math.max(0, Math.min(w, h) / 2 - (root.ringWidth / 2) - root.ringInset)

            // Background track (dimmed circle)
            ctx.beginPath()
            ctx.lineWidth = root.ringWidth
            ctx.lineCap = "butt"
            ctx.strokeStyle = root.ringBg
            ctx.globalAlpha = 0.22
            ctx.arc(cx, cy, radius, 0, Math.PI * 2, false)
            ctx.stroke()

            // Reset alpha for future draws if needed
            ctx.globalAlpha = 1.0
        }
    }

    // ── Center icon (Nerd Font microphone/recorder symbol) ──
    Text {
        anchors.centerIn: parent
        text: "⏺"                  // ﰈ = microphone/recorder (Nerd Fonts)
        font.family: "Hack Nerd Font"
        font.pixelSize: 16          // slightly larger looks better on 28×28
        color: root.iconColor
    }

    // ── Tooltip (appears on hover) ──
    Item {
        id: tooltipWrapper
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        anchors.bottomMargin: root.hovered ? 6 : 2

        width: tooltipPill.implicitWidth
        height: root.hovered ? tooltipPill.implicitHeight : 0
        clip: true

        Behavior on height {
            NumberAnimation {
                duration: 180
                easing.type: Easing.OutCubic
            }
        }

        Rectangle {
            id: tooltipPill
            implicitHeight: 22
            implicitWidth: tooltipLabel.implicitWidth + 16
            radius: 11
            color: Theme.Theme.bttnbg ?? "#2e3440"  // fallback color

            Text {
                id: tooltipLabel
                anchors.centerIn: parent
                text: "Screen Record"
                color: Theme.Theme.text ?? "#d8dee9"   // fallback
                font.pixelSize: 11
                font.weight: Font.Bold
            }
        }
    }

    // ── Interaction ──
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered:  root.hovered = true
        onExited:   root.hovered = false

        onClicked: {
            koohaProcess.running = true
            // Optional: visual feedback on click
            root.opacity = 0.7
            clickFeedback.start()
        }
    }

    // Quick fade-back animation after click
    NumberAnimation {
        id: clickFeedback
        target: root
        property: "opacity"
        to: 1.0
        duration: 120
        easing.type: Easing.OutQuad
    }

    // ── Actually launches Kooha (detached) ──
    Process {
        id: koohaProcess
        command: ["kooha"]
    }
}
