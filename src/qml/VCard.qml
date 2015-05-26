import QtQuick 2.3
import QtQuick.Window 2.0

import "style"

Rectangle {
    id: vcard

    property string userPhoto: "https://lh3.googleusercontent.com/-S8d0_Ws_sJY/AAAAAAAAAAI/AAAAAAAABAc/v4FZ2mpFCy4/s120-c/photo.jpg"
    property string backgroundImage: "https://lh3.googleusercontent.com/-MClGeXiAM-0/Uica-OFcG5I/AAAAAAAAA2Q/Olt_LZXcQmU/s923-fcrop64=1,00000c6ffffff44b/World_Scotland_Scotland_Cairngorms_007813_.jpg"
    property color backgroundColor: "orange"

    Component {
        id: picture

        Image {
            source: backgroundImage
            fillMode: Image.PreserveAspectCrop
            smooth: true
        }
    }

    Component {
        id: solid

        Rectangle {
            color: backgroundColor
        }
    }

    Item {
        id: header

        height: 48 * Screen.pixelDensity
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }

        Loader {
            id: loader1
            anchors.fill: parent
            sourceComponent: backgroundImage ? picture : solid
        }

        DMRoundImage {
            id: photo

            width: 24 * Screen.pixelDensity
            height: 24 * Screen.pixelDensity
            anchors.left: parent.left
            anchors.leftMargin: 2 * Screen.pixelDensity
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2 * Screen.pixelDensity
            source: userPhoto
        }

        Text {
            id: name

            anchors.left: photo.right
            anchors.top: photo.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: photo.height / 2
            anchors.leftMargin: 2 * Screen.pixelDensity

            color: "#e1dada"
            text: qsTr("Artyom Shal")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere

            font.family: "Tahoma"
            font.pixelSize: 20
        }

        Text {
            id: nickname

            anchors.left: photo.right
            anchors.top: name.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2 * Screen.pixelDensity
            anchors.leftMargin: 2 * Screen.pixelDensity

            color: "#e1dada"
            text: qsTr("occash")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere

            font.family: "Tahoma"
            font.pixelSize: 16
        }
    }

    VCardGroup {
        anchors.left: parent.left
        anchors.top: header.bottom
        anchors.right: parent.right
        anchors.margins: 2 * Screen.pixelDensity
        height: 24 * Screen.pixelDensity

        title: "Basic Information"
        model: ListModel {
            id: detaiModel

            ListElement {
                title: qsTr("Gender")
                value: "Male"
            }
        }
    }
}

