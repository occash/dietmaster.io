import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls 1.2

import "style"
import "js/utils.js" as Utils

Rectangle {
    id: productForm
    color: Style.dark.base

    property var product: null
    signal record(var product)

    ListModel { id: nutritionModel }

    function updateFacts(weight) {
        var coef = weight / 100.0

        nutritionModel.clear()
        nutritionModel.append({
            "title": qsTr("Calories"),
            "value": (product.calories * coef).toFixed()
        })
        nutritionModel.append({
            "title": qsTr("Total Fat"),
            "value": (product.fat * coef).toFixed()
        })
        nutritionModel.append({
            "title": qsTr("Total Carbohydrate"),
            "value": (product.carbohydrate * coef).toFixed()
        })
        nutritionModel.append({
            "title": qsTr("Protein"),
            "value": (product.protein * coef).toFixed()
        })
    }

    Column {
        id: column
        anchors.fill: parent
        anchors.margins: 2 * Screen.pixelDensity
        spacing: 2 * Screen.pixelDensity

        Item {
            id: header

            width: parent.width
            height: 15 * Screen.pixelDensity

            Image {
                id: photo

                width: height
                anchors {
                    top: parent.top
                    left: parent.left
                    bottom: parent.bottom
                }

                source: "logo.png"
            }

            Column {
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

                    text: product.name
                    font.pixelSize: 3 * Screen.pixelDensity
                    font.family: "Tahoma"
                    color: Style.dark.text
                    renderType: Text.NativeRendering
                }

                Text {
                    id: group
                    width: parent.width

                    text: product.group.name
                    font.pixelSize: 3 * Screen.pixelDensity
                    font.family: "Tahoma"
                    color: Style.dark.mid
                    renderType: Text.NativeRendering
                }
            }
        }

        SpinBox {
            id: weightField
            width: parent.width

            style: DMSpinBoxStyle {}
            value: 100
            minimumValue: 1
            maximumValue: 1500
            suffix: qsTr(" g")

            onValueChanged: updateFacts(value)
        }

        Button {
            id: recordData
            width: parent.width

            style: DMButtonStyle {}
            text: qsTr("Update")

            onClicked: {
                var currentDate = new Date()
                currentDate.setHours(0, 0, 0, 0)

                record({
                    date: Utils.toEds(currentDate),
                    weight: weightField.value,
                    product: productForm.product
                })
            }
        }

        VCardGroup {
            id: nutrition
            width: parent.width

            title: qsTr("Nutrition facts")
            model: nutritionModel
        }
    }
}

