import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.2

import "."

TextFieldStyle {
    textColor: Style.textColor
    placeholderTextColor: Style.placeholderColor
    background: Rectangle {
        id: input

        implicitWidth: 20 * Screen.pixelDensity
        implicitHeight: 6 * Screen.pixelDensity

        color: Style.secondColor
        border.width: 1
        border.color: control.activeFocus ? Style.borderColor : Style.secondColor

        states: [
            State {
                name: "hovered"
                when: control.hovered
                PropertyChanges { target: input.border; color: Style.borderColor }
            }
        ]

        transitions: [
            Transition {
                to: ""
                ColorAnimation { property: "color" }
            },
            Transition {
                to: "hovered"
                ColorAnimation { property: "color" }
            }
        ]
    }
}

