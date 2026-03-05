// modules/controlpanel/ProfilePicture.qml
import QtQuick
import Quickshell
import Quickshell.Widgets

ClippingRectangle {
    id: avatar
    implicitWidth: 80
    implicitHeight: 80
    radius: 14
    antialiasing: true
    layer.enabled: true
    layer.smooth: true
    color: "#1e1e2e"

    // Default to ~/.config/quickshell/assets/pfp.jpg
    property url source: "file://" + Quickshell.shellDir + "/assets/pfp.jpg"

    Image {
        anchors.fill: parent
        source: avatar.source
        fillMode: Image.PreserveAspectCrop
        smooth: true
        mipmap: true
        antialiasing: true
    }
}
