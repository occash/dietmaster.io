import QtQuick 2.3
import QtGraphicalEffects 1.0

Item {
    id: overlay

    anchors.fill: source

    /*property string animationTarget: "radius"
    property variant from: 0
    property variant to: 16*/
    property variant source: null
    property Component effect: GaussianBlur {
        radius: 8
        samples: 16
    }

    signal clicked()

    /*onVisibleChanged: {
        if (visible) {
            hideAnimation.stop()
            showAnimation.start()
        } else {
            showAnimation.stop()
            hideAnimation.start()
        }
    }*/

    Loader {
        id: loader
        anchors.fill: parent
        sourceComponent: effect
    }

    Binding {
        target: loader.item
        property: "source"
        value: overlay.source
    }

    MouseArea {
        anchors.fill: parent
        onClicked: overlay.clicked()
    }

    /*PropertyAnimation {
        id: showAnimation
        target: loader.item
        property: animationTarget
        from: overlay.from
        to: overlay.to
    }

    PropertyAnimation {
        id: hideAnimation
        target: loader.item
        property: animationTarget
        from: overlay.to
        to: overlay.from
    }*/
}

