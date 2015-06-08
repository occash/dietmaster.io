import QtQuick 2.3
import QtQuick.Window 2.0

import "style"

Rectangle {
    id: vcard

    property var user: null

    Component {
        id: picture

        Image {
            source: user.backgroundImage
            fillMode: Image.PreserveAspectCrop
            smooth: true
        }
    }

    Component {
        id: solid

        Rectangle {
            color: user.backgroundColor
        }
    }

    Item {
        id: header
        anchors.fill: parent

        Loader {
            id: loader
            anchors.fill: parent
            sourceComponent: user.backgroundImage ? picture : solid
        }

        DMRoundImage {
            id: photo

            width: 15 * Screen.pixelDensity
            height: 15 * Screen.pixelDensity
            anchors.left: parent.left
            anchors.leftMargin: 2 * Screen.pixelDensity
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2 * Screen.pixelDensity

            source: user.photo
            color: "white"
        }

        /*Text {
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
            verticalAlignment: Text.AlignTop
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere

            font.family: "Tahoma"
            font.pixelSize: 4 * Screen.pixelDensity
        }*/

        VCardGroup {
            id: nutrition

            opacity: 0.7

            anchors {
                left: photo.right
                top: parent.top
                right: parent.right
                bottom: parent.bottom
                margins: 2 * Screen.pixelDensity
            }

            title: "Nutrition"
            model: ListModel {
                ListElement {
                    title: "Protein"
                    value: 150
                }

                ListElement {
                    title: "Fat"
                    value: 15
                }

                ListElement {
                    title: "Carbs"
                    value: 30
                }
            }
        }

        /*Text {
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
            verticalAlignment: Text.AlignTop
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere

            font.family: "Tahoma"
            font.pixelSize: 5 * Screen.pixelDensity
        }*/
    }
}

