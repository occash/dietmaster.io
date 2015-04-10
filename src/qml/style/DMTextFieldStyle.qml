import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.2

import "."

TextFieldStyle {
    property bool dark: true
    property DMTheme palette: dark ? Style.dark : Style.light

    textColor: palette.text
    selectedTextColor: palette.text
    placeholderTextColor: palette.mid
    selectionColor: palette.highlight
    background: Rectangle {
        id: input

        implicitWidth: 20 * Screen.pixelDensity
        implicitHeight: 6 * Screen.pixelDensity

        color: palette.alternateBase
        border.width: 1
        border.color: palette.dark

        states: [
            State {
                name: "active"
                when: control.hovered || control.activeFocus
                PropertyChanges { target: input.border; color: palette.highlight }
            }
        ]

        transitions: [
            Transition {
                to: ""
                ColorAnimation { property: "color" }
            },
            Transition {
                to: "active"
                ColorAnimation { property: "color" }
            }
        ]
    }
}

