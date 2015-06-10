import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1

import "style"

Item {
    id: homeForm
    clip: true

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

    Flickable {
        id: flickable

        anchors.fill: parent
        anchors.margins: 2 * Screen.pixelDensity

        contentWidth: width
        contentHeight: flickable.height + 1

        ColumnLayout {
            id: layout

            //anchors.fill: parent
            width: parent.width
            height: parent.height + 1

            InputField {
                id: productField
                Layout.fillWidth: true
                width: parent.width
                //title: qsTr("Product")
                placeholder: qsTr("Enter product name")
                //isDefault: true

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
                width: parent.width
                height: 100

                //Layout.fillWidth: true
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
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                color: Style.dark.text

                text: qsTr("Weight")
            }

            SpinBox {
                id: weidthField
                Layout.fillWidth: true
                width: parent.width
                decimals: 2
                value: 100
                minimumValue: 1
                maximumValue: 1500
                style: DMSpinBoxStyle {}
            }

            Button {
                id: toolButton

                Layout.fillWidth: true
                width: parent.width
                //isDefault: true
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

