// modules/DateTime.qml
import QtQuick
import Quickshell
import qs.theme as Theme

Rectangle {
    id: root
    height: 28
    radius: height / 2
    color: Theme.Theme.bttnbg
    border.width: 1
    border.color: Theme.Theme.bttnbg
    antialiasing: true
    implicitWidth: timeText.implicitWidth + 12

    property bool hovered: false
    property bool pressed: false
    property string currentTime: ""

    property var panelWin: null

    // your animation formula
    scale: pressed ? 0.985 : (hovered ? 1.03 : 1.0)
    Behavior on scale {
        NumberAnimation { duration: 90; easing.type: Easing.OutQuad }
    }

    function updateDateTime() {
        const d = new Date()
        currentTime = Qt.formatDateTime(d, "HH:mm • ddd, MM/dd")
    }

    function ensurePanel() {
        if (panelWin) return true

        const cmp = Qt.createComponent(Qt.resolvedUrl("WidgetPanel.qml"))
        if (cmp.status !== Component.Ready) {
            console.log("WidgetPanel load failed:", cmp.errorString())
            return false
        }

        panelWin = cmp.createObject(null)
        if (!panelWin) {
            console.log("WidgetPanel createObject failed")
            return false
        }

        return true
    }

    function togglePanel() {
        if (!ensurePanel()) return
        panelWin.visible = !panelWin.visible
    }

    Text {
        id: timeText
        anchors.centerIn: parent
        color: Theme.Theme.text
        font.pixelSize: 13
        font.family: "Adwaita Sans"
        font.weight: 600
        text: root.currentTime
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.updateDateTime()
    }
    Component.onCompleted: root.updateDateTime()

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: root.hovered = true
        onExited: { root.hovered = false; root.pressed = false }
        onPressed: root.pressed = true
        onReleased: root.pressed = false
        onClicked: root.togglePanel()
    }
}