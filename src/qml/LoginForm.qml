import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

import "style"

Rectangle {
    id: loginForm
    color: Style.dark.base

    property RemoteAccess client: null

    signal register()

    function login() {
        if (usernameField.text.length > 0
                && passwordField.text.length > 0) {
            client.username = usernameField.text
            client.password = passwordField.text
            client.autoLogin = autologinCheck.checked
            client.login()
        }
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent

        VerticalSpacer {}

        InputField {
            id: usernameField
            Layout.fillWidth: true
            title: qsTr("Username")
            placeholder: qsTr("Enter username")
            isDefault: true
            text: client.username

            onAccept: login()
        }

        InputField {
            id: passwordField
            Layout.fillWidth: true
            title: qsTr("Password")
            placeholder: qsTr("Enter password")
            echo: TextInput.Password
            text: client.password

            onAccept: login()
        }

        CheckBox {
            id: autologinCheck
            Layout.fillWidth: true
            text: qsTr("Auto login")
            checked: client.autoLogin

            style: DMCheckBoxStyle {}
        }

        Button {
            id: loginButton

            Layout.fillWidth: true

            isDefault: true
            enabled: client.busy ? false : true
            text: client.busy ? qsTr("Logging in") : qsTr("Login")

            onClicked: login()

            style: DMButtonStyle {}
        }

        Link {
            id: registerText
            Layout.fillWidth: true
            linkText: qsTr("Register")

            onActivated: register()
        }

        Label {
            id: errorLabel
            visible: client.failed
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            color: Style.colorBad
        }

        VerticalSpacer {}
    }
}

