import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

import ".."
import "../style"

Rectangle {
    id: extraForm

    property var client: null
    property var user: null

    function check() {
        return true
    }

    signal register()

    Binding {
        target: user
        property: "abdomen"
        value: abdomenSpin.value
    }

    Binding {
        target: user
        property: "neck"
        value: neckSpin.value
    }

    Binding {
        target: user
        property: "hip"
        value: hipSpin.value
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent

        Alert {
            Layout.fillWidth: true
            text: qsTr("These fields are not required, but it is recommended to fill them in.")
        }

        Label {
            id: abdomenLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Abdomen")
            color: Style.dark.base
        }

        SpinBox {
            id: abdomenSpin

            Layout.fillWidth: true

            minimumValue: 10
            maximumValue: 300

            value: 80
            style: DMSpinBoxStyle { dark: false }
        }

        Label {
            id: neckLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Neck")
            color: Style.dark.base
        }

        SpinBox {
            id: neckSpin

            Layout.fillWidth: true

            minimumValue: 10
            maximumValue: 300

            value: 50
            style: DMSpinBoxStyle { dark: false }
        }

        Label {
            id: hipLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Hip")
            color: Style.dark.base
        }

        SpinBox {
            id: hipSpin

            Layout.fillWidth: true

            minimumValue: 10
            maximumValue: 300

            value: 35
            style: DMSpinBoxStyle { dark: false }
        }

        Button {
            id: loginButton

            Layout.fillWidth: true

            //isDefault: true
            text: qsTr("Send")
            style: DMButtonStyle { dark: false }

            onClicked: register()
        }

        Label {
            id: registerError
            Layout.fillHeight: true
            visible: false
            color: "red"
            wrapMode: Text.WordWrap
        }

        VerticalSpacer {}
    }


}
