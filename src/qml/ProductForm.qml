import QtQuick 2.3
import QtQuick.Window 2.0

Item {
    id: productForm

    property var product: null

    Item {
        id: header

        height: 17 * Screen.pixelDensity
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
                margins: 2 * Screen.pixelDensity
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

                text: qsTr("Product name")
                font.pixelSize: 12
            }

            Text {
                id: group
                width: parent.width

                text: qsTr("Group")
                font.pixelSize: 12
            }
        }
    }
}

