import QtQuick 2.3
import QtQuick.Window 2.0

import "style"

Overlay {
    id: overlay
    visible: false

    default property alias data: container.data

    function show() {
        visible = true
    }

    function hide() {
        visible = false
    }

    onClicked: hide()

    Item {
        id: container
        anchors.centerIn: parent
        width: childrenRect.width + 20
        height: childrenRect.height + 20

        //width: 40 * Screen.pixelDensity
        //height: 10 * Screen.pixelDensity
    }
}

