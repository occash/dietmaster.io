import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import Enginio 1.0

import "enums.js" as Severity

Rectangle {
    id: mainForm

    property EnginioClient client: null
    property var currentProduct

    UserInfo {
        id: user
    }

    OptimalNutrient {
        id: nutrient
        user: user
    }

    function updateInfo() {
        var queryString = {
            "objectType": "objects.userinfo",
            "limit": 1,
            "query": {}
        }
        var reply = client.query(queryString)
        reply.finished.connect(function() {
            if (!reply.isError)
                user.update(reply.data.results[0])
        })
    }

    function updateNutrient() {
        var currentDate = new Date()
        currentDate.setHours(0, 0, 0, 0)

        var queryString = {
            "objectType": "objects.record",
            "limit": 100,
            "query": {
                "date": currentDate
            },
            "include": {
                "product": {}
            }
        }
        var reply = client.query(queryString)

        reply.finished.connect(function() {
            var totalCalories = 0
            var totalProtein = 0
            var totalFat = 0
            var totalCarbohydrate = 0

            for (var i = 0; i < reply.data.results.length; ++i) {
                var factor = reply.data.results[i].weight / 100.0

                totalCalories += reply.data.results[i].product.calories * factor
                totalProtein += reply.data.results[i].product.protein * factor
                totalFat += reply.data.results[i].product.fat * factor
                totalCarbohydrate += reply.data.results[i].product.carbohydrate * factor
            }

            calories.currentValue = totalCalories
            protein.currentValue = totalProtein
            fat.currentValue = totalFat
            carbohydrate.currentValue = totalCarbohydrate
        })
    }

    function record() {
        if (currentProduct) {
            var weight = weidthField.value
            var factor = weight / 100.0

            calories.currentValue += currentProduct.calories * factor
            protein.currentValue += currentProduct.protein * factor
            fat.currentValue += currentProduct.fat * factor
            carbohydrate.currentValue += currentProduct.carbohydrate * factor

            var currentDate = new Date()
            currentDate.setHours(0, 0, 0, 0)

            var record = {
                "objectType": "objects.record",
                "date": currentDate,
                "product": {
                    "id": currentProduct.id,
                    "objectType": "objects.product"
                },
                "weight": weidthField.value
            }
            client.create(record)

            currentProduct = null
            productField.text = ""
            weidthField.value = 100
        }
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent

        Component.onCompleted: {
            updateNutrient()
            updateInfo()
        }

        RowLayout {
            id: rowLayout

            spacing: -1

            Layout.fillWidth: true
            Layout.preferredHeight: parent.width / 4
            Layout.maximumHeight: 50

            NutritionPanel {
                id: calories

                Layout.fillWidth: true
                Layout.fillHeight: true

                title: qsTr("Calories")
                maxValue: nutrient.calories
                currentValue: 0
            }

            NutritionPanel {
                id: protein

                Layout.fillWidth: true
                Layout.fillHeight: true

                title: qsTr("Protein")
                maxValue: nutrient.protein
                currentValue: 0
            }

            NutritionPanel {
                id: fat

                Layout.fillWidth: true
                Layout.fillHeight: true

                title: qsTr("Fat")
                maxValue: nutrient.fat
                currentValue: 0
            }

            NutritionPanel {
                id: carbohydrate

                Layout.fillWidth: true
                Layout.fillHeight: true

                title: qsTr("Carbohydrate")
                maxValue: nutrient.carbohydrate
                currentValue: 0
            }
        }

        InputField {
            id: productField
            Layout.fillWidth: true
            title: qsTr("Product")
            placeholder: qsTr("Enter product name")
            errorString: qsTr("Not found in database")
            severity: Severity.Bad

            function check() {
                currentProduct = null
                valid = true
            }

            function checkFull() {
                var queryString = {
                    "objectType": "objects.product",
                    "limit": 1,
                    "query": {
                        "name": text
                    }
                }
                var reply = client.query(queryString)

                /*var q = {
                    "objectTypes": [0, "objects.product"],
                    "search": {
                        "phrase": text + "*",
                        "properties": ["objectType"]
                    },
                    "limit": 10
                }
                var reply = client.fullTextSearch(q)*/

                reply.finished.connect(function() {
                    valid = reply.data.results.length > 0
                    if (reply.data.results.length > 0)
                        currentProduct = reply.data.results[0]
                    else
                        currentProduct = null

                    /*for (var i = 0; i < reply.data.results.length; ++i) {
                        console.log(JSON.stringify(reply.data.results))
                    }*/
                })
            }

            onValidate: check()
            onValidateFull: checkFull()
        }

        Label {
            id: weigthLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Weight")
        }

        SpinBox {
            id: weidthField
            Layout.fillWidth: true
            decimals: 2
            value: 100
            minimumValue: 1
            maximumValue: 1500
        }

        Button {
            id: toolButton

            Layout.fillWidth: true
            isDefault: true
            text: qsTr("Add record")

            onClicked: record()
        }

        Item {
            id: spacer
            Layout.fillHeight: true
        }
    }
}

