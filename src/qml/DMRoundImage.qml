import QtQuick 2.3

DMRoundComponent {
    id: roundImage

    property alias source: picture.source

    Image {
        id: picture
        anchors.fill: parent
    }
}

