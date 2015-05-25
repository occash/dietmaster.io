import QtQuick 2.3

Rectangle {
    id: vcard

    property alias userPhoto: background.source

    Image {
        id: background
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        source: "https://lh3.googleusercontent.com/-MClGeXiAM-0/Uica-OFcG5I/AAAAAAAAA2Q/Olt_LZXcQmU/s923-fcrop64=1,00000c6ffffff44b/World_Scotland_Scotland_Cairngorms_007813_.jpg"

        Rectangle {
            id: overlay
            color: "#000000"
            opacity: 0.7
            height: 100

            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top
        }

        Item {
            id: header
            anchors.fill: overlay

            Rectangle {
                id: userPhoto
                x: 8
                y: 5
                width: 83
                height: 83
                color: "#ffffff"
                radius: 42
                z: 1
            }

            Text {
                id: nameText
                x: 106
                y: 5
                width: 243
                height: 30
                color: "#ebe6e6"
                text: qsTr("Artyom Shal")
                font.family: "Tahoma"
                styleColor: "#dacece"
                font.pixelSize: 18
            }
        }
    }
}

