import QtQuick 2.2
import QtQuick.Window 2.0

import "style"

DMWindow {
    id: window

    title: qsTr("DietMaster")
    visible: true
    width: 100 * Screen.pixelDensity
    height: 150 * Screen.pixelDensity

    Item {
        id: central
        anchors.fill: parent

        SplashScreen {
            id: splash
            anchors.fill: parent
            logo: "qrc:/images/logo.jpg"
            text: qsTr("DietMaster")
        }

        /*Loader {
            id: loader
            anchors.fill: parent
            anchors.margins: 1 * Screen.pixelDensity
            source: "CentralWindow.qml"
            asynchronous: true
            opacity: 0
        }

        states: State {
            name: "loaded"
            when: loader.status == Loader.Ready
        }

        transitions: Transition {
            to: "loaded"

            PropertyAnimation {
                target: splash
                properties: "opacity"
                to: 0
                duration: 800
            }

            PropertyAnimation {
                target: loader
                properties: "opacity"
                to: 1
                duration: 400
            }
        }*/
    }
}
