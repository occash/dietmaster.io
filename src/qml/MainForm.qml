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

            board.calories = totalCalories
            board.protein = totalProtein
            board.fat = totalFat
            board.carbohydrate = totalCarbohydrate
        })
    }

    function record() {
        if (currentProduct) {
            var weight = weidthField.value
            var factor = weight / 100.0

            board.calories += currentProduct.calories * factor
            board.protein += currentProduct.protein * factor
            board.fat += currentProduct.fat * factor
            board.carbohydrate += currentProduct.carbohydrate * factor

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

    UserInfo {
        id: user
    }

    OptimalNutrient {
        id: nutrient
        user: user
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent

        Component.onCompleted: {
            updateNutrient()
            updateInfo()
        }

        DashBoard {
            id: board
            nutrient: nutrient

            Layout.fillWidth: true
            Layout.preferredHeight: parent.width / 4
            Layout.maximumHeight: parent.height / 10
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
                    if (reply.data.results.length > 0) {
                        currentProduct = reply.data.results[0]
                        list.model = reply.data.results
                        list.visible = true
                    } else
                        currentProduct = null

                    /*for (var i = 0; i < reply.data.results.length; ++i) {
                        console.log(JSON.stringify(reply.data.results))
                    }*/
                })
            }

            onValidate: check()
            onValidateFull: checkFull()
        }

        SuggestList {
            id: list
            Layout.fillWidth: true
            visible: false
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

