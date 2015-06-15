import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls 1.2

import "style"

Item {
    id: productForm

    property var product: null

    Item {
        id: header

        height: 15 * Screen.pixelDensity
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }

        Image {
            id: photo

            width: height
            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }

            source: "logo.jpg"
        }

        Column {
            id: column

            anchors {
                left: photo.right
                right: parent.right
                bottom: parent.bottom
                top: parent.top
                margins: 2 * Screen.pixelDensity
            }

            Text {
                id: name
                width: parent.width

                text: "Сосиски"
                font.pixelSize: 3 * Screen.pixelDensity
                color: Style.dark.text
            }

            Text {
                id: group
                width: parent.width

                text: "Колбасные изделия"
                font.pixelSize: 3 * Screen.pixelDensity
                color: Style.dark.mid
            }
        }
    }

    SpinBox {
        id: weightField

        style: DMSpinBoxStyle {}

        anchors {
            left: parent.left
            top: header.bottom
            right: parent.right
            topMargin: 2 * Screen.pixelDensity
        }
    }
}

