import QtQuick 2.3
import QtQuick.Window 2.0

import "style"

Item {
    id: row

    default property alias data: picture.data

    property alias text: name.text
    signal clicked()

    Item {
        id: picture
        width: 24
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.top: parent.top
    }

    Text {
        id: name

        anchors.right: parent.right
        anchors.left: picture.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.leftMargin: 2 * Screen.pixelDensity

        color: Style.dark.text
        verticalAlignment: Text.AlignVCenter
        font.family: "Tahoma"
        font.pixelSize: 16
        renderType: Text.NativeRendering
    }

    MouseArea {
        anchors.fill: parent
        onClicked: row.clicked()
    }
}

