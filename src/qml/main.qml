import QtQuick 2.2
import QtQuick.Window 2.0

import "style"

DMWindow {
    id: window

    title: qsTr("DietMaster")
    visible: true
    width: 90 * Screen.pixelDensity
    height: 150 * Screen.pixelDensity

    Loader {
        id: client
        asynchronous: true
        sourceComponent: RemoteAccess {}
    }

    SplashScreen {
        anchors.fill: parent
        logo: "qrc:/images/logo.jpg"
        text: qsTr("DietMaster")
        loading: client.state === Loader.Loading
        client: client.item
    }

    Item {
        id: central
        anchors.fill: parent

        property string sourceComponent: ""

        function loadComponent(component) {
            fadeIn.stop()
            fadeOut.start()
            sourceComponent = component
        }

        Loader {
            id: loader
            anchors.fill: parent
            onLoaded: {
                fadeOut.stop()
                fadeIn.start()
            }

            Connections {
                target: client.item
                onLoggedin: central.loadComponent("MainForm.qml")
            }
        }

        NumberAnimation on opacity {
            id: fadeOut
            to: 0.0
            running: false
            onStopped: {
                loader.source = central.sourceComponent
            }
        }

        NumberAnimation on opacity {
            id: fadeIn
            to: 1.0
            running: false
        }
    }
}
