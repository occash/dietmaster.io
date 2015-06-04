import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

import "style"
import "severity.js" as Severity

Column {
    id: input

    spacing: 2

    property bool valid: true
    property int severity: 0
    property bool isDefault: false

    property bool dark: true
    property DMTheme palette: dark ? Style.dark : Style.light

    property alias title: label.text
    property alias text: field.text
    property alias placeholder: field.placeholderText
    property alias echo: field.echoMode
    property alias errorString: error.text
    property alias hints: field.inputMethodHints

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

        color: palette.text
        visible: text.length > 0

        anchors {
            left: parent.left
            right: parent.right
        }

        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        font.pixelSize: 3 * Screen.pixelDensity
    }

    TextField {
        id: field

        inputMethodHints: Qt.ImhNoPredictiveText
        style: DMTextFieldStyle { dark: input.dark }

        anchors {
            left: parent.left
            right: parent.right
        }

        onTextChanged: {
            //validate()
            valid = true
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
                validate()
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

