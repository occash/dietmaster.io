import QtQuick 2.3
import QtQuick.Window 2.0

import "style"

Rectangle {
    id: suggestBox

    property alias model: listView.model
    property int count: typeof(model) === "undefined" ? 0 : model.length

    signal selected(var data)

    color: Style.dark.alternateBase

    Text {
        visible: !count
        anchors.fill: parent
        anchors.leftMargin: 2
        text: qsTr("No results")
        color: Style.dark.mid
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        renderType: Text.NativeRendering
    }

    /*ProductForm {
        id: productForm

        anchors {
            left: parent.left
            top: searchBox.bottom
            right: parent.right
            bottom: parent.bottom
        }
    }*/

    ListView {
        id: listView

        anchors.fill: parent
        anchors.margins: 2 * Screen.pixelDensity

        clip: true
        focus: true
        visible: count

        delegate: Item {
            id: container

            height: 8 * Screen.pixelDensity
            width: parent.width

            property var delegateData: modelData

            Column {
                anchors.fill: parent

                Text {
                    text: modelData.name
                    color: Style.dark.text
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                    font.pixelSize: 3 * Screen.pixelDensity
                    font.family: "Tahoma"
                }

                Text {
                    text: modelData.group.name
                    color: Style.dark.mid
                    verticalAlignment: Text.AlignVCenter
                    renderType: Text.NativeRendering
                    font.pixelSize: 3 * Screen.pixelDensity
                    font.family: "Tahoma"
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: selected(delegateData)
            }
        }
    }
}

