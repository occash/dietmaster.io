import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import Enginio 1.0

Rectangle {
    id: infoForm

    property EnginioClient client: null

    signal next()

    ColumnLayout {
        id: layout

        anchors.fill: parent

        Label {
            id: genderLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Gender")
        }

        RowLayout {
            id: genderLayout

            Layout.fillWidth: true

            ExclusiveGroup { id: genderGroup }
            RadioButton {
                id: maleRadio

                Layout.fillWidth: true
                text: qsTr("Male")
                checked: true
                exclusiveGroup: genderGroup
            }
            RadioButton {
                id: femaleRadio

                Layout.fillWidth: true
                text: qsTr("Female")
                exclusiveGroup: genderGroup
            }
        }

        Label {
            id: birthLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Date of birth")
        }

        TextField {
            id: birthField

            Layout.fillWidth: true

            /*placeholderText: qsTr("Enter date of birth")
            inputMask: "0000-00-00"*/
            text: Qt.formatDate(calendar.selectedDate)
        }

        Calendar {
            id: calendar
            visible: birthField.activeFocus
            selectedDate: new Date(1990, 1, 1)

            Layout.fillWidth: true
        }

        Label {
            id: weightLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Weight")
        }

        SpinBox {
            id: weightSpin

            Layout.fillWidth: true

            minimumValue: 10
            maximumValue: 300

            value: maleRadio.checked ? 75 : 50
        }

        Label {
            id: heightLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Height")
        }

        SpinBox {
            id: heightSpin

            Layout.fillWidth: true

            minimumValue: 10
            maximumValue: 300

            value: maleRadio.checked ? 175 : 160
        }

        Label {
            id: fatPercentLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Body fat percentage")
        }

        SpinBox {
            id: fatPercentSpin

            Layout.fillWidth: true

            minimumValue: 1
            maximumValue: 100

            value: fatPanel.fatPercentage
        }

        FatPanel {
            id: fatPanel
            visible: fatPercentSpin.activeFocus

            Layout.fillWidth: true
        }

        Label {
            id: lifestyleLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Lifestyle")
        }

        ComboBox {
            id: lifestyleCombo

            Layout.fillWidth: true

            model: ListModel {
                ListElement { text: "No fitness" }
                ListElement { text: "Fitness 3 times a week" }
                ListElement { text: "Fitness 5 times a week" }
                ListElement { text: "Intensive fitness 5 times a week" }
                ListElement { text: "Fitness every day" }
                ListElement { text: "Intensive fitness every day" }
                ListElement { text: "Intensive fitness every day + physical work" }
            }
        }

        Button {
            id: loginButton

            Layout.fillWidth: true

            isDefault: true
            text: qsTr("Send")

            onClicked: {
                var birth = Date.fromLocaleDateString(Qt.locale(), birthField.text, Locale.ShortFormat)
                birth.setHours(0, 0, 0, 0)
                console.log(birth)
                var query = {
                    "objectType": "objects.userinfo",
                    "gender": maleRadio.checked,
                    "birth": birth,
                    "weight": weightSpin.value,
                    "height": heightSpin.value,
                    "fatpercent": fatPercentSpin.value,
                    "lifestyle": lifestyleCombo.currentIndex
                }
                console.log(JSON.stringify(query))
                var reply = client.create(query)
                reply.finished.connect(function() {
                    if (!reply.isError)
                        next()
                })
            }
        }

        Item {
            id: spacer
            Layout.fillHeight: true
        }
    }
}

