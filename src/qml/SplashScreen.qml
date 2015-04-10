import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2

import "style"

Rectangle {
    id: splash
    color: "white"

    property bool loading: true
    property bool login: false

    property alias logo: logo.source
    property alias text: text.text

    states: [
        State {
            name: "login"
            //PropertyChanges { target: logo; y: 10 * Screen.pixelDensity }
            PropertyChanges { target: indicator; opacity: 0 }
            PropertyChanges { target: loginForm; opacity: 1 }
        }

    ]

    transitions: [
        Transition {
            to: "login"

            SequentialAnimation {
                NumberAnimation { target: indicator; property: "opacity"; easing.type: Easing.InQuad }
                //NumberAnimation { target: logo; property: "y" }
                NumberAnimation { target: loginForm; property: "opacity"; easing.type: Easing.OutQuad }
            }
        }
    ]

    Timer {
        interval: 1000
        running: true
        onTriggered: state = "login"

    }

    Image {
        id: logo
        anchors.left: parent.left
        anchors.right: parent.right
        y: (parent.height - loginForm.height) / 2 - height / 2
        asynchronous: true
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: text

        anchors {
            top: logo.bottom
            left: parent.left
            right: parent.right
        }

        opacity: 0
        color: Style.dark.base
        font.pointSize: 20
        horizontalAlignment: Text.AlignHCenter
    }

    BusyIndicator {
        id: indicator

        anchors {
            left: parent.left
            top: text.bottom
            right: parent.right
        }
    }

    Column {
        id: loginForm
        spacing: 6
        opacity: 0

        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right

            leftMargin: 2 * Screen.pixelDensity
            bottomMargin: 5 * Screen.pixelDensity
            rightMargin: 2 * Screen.pixelDensity
        }

        InputField {
            id: usernameField

            width: parent.width
            dark: false

            placeholder: qsTr("Enter username")
            isDefault: true
            //text: client.username

            //onAccept: login()
        }

        InputField {
            id: passwordField

            width: parent.width
            dark: false

            placeholder: qsTr("Enter password")
            echo: TextInput.Password
            //text: client.password

            //onAccept: login()
        }

        Button {
            id: loginButton

            width: parent.width
            isDefault: true
            //enabled: client.busy ? false : true
            text: qsTr("Login")
            //text: client.busy ? qsTr("Logging in") : qsTr("Login")

            //onClicked: login()

            style: DMButtonStyle { dark: false }
        }

        Link {
            id: registerText
            width: parent.width
            linkText: qsTr("Register")
            //onActivated: register()
        }
    }
}

