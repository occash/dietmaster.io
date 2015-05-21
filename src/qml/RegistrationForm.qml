import QtQuick 2.3
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0

import "style"

Item {
    id: registrationForm

    Rectangle {
        id: header
        color: Style.light.button
        height: 10 * Screen.pixelDensity

        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }

        Text {
            anchors.fill: parent
            text: qsTr("Registration")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: Style.dark.text
            font.pointSize: 14
            renderType: Text.NativeRendering
        }
    }

    Rectangle {
        id: pageIndicator
        color: Style.light.button
        height: 4 * Screen.pixelDensity

        anchors {
            left: parent.left
            top: header.bottom
            right: parent.right
        }

        Row {
            anchors.centerIn: parent
            spacing: 2 * Screen.pixelDensity

            Repeater {
                model: 3

                DMRoundComponent {
                    id: dot

                    width: 2 * Screen.pixelDensity
                    height: 2 * Screen.pixelDensity

                    Rectangle {
                        anchors.fill: parent
                        color: pages.currentIndex === index ?
                                   Style.light.highlight : Style.dark.text
                    }
                }
            }
        }
    }

    ListModel {
        id: dataModel

        ListElement { component: "UserForm.qml" }
        ListElement { component: "InfoForm.qml" }
        ListElement { component: "UserForm.qml" }
    }

    Rectangle {
        id: background
        anchors {
            left: parent.left
            top: pageIndicator.bottom
            right: parent.right
            bottom: parent.bottom
        }

        ListView {
            id: pages
            anchors.fill: parent

            highlightRangeMode: ListView.StrictlyEnforceRange
            highlightFollowsCurrentItem: true
            highlightMoveDuration: 400

            orientation: Qt.Horizontal
            snapMode: ListView.SnapOneItem
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            model: dataModel
            delegate: Item {
                height: pages.height
                width: pages.width

                Loader {
                    anchors.fill: parent
                    anchors.margins: 2 * Screen.pixelDensity
                    source: component
                }
            }
        }
    }
}
