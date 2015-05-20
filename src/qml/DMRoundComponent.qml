import QtQuick 2.3
import QtGraphicalEffects 1.0

Item {
    id: item

    default property alias children: placeholder.children

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

        anchors.fill: parent
        maskSource: circleMask
        source: placeholder
    }
}

