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

    function record(data) {
        var currentDate = new Date()
        currentDate.setHours(0, 0, 0, 0)

        var record = {
            "objectType": "objects.record",
            "date": currentDate,
            "product": {
                "id": data.product.id,
                "objectType": "objects.product"
            },
            "weight": data.weight
        }
        client.create(record)
    }

    onClientChanged: {
        if (!client)
            return

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
            if (!reply.isError) {
                diaryForm.model.clear()
                for (var i = 0; i < reply.data.results.length; ++i)
                    diaryForm.model.append(reply.data.results[i])
            }
        })
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
                if (!reply.isError) {
                    suggestList.pop()
                    suggestList.currentItem.model = reply.data.results
                }
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

            onClicked: {
                suggestList.pop({immediate: true})
                suggestList.currentItem.model = []
                searchBox.text = ""
            }
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

    StackView {
        id: suggestList
        height: searchBox.text.length ?
                    (parent.height - searchBox.height) : 0

        anchors {
            left: parent.left
            top: searchBox.bottom
            right: parent.right
        }

        Component {
            id: productForm
            ProductForm {
                onRecord: {
                    suggestList.pop({immediate: true})
                    suggestList.currentItem.model = []
                    searchBox.text = ""
                    homeForm.record(product)
                }
            }
        }

        initialItem: SuggestList {
            onSelected: {
                suggestList.push({
                    item: productForm,
                    properties: {
                        product: data
                    }
                })
            }
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
}

