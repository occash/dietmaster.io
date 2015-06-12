import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import DietMaster 1.0

import "style"

ApplicationWindow {
    id: window

    title: qsTr("DietMaster")
    visible: true
    width: 69 * Screen.pixelDensity
    height: 122 * Screen.pixelDensity
    contentOrientation: Qt.PortraitOrientation

    Loader {
        id: remote
        asynchronous: true
        sourceComponent: RemoteAccess {}
    }

    UserInfo {
        id: userInfo
    }

    Connections {
        target: remote.item
        onLoggedin: loader.source = "MainForm.qml"
        onLoggedout: loader.source = "SplashScreen.qml"
    }

    Connections {
        target: loader.item
        ignoreUnknownSignals: true
        onRegister: loader.source = "register/RegistrationForm.qml"
    }

    Loader {
        id: loader
        anchors.fill: parent
        source: "SplashScreen.qml"
        asynchronous: true

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
