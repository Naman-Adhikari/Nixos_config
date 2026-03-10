import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.modules

PanelWindow {
    id: topBar

    property var targetScreen: null
    
    Binding {
        target: topBar
        property: "screen"
        value: topBar.targetScreen
        when: topBar.targetScreen !== null
    }

    implicitHeight: 40
    color: "transparent"
    anchors { top: true; left: true; right: true }
    WlrLayershell.layer: WlrLayershell.Top
    WlrLayershell.exclusiveZone: implicitHeight

    // LEFT
    RowLayout {
        id: leftCluster
        anchors.left: parent.left
        anchors.leftMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        spacing: 6

        DateTime { Layout.alignment: Qt.AlignVCenter }
        Battery  { Layout.alignment: Qt.AlignVCenter }
    }

    // CENTER
    RowLayout {
        id: centerCluster
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        spacing: 6

        readonly property real sideW: Math.max(leftContent.implicitWidth, rightContent.implicitWidth)

        Item {
            Layout.preferredWidth: centerCluster.sideW
            Layout.minimumWidth: centerCluster.sideW
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter

            Row {
                id: leftContent
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                Memory {}
                Recorder{}

                Power {
                    powerIcon:    Qt.resolvedUrl("../assets/power_icons/power-1.svg")
                    lockIcon:     Qt.resolvedUrl("../assets/power_icons/lock.svg")
                    sleepIcon:    Qt.resolvedUrl("../assets/power_icons/moon.svg")
                    logoutIcon:   Qt.resolvedUrl("../assets/power_icons/log-out.svg")
                    rebootIcon:   Qt.resolvedUrl("../assets/power_icons/refresh-cw.svg")
                    shutdownIcon: Qt.resolvedUrl("../assets/power_icons/power.svg")
                }
            }
        }

        Workspaces { Layout.alignment: Qt.AlignVCenter }

        Item {
            Layout.preferredWidth: centerCluster.sideW
            Layout.minimumWidth: centerCluster.sideW
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter

            Row {
                id: rightContent
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                Mediaplayer { id: media }
            }
        }
    }

    // RIGHT
    RowLayout {
        id: rightCluster
        anchors.right: parent.right
        anchors.rightMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        spacing: 6

        RightBtn { Layout.alignment: Qt.AlignVCenter }
    }
}
