import QtQuick 2.3
import QtQuick.Window 2.0

import "style"

Rectangle {
    id: warning

    property alias text: label.text

    color: Style.light.button
    height: 12 * Screen.pixelDensity

    Text {
        id: label
        anchors.fill: parent
        anchors.margins: 1 * Screen.pixelDensity
        color: Style.dark.text
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        renderType: Text.NativeRendering
    }
}

