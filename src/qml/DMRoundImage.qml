import QtQuick 2.3

DMRoundComponent {
    id: roundImage

    property alias source: picture.source
    property alias color: background.color

    Rectangle {
        id: background
        anchors.fill: parent

        Image {
            id: picture
            anchors.fill: parent
            smooth: true
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
        }
    }
}

