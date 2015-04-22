import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2

import "style"

Window {
    id: window

    default property alias contents: placeholder.children

    flags: Qt.FramelessWindowHint |
           Qt.WindowMinimizeButtonHint |
           Qt.Window

    color: Style.dark.base

    DMSizeGrip {
        id: sizeGrip
        anchors.fill: parent
        target: window

        Rectangle {
            id: clientArea
            anchors.fill: parent

            border.color: Style.dark.highlight
            border.width: window.visibility == Window.Maximized ||
                          window.visibility == Window.FullScreen ? 0 : 1
            color: Style.dark.base

            Rectangle {
                id: titleBar

                height: 8 * Screen.pixelDensity
                anchors {
                    left: parent.left
                    top: parent.top
                    right: parent.right
                }
                anchors.margins: 1

                color: Style.dark.base

                Image {
                    id: titleIcon
                    anchors {
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                    }
                    anchors.margins: 1 * Screen.pixelDensity
                    source: "qrc:/images/logo.jpg"
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    id: titleText
                    anchors {
                        left: titleIcon.right
                        top: parent.top
                        right: titleButtons.left
                        bottom: parent.bottom
                    }

                    color: Style.dark.text
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    text: window.title
                    renderType: Text.NativeRendering
                    font.pointSize: 10

                    MouseArea {
                        id: titleDrag
                        anchors.fill: parent

                        property bool dragging: false
                        property point clickPos: Qt.point(0, 0)

                        onPressed: {
                            if (window.visibility == Window.Windowed) {
                                dragging = true
                                clickPos = Qt.point(mouse.x, mouse.y)
                            }
                        }

                        onReleased: {
                            dragging = false
                        }

                        onPositionChanged: {
                            if (dragging) {
                                var deltaX = mouse.x - clickPos.x
                                var deltaY = mouse.y - clickPos.y
                                window.x += deltaX
                                window.y += deltaY
                            }
                        }

                        onDoubleClicked: {
                            if (window.visibility == Window.Maximized)
                                window.visibility = Window.Windowed
                            else
                                window.visibility = Window.Maximized
                        }
                    }
                }

                Row {
                    id: titleButtons
                    anchors {
                        right: parent.right
                        top: parent.top
                        bottom: parent.bottom
                    }

                    Component {
                        id: titleStyle

                        ButtonStyle {
                            background: Rectangle {
                                color: control.pressed ?
                                           Style.dark.highlight : control.hovered ?
                                               Style.dark.button : Style.dark.base
                            }
                        }
                    }

                    Button {
                        id: minimizeButton
                        width: 7 * Screen.pixelDensity
                        height: parent.height
                        style: titleStyle
                        onClicked: window.showMinimized()
                    }

                    Button {
                        id: maximizeButton
                        width: 7 * Screen.pixelDensity
                        height: parent.height
                        style: titleStyle
                        onClicked: window.showMaximized()
                    }

                    Button {
                        id: closeButton
                        width: 7 * Screen.pixelDensity
                        height: parent.height
                        style: titleStyle
                        onClicked: window.close()
                    }
                }
            }

            Item {
                id: placeholder
                anchors {
                    left: parent.left
                    top: titleBar.bottom
                    right: parent.right
                    bottom: parent.bottom
                }
                anchors.margins: 1
            }
        }
    }
}
