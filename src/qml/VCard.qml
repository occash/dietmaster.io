import QtQuick 2.3
import QtQuick.Window 2.0

import "style"

Rectangle {
    id: vcard

    property UserInfo user: null

    ListModel { id: nutritionModel }

    onUserChanged: {
        nutritionModel.clear()
        nutritionModel.append({
            "title": "Protein",
            "value": user.nutrition.protein
        })
        nutritionModel.append({
            "title": "Fat",
            "value": user.nutrition.fat
        })
        nutritionModel.append({
            "title": "Carbs",
            "value": user.nutrition.carbohydrate
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

        /*Text {
            id: name

            anchors.left: photo.right
            anchors.top: photo.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: photo.height / 2
            anchors.leftMargin: 2 * Screen.pixelDensity

            color: "#e1dada"
            text: qsTr("Artyom Shal")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere

            font.family: "Tahoma"
            font.pixelSize: 4 * Screen.pixelDensity
        }*/

        VCardGroup {
            id: nutrition

            opacity: 0.7

            anchors {
                left: photo.right
                top: parent.top
                right: parent.right
                bottom: parent.bottom
                margins: 2 * Screen.pixelDensity
            }

            title: user.firstname + " " + user.lastname
            model: nutritionModel
        }

        /*Text {
            id: nickname

            anchors.left: photo.right
            anchors.top: name.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2 * Screen.pixelDensity
            anchors.leftMargin: 2 * Screen.pixelDensity

            color: "#e1dada"
            text: qsTr("occash")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere

            font.family: "Tahoma"
            font.pixelSize: 5 * Screen.pixelDensity
        }*/
    }
}

