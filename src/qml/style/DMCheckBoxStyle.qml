import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.2

import "."

CheckBoxStyle {
    property bool dark: true
    property DMTheme palette: dark ? Style.dark : Style.light

    indicator: Rectangle {
        id: button

        implicitWidth: 4 * Screen.pixelDensity
        implicitHeight: 4 * Screen.pixelDensity

        color: palette.alternateBase
        border.color: palette.dark

        Rectangle {
            visible: control.checked
            color: palette.text
            anchors.margins: 1 * Screen.pixelDensity
            anchors.fill: parent
        }

        states: [
            State {
                name: "active"
                when: control.hovered || control.pressed
                PropertyChanges { target: button.border; color: palette.highlight }
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
        color: palette.text
        text: control.text
        renderType: Text.NativeRendering
    }
}

