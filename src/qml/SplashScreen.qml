import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2

import "style"

Rectangle {
    id: splash

    property alias client: loginForm.client

    property alias logo: logo.source
    property alias text: text.text

    signal register()

    Item {
        id: logoContainer

        anchors {
            left: parent.left
            bottom: loginForm.top
            right: parent.right
            top: parent.top
        }

        Image {
            id: logo

            anchors.centerIn: parent
            width: parent.width - text.height
            height: parent.width - text.height

            asynchronous: true
            fillMode: Image.PreserveAspectFit
            source: "logo.jpg"
        }

        Text {
            id: text

            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }

            text: qsTr("DietMaster")
            color: Style.dark.base
            font.pixelSize: 6 * Screen.pixelDensity
            horizontalAlignment: Text.AlignHCenter
        }
    }

    LoginForm {
        id: loginForm
        height: 32 * Screen.pixelDensity

        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right

            leftMargin: 2 * Screen.pixelDensity
            bottomMargin: 5 * Screen.pixelDensity
            rightMargin: 2 * Screen.pixelDensity
        }

        onRegister: splash.register()
    }
}

