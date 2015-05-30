import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import DietMaster 1.0

import "style"

ApplicationWindow {
    id: window

    title: qsTr("DietMaster")
    visible: true
    width: 90 * Screen.pixelDensity
    height: 150 * Screen.pixelDensity

    /*Flickable {
        id: flickable
        anchors.fill: parent

        contentWidth: width
        contentHeight: vcard.height

        VCard {
            id:vcard

            width: parent.width
            height: 800
        }
    }*/

    Loader {
        id: remote
        asynchronous: true
        sourceComponent: RemoteAccess {}
    }

    UserInfo {
        id: userInfo
    }

    /*
    MessageBox {
        id: message
        source: registrationForm

        Rectangle {
            anchors.centerIn: parent
            width: 40 * Screen.pixelDensity
            height: 10 * Screen.pixelDensity
            color: Style.light.text
            opacity: 0.7

            Text {
                anchors.fill: parent
                text: "Error"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: Style.dark.text
                font.pointSize: 12
                renderType: Text.NativeRendering
            }
        }
    }
    */

    Translator {
        id: translator
    }

    MessageBox {
        id: message
        source: loader.item
        anchors.fill: parent
        z: 1

        Rectangle {
            anchors.fill: parent
            anchors.margins: 5 * Screen.pixelDensity
            color: Style.light.text
            opacity: 0.7

            ListView {
                id: list

                anchors.fill: parent
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                highlightFollowsCurrentItem: true
                highlightMoveDuration: 0

                currentIndex: translator.currentCountry
                model: translator.countries
                delegate: DMRow {
                    height: 24
                    width: parent.width
                    text: name

                    onClicked: list.currentIndex = index

                    DMRoundComponent {
                        anchors.fill: parent
                        anchors.margins: 1 * Screen.pixelDensity
                        Image {
                            anchors.fill: parent
                            source: "qrc:/flags/" + code + ".svg"
                        }
                    }
                }
                highlight: Rectangle {
                    color: Style.dark.highlight
                }
            }
        }
    }

    SplashScreen {
        anchors.fill: parent
        logo: "qrc:/logo.jpg"
        text: qsTr("DietMaster")
        //loading: client.state === Loader.Loading
        client: remote.item

        onRegister: loader.source = "RegistrationForm.qml"
    }

    Connections {
        target: remote.item
        onLoggedin: loader.source = "MainForm.qml"
    }

    Loader {
        id: loader
        anchors.fill: parent

        Binding {
            when: loader.status === Loader.Ready
            target: loader.item
            property: "client"
            value: remote.item
        }

        Binding {
            when: loader.status === Loader.Ready
            target: loader.item
            property: "user"
            value: userInfo
        }
    }
}
