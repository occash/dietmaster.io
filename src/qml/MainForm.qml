import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage 2.0
import Enginio 1.0

/*for(var i = 0; i < rs.rows.length; ++i) {
    console.log(rs.rows.item(i).name)
    var product = {
            objectType: "objects.product",
            group: rs.rows.item(i).group,
            name: rs.rows.item(i).name,
            gi: rs.rows.item(i).gi,
            calories: rs.rows.item(i).calories,
            protein: rs.rows.item(i).protein,
            fat: rs.rows.item(i).fat,
            carbohydrate: rs.rows.item(i).carbohydrate
        };
    client.create(product)
}*/

Rectangle {
    id: mainForm

    property EnginioClient client: null
    //property var db: LocalStorage.openDatabaseSync("diet", "1.0", "diet", 1000000);
    property var currentProduct

    property bool _gender: true
    property int _age: 30
    property real _height: 170
    property real _weight: 80
    property real _fatpercent: 25
    property int _lifestyle: 0

    function updateCurrent() {
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

    function updateInfo() {
        var queryString = {
            "objectType": "objects.userinfo",
            "limit": 1,
            "query": {}
        }
        var reply = client.query(queryString)
        reply.finished.connect(function() {
            if (!reply.isError) {
                var today = new Date()
                var birth = Date.fromLocaleString(Qt.locale(),
                    reply.data.results[0].birth, "yyyy-MM-ddThh:mm:ss.zzzZ")
                _gender = reply.data.results[0].gender
                _age = today.getFullYear() - birth.getFullYear()
                _height = reply.data.results[0].height
                _weight = reply.data.results[0].weight
                _fatpercent = reply.data.results[0].fatpercent
                _lifestyle = reply.data.results[0].lifestyle
            }
        })
    }

    function lifestyleCoef(l) {
        switch (l)
        {
        case 0: return 1.2
        case 1: return 1.375
        case 2: return 1.4625
        case 3: return 1.550
        case 4: return 1.6375
        case 5: return 1.725
        case 6: return 1.9
        }
    }

    function harrisBenedict(g, a, w, h) {
        var fc = g ? 66.5 : 655.1
        var wc = g ? 13.75 : 9.563
        var hc = g ? 5.003 : 1.85
        var ac = g ? 6.775 : 4.676

        return fc + (wc * w) + (hc * h) - (ac * a)
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent

        Component.onCompleted: updateInfo()

        RowLayout {
            id: rowLayout

            spacing: 0

            Layout.fillWidth: true
            Layout.preferredHeight: parent.width / 4
            Layout.maximumHeight: 50

            Timer {
                id: timer
                repeat: true
                interval: 1000
                triggeredOnStart: true
                running: pages.currentItem == mainForm

                onTriggered: updateCurrent()
            }

            NutritionPanel {
                id: calories

                Layout.fillWidth: true
                Layout.fillHeight: true

                title: qsTr("Calories")
                maxValue: harrisBenedict(_gender, _age, _weight, _height) *
                          lifestyleCoef(_lifestyle)
                currentValue: 0
            }

            NutritionPanel {
                id: protein

                Layout.fillWidth: true
                Layout.fillHeight: true

                title: qsTr("Protein")
                maxValue: _weight * (1 - _fatpercent / 100.0) * 5
                currentValue: 0
            }

            NutritionPanel {
                id: fat

                Layout.fillWidth: true
                Layout.fillHeight: true

                title: qsTr("Fat")
                maxValue: _weight * 3
                currentValue: 0
            }

            NutritionPanel {
                id: carbohydrate

                Layout.fillWidth: true
                Layout.fillHeight: true

                title: qsTr("Carbohydrate")
                maxValue: _weight * (1 - _fatpercent / 100.0)
                currentValue: 0
            }
        }

        Label {
            id: productLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Product")
        }

        TextField {
            id: productField

            Layout.fillWidth: true
            placeholderText: qsTr("Enter product name")

            onTextChanged: {
                if (text.length == 0)
                    return

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
                    errorLabel.visible = reply.data.results.length === 0
                    if (reply.data.results.length > 0)
                        currentProduct = reply.data.results[0]
                    else
                        currentProduct = null

                    /*for (var i = 0; i < reply.data.results.length; ++i) {
                        console.log(JSON.stringify(reply.data.results))
                    }*/
                })
            }
        }

        Label {
            id: errorLabel
            visible: false
            Layout.fillWidth: true
            text: qsTr("Not found in database")
            color: "#ff9896"
        }

        Label {
            id: weigthLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Weight")
        }

        TextField {
            id: weidthField

            Layout.fillWidth: true
            placeholderText: qsTr("Enter product weight")
            validator: DoubleValidator {
                bottom: 1.0
                notation: DoubleValidator.StandardNotation
            }
            /*style: TextFieldStyle {
                    textColor: "black"
                    background: Rectangle {
                        radius: 2
                        //implicitWidth: 100
                        //implicitHeight: 24
                        border.color: "#333"
                        border.width: 1
                        //color: "yellow"
                    }
                }*/
        }

        Button {
            id: toolButton

            Layout.fillWidth: true
            isDefault: true
            text: qsTr("Add record")

            onClicked: {
                console.log("Adding record")
                if (currentProduct) {
                    var currentDate = new Date()
                    currentDate.setHours(0, 0, 0, 0)

                    var record = {
                        "objectType": "objects.record",
                        "date": currentDate,
                        "product": {
                            "id": currentProduct.id,
                            "objectType": "objects.product"
                        },
                        "weight": Number(weidthField.text)
                    }
                    client.create(record)

                    currentProduct = ""
                    productField.text = ""
                    weidthField.text = ""
                }
            }
        }

        Item {
            id: spacer
            Layout.fillHeight: true
        }
    }
}

