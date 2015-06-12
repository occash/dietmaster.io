import QtQuick 2.3
import QtQuick.Window 2.0

import "style"

Item {
    id: group

    property alias title: entryTitle.text
    property alias model: repeater.model
    property alias background: background

    property real titleHeight: 6 * Screen.pixelDensity
    property real entryHeight: 5 * Screen.pixelDensity

    height: titleHeight + model.count * entryHeight + 2 * Screen.pixelDensity

    Rectangle {
        id: background
        anchors.fill: parent
        color: Style.dark.alternateBase
    }

    Item {
        id: foreground
        anchors.fill: parent

        Text {
            id: entryTitle

            height: titleHeight
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
                    height: entryHeight

                    title: model.title
                    value: model.value
                }
            }
        }
    }
}

