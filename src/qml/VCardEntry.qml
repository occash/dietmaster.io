import QtQuick 2.0

Rectangle {
    id: rectangle1
    width: 100
    height: 62
    color: "#ffffff"

    Text {
        id: title
        width: 104
        text: "Gender"
        font.family: "Tahoma"
        verticalAlignment: Text.AlignVCenter
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        font.pixelSize: 16
    }

    Text {
        id: value
        text: qsTr("Text")
        verticalAlignment: Text.AlignVCenter
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: title.right
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        font.pixelSize: 16
    }
}

