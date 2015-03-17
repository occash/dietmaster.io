import QtQuick 2.2
import QtQuick.Controls 1.1

ApplicationWindow {
    id: window

    visible: true
    width: 250
    height: 480

    color: "white"
    title: qsTr("DietMaster")

    Item {
        id: central
        anchors.fill: parent

        SplashScreen {
            id: splash
            anchors.fill: parent
            logo: "qrc:/images/logo.jpg"
            text: qsTr("DietMaster")
        }

        Loader {
            id: loader
            anchors.fill: parent
            source: "CentralWindow.qml"
            asynchronous: true
            opacity: 0
        }

        states: State {
            name: "loaded";
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
                duration: 800
            }
        }
    }
}
