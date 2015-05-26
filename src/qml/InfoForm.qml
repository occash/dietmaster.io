import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

import "style"

Rectangle {
    id: infoForm
    color: Style.dark.text

    property var client: null

    signal next()

    ColumnLayout {
        id: layout

        anchors.fill: parent

        Label {
            id: genderLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Gender")
            color: Style.dark.base
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
                style: DMRadioButtonStyle { dark: false }
            }
            RadioButton {
                id: femaleRadio

                Layout.fillWidth: true
                text: qsTr("Female")
                exclusiveGroup: genderGroup
                style: DMRadioButtonStyle { dark: false }
            }
        }

        Label {
            id: birthLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Date of birth")
            color: Style.dark.text
        }

        TextField {
            id: birthField

            Layout.fillWidth: true
            text: Qt.formatDate(calendar.selectedDate)
            style: DMTextFieldStyle { dark: false }
        }

        Calendar {
            id: calendar
            visible: false//birthField.activeFocus
            selectedDate: new Date(1990, 1, 1)

            Layout.fillWidth: true
        }

        Label {
            id: weightLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Weight")
            color: Style.dark.base
        }

        SpinBox {
            id: weightSpin

            Layout.fillWidth: true

            minimumValue: 10
            maximumValue: 300

            value: maleRadio.checked ? 75 : 50
            style: DMSpinBoxStyle { dark: false }
        }

        Label {
            id: heightLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Height")
            color: Style.dark.base
        }

        SpinBox {
            id: heightSpin

            Layout.fillWidth: true

            minimumValue: 10
            maximumValue: 300

            value: maleRadio.checked ? 175 : 160
            style: DMSpinBoxStyle { dark: false }
        }

        Label {
            id: fatPercentLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Body fat percentage")
            color: Style.dark.base
        }

        SpinBox {
            id: fatPercentSpin

            Layout.fillWidth: true

            minimumValue: 1
            maximumValue: 100

            value: fatPanel.fatPercentage
            style: DMSpinBoxStyle { dark: false }
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
            color: Style.dark.base
        }

        ComboBox {
            id: lifestyleCombo

            Layout.fillWidth: true
            style: DMComboBoxStyle { dark: false }

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
            style: DMButtonStyle { dark: false }

            onClicked: {
                var birth = Date.fromLocaleDateString(Qt.locale(), birthField.text, Locale.ShortFormat)
                birth.setHours(0, 0, 0, 0)
                var query = {
                    "objectType": "objects.userinfo",
                    "gender": maleRadio.checked,
                    "birth": birth,
                    "weight": weightSpin.value,
                    "height": heightSpin.value,
                    "fatpercent": fatPercentSpin.value,
                    "lifestyle": lifestyleCombo.currentIndex
                }
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

