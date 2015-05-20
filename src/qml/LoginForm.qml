import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

import "style"

Rectangle {
    id: loginForm
    color: Style.light.base

    property RemoteAccess client: null

    signal register()

    function login() {
        if (usernameField.text.length > 0
                && passwordField.text.length > 0) {
            client.username = usernameField.text
            client.password = passwordField.text
            //client.autoLogin = autologinCheck.checked
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
            dark: false
            placeholder: qsTr("Username")
            isDefault: true
            text: client !== null ? client.username : ""

            onAccept: login()
        }

        InputField {
            id: passwordField
            Layout.fillWidth: true
            dark: false
            placeholder: qsTr("Password")
            echo: TextInput.Password
            text: client ? client.password: ""

            onAccept: login()
        }

        /*CheckBox {
            id: autologinCheck
            Layout.fillWidth: true
            text: qsTr("Auto login")
            checked: client.autoLogin

            style: DMCheckBoxStyle {}
        }*/

        Button {
            id: loginButton

            Layout.fillWidth: true

            isDefault: true
            enabled: client && !client.busy
            text: (client && client.busy) ? qsTr("Logging in") : qsTr("Login")

            onClicked: login()

            style: DMButtonStyle { dark: false }
        }

        Link {
            id: registerText
            Layout.fillWidth: true
            linkText: qsTr("Register")

            onActivated: register()
        }

        Label {
            id: errorLabel
            visible: client && client.failed
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            color: Style.colorBad
        }

        VerticalSpacer {}
    }
}

