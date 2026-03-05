import QtQuick

Item {
    id: fgLayer
    anchors.fill: parent
    clip: false

    property real gapPx: 350
    property real speedPxPerSec: 10
    property real phase: 0
    property real lastMs: 0
    readonly property real arA: (fgA.sourceSize.height > 0) ? (fgA.sourceSize.width / fgA.sourceSize.height) : 1.0
    readonly property real arB: (fgB.sourceSize.height > 0) ? (fgB.sourceSize.width / fgB.sourceSize.height) : 1.0
    readonly property real wA: height * arA
    readonly property real wB: height * arB
    readonly property real centerXA: (width - wA) / 2
    readonly property real periodPx: wA + gapPx + wB + gapPx
    readonly property bool ready: (fgA.status === Image.Ready) && (fgB.status === Image.Ready)

    function normPhase(p) {
        if (periodPx <= 0) return 0
        p = p % periodPx
        if (p < 0) p += periodPx
        return p
    }

    function restart() {
        lastMs = 0
        phase = 0
    }

    Timer {
        id: ticker
        interval: 16
        repeat: true
        running: fgLayer.ready
        triggeredOnStart: true
        onTriggered: {
            const now = Date.now()
            if (fgLayer.lastMs === 0) fgLayer.lastMs = now
            const dt = (now - fgLayer.lastMs) / 1000.0
            fgLayer.lastMs = now
            fgLayer.phase = fgLayer.normPhase(fgLayer.phase + fgLayer.speedPxPerSec * dt)
        }
    }

    // Image A (lead)
    Image {
        id: fgA
        y: 0
        height: fgLayer.height
        width: fgLayer.wA
        source: Qt.resolvedUrl("assets/fg.png")
        fillMode: Image.PreserveAspectFit
        smooth: true
        x: fgLayer.centerXA + fgLayer.phase
    }

    // Image B
    Image {
        id: fgB
        y: 0
        height: fgLayer.height
        width: fgLayer.wB
        source: Qt.resolvedUrl("assets/fg2.png")
        fillMode: Image.PreserveAspectFit
        smooth: true
        x: fgA.x - (fgLayer.wB + fgLayer.gapPx)
    }

    Image {
        id: fgA2
        y: 0
        height: fgLayer.height
        width: fgLayer.wA
        source: fgA.source
        fillMode: Image.PreserveAspectFit
        smooth: true
        visible: fgLayer.ready

        x: fgA.x - fgLayer.periodPx
    }

    Image {
        id: fgB2
        y: 0
        height: fgLayer.height
        width: fgLayer.wB
        source: fgB.source
        fillMode: Image.PreserveAspectFit
        smooth: true
        visible: fgLayer.ready

        x: fgB.x - fgLayer.periodPx
    }

    Connections {
        target: root
        function onWidthChanged()  { if (fgLayer.ready) fgLayer.restart() }
        function onHeightChanged() { if (fgLayer.ready) fgLayer.restart() }
    }
    onWidthChanged:  if (ready) restart()
    onHeightChanged: if (ready) restart()

    Connections {
        target: fgA
        function onStatusChanged() { if (fgLayer.ready) fgLayer.restart() }
    }
    Connections {
        target: fgB
        function onStatusChanged() { if (fgLayer.ready) fgLayer.restart() }
    }
}
