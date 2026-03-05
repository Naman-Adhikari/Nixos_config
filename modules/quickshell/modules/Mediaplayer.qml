import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import qs.services as Services
import qs.theme as Theme

Item {
    id: root
    implicitHeight: 28
    implicitWidth: 210
    Layout.preferredWidth: implicitWidth
    Layout.alignment: Qt.AlignVCenter

    // theme
    property color bg: Theme.Theme.bttnbg
    property color text: Theme.Theme.text
    property color btnBg: Theme.Theme.bttnbg

    // whole-module button feedback
    property color cardHover: "#2f3042"
    property color cardPress: "#2a2b3a"

    readonly property var mpris: Services.Mpris
    readonly property string line: (mpris.albumArtist || "No Artist") + " - " + (mpris.albumTitle || "No Media")

    // playback state
    property bool isPlaying: false
    property bool needsMarquee: false
    property int fadeW: 12

    // popup toggle state
    property bool detailsOpen: false

    // click hook (whole card uses this)
    property var onOpen: function() { detailsOpen = !detailsOpen }


    Process { id: playPauseProc; command: ["playerctl", "play-pause"] }

    Process {
        id: statusProc
        command: ["bash", "-lc", "playerctl status 2>/dev/null || echo Stopped"]
        stdout: StdioCollector {
            onStreamFinished: root.isPlaying = (text.trim() === "Playing")
        }
    }

    Timer {
        interval: 800
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            statusProc.running = false
            statusProc.running = true
        }
    }

    Rectangle {
        id: card
        anchors.fill: parent
        radius: 14
        antialiasing: true
        transformOrigin: Item.Center

        // hover expand + press squish
        scale: cardMouse.pressed ? 0.985 : (cardMouse.containsMouse ? 1.03 : 1.0)

        // color reacts to whole-card mouse, but NOT when clicking play/pause
        color: root.bg

        Behavior on color { ColorAnimation { duration: 120 } }
        Behavior on scale {
            NumberAnimation {
                duration: 140
                easing.type: Easing.OutCubic
            }
        }

        // subtle lift shadow (optional but nice)
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowOpacity: cardMouse.containsMouse ? 0.35 : 0.0
            shadowBlur: 0.9
            shadowVerticalOffset: cardMouse.containsMouse ? 2 : 0
        }

        // Whole-module click target (behind the play/pause button)
        MouseArea {
            id: cardMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            z: 0
            onClicked: root.onOpen()
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 4
            spacing: 8
            z: 1 // content above the background mousearea

            // play/pause button (should NOT trigger card click)
            Rectangle {
                id: btn
                width: 20
                height: 20
                radius: 20
                color: root.btnBg
                border.width: 1
                border.color: Theme.Theme.border
                Layout.alignment: Qt.AlignVCenter
                Behavior on color { ColorAnimation { duration: 120 } }

                Text {
                    anchors.centerIn: parent
                    text: root.isPlaying ? "󰏤" : "󰐊"
                    font.family: "Hack Nerd Font"
                    font.pixelSize: 14
                    lineHeightMode: Text.FixedHeight
                    lineHeight: btn.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    x: Math.round(-0.5)
                    y: root.isPlaying ? Math.round(-0.5) : 0
                    color: root.text
                    opacity: 0.95
                }

                MouseArea {
                    id: btnMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    preventStealing: true
                    propagateComposedEvents: false
                    onClicked: {
                        playPauseProc.running = false
                        playPauseProc.running = true
                        statusProc.running = false
                        statusProc.running = true
                    }
                }
            }

            // ---- marquee viewport ----
            Item {
                id: viewport
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                height: 20
                clip: true

                Row {
                    id: marqueeRow
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 22
                    x: 0

                    Text {
                        id: textA
                        text: root.line
                        color: root.text
                        font.family: "Adwaita Sans"
                        font.pixelSize: 13
                        font.weight: 600
                        elide: Text.ElideNone
                    }

                    Text {
                        id: textB
                        text: textA.text
                        color: root.text
                        font.family: "Adwaita Sans"
                        font.pixelSize: 13
                        font.weight: 600
                        elide: Text.ElideNone
                        visible: root.needsMarquee
                    }
                }

                // LEFT fade
                Item {
                    z: 10
                    visible: root.needsMarquee
                    width: root.fadeW
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    clip: true

                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.height
                        height: parent.width
                        rotation: -90
                        transformOrigin: Item.Center
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: card.color }
                            GradientStop { position: 1.0; color: "transparent" }
                        }
                    }
                }

                // RIGHT fade
                Item {
                    z: 10
                    visible: root.needsMarquee
                    width: root.fadeW
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    clip: true

                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.height
                        height: parent.width
                        rotation: -90
                        transformOrigin: Item.Center
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "transparent" }
                            GradientStop { position: 1.0; color: card.color }
                        }
                    }
                }

                Timer {
                    id: marqueeDelay
                    interval: 1000
                    repeat: false
                    onTriggered: {
                        if (root.needsMarquee) marqueeAnim.start()
                    }
                }

                function recompute(resetPosition) {
                    const usable = Math.max(0, viewport.width - (root.fadeW * 2))
                    root.needsMarquee = textA.paintedWidth > usable

                    marqueeAnim.stop()
                    marqueeDelay.stop()

                    if (resetPosition || !root.needsMarquee) marqueeRow.x = 0

                    if (root.needsMarquee) {
                        marqueeAnim.from = 0
                        marqueeAnim.to = -(textA.paintedWidth + marqueeRow.spacing)
                        marqueeDelay.start()
                    }
                }

                onWidthChanged: recompute(false)
                Component.onCompleted: recompute(true)

                Connections {
                    target: root.mpris
                    function onAlbumArtistChanged() { viewport.recompute(true) }
                    function onAlbumTitleChanged()  { viewport.recompute(true) }
                }

                NumberAnimation {
                    id: marqueeAnim
                    target: marqueeRow
                    property: "x"
                    from: 0
                    to: -(textA.paintedWidth + marqueeRow.spacing)
                    duration: Math.max(12000, textA.paintedWidth * 22)
                    loops: Animation.Infinite
                    easing.type: Easing.Linear
                    running: false
                }
            }
        }
    }
    MediaPopup {
    id: mediaPop
    open: root.detailsOpen
    anchorItem: root
    onRequestClose: root.detailsOpen = false
}
}
