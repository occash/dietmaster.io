import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

import "style"
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
        case Severity.Good: return Style.colorGood
        case Severity.Normal: return Style.colorNormal
        case Severity.Bad: return Style.colorBad
        }
    }

    Label {
        id: label

        color: Style.textColor

        anchors {
            left: parent.left
            right: parent.right
        }

        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
    }

    TextField {
        id: field

        style: DMTextFieldStyle {}

        anchors {
            left: parent.left
            right: parent.right
        }

        onTextChanged: {
            validate()
            if (text.length > 0)
                timer.restart()
            else
                timer.stop()
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

