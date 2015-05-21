import QtQuick 2.3
import QtQuick.Window 2.0

import "style"

Overlay {
    id: overlay
    visible: false

    property alias text: message.text

    function show() {
        visible = true
    }

    function hide() {
        visible = false
    }

    onClicked: hide()

    Rectangle {
        id: popup

        anchors.centerIn: parent
        width: 40 * Screen.pixelDensity
        height: 10 * Screen.pixelDensity
        color: Style.light.text
        opacity: 0.7

        Text {
            id: message

            anchors.fill: parent
            text: ""
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: Style.dark.text
            font.pointSize: 12
            renderType: Text.NativeRendering
            //font.weight: Font.DemiBold
        }
    }
}

