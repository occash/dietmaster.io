import QtQuick 2.3
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0

import "style"

Rectangle {
    id: vcard

    property UserInfo user: null

    ListModel { id: nutritionModel }

    onUserChanged: {
        nutritionModel.clear()
        nutritionModel.append({
            "title": "Calories",
            "value": user.nutrition.calories.toFixed()
        })
        nutritionModel.append({
            "title": "Protein",
            "value": user.nutrition.protein.toFixed()
        })
        nutritionModel.append({
            "title": "Fat",
            "value": user.nutrition.fat.toFixed()
        })
        nutritionModel.append({
            "title": "Carbs",
            "value": user.nutrition.carbohydrate.toFixed()
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

    Component {
        id: picture

        Image {
            source: user.backgroundImage
            fillMode: Image.PreserveAspectCrop
            smooth: true
        }
    }

    Component {
        id: solid

        Rectangle {
            color: user.backgroundColor
        }
    }

    Item {
        id: header
        anchors.fill: parent

        Loader {
            id: loader
            anchors.fill: parent
            sourceComponent: user.backgroundImage ? picture : solid
        }

        DMRoundImage {
            id: photo

            width: 15 * Screen.pixelDensity
            height: 15 * Screen.pixelDensity
            anchors.left: parent.left
            anchors.leftMargin: 2 * Screen.pixelDensity
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2 * Screen.pixelDensity

            source: user.photo
            color: "white"
        }

        VCardGroup {
            id: nutrition

            background.opacity: 0.7

            anchors {
                left: photo.right
                top: parent.top
                right: parent.right
                bottom: parent.bottom
                margins: 2 * Screen.pixelDensity
            }

            titleHeight: 5 * Screen.pixelDensity
            entryHeight: 4.5 * Screen.pixelDensity
            title: user.firstname + " " + user.lastname
            model: nutritionModel
        }
    }
}

