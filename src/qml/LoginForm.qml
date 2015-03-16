import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import Enginio 1.0
import Qt.labs.settings 1.0

import "utils.js" as Utils

Rectangle {
    id: loginForm

    property bool autoLogin: false//autologinCheck.checked
    property EnginioClient client: null

    signal logedin()
    signal loggedout()
    signal register()

    Component.onCompleted: {
        if (autoLogin)
            loginButton.clicked()
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
        password: passwordField.text
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
            errorLabel.text = Utils.capitalizeFirst(reply.data.error_description)
        }

        onSessionTerminated: {
            console.log("Session terminated")
            loggedout()
        }
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent

        InputField {
            id: usernameField
            Layout.fillWidth: true
            title: qsTr("Username")
            placeholder: qsTr("Enter username")
            isDefault: true

            onAccept: {
                if (passwordField.text.length > 0 && text.length > 0)
                    login()
            }
        }

        InputField {
            id: passwordField
            Layout.fillWidth: true
            title: qsTr("Password")
            placeholder: qsTr("Enter password")
            echo: TextInput.Password

            onAccept: {
                if (usernameField.text.length > 0 && text.length > 0)
                    login()
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

        Link {
            id: registerText
            Layout.fillWidth: true
            linkText: qsTr("Register")

            onActivated: register()
        }

        Label {
            id: errorLabel
            visible: client.authenticationState == Enginio.AuthenticationFailure
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            color: "red"
        }

        VerticalSpacer {}
    }
}

