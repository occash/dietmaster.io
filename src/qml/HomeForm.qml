import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.2
import Enginio 1.0

import "style"

Item {
    id: homeForm
    clip: true

    property var client: null
    property var user: null

    function record(product) {
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

    TextField {
        id: searchBox

        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }

        style: DMTextFieldStyle {}
        placeholderText: qsTr("Search product")
        inputMethodHints: Qt.ImhNoPredictiveText

        onAccepted: {
            var reply = client.search(searchBox.text)
            reply.finished.connect(function() {
                if (!reply.isError)
                    suggestList.model = reply.data.results
            })
        }

        Button {
            id: searchImage

            visible: searchBox.text
            width: height
            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }

            iconSource: "icons/dark/close.png"
            smooth: true

            style: ButtonStyle {
                background: Item {}
                label: Image {
                    clip: true
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    source: control.iconSource
                    smooth: true
                    fillMode: Image.PreserveAspectFit
                }
            }

            onClicked: searchBox.text = ""
        }
    }

    DiaryForm {
        id: diaryForm

        anchors {
            left: parent.left
            top: searchBox.bottom
            right: parent.right
            bottom: parent.bottom
        }
    }

    SuggestList {
        id: suggestList
        height: searchBox.text.length ?
                    (parent.height - searchBox.height) : 0

        anchors {
            left: parent.left
            top: searchBox.bottom
            right: parent.right
        }

        onSelected: {
            productForm.product = data
            suggestList.visible = false
        }

        Behavior on height {
            NumberAnimation {
                target: suggestList
                property: "height"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }

    /*ProductForm {
        id: productForm

        anchors {
            left: parent.left
            top: searchBox.bottom
            right: parent.right
            bottom: parent.bottom
            margins: 2 * Screen.pixelDensity
        }
    }*/
}

