import QtQuick 2.3
import QtQuick.Window 2.0

import "style"

Rectangle {
    id: entry

    property alias title: entryTitle.text
    property alias model: repeater.model

    Text {
        id: entryTitle

        height: 8 * Screen.pixelDensity
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top

        color: Style.dark.base
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font.family: "Tahoma"
        font.pixelSize: 16
    }

    Column {
        id: form
        anchors.left: parent.left
        anchors.top: entryTitle.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Repeater {
            id: repeater
            model: detaiModel

            Item {
                id: row
                width: parent.width
                height: 8 * Screen.pixelDensity

                Text {
                    id: titleText

                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.top: parent.top
                    width: 24 * Screen.pixelDensity

                    text: title
                    color: Style.dark.base
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

                    text: value
                    color: Style.dark.base
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 14
                }
            }
        }
    }
}

