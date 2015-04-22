import QtQuick 2.3
import QtGraphicalEffects 1.0

Item {
    id: item

    property alias source: image.source

    Rectangle {
        id: circleMask
        anchors.fill: parent

        smooth: true
        visible: false

        radius: Math.max(width/2, height/2)
    }

    Image {
        id: image
        anchors.fill: parent
        visible: false
    }

    OpacityMask {
        id: mask

        anchors.fill: parent
        maskSource: circleMask
        source: image
    }
}

