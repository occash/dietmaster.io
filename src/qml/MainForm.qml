import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

import "style"
import "severity.js" as Severity

Rectangle {
    id: mainForm
    color: Style.dark.base

    property var client: null
    property var user: null
    property var currentProduct

    onClientChanged:  {
        if (client) {
            updateNutrient()
            updateInfo()
        }
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
            productField.selected = true
            productField.text = ""
            weidthField.value = 100
        }
    }

    VCard {
        id: board

        user: mainForm.user
        height: 28 * Screen.pixelDensity

        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }

        OptimalNutrient {
            id: nutrient
            user: mainForm.user
        }

        /*DashBoard {
            id: dashboard
            nutrient: nutrient

            anchors {
                left: parent.left
                top: parent.top
                right: parent.right
            }
            height: parent.height / 2
        }*/
    }

    HomeForm {
        anchors {
            left: parent.left
            top: board.bottom
            right: parent.right
            bottom: buttons.top
        }
    }

    Rectangle {
        id: buttons
        height: 11 * Screen.pixelDensity
        color: Style.light.button

        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right
        }

        ExclusiveGroup {
            id: group
        }

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Button {
                Layout.fillHeight: true
                Layout.fillWidth: true
                iconSource: "home.png"
                style: DMButtonStyle { dark: false }
                exclusiveGroup: group
                checkable: true
                checked: true
            }
            Button {
                Layout.fillHeight: true
                Layout.fillWidth: true
                iconSource: "stats.png"
                style: DMButtonStyle { dark: false }
                exclusiveGroup: group
                checkable: true
            }
            Button {
                Layout.fillHeight: true
                Layout.fillWidth: true
                iconSource: "tools.png"
                style: DMButtonStyle { dark: false }
                exclusiveGroup: group
                checkable: true
            }
        }
    }
}

