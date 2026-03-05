// modules/datetimepanel/Reminders.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.theme as Theme

Rectangle {
    id: root
    radius: 14
    color: Theme.Theme.widget
    antialiasing: true

    // expansion API
    property bool expanded: false
    signal requestExpand()
    signal requestCollapse()

    // clickable border thickness
    readonly property int rimW: 12

    property bool rimHovered: false

    // border only on hover, same color always
    border.width: rimHovered ? 2 : 0
    border.color: Theme.Theme.border
    Behavior on border.width { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

    // Persist
    readonly property string configHome: {
        const x = Quickshell.env("XDG_CONFIG_HOME")
        return (x && x.length > 0) ? x : (Quickshell.env("HOME") + "/.config")
    }
    property string savePath: configHome + "/quickshell/assets/reminders.cache"
    property bool loadedOnce: false

    readonly property string bullet: "• "
    readonly property string subBullet: "    • "

    function lineStartPos(pos) {
        const t = editor.text
        const p = Math.max(0, Math.min(pos, t.length))
        return t.lastIndexOf("\n", p - 1) + 1
    }
    function lineTextAt(pos) {
        const t = editor.text
        const s = lineStartPos(pos)
        const e = t.indexOf("\n", s)
        return t.slice(s, e === -1 ? t.length : e)
    }
    function lineHasBulletPrefix(pos) {
        const line = lineTextAt(pos)
        return line.indexOf(bullet) === 0 || line.indexOf(subBullet) === 0
    }
    function currentLinePrefix(pos) {
        const line = lineTextAt(pos)
        if (line.indexOf(subBullet) === 0) return subBullet
        if (line.indexOf(bullet) === 0) return bullet
        return ""
    }

    function insertText(str) {
        const a = editor.selectionStart
        const b = editor.selectionEnd
        if (a !== b) {
            const s = Math.min(a, b)
            const len = Math.abs(a - b)
            editor.remove(s, len)
            editor.cursorPosition = s
        }
        editor.insert(editor.cursorPosition, str)
        editor.cursorPosition += str.length
    }

    function insertBulletHere(prefix) {
        editor.forceActiveFocus()
        const pos = editor.cursorPosition
        const s = lineStartPos(pos)
        const before = editor.text.slice(s, pos)

        if (/^\s*$/.test(before)) {
            if (pos > s) editor.remove(s, pos - s)
            editor.cursorPosition = s

            const line = lineTextAt(s)
            if (line.indexOf(bullet) === 0 || line.indexOf(subBullet) === 0) return

            editor.insert(s, prefix)
            editor.cursorPosition = s + prefix.length
            return
        }
        insertText(prefix)
    }

    function loadFromDisk() {
        if (loadProc.running) return
        loadProc.command = ["sh", "-c",
            "test -f '" + savePath + "' && cat '" + savePath + "' || true"
        ]
        loadProc.running = true
    }

    function saveToDisk(text) {
        if (saveProc.running) return
        const payload = String(text)
        const needsNl = payload.length > 0 && payload[payload.length - 1] !== "\n"
        const body = payload + (needsNl ? "\n" : "")

        const cmd =
            "mkdir -p \"$(dirname '" + savePath + "')\" && " +
            "tmp='" + savePath + ".tmp' && " +
            "cat > \"$tmp\" <<'__QS_REMINDERS_EOF__'\n" +
            body +
            "__QS_REMINDERS_EOF__\n" +
            "mv -f \"$tmp\" '" + savePath + "'"

        saveProc.command = ["sh", "-c", cmd]
        saveProc.running = true
    }

    Component.onCompleted: loadFromDisk()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: "Reminders"
                color: Theme.Theme.text
                font.pixelSize: 13
                font.weight: 700
                font.family: "Adwaita Sans"
            }

            Item { Layout.fillWidth: true }

            Text {
                id: savedHint
                text: "Saved"
                opacity: 0.0
                color: Theme.Theme.gridBttn_off_subt
                font.pixelSize: 11
                font.family: "Adwaita Sans"
                Behavior on opacity { NumberAnimation { duration: 160 } }
            }

            // Bullet button (always on top, always clickable)
            Rectangle {
                id: bulletBtn
                width: 22
                height: 18
                radius: 9
                color: "transparent"
                opacity: bulletMouse.containsMouse ? 1.0 : 0.85
                antialiasing: true
                z: 100             // IMPORTANT: above any rim hitzones

                Text {
                    anchors.centerIn: parent
                    text: "•"
                    color: "#cdd6f4"
                    font.pixelSize: 14
                    font.family: "Adwaita Sans"
                }

                MouseArea {
                    id: bulletMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.insertBulletHere(root.bullet)
                }
            }
        }

        ScrollView {
            id: editorScroll
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            padding: 0
            background: Item {}

            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            TextArea {
                id: editor
                width: editorScroll.availableWidth

                placeholderText: "Type reminders here…"
                wrapMode: TextEdit.Wrap
                selectByMouse: true

                color: "#cdd6f4"
                placeholderTextColor: Theme.Theme.gridBttn_off_subt
                font.family: "Adwaita Sans"
                font.pixelSize: 12

                background: Item {}
                leftPadding: 0; rightPadding: 0; topPadding: 0; bottomPadding: 0
                focusPolicy: Qt.StrongFocus

                Keys.onPressed: function(event) {
                    if (event.key !== Qt.Key_Return && event.key !== Qt.Key_Enter) return
                    const hasBullet = root.lineHasBulletPrefix(editor.cursorPosition)
                    if (!hasBullet) return

                    event.accepted = true
                    const isShift = (event.modifiers & Qt.ShiftModifier)
                    const prefix = isShift ? root.subBullet : root.currentLinePrefix(editor.cursorPosition)
                    const finalPrefix = (prefix && prefix.length) ? prefix : root.bullet
                    root.insertText("\n" + finalPrefix)
                }

                Timer {
                    id: saveDebounce
                    interval: 2000
                    repeat: false
                    onTriggered: {
                        root.saveToDisk(editor.text)
                        savedHint.opacity = 1.0
                        savedFade.restart()
                    }
                }

                onTextChanged: {
                    if (!root.loadedOnce) return
                    saveDebounce.restart()
                }
            }
        }
    }

    // Border ring hover/click ONLY (no top overlay)
    Item {
        id: rimHit
        anchors.fill: parent
        z: 10

        property bool anyHover: left.containsMouse || right.containsMouse || top.containsMouse || bottom.containsMouse

        function updateHover() { root.rimHovered = anyHover }

        function toggle() {
            if (root.expanded) root.requestCollapse()
            else root.requestExpand()
        }

        MouseArea {
            id: left
            x: 0; y: 0
            width: root.rimW
            height: parent.height
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: rimHit.updateHover()
            onExited:  rimHit.updateHover()
            onClicked: rimHit.toggle()
        }

        MouseArea {
            id: right
            x: parent.width - root.rimW; y: 0
            width: root.rimW
            height: parent.height
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: rimHit.updateHover()
            onExited:  rimHit.updateHover()
            onClicked: rimHit.toggle()
        }

        MouseArea {
            id: top
            x: 0; y: 0
            width: parent.width
            height: root.rimW
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: rimHit.updateHover()
            onExited:  rimHit.updateHover()
            onClicked: rimHit.toggle()
        }

        MouseArea {
            id: bottom
            x: 0; y: parent.height - root.rimW
            width: parent.width
            height: root.rimW
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: rimHit.updateHover()
            onExited:  rimHit.updateHover()
            onClicked: rimHit.toggle()
        }
    }

    Timer {
        id: savedFade
        interval: 900
        repeat: false
        onTriggered: savedHint.opacity = 0.0
    }

    Process {
        id: loadProc
        running: false
        command: ["sh", "-c", "true"]
        stdout: StdioCollector {
            onStreamFinished: {
                const t = (this.text || "").replace(/\r/g, "")
                editor.text = t
                root.loadedOnce = true
                editor.cursorPosition = editor.text.length
            }
        }
    }

    Process {
        id: saveProc
        running: false
        command: ["sh", "-c", "true"]
    }
}