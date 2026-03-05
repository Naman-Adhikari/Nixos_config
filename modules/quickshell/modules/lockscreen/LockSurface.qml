import QtQuick
import QtQuick.Layouts
import QtQml
import qs.services
import "."

Rectangle {
    id: root
    required property LockContext context
    anchors.fill: parent
    color: "transparent"

    // ---------------------------
    property int clockX: 0
    property int clockY: 160

    property int greeterX: 0
    property int greeterY: 60

    property int panelX: 0
    property int panelY: -250
    // ---------------------------

    Image {
        id: bg
        anchors.fill: parent
        source: Qt.resolvedUrl("assets/wall2.png")
        fillMode: Image.PreserveAspectCrop
        smooth: true
    }

    Rectangle {
        color: "#000000"
        anchors.fill: parent
        opacity: 0.2
    }

    Item {
        id: clockAnchor
        width: 1
        height: 1
        x: (root.width / 2) + root.clockX
        y: (root.height / 2) - root.clockY
    }

    Item {
        id: greeterAnchor
        width: 1
        height: 1
        x: (root.width / 2) + root.greeterX
        y: (root.height / 2) - root.greeterY
    }

    Item {
        id: panelAnchor
        width: 1
        height: 1
        x: (root.width / 2) + root.panelX
        y: (root.height / 2) - root.panelY
    }

    //clock
    Text {
        id: clock
        anchors.horizontalCenter: clockAnchor.horizontalCenter
        anchors.verticalCenter: clockAnchor.verticalCenter

        color: "white"
        font.pixelSize: 150
        font.family: "Adwaita Sans"
        font.weight: 150
        renderType: Text.NativeRendering

        property var date: new Date()

        Timer {
            running: true
            repeat: true
            interval: 1000
            onTriggered: clock.date = new Date()
        }

        text: {
            const h = clock.date.getHours().toString().padStart(2, "0")
            const m = clock.date.getMinutes().toString().padStart(2, "0")
            return `${h}:${m}`
        }
    }

    Text {
        id: greeter
        anchors.horizontalCenter: greeterAnchor.horizontalCenter
        anchors.verticalCenter: greeterAnchor.verticalCenter

        color: "white"
        font.pixelSize: 40
        font.weight: 300
        font.family: "Adwaita Sans"
        renderType: Text.NativeRendering
        text: "hi, "  + SystemDetails.username + "!"
    }

    Foreground {
        id: clouds
        anchors.fill: parent
    }

    Column {
        anchors.horizontalCenter: panelAnchor.horizontalCenter
        anchors.verticalCenter: panelAnchor.verticalCenter
        spacing: 12

        PasswordPrompt {
            id: prompt
            context: root.context
        }
    }
}
