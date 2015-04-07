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
    incrementControl: Item {
        implicitWidth: padding.right
        Image {
            source: "qrc:/images/icons/arrow_up.png"
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
            source: "qrc:/images/icons/arrow_down.png"
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -2
            //opacity: control.enabled ? (styleData.downPressed ? 1 : 0.6) : 0.5
            width: 3 * Screen.pixelDensity
            fillMode: Image.PreserveAspectFit
        }
    }
}

