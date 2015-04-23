import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.2

import "style"

Window {
    id: window

    default property alias contents: placeholder.children

    property bool dark: true
    property DMTheme palette: dark ? Style.dark : Style.light

    flags: Qt.FramelessWindowHint |
           Qt.WindowMinimizeButtonHint |
           Qt.Window

    color: palette.base

    function toggleMaximized() {
        if (window.visibility == Window.Maximized)
            window.visibility = Window.Windowed
        else
            window.visibility = Window.Maximized
    }

    DMSizeGrip {
        id: sizeGrip
        anchors.fill: parent
        target: window

        Rectangle {
            id: clientArea
            anchors.fill: parent

            border.color: window.active ? palette.highlight : palette.button
            border.width: window.visibility == Window.Maximized ||
                          window.visibility == Window.FullScreen ? 0 : 1
            color: palette.base

            Rectangle {
                id: titleBar

                height: 7 * Screen.pixelDensity
                anchors {
                    left: parent.left
                    top: parent.top
                    right: parent.right
                }
                anchors.margins: window.visibility == Window.Maximized ||
                                 window.visibility == Window.FullScreen ? 0 : 1

                color: palette.base

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

                    color: palette.text
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    text: window.title
                    //renderType: Text.NativeRendering
                    font.pointSize: 10
                    font.weight: Font.DemiBold

                    MouseArea {
                        id: titleDrag
                        anchors.fill: parent

                        property bool dragging: false
                        property point clickPos: Qt.point(0, 0)

                        onPressed: {
                            dragging = true
                            clickPos = Qt.point(mouse.x, mouse.y)
                        }

                        onReleased: {
                            dragging = false
                        }

                        onPositionChanged: {
                            if (dragging) {
                                if (window.visibility == Window.Maximized) {
                                    var globalX = window.x + mouse.x
                                    var globalY = window.y + mouse.y

                                    window.toggleMaximized()

                                    window.x = globalX - window.width / 2
                                    window.y = globalY - titleBar.height / 2

                                    clickPos.x = window.width / 2
                                    clickPos.y = titleBar.height / 2

                                    return
                                }

                                var deltaX = mouse.x - clickPos.x
                                var deltaY = mouse.y - clickPos.y
                                window.x += deltaX
                                window.y += deltaY
                            }
                        }

                        onDoubleClicked: window.toggleMaximized()
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
                            label: Item {
                                Image {
                                    anchors.centerIn: parent
                                    source: control.iconSource
                                    smooth: false
                                }
                            }
                        }
                    }

                    Button {
                        id: minimizeButton
                        width: 8 * Screen.pixelDensity
                        height: parent.height
                        iconSource: "qrc:/images/window/minimize.png"
                        style: titleStyle
                        onClicked: window.showMinimized()
                    }

                    Button {
                        id: maximizeButton
                        width: 8 * Screen.pixelDensity
                        height: parent.height
                        iconSource: window.visibility == Window.Windowed ?
                                        "qrc:/images/window/maximize.png" :
                                        "qrc:/images/window/restore.png"
                        style: titleStyle
                        onClicked: window.toggleMaximized()
                    }

                    Button {
                        id: closeButton
                        width: 8 * Screen.pixelDensity
                        height: parent.height
                        iconSource: "qrc:/images/window/close.png"
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
