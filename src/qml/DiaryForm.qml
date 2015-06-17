import QtQuick 2.3
import QtQuick.Window 2.0

import "style"
import "js/utils.js" as Utils

Item {
    id: diaryForm
    clip: true

    property alias model: listView.model

    ListView {
        id: listView

        anchors.fill: parent
        anchors.margins: 2 * Screen.pixelDensity

        focus: true
        visible: count
        spacing: 2 * Screen.pixelDensity

        section.property: "date"
        section.criteria: ViewSection.FullString
        section.delegate: Text {
            width: listView.width
            height: 7 * Screen.pixelDensity

            text: Utils.fromEds(section)
            color: Style.dark.text
            font.family: "Tahoma"
            font.pixelSize: 3.5 * Screen.pixelDensity
            renderType: Text.NativeRendering

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        delegate: Rectangle {
            id: container

            height: 12 * Screen.pixelDensity
            width: parent.width
            color: Style.dark.alternateBase

            Item {
                anchors.fill: parent
                anchors.margins: 2 * Screen.pixelDensity

                Column {
                    anchors {
                        left: parent.left
                        top: parent.top
                        right: giColor.right
                        bottom: parent.bottom
                    }

                    Text {
                        width: parent.width - 2 * Screen.pixelDensity
                        text: product.name
                        color: Style.dark.text
                        verticalAlignment: Text.AlignVCenter
                        renderType: Text.NativeRendering
                        font.pixelSize: 3 * Screen.pixelDensity
                        font.family: "Tahoma"
                        elide: Text.ElideRight
                    }

                    Text {
                        width: parent.width - 2 * Screen.pixelDensity
                        text: weight.toFixed() + "g"
                        color: Style.dark.mid
                        verticalAlignment: Text.AlignVCenter
                        renderType: Text.NativeRendering
                        font.pixelSize: 3 * Screen.pixelDensity
                        font.family: "Tahoma"
                        elide: Text.ElideRight
                    }
                }

                Rectangle {
                    id: giColor
                    width: 2 * Screen.pixelDensity
                    color: product.gi > 55 ? Style.colorBad : Style.colorGood

                    anchors {
                        top: parent.top
                        right: parent.right
                        bottom: parent.bottom
                    }
                }
            }
        }
    }
}

