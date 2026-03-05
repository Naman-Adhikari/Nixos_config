// modules/RightBtn.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.services as Services
import qs.theme as Theme

Rectangle {
    id: root
    height: 28
    radius: height / 2
    color: Theme.Theme.bttnbg
    antialiasing: true
    implicitWidth: row.implicitWidth + 12

    property bool hovered: false
    property bool pressed: false
    property bool open: false

    // IMPORTANT:
    // Anchor the panel to the *cluster* (your RowLayout in Bar.qml), not the button.
    // This makes the popup align with the right side of the whole cluster (LeftBtn + PfpPanel),
    // which naturally "pushes it right" without offsets.
    property Item panelAnchorItem: (root.parent ? root.parent : root)

    scale: pressed ? 0.96 : (hovered ? 1.02 : 1.0)
    Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

    function wifiIcon(connected, strength) {
        if (!connected) return "󰤮"
        if (strength >= 75) return "󰤨"
        if (strength >= 50) return "󰤥"
        if (strength >= 25) return "󰤢"
        return "󰤟"
    }

    RowLayout {
        id: row
        anchors.fill: parent
        anchors.margins: 0
        spacing: 2

        Rectangle {
            id: avatarBorder
            width: 28
            height: 28
            radius: width / 2
            color: "transparent"
            antialiasing: true
            Layout.alignment: Qt.AlignVCenter

            ClippingRectangle {
                anchors.fill: parent
                anchors.margins: 2
                radius: width / 2
                antialiasing: true
                layer.enabled: true
                layer.smooth: true

                Image {
                    anchors.fill: parent
                    source: Qt.resolvedUrl("../assets/pfp.jpg")
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    mipmap: true
                }
            }
        }

        Text {
            text: wifiIcon(Services.Network.connected, Services.Network.signalStrength)
            font.family: "Hack Nerd Font"
            font.pixelSize: 14
            color: Theme.Theme.text
            opacity: Services.Network.connected ? 1.0 : 0.75
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: ""
            font.family: "Hack Nerd Font"
            font.pixelSize: 14
            color: Theme.Theme.text
            opacity: 0.95
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: "󰃠 "
            font.family: "Hack Nerd Font"
            font.pixelSize: 14
            color: Theme.Theme.text
            opacity: 0.95
            Layout.alignment: Qt.AlignVCenter
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
        onClicked: {
            root.open = !root.open
            if (root.open) Qt.callLater(panel.updatePos)
        }
    }

    RightPanel {
        id: panel
        open: root.open
        anchorItem: root.panelAnchorItem
        onRequestClose: root.open = false
    }
}
