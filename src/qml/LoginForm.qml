import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import Enginio 1.0
import Qt.labs.settings 1.0

Rectangle {
    id: loginForm

    property bool autoLogin: false//autologinCheck.checked
    property EnginioClient client: null

    signal logedin()
    signal loggedout()
    signal register()

    Component.onCompleted: {
        if (autoLogin) {
            console.log("Autologin")
            loginButton.clicked()
        }
    }

    function login() {
        client.identity = user
    }

    Settings {
        id: config

        property alias username: usernameField.text
        property alias password: passwordField.text
        property alias autoLogin: autologinCheck.checked
    }

    EnginioOAuth2Authentication {
        id: user

        user: usernameField.text
        password: Qt.md5(passwordField.text)
    }

    Connections {
        id: clientConnection
        target: client

        onSessionAuthenticated: {
            console.log("Authenticated", JSON.stringify(reply.data))
            logedin()
        }

        onSessionAuthenticationError: {
            console.log("AuthenticationError", JSON.stringify(reply.data))
            client.identity = null
            errorLabel.text = reply.data.error_description
        }

        onSessionTerminated: {
            console.log("Session terminated")
            loggedout()
        }
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent

        Label {
            id: usernameLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Username")
        }

        TextField {
            id: usernameField

            Layout.fillWidth: true
            placeholderText: qsTr("Enter username")

            onAccepted: {
                if (passwordField.text.length > 0 && text.length > 0)
                    login()
            }

            Component.onCompleted: {
                if (text.length == 0)
                    forceActiveFocus()
            }
        }

        Label {
            id: passwordLabel

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Password")
        }

        TextField {
            id: passwordField

            Layout.fillWidth: true
            placeholderText: qsTr("Enter password")
            echoMode: TextInput.Password

            onAccepted: {
                if (usernameField.text.length > 0 && text.length > 0)
                    login()
            }

            Component.onCompleted: {
                if (text.length == 0 && !usernameField.activeFocus)
                    forceActiveFocus()
            }
        }

        CheckBox {
            id: autologinCheck
            Layout.fillWidth: true
            text: qsTr("Auto login")
        }

        Button {
            id: loginButton

            Layout.fillWidth: true

            isDefault: true
            enabled: client.authenticationState == Enginio.Authenticating ? false : true
            text: client.authenticationState == Enginio.Authenticating ? qsTr("Logging in") : qsTr("Login")

            onClicked: login()
        }

        Text {
            id: registerText

            Layout.fillWidth: true

            text: "<a href=\"register\">Register</a>"
            textFormat: Text.RichText
            color: "blue"
            horizontalAlignment: Text.AlignHCenter

            onLinkActivated: {
                register()
            }
        }

        Label {
            id: errorLabel
            visible: client.authenticationState == Enginio.AuthenticationFailure
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            color: "#ff9896"
        }

        Item {
            id: spacer
            Layout.fillHeight: true
        }
    }
}

