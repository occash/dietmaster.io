import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.2

import "."

SpinBoxStyle {
    property bool dark: true
    property DMTheme palette: dark ? Style.dark : Style.light

    textColor: palette.text
    selectedTextColor: palette.text
    selectionColor: palette.highlight
    background: Rectangle {
        id: input

        implicitWidth: 20 * Screen.pixelDensity
        implicitHeight: 5 * Screen.pixelDensity

        color: palette.alternateBase
        border.width: 1
        border.color: palette.alternateBase

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
    incrementControl: Item {
        implicitWidth: padding.right
        Image {
            source: "qrc:/icons/arrow_up.png"
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 1
            //opacity: control.enabled ? (styleData.upPressed ? 1 : 0.6) : 0.5
            width: 3 * Screen.pixelDensity
            fillMode: Image.PreserveAspectFit
        }
    }
    decrementControl: Item {
        implicitWidth: padding.right
        Image {
            source: "qrc:/icons/arrow_down.png"
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -2
            //opacity: control.enabled ? (styleData.downPressed ? 1 : 0.6) : 0.5
            width: 3 * Screen.pixelDensity
            fillMode: Image.PreserveAspectFit
        }
    }
}

