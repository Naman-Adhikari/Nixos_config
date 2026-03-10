//@ pragma UseQApplication
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Effects
import qs.theme as Theme

PanelWindow {
    id: root

    property var targetScreen: null

    Binding {
        target: root
        property: "screen"
        value: root.targetScreen
        when: root.targetScreen !== null
    }

    color: "transparent"
    visible: true
    anchors { top: true; left: true; bottom: true; right: true }
    WlrLayershell.layer: WlrLayershell.Bottom
    WlrLayershell.exclusiveZone: -1

    mask: Region { item: container; intersection: Intersection.Xor }

    Item {
        id: container
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.Theme.gradientTop }
                GradientStop { position: 1.0; color: Theme.Theme.gradientBottom }
            }

            Behavior on gradient {
                PropertyAnimation { duration: 300; easing.type: Easing.InOutQuad }
            }

            layer.enabled: true
            layer.effect: MultiEffect {
                maskSource: maskItem
                maskEnabled: true
                maskInverted: true
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1
            }
        }

        Item {
            id: maskItem
            anchors.fill: parent
            layer.enabled: true
            visible: false

            Rectangle {
                anchors.fill: parent
                anchors.topMargin: 40
                radius: 24
                color: "#000000"
            }
        }
    }
}
