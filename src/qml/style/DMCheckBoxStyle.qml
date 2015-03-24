import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.2

import "."

CheckBoxStyle {
    indicator: Rectangle {
        id: button

        implicitWidth: 4 * Screen.pixelDensity
        implicitHeight: 4 * Screen.pixelDensity

        color: Style.secondColor
        border.color: Style.secondColor

        Rectangle {
            visible: control.checked
            color: Style.textColor
            anchors.margins: 1 * Screen.pixelDensity
            anchors.fill: parent
        }

        states: [
            State {
                name: "active"
                when: control.hovered || control.pressed
                PropertyChanges { target: button.border; color: Style.pressedColor }
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

    label: Text {
        color: Style.textColor
        text: control.text
    }
}

