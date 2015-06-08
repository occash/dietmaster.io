import QtQuick 2.3
import QtQuick.Window 2.0

import "style"

Item {
    id: entry

    property alias title: titleText.text
    property alias value: valueText.text

    Text {
        id: titleText

        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.leftMargin: 2 * Screen.pixelDensity
        width: 24 * Screen.pixelDensity

        color: Style.dark.text
        font.family: "Tahoma"
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 3 * Screen.pixelDensity
        renderType: Text.NativeRendering
    }

    Text {
        id: valueText

        anchors.right: parent.right
        anchors.left: titleText.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.rightMargin: 2 * Screen.pixelDensity

        color: Style.dark.text
        font.family: "Tahoma"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 3 * Screen.pixelDensity
        renderType: Text.NativeRendering
    }
}

