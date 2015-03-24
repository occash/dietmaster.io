import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.2

import "."

SpinBoxStyle {
    textColor: Style.textColor
    selectedTextColor: Style.textColor
    selectionColor: Style.selectionColor
    background: Rectangle {
        id: input

        implicitWidth: 20 * Screen.pixelDensity
        implicitHeight: 5 * Screen.pixelDensity

        color: Style.secondColor
        border.width: 1
        border.color: Style.secondColor

        states: [
            State {
                name: "active"
                when: control.hovered || control.activeFocus
                PropertyChanges { target: input.border; color: Style.borderColor }
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

