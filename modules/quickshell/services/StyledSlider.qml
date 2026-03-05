import QtQuick
import QtQuick.Controls

Slider {
    id: root

    // ---- style / geometry knobs ----
    property color colPrimary: "#c2c1ff"
    property color colSecondaryContainer: "#454559"
    property color handleBorderColor: "#313244"
    property int handleBorderWidth: 1

    property real trackHeightDiff: 15
    property real handleGap: 6
    property real trackNearHandleRadius: 2
    property bool useAnim: true
    signal userMoved(real value)
    signal userReleased(real value)

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: root.pressed ? Qt.ClosedHandCursor : Qt.PointingHandCursor
        onPressed: (mouse) => mouse.accepted = false
    }

    onMoved: userMoved(value)
    onPressedChanged: if (!pressed) userReleased(value)

    background: Item {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: parent.height

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            width: root.handleGap + (root.visualPosition * (root.width - root.handleGap * 2))
                   - ((root.pressed ? 1.5 : 3) / 2 + root.handleGap)
            height: root.height - root.trackHeightDiff
            color: root.colPrimary
            radius: 10
            topRightRadius: root.trackNearHandleRadius
            bottomRightRadius: root.trackNearHandleRadius

            Behavior on width {
                NumberAnimation { duration: root.useAnim ? 120 : 0; easing.type: Easing.OutCubic }
            }
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            width: root.handleGap + ((1 - root.visualPosition) * (root.width - root.handleGap * 2))
                   - ((root.pressed ? 1.5 : 3) / 2 + root.handleGap)
            height: root.height - root.trackHeightDiff
            color: root.colSecondaryContainer
            radius: 10
            topLeftRadius: root.trackNearHandleRadius
            bottomLeftRadius: root.trackNearHandleRadius

            Behavior on width {
                NumberAnimation { duration: root.useAnim ? 120 : 0; easing.type: Easing.OutCubic }
            }
        }
    }

    handle: Rectangle {
        width: 6
        height: root.height
        radius: width / 2
        x: root.handleGap + (root.visualPosition * (root.width - root.handleGap * 2)) - width / 2
        anchors.verticalCenter: parent.verticalCenter
        color: root.colPrimary
        border.color: root.handleBorderColor
        border.width: root.handleBorderWidth

        Behavior on x {
            NumberAnimation { duration: root.useAnim ? 120 : 0; easing.type: Easing.OutCubic }
        }
    }
}
