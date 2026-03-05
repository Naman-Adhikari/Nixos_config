// qs/modules/FillerTile.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import qs.theme as Theme

Item {
    id: root
    implicitHeight: 60
    Layout.fillWidth: true

    property string title: "Filler"
    property string subtitle: "Sample module"
    signal clicked()

    Rectangle {
        id: card
        anchors.fill: parent
        radius: 16
        color: Theme.Theme.bg
        border.width: 1
        border.color: Theme.Theme.bttnbg

        property bool hovered: false
        property bool pressed: false

        scale: pressed ? 0.98 : (hovered ? 1.01 : 1.0)

        Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
        Behavior on color { ColorAnimation { duration: 120 } }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10

            // Icon bubble
            Rectangle {
                width: 36
                height: 36
                radius: 18
                color: Theme.Theme.bttnbg
                Layout.alignment: Qt.AlignVCenter

                Text {
                    anchors.centerIn: parent
                    text: root.icon
                    font.pixelSize: 16
                    color: "#cdd6f4"
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    Layout.fillWidth: true
                    text: root.title
                    font.pixelSize: 16
                    font.weight: 600
                    color: Theme.Theme.text
                    elide: Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true
                    text: root.subtitle
                    font.pixelSize: 12
                    color: Theme.Theme.gridBttn_off_subt
                    opacity: 0.9
                    elide: Text.ElideRight
                }
            }

            // Right-side chevron-ish hint
            Text {
                text: "›"
                font.pixelSize: 22
                color: Theme.Theme.gridBttn_off_subt
                opacity: 0.8
                Layout.alignment: Qt.AlignVCenter
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onEntered: card.hovered = true
            onExited:  card.hovered = false
            onPressed: card.pressed = true
            onReleased: card.pressed = false
            onClicked: root.clicked()
        }
    }
}
