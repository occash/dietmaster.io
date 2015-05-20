import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.3

import "."

ProgressBarStyle {
    property bool dark: true
    property DMTheme palette: dark ? Style.dark : Style.light

    background: Rectangle {
        color: "transparent"
        border.width: 1
        border.color: palette.dark

        implicitWidth: 200
        implicitHeight: 24
    }

    progress: Rectangle {
        color: control.indeterminate ? "transparent" : palette.button

        // Indeterminate animation by animating alternating stripes:
        Item {
            anchors.fill: parent
            anchors.margins: 1
            visible: control.indeterminate
            clip: true
            Row {
                Repeater {
                    Rectangle {
                        color: index % 2 ? palette.button : "transparent"
                        width: 20
                        height: control.height
                    }
                    model: control.width / 20 + 2
                }
                XAnimator on x {
                    from: 0
                    to: -40
                    loops: Animation.Infinite
                    running: control.indeterminate
                }
            }
        }
    }
}

