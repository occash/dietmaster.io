import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

import "enums.js" as Severity

Column {
    id: input

    spacing: 2

    property bool valid: true
    property int severity: 0
    property bool isDefault: false

    property alias title: label.text
    property alias text: field.text
    property alias placeholder: field.placeholderText
    property alias echo: field.echoMode
    property alias errorString: error.text

    signal validate()
    signal validateFull()
    signal accept()

    function severityColor(s) {
        switch (s)
        {
        case Severity.Good: return "green"
        case Severity.Normal: return "orange"
        case Severity.Bad: return "red"
        }
    }

    Label {
        id: label

        anchors {
            left: parent.left
            right: parent.right
        }

        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
    }

    TextField {
        id: field

        anchors {
            left: parent.left
            right: parent.right
        }

        onTextChanged: {
            timer.restart()
            validate()
        }

        onAccepted: accept()

        Timer {
            id: timer
            interval: 400
            onTriggered: {
                if (input.valid)
                    validateFull()
            }
        }

        Component.onCompleted: {
            if (isDefault)
                field.forceActiveFocus()
        }
    }

    Label {
        id: error

        anchors {
            left: parent.left
            right: parent.right
        }

        visible: !input.valid
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        color: severityColor(input.severity)
    }
}

