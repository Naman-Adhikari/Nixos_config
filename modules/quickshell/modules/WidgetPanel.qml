// modules/WidgetPanel.qml
import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Wayland
import qs.modules.datetimepanel
import qs.theme as Theme

PanelWindow {
    id: panel
    visible: false
    color: "transparent"
    exclusiveZone: 0
    focusable: true
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    // pages: 0 = Dashboard, 1 = Wallpapers (blank for now)
    property int pageIndex: 0

    // expansion state (only relevant on page 0)
    property bool remindersExpanded: false
    property bool weatherExpanded: false

    function clamp01(v) { return Math.max(0, Math.min(1, v)) }
    function lerp(a, b, t) { return a + (b - a) * t }

    onVisibleChanged: {
        if (visible) {
            remindersExpanded = false
            weatherExpanded = false
            pageIndex = 0
        }
    }

    onPageIndexChanged: {
        remindersExpanded = false
        weatherExpanded = false
    }

    onRemindersExpandedChanged: if (remindersExpanded) weatherExpanded = false
    onWeatherExpandedChanged: if (weatherExpanded) remindersExpanded = false

    // --- shadow ---
    property int shadowPad: 10
    property real shadowOpacity: 0.28
    property real shadowBlur: 0.55
    property int shadowOffsetY: 6

    // size
    property int contentW: 600
    property int contentH: 325
    implicitWidth: contentW + shadowPad * 2
    implicitHeight: contentH + shadowPad * 2

    anchors { top: true; left: true }
    margins { top: 6 - shadowPad; left: 6 - shadowPad }

    // ===== padding knobs =====
    // overall inner padding for the whole content area
    property int contentPadding: 12
    // extra gap from the very top (inside padding) down to the TOP of the tab buttons row
    property int tabsTopGap: -6

    Item {
        id: wrap
        anchors.fill: parent
        anchors.margins: panel.shadowPad

        Rectangle {
            anchors.fill: parent
            radius: 16
            antialiasing: true
            color: Theme.Theme.bg

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowOpacity: panel.shadowOpacity
                shadowVerticalOffset: panel.shadowOffsetY
                shadowBlur: panel.shadowBlur
            }
        }

        Rectangle {
            id: clipCard
            anchors.fill: parent
            radius: 16
            color: "transparent"
            clip: true
            antialiasing: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: panel.contentPadding
                spacing: 12

                // =========================
                // TOP MENU (tabs)
                // =========================
                Item {
                    id: topMenu
                    Layout.fillWidth: true
                    Layout.preferredHeight: 30

                    // THIS is the control you asked for:
                    // distance from the very top of the card content area to the top of the buttons row.
                    // (It stacks on top of anchors.margins.)
                    Layout.topMargin: panel.tabsTopGap

                    // tweak if you still want the label to sit perfectly between the top and underline
                    property int tabLabelVOffset: 1

                    RowLayout {
                        id: tabsRow
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        height: parent.height - 2
                        spacing: 0

                        // ---- LEFT HALF ----
                        Item { Layout.fillWidth: true }

                        Item {
                            id: tabDashboard
                            Layout.preferredWidth: dashLabel.implicitWidth
                            Layout.preferredHeight: parent.height
                            readonly property real labelW: dashLabel.implicitWidth
                            readonly property real centerX: x + width / 2

                            Text {
                                id: dashLabel
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.verticalCenterOffset: topMenu.tabLabelVOffset

                                text: "Dashboard"
                                color: panel.pageIndex === 0 ? Theme.Theme.text : Theme.Theme.subText
                                font.pixelSize: 13
                                font.family: "Adwaita Sans"
                                font.weight: panel.pageIndex === 0 ? 700 : 600
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: panel.pageIndex = 0
                            }
                        }

                        Item { Layout.fillWidth: true }

                        // ---- RIGHT HALF ----
                        Item { Layout.fillWidth: true }

                        Item {
                            id: tabWallpapers
                            Layout.preferredWidth: wallLabel.implicitWidth
                            Layout.preferredHeight: parent.height
                            readonly property real labelW: wallLabel.implicitWidth
                            readonly property real centerX: x + width / 2

                            Text {
                                id: wallLabel
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.verticalCenterOffset: topMenu.tabLabelVOffset

                                text: "Wallpapers"
                                color: panel.pageIndex === 1 ? Theme.Theme.text : Theme.Theme.subText
                                font.pixelSize: 13
                                font.family: "Adwaita Sans"
                                font.weight: panel.pageIndex === 1 ? 700 : 600
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: panel.pageIndex = 1
                            }
                        }

                        Item { Layout.fillWidth: true }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 1
                        color: "#313244"
                        opacity: 0.7
                    }

                    Rectangle {
                        id: indicator
                        height: 2
                        radius: 2
                        color: Theme.Theme.accent
                        y: topMenu.height - 2

                        readonly property real t: {
                            const w = Math.max(1, pageViewport.width)
                            return panel.clamp01((-pageRow.x) / w)
                        }

                        readonly property real dashCX: tabDashboard.centerX
                        readonly property real wallCX: tabWallpapers.centerX

                        width: Math.max(34, panel.lerp(tabDashboard.labelW + 10, tabWallpapers.labelW + 10, t))
                        x: panel.lerp(dashCX, wallCX, t) - width / 2
                    }
                }

                // =========================
                // PAGES (slide)
                // =========================
                Item {
                    id: pageViewport
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    Row {
                        id: pageRow
                        width: pageViewport.width * 2
                        height: pageViewport.height
                        spacing: 0

                        x: -panel.pageIndex * pageViewport.width
                        Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

                        // -------- Page 0: Dashboard --------
                        Item {
                            id: dashboardPage
                            width: pageViewport.width
                            height: pageViewport.height

                            Item {
                                id: overlaySurface
                                anchors.fill: parent
                                visible: panel.remindersExpanded
                                z: 9999

                                Rectangle { anchors.fill: parent; color: "#000000"; opacity: 0 }

                                MouseArea {
                                    anchors.fill: parent
                                    onPressed: (m) => { m.accepted = true }
                                    onClicked: (m) => { m.accepted = true }
                                }
                            }

                            RowLayout {
                                anchors.fill: parent
                                spacing: 12

                                ColumnLayout {
                                    Layout.preferredWidth: 280
                                    Layout.minimumWidth: 280
                                    Layout.maximumWidth: 280
                                    Layout.fillHeight: true

                                    Item {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        clip: true
                                        opacity: panel.remindersExpanded ? 0.0 : 1.0
                                        enabled: !panel.remindersExpanded
                                        Behavior on opacity { NumberAnimation { duration: 140 } }

                                        Calendar { anchors.fill: parent }
                                    }
                                }

                                Item {
                                    id: rightRegion
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: 180

                                    ColumnLayout {
                                        anchors.fill: parent
                                        spacing: 12

                                        Item {
                                            id: weatherSlot
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            Layout.minimumHeight: 65
                                            opacity: panel.remindersExpanded ? 0.0 : 1.0
                                            enabled: !panel.remindersExpanded
                                            Behavior on opacity { NumberAnimation { duration: 140 } }
                                        }

                                        Item {
                                            id: remindersSlot
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            Layout.minimumHeight: 90
                                        }
                                    }
                                }
                            }

                            // ===== Weather Host =====
                            Item {
                                id: weatherHost
                                z: 9500

                                Behavior on x { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                                Behavior on y { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                                Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                                Behavior on height { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

                                Weather {
                                    anchors.fill: parent
                                    iconDir: "../assets/weather"

                                    expanded: panel.weatherExpanded
                                    onRequestExpand: panel.weatherExpanded = true
                                    onRequestCollapse: panel.weatherExpanded = false

                                    active: panel.visible && panel.pageIndex === 0 && !panel.remindersExpanded
                                }
                            }

                            // ===== Reminders Host =====
                            Item {
                                id: remindersHost
                                z: 10000

                                opacity: panel.weatherExpanded ? 0.0 : 1.0
                                enabled: !panel.weatherExpanded
                                Behavior on opacity { NumberAnimation { duration: 140 } }

                                Behavior on x { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                                Behavior on y { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                                Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                                Behavior on height { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

                                Reminders {
                                    anchors.fill: parent
                                    expanded: panel.remindersExpanded
                                    onRequestExpand: panel.remindersExpanded = true
                                    onRequestCollapse: panel.remindersExpanded = false
                                }
                            }

                            StateGroup {
                                states: [
                                    State {
                                        name: "remindersNormal"
                                        when: !panel.remindersExpanded
                                        ParentChange { target: remindersHost; parent: remindersSlot }
                                        PropertyChanges { target: remindersHost; x: 0; y: 0; width: remindersSlot.width; height: remindersSlot.height }
                                    },
                                    State {
                                        name: "remindersExpanded"
                                        when: panel.remindersExpanded
                                        ParentChange { target: remindersHost; parent: overlaySurface }
                                        PropertyChanges { target: remindersHost; x: 0; y: 0; width: overlaySurface.width; height: overlaySurface.height }
                                    }
                                ]
                            }

                            StateGroup {
                                states: [
                                    State {
                                        name: "weatherNormal"
                                        when: !panel.weatherExpanded
                                        ParentChange { target: weatherHost; parent: weatherSlot }
                                        PropertyChanges { target: weatherHost; x: 0; y: 0; width: weatherSlot.width; height: weatherSlot.height }
                                    },
                                    State {
                                        name: "weatherExpanded"
                                        when: panel.weatherExpanded
                                        ParentChange { target: weatherHost; parent: rightRegion }
                                        PropertyChanges { target: weatherHost; x: 0; y: 0; width: rightRegion.width; height: rightRegion.height }
                                    }
                                ]
                            }
                        }

                        // -------- Page 1: Wallpapers (blank for now) --------
                        Item {
                            id: wallpapersPage
                            width: pageViewport.width
                            height: pageViewport.height
                        }
                    }
                }
            }
        }
    }
}
