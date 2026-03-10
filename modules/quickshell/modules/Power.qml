// modules/Power.qml
import QtQuick
import Quickshell
import qs.theme as Theme

Item {
    id: root
    implicitWidth: 28
    implicitHeight: 28
    
    property bool open: false
    
    // Power button icon
    property url powerIcon: Qt.resolvedUrl("../assets/icons/power.svg")
    
    // Menu icons (can be overridden from Bar.qml)
    property url lockIcon:     Qt.resolvedUrl("../assets/icons/lock.svg")
    property url sleepIcon:    Qt.resolvedUrl("../assets/icons/sleep.svg")
    property url logoutIcon:   Qt.resolvedUrl("../assets/icons/logout.svg")
    property url rebootIcon:   Qt.resolvedUrl("../assets/icons/reboot.svg")
    property url shutdownIcon: Qt.resolvedUrl("../assets/icons/shutdown.svg")
    
    // Theme
    property color bg: Theme.Theme.bttnbg
    property int radius: 14
    
    // Hover/click animation
    scale: area.pressed ? 0.985 : (area.containsMouse ? 1.08 : 1.0)
    Behavior on scale { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
    
    Rectangle {
        id: btn
        anchors.fill: parent
        radius: root.radius
        color: root.bg
        
        Image {
            anchors.centerIn: parent
            width: 18
            height: 18
            source: root.powerIcon
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
            sourceSize.width: 64
            sourceSize.height: 64
        }
        
        MouseArea {
            id: area
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                root.open = !root.open
            }
        }
    }
    
    PowerMenu {
        id: menu
        open: root.open
        anchorItem: btn
        
        // Pass icon overrides to menu
        lockIcon: root.lockIcon
        sleepIcon: root.sleepIcon
        logoutIcon: root.logoutIcon
        rebootIcon: root.rebootIcon
        shutdownIcon: root.shutdownIcon
        
        onRequestClose: root.open = false
    }
}