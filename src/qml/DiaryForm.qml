import QtQuick 2.3
import QtQuick.Window 2.0

import "style"

Item {
    id: diaryForm
    clip: true

    ListModel { id: defaultModel }

    Component.onCompleted: {
        for (var i = 0; i < 10; ++i)
        defaultModel.append({
            "date": new Date().toLocaleDateString(),
            "product": {
                "name": "Суши Инари унаги",
                "calories": 213,
                "carbohydrate": 11.3,
                "fat": 15,
                "protein": 8.4,
                "gi": Math.random() * 100.0,
                "group": {
                    "name": "Колбасные изделия"
                }
            },
            "weight": Math.random() * 400.0
        })
        for (var i = 0; i < 10; ++i)
        defaultModel.append({
            "date": new Date(2015, 6, 14).toLocaleDateString(),
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

        focus: true
        visible: count
        spacing: 2 * Screen.pixelDensity

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
                    anchors {
                        left: parent.left
                        top: parent.top
                        right: giColor.right
                        bottom: parent.bottom
                    }

                    Text {
                        text: product.name
                        color: Style.dark.text
                        verticalAlignment: Text.AlignVCenter
                        renderType: Text.NativeRendering
                        font.pixelSize: 3 * Screen.pixelDensity
                        font.family: "Tahoma"
                    }

                    Text {
                        text: weight.toFixed() + "g"
                        color: Style.dark.mid
                        verticalAlignment: Text.AlignVCenter
                        renderType: Text.NativeRendering
                        font.pixelSize: 3 * Screen.pixelDensity
                        font.family: "Tahoma"
                    }
                }

                Rectangle {
                    id: giColor
                    width: 2 * Screen.pixelDensity
                    color: product.gi > 70 ? Style.colorBad : Style.colorGood

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

