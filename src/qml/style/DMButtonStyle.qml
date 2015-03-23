import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.3

import "."

ButtonStyle {
    background: Rectangle {
        id: button

        implicitWidth: 20 * Screen.pixelDensity
        implicitHeight: 5 * Screen.pixelDensity

        color: {
            if (!control.enabled)
                return Style.mainColor

            return control.pressed ? Style.pressedColor : Style.secondColor
        }

        states: [
            State {
                name: "hovered"
                when: control.hovered
                PropertyChanges { target: button; color: Style.pressedColor }
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

    label: Text {
        text: control.text
        clip: true
        wrapMode: Text.WordWrap
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.fill: parent
        color: Style.textColor
        font.weight: Font.DemiBold
    }
}
