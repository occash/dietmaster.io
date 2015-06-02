import QtQuick 2.3
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0

import "style"
import "operation.js" as Operation

Item {
    id: registrationForm

    property var client: null
    property var user: null

    /*Provider {
        id: provider

        onSuccess: {
            console.log("Success")
            usernameField.text = username
            fullnameField.text = fullname
        }

        onError: {
            console.log("Error", message)
        }
    }*/

    function register() {
        var reply = client.create(user.create(), Operation.User)
        reply.finished.connect(function() {
            if (!reply.isError) {
                client.username = user.username
                client.password = user.password
                client.login()
            } else {
                /*registerError.visible = true
                registerError.text = reply.errorString*/
                console.log("Error", reply.errorString)
            }
        })
    }

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
            font.pixelSize: 5 * Screen.pixelDensity
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
            spacing: 3 * Screen.pixelDensity

            Repeater {
                model: 3

                DMRoundComponent {
                    id: dot

                    width: 3 * Screen.pixelDensity
                    height: 3 * Screen.pixelDensity

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
        ListElement { component: "ExtraForm.qml" }
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
            cacheBuffer: width * 2

            model: dataModel
            delegate: Item {
                height: pages.height
                width: pages.width

                Loader {
                    id: loader
                    anchors.fill: parent
                    anchors.margins: 2 * Screen.pixelDensity
                    source: component

                    Binding {
                        when: loader.status == Loader.Ready
                        target: loader.item
                        property: "client"
                        value: client
                    }

                    Binding {
                        when: loader.status == Loader.Ready
                        target: loader.item
                        property: "user"
                        value: user
                    }

                    Connections {
                        target: loader.item
                        ignoreUnknownSignals: true
                        onRegister: register()
                    }
                }
            }
        }
    }
}
