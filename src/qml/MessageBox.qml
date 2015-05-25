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
        anchors.fill: parent
    }
}

