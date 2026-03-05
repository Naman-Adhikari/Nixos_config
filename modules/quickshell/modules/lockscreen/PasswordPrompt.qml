import QtQuick
import QtQml

Item {
    id: root
    required property LockContext context

    // -------- defaults (edit here only) --------
    property int fieldWidth: 300
    property int fieldHeight: 60

    // visuals
    property int outlineThickness: 2
    property color outerColor: Qt.rgba(0, 0, 0, 0.15)
    property color innerColor: "#181825"
    property int rounding: 20

    // text
    property color fontColor: "white"
    property string fontFamily: "Adwaita Sans"
    property bool fontItalic: true
    property int fontSize: 20

    // placeholder
    property string placeholderText: "Enter Password"
    property bool fadeOnEmpty: false

    // dots
    property bool hideInput: true
    property real dotsSize: 0.20          // fraction of height
    property real dotsSpacing: 0.35       // multiplier on dot size
    property bool dotsCenter: true
    property int maxDots: 32

    // right status glyph
    property bool showStatusGlyph: true
    property color checkColor: "white"
    property color failureColor: "#f38ba8"

    // layout
    property int padding: 18

    // fade / motion tuning
    property int fadeInDuration: 120
    property int fadeOutDuration: 120
    property int rowSlideDuration: 140
    property real dotOpacity: 0.90
    property real dotFadeInFrom: 0.0
    // ------------------------------------------

    width: fieldWidth
    height: fieldHeight

    // internal state
    property bool syncing: false
    property int lastLen: 0

    // dot animation state (lets us fade-out on delete)
    property int displayedLen: 0          // what we actually render
    property int pendingLen: 0            // final len after fade-out
    property int fadingOutIndex: -1       // last dot index that is fading out

    Timer {
        id: shrinkTimer
        interval: root.fadeOutDuration
        repeat: false
        onTriggered: {
            root.displayedLen = root.pendingLen
            root.fadingOutIndex = -1
        }
    }

    function handleLenChange(newLen) {
        const cappedNew = Math.min(newLen, maxDots)

        if (syncing) {
            lastLen = newLen
            displayedLen = cappedNew
            fadingOutIndex = -1
            shrinkTimer.stop()
            return
        }

        // typing (grow)
        if (newLen > lastLen) {
            shrinkTimer.stop()
            fadingOutIndex = -1
            displayedLen = cappedNew
        }

        // deleting (shrink with fade-out)
        if (newLen < lastLen) {
            if (displayedLen > 0) {
                pendingLen = cappedNew
                fadingOutIndex = displayedLen - 1
                shrinkTimer.restart()
            } else {
                displayedLen = cappedNew
            }
        }

        lastLen = newLen
    }

    Rectangle {
        id: field
        anchors.fill: parent
        radius: root.rounding
        color: "transparent"
        z: 1

        MouseArea {
            anchors.fill: parent
            onClicked: input.forceActiveFocus()
        }

        // border
        Rectangle {
            anchors.fill: parent
            radius: root.rounding
            color: "transparent"
            border.width: root.outlineThickness
            border.color: root.outerColor
            antialiasing: true
        }

        // inner fill + clip to keep dots/placeholder inside
        Rectangle {
            anchors.fill: parent
            anchors.margins: root.outlineThickness
            radius: Math.max(0, root.rounding - root.outlineThickness)
            color: root.innerColor
            antialiasing: true
            clip: true
        }

        // real input (we draw dots ourselves)
        TextInput {
            id: input
            anchors.fill: parent
            anchors.margins: root.padding

            echoMode: TextInput.Normal
            color: root.hideInput ? "transparent" : root.fontColor
            selectionColor: "transparent"
            selectedTextColor: "transparent"

            font.family: root.fontFamily
            font.italic: root.fontItalic
            font.pixelSize: root.fontSize

            enabled: !root.context.unlockInProgress
            focus: true

            cursorDelegate: Item { width: 0; height: 0; visible: false }
            inputMethodHints: Qt.ImhSensitiveData

            onTextChanged: {
                root.handleLenChange(text.length)
                if (root.context.currentText !== text)
                    root.context.currentText = text
            }

            Keys.onReturnPressed: root.context.tryUnlock()
            Keys.onEnterPressed: root.context.tryUnlock()

            Component.onCompleted: forceActiveFocus()
        }

        // placeholder (centered)
        Text {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: root.padding
            anchors.rightMargin: root.padding
            anchors.verticalCenter: parent.verticalCenter

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight

            text: root.placeholderText
            color: root.fontColor
            opacity: (root.context.currentText.length === 0)
                ? (root.fadeOnEmpty ? 0.35 : 0.8)
                : 0

            font.family: root.fontFamily
            font.italic: root.fontItalic
            font.pixelSize: root.fontSize
        }

        // dots
        Item {
            id: dotsLayer
            anchors.fill: parent
            visible: root.hideInput
            clip: true

            // IMPORTANT: use displayedLen so we can keep the last dot alive while fading out
            readonly property int shown: root.displayedLen
            readonly property real d: Math.max(2, root.fieldHeight * root.dotsSize)
            readonly property real gap: d * root.dotsSpacing

            Row {
                id: dotsRow
                spacing: dotsLayer.gap

                // manual centering so the row slides smoothly instead of "jumping"
                y: (parent.height - implicitHeight) / 2

                readonly property real rowW: (dotsLayer.shown <= 0)
                    ? 0
                    : (dotsLayer.shown * dotsLayer.d) + ((dotsLayer.shown - 1) * dotsLayer.gap)

                x: root.dotsCenter
                    ? Math.max(root.padding, (parent.width - rowW) / 2)
                    : root.padding

                Behavior on x {
                    NumberAnimation { duration: root.rowSlideDuration; easing.type: Easing.OutCubic }
                }

                Repeater {
                    model: dotsLayer.shown

                    Rectangle {
                        id: dot
                        width: dotsLayer.d
                        height: dotsLayer.d
                        radius: width / 2
                        color: root.fontColor
                        antialiasing: true

                        // Start new dots invisible so they fade in when created
                        Component.onCompleted: {
                            opacity = root.dotFadeInFrom
                            opacity = root.dotOpacity
                        }

                        // Fade out only the last dot when deleting, but keep it rendered until timer fires.
                        // Otherwise stay at normal opacity.
                        onVisibleChanged: opacity = root.dotOpacity

                        opacity: (index === root.fadingOutIndex) ? 0.0 : root.dotOpacity

                        Behavior on opacity {
                            NumberAnimation {
                                duration: (index === root.fadingOutIndex) ? root.fadeOutDuration : root.fadeInDuration
                                easing.type: Easing.InOutCubic
                            }
                        }
                    }
                }
            }
        }

        // right-side glyph (optional)
        Text {
            visible: root.showStatusGlyph
            anchors.right: parent.right
            anchors.rightMargin: root.padding
            anchors.verticalCenter: parent.verticalCenter

            text: root.context.showFailure ? "×" : ""
            color: root.context.showFailure ? root.failureColor : root.checkColor
            font.pixelSize: 22
            opacity: (text === "") ? 0 : 0.9
        }
    }

    // Sync from context changes (multi-monitor safe, no weird fades)
    Connections {
        target: root.context
        function onCurrentTextChanged() {
            if (input.text !== root.context.currentText) {
                root.syncing = true
                input.text = root.context.currentText

                root.lastLen = input.text.length
                root.displayedLen = Math.min(root.lastLen, root.maxDots)
                root.fadingOutIndex = -1
                shrinkTimer.stop()

                Qt.callLater(function() { root.syncing = false })
            }
        }
    }

    Component.onCompleted: {
        // initialize displayedLen for first paint
        root.lastLen = root.context.currentText.length
        root.displayedLen = Math.min(root.lastLen, root.maxDots)
    }
}
