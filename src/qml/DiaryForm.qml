import QtQuick 2.3
import QtQuick.Window 2.0

import "style"

Item {
    id: diaryForm

    ListModel { id: defaultModel }

    Component.onCompleted: {
        defaultModel.append({
            "date": new Date().toLocaleDateString(),
            "product": {
                "name": "Сосиски",
                "calories": 150,
                "group": {
                    "name": "Колбасные изделия"
                }
            },
            "weight": 150
        })
    }

    ListView {
        id: listView

        anchors.fill: parent
        anchors.margins: 2 * Screen.pixelDensity

        clip: true
        focus: true
        visible: count

        section.property: "date"
        section.criteria: ViewSection.FullString
        section.delegate: Text {
            width: listView.width
            height: 7 * Screen.pixelDensity

            text: section
            color: Style.dark.text
            font.family: "Tahoma"
            font.pixelSize: 3.5 * Screen.pixelDensity
            renderType: Text.NativeRendering

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        model: defaultModel
        delegate: Rectangle {
            id: container

            height: 12 * Screen.pixelDensity
            width: parent.width
            color: Style.dark.alternateBase

            Item {
                anchors.fill: parent
                anchors.margins: 2 * Screen.pixelDensity

                Column {
                    anchors.fill: parent

                    Text {
                        text: product.name
                        color: Style.dark.text
                        verticalAlignment: Text.AlignVCenter
                        renderType: Text.NativeRendering
                        font.pixelSize: 3 * Screen.pixelDensity
                        font.family: "Tahoma"
                    }

                    Text {
                        text: weight + "g"
                        color: Style.dark.mid
                        verticalAlignment: Text.AlignVCenter
                        renderType: Text.NativeRendering
                        font.pixelSize: 3 * Screen.pixelDensity
                        font.family: "Tahoma"
                    }
                }
            }


        }
    }
}

