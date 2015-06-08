import QtQuick 2.3
import QtQuick.Window 2.0

Item {
    id: form
    clip: true

    default property alias data: flickable.data

    Flickable {
        id: flickable

        interactive: true
        anchors.fill: parent
        anchors.margins: 2 * Screen.pixelDensity

        contentWidth: width
        contentHeight: 800//height + 1
    }
}

