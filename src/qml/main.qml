import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Window 2.0

import "style"

ApplicationWindow {
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

    RegistrationForm {
        id: registrationForm
        anchors.fill: parent
    }

    MessageBox {
        id: message
        source: registrationForm

        Rectangle {
            //anchors.fill: parent
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

    Component.onCompleted: console.log(Qt.locale().uiLanguages)

    /*SplashScreen {
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
    }*/
}
