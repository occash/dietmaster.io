import QtQuick 2.3
import QtGraphicalEffects 1.0

import "style"

Item {
    id: item

    default property alias data: placeholder.data
    property alias overlay: mask.data
    property int borderWidth: 0
    property color borderColor: Style.dark.base

    Rectangle {
        id: circleMask
        anchors.fill: parent

        smooth: true
        visible: false

        radius: Math.max(width/2, height/2)
    }

    Item {
        id: placeholder
        anchors.fill: parent
        visible: false
    }

    OpacityMask {
        id: mask

        width: parent.width - 1
        height: parent.height - 1
        maskSource: circleMask
        source: placeholder

        Rectangle {
            id: border
            anchors.fill: parent

            smooth: true
            visible: true
            color: "transparent"
            border.width: borderWidth
            border.color: borderColor

            radius: Math.max(width/2, height/2)
        }
    }
}

