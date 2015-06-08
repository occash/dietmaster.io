import QtQuick 2.3
import QtQuick.Window 2.0

import "style"

Rectangle {
    id: group

    property alias title: entryTitle.text
    property alias model: repeater.model

    height: (8 + 5 * model.count) * Screen.pixelDensity
    color: Style.dark.alternateBase

    Text {
        id: entryTitle

        height: 6 * Screen.pixelDensity
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top

        color: Style.dark.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        renderType: Text.NativeRendering
        font.family: "Tahoma"
        font.pixelSize: 3.5 * Screen.pixelDensity
    }

    Column {
        id: form
        anchors.left: parent.left
        anchors.top: entryTitle.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Repeater {
            id: repeater

            VCardEntry {
                id: entry

                width: parent.width
                height: 5 * Screen.pixelDensity

                title: model.title
                value: model.value
            }
        }
    }
}

