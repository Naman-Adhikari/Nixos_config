// modules/datetimepanel/Calendar.qml
import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Io
import qs.services as Services
import qs.theme as Theme

Rectangle {
    id: root
    antialiasing: true
    radius: 14

    // --- Minimal palette (tweak to match your theme) ---
    property color bgColor: Theme.Theme.widget
    property color textColor: Theme.Theme.text
    property color mutedColor: "#7A7A7A"     // prev/next month days
    property color headerColor: Theme.Theme.text
    property color todayFill: Theme.Theme.accent
    property color todayText: "#1E1E2E"      // text on highlight

    color: bgColor

    // sizing defaults (it will still scale if you anchor/fill it)
    implicitWidth: 360
    implicitHeight: 250

    // padding + gaps
    property int pad: 14
    property int colGap: 10
    property int rowGap: 10

    // Week starts Monday like your screenshot
    readonly property var now: new Date()
    readonly property int yearValue: now.getFullYear()
    readonly property int monthValue: now.getMonth() // 0-11

    function daysInMonth(year, month0) { return new Date(year, month0 + 1, 0).getDate() }
    function daysInPrevMonth(year, month0) { return new Date(year, month0, 0).getDate() }

    // JS getDay(): 0 Sun ... 6 Sat
    // Convert to Monday-first offset: 0 Mon ... 6 Sun
    function mondayOffset(year, month0) {
        return (new Date(year, month0, 1).getDay() + 6) % 7
    }

    function isToday(y, m, d) {
        return now.getFullYear() === y && now.getMonth() === m && now.getDate() === d
    }

    Column {
        anchors.fill: parent
        anchors.margins: root.pad
        spacing: root.rowGap

        // Weekday header row
        Grid {
            id: headerGrid
            width: parent.width
            columns: 7
            columnSpacing: root.colGap
            rowSpacing: 0
            property real cellW: Math.floor((width - columnSpacing * 6) / 7)

            Repeater {
                model: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                Text {
                    width: headerGrid.cellW
                    height: 18
                    text: modelData
                    color: root.headerColor
                    font.pixelSize: 12
                    font.weight: 600
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Adwaita Sans"
                }
            }
        }

        // Days grid (always 6 rows x 7 cols)
        Grid {
            id: daysGrid
            width: parent.width
            height: parent.height - headerGrid.height - root.rowGap
            columns: 7
            columnSpacing: root.colGap
            rowSpacing: root.rowGap

            property int offset: root.mondayOffset(root.yearValue, root.monthValue)
            property int dim: root.daysInMonth(root.yearValue, root.monthValue)
            property int prevDim: root.daysInPrevMonth(root.yearValue, root.monthValue)

            property real cellW: Math.floor((width - columnSpacing * 6) / 7)
            property real cellH: Math.floor((height - rowSpacing * 5) / 6)

            Repeater {
                model: 42

                Item {
                    width: daysGrid.cellW
                    height: daysGrid.cellH

                    // Day number for the current month grid position
                    property int rawDay: index - daysGrid.offset + 1

                    // Determine which month this cell belongs to
                    property bool inCurrent: rawDay >= 1 && rawDay <= daysGrid.dim
                    property bool inPrev: rawDay < 1
                    property bool inNext: rawDay > daysGrid.dim

                    property int displayDay: inCurrent ? rawDay
                                         : (inPrev ? (daysGrid.prevDim + rawDay)
                                                   : (rawDay - daysGrid.dim))

                    // Only highlight today if it's in the current month
                    property bool today: inCurrent && root.isToday(root.yearValue, root.monthValue, displayDay)

                    // Minimal “circle” highlight
                    Rectangle {
                        anchors.centerIn: parent
                        width: Math.min(parent.width, parent.height) * 0.9
                        height: width
                        radius: width / 2
                        color: parent.today ? root.todayFill : "transparent"
                        antialiasing: true

                        Text {
                            anchors.centerIn: parent
                            text: parent.parent.displayDay
                            font.family: "Adwaita Sans"
                            font.pixelSize: 12
                            font.weight: parent.parent.today ? Font.DemiBold : Font.Normal
                            color: parent.parent.today ? root.todayText
                                                     : (parent.parent.inCurrent ? root.textColor : root.mutedColor)
                        }
                    }
                }
            }
        }
    }
}
