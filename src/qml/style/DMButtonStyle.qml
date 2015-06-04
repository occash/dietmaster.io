import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.3

import "."

ButtonStyle {
    property bool dark: true
    property DMTheme palette: dark ? Style.dark : Style.light

    background: Rectangle {
        id: button

        implicitWidth: 20 * Screen.pixelDensity
        implicitHeight: 5 * Screen.pixelDensity

        color: palette.button

        states: [
            State {
                name: "active"
                when: control.pressed
                PropertyChanges { target: button; color: palette.highlight }
            },
            State {
                name: "checked"
                when: control.checked
                PropertyChanges { target: button; color: palette.dark }
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
            },
            Transition {
                to: "checked"
                ColorAnimation { property: "color" }
            }
        ]
    }

    label: Loader {
        anchors.fill: parent
        sourceComponent: (control.text === "") ? iconLabel : textLabel

        Component {
            id: textLabel

            Text {
                text: control.text
                clip: true
                wrapMode: Text.WordWrap
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: palette.buttonText
                font.weight: Font.DemiBold
                renderType: Text.NativeRendering
            }
        }

        Component {
            id: iconLabel

            Image {
                clip: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                source: control.iconSource
                smooth: true
                fillMode: Image.PreserveAspectFit
            }
        }
    }
}
