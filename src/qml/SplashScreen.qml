import QtQuick 2.0

Rectangle {
    id: splash
    color: "white"

    property alias logo: logo.source
    property alias text: text.text

    Image {
        id: logo
        anchors.left: parent.left
        anchors.right: parent.right
        y: (parent.height / 2) - (height / 2) - text.height
        asynchronous: true
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: text
        anchors.top: logo.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        font.pointSize: 20
        horizontalAlignment: Text.AlignHCenter
    }
}

