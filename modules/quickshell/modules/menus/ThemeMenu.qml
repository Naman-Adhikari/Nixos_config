import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.theme as Theme

PanelWindow {
    id: menu
    visible: false
    color: "transparent"
    focusable: true
    exclusiveZone: 0

    // Fullscreen overlay
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.anchors.top: true
    WlrLayershell.anchors.bottom: true
    WlrLayershell.anchors.left: true
    WlrLayershell.anchors.right: true

    // Selection index (0 = Catppuccin, 1 = OLED)
    property int selected: 0

    function openMenu() {
        visible = true
        selected = 0
        fadeIn.start()
        card.forceActiveFocus()
    }
    function closeMenu() { 
        fadeOut.start()
    }
    function toggleMenu() { visible ? closeMenu() : openMenu() }

    // IPC entry
    IpcHandler {
        target: "themeMenu"
        function toggle() { menu.toggleMenu() }
        function open()   { menu.openMenu() }
        function close()  { menu.closeMenu() }
    }

    // Run command
    Process { id: proc }
    function run(args) {
        proc.command = args
        proc.startDetached()
    }

    // Backdrop with fade animation
    Rectangle {
        id: backdrop
        anchors.fill: parent
        color: "#000000"
        opacity: 0

        NumberAnimation {
            id: fadeIn
            target: backdrop
            property: "opacity"
            to: 0
            duration: 200
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            id: fadeOut
            target: backdrop
            property: "opacity"
            to: 0
            duration: 150
            easing.type: Easing.InCubic
            onFinished: menu.visible = false
        }

        MouseArea {
            anchors.fill: parent
            onClicked: menu.closeMenu()
        }
    }

    // Center card
    Rectangle {
        id: card
        width: 380
        height: 145
        radius: 20
        color: Theme.Theme.bg
        border.width: 2
        border.color: Theme.Theme.border
        anchors.centerIn: parent

        // Subtle shadow effect
        layer.enabled: true
        layer.effect: ShaderEffect {
            property color shadowColor: "#000000"
        }

        scale: 1.0
        opacity: 0

        // Entry animation
        ParallelAnimation {
            id: cardEnter
            running: menu.visible
            NumberAnimation { 
                target: card
                property: "scale"
                from: 0.9
                to: 1.0
                duration: 250
                easing.type: Easing.OutBack
                easing.overshoot: 1.2
            }
            NumberAnimation { 
                target: card
                property: "opacity"
                from: 0
                to: 1
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            // Header
            Text {
                text: "Choose Theme"
                color: Theme.Theme.text
                font.pixelSize: 18
                font.family: "Adwaita Sans"
                font.weight: 500
                Layout.fillWidth: true
            }

            // Buttons container
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column {
                    anchors.fill: parent
                    spacing: 8

                    // --- Catppuccin button ---
                    Rectangle {
                        id: btnCat
                        width: parent.width
                        height: 42
                        radius: 12
                        color: menu.selected === 0 ? Theme.Theme.accent : Theme.Theme.bttnbg
                        border.width: 2
                        border.color: menu.selected === 0 ? Theme.Theme.accent : Theme.Theme.border

                        scale: 1.0
                        Behavior on scale {
                            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                        }
                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                        Behavior on border.color {
                            ColorAnimation { duration: 200 }
                        }

                        Row {
                            anchors.centerIn: parent
                            spacing: 12

                            Text {
                                text: "Catppuccin"
                                color: menu.selected === 0 ? Theme.Theme.gridBttn_on_ttl : Theme.Theme.gridBttn_off_ttl
                                font.pixelSize: 16
                                font.weight: 600
                                anchors.verticalCenter: parent.verticalCenter

                                Behavior on color {
                                    ColorAnimation { duration: 200 }
                                }
                            }
                        }

                        property bool hovered: false
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: {
                                btnCat.hovered = true
                                btnCat.scale = 1.02
                            }
                            onExited: {
                                btnCat.hovered = false
                                btnCat.scale = 1.0
                            }
                            onClicked: {
                                menu.run(["./.config/scripts/theme-switch.sh", "Catppuccin"])
                                menu.closeMenu()
                            }
                        }
                    }

                    // --- OLED button ---
                    Rectangle {
                        id: btnOled
                        width: parent.width
                        height: 42
                        radius: 12
                        color: menu.selected === 1 ? Theme.Theme.accent : Theme.Theme.bttnbg
                        border.width: 2
                        border.color: menu.selected === 0 ? Theme.Theme.border : Theme.Theme.accent

                        scale: 1.0
                        Behavior on scale {
                            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                        }
                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                        Behavior on border.color {
                            ColorAnimation { duration: 200 }
                        }

                        Row {
                            anchors.centerIn: parent
                            spacing: 12

                            Text {
                                text: "OLED"
                                color: menu.selected === 1 ? Theme.Theme.gridBttn_on_ttl : Theme.Theme.gridBttn_off_ttl
                                font.pixelSize: 16
                                font.weight: 600
                                anchors.verticalCenter: parent.verticalCenter

                                Behavior on color {
                                    ColorAnimation { duration: 200 }
                                }
                            }
                        }

                        property bool hovered: false
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: {
                                btnOled.hovered = true
                                btnOled.scale = 1.02
                            }
                            onExited: {
                                btnOled.hovered = false
                                btnOled.scale = 1.0
                            }
                            onClicked: {
                                menu.run(["./.config/scripts/theme-switch.sh", "Oled"])
                                menu.closeMenu()
                            }
                        }
                    }
                }
            }
        }

        // Pop animation when selection changes with keyboard
        SequentialAnimation {
            id: popAnim
            NumberAnimation { 
                target: menu.selected === 0 ? btnCat : btnOled
                property: "scale"
                to: 1.02
                duration: 100
                easing.type: Easing.OutCubic
            }
            NumberAnimation { 
                target: menu.selected === 0 ? btnCat : btnOled
                property: "scale"
                to: 1.0
                duration: 150
                easing.type: Easing.OutBack
                easing.overshoot: 1.1
            }
        }

        // Keyboard navigation
        Keys.onPressed: (e) => {
            if (e.key === Qt.Key_Escape) {
                menu.closeMenu()
                e.accepted = true
            } else if (e.key === Qt.Key_Up || e.key === Qt.Key_Down) {
                menu.selected = 1 - menu.selected
                popAnim.restart()
                e.accepted = true
            } else if (e.key === Qt.Key_Return || e.key === Qt.Key_Enter) {
                if (menu.selected === 0)
                    menu.run(["./.config/scripts/theme-switch.sh", "Catppuccin"])
                else
                    menu.run(["./.config/scripts/theme-switch.sh", "Oled"])
                menu.closeMenu()
                e.accepted = true
            }
        }
    }
}