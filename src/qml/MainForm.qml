import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

import "style"
import "severity.js" as Severity

Rectangle {
    id: mainForm
    color: Style.dark.base

    property RemoteAccess client: null
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
            productField.selected = true
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

    DashBoard {
        id: board
        nutrient: nutrient

        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }
        height: parent.width / 5 //parent.height / 9
    }

    Flickable {
        id: flickable

        anchors {
            left: parent.left
            top: board.bottom
            right: parent.right
            bottom: parent.bottom
        }

        ColumnLayout {
            id: layout

            anchors.fill: parent

            Component.onCompleted: {
                updateNutrient()
                updateInfo()
            }

            InputField {
                id: productField
                Layout.fillWidth: true
                title: qsTr("Product")
                placeholder: qsTr("Enter product name")
                isDefault: true

                property bool selected: false
                property var reply: null

                function update() {
                    if (reply.data.results.length > 0) {
                        list.model = reply.data.results
                        list.visible = true
                    } else
                        list.visible = false
                }

                function check() {
                    if (selected) {
                        selected = false
                        return
                    }

                    currentProduct = null

                    if (reply)
                        reply.finished.disconnect(update)

                    if (text.length === 0) {
                        list.visible = false
                        return
                    }

                    reply = client.search(text)
                    reply.finished.connect(update)
                }

                onValidate: check()
                onAccept: list.select(list.currentIndex)

                Keys.onPressed: {
                    if (event.key === Qt.Key_Down)
                        list.incrementCurrentIndex()
                    else if (event.key === Qt.Key_Up)
                        list.decrementCurrentIndex()
                }
            }

            SuggestList {
                id: list
                visible: false

                Layout.fillWidth: true
                Layout.preferredHeight: height

                onSelected: {
                    currentProduct = data
                    visible = false
                    productField.selected = true
                    productField.text = data.name
                }
            }

            Label {
                id: weigthLabel

                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                color: Style.dark.text

                text: qsTr("Weight")
            }

            SpinBox {
                id: weidthField
                Layout.fillWidth: true
                decimals: 2
                value: 100
                minimumValue: 1
                maximumValue: 1500
                style: DMSpinBoxStyle {}
            }

            Button {
                id: toolButton

                Layout.fillWidth: true
                isDefault: true
                text: qsTr("Add record")
                style: DMButtonStyle {}
                enabled: currentProduct !== null

                onClicked: record()
            }

            VerticalSpacer {
                id: spacer
            }
        }
    }
}

