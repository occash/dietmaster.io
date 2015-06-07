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
        width: 24 * Screen.pixelDensity

        color: Style.dark.text
        font.family: "Tahoma"
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 14
    }

    Text {
        id: valueText

        anchors.right: parent.right
        anchors.left: titleText.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top

        color: Style.dark.text
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 14
    }
}

