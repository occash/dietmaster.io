import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

import "style"
import "xregexp.js" as XRegExp
import "severity.js" as Severity
import "operation.js" as Operation
import "providers.js" as Providers

Rectangle {
    id: userForm
    color: "transparent"

    property RemoteAccess client: null

    function validateUsername(username) {
        var allowedChars = /^[-\w\._]+$/

        if (username.length === 0)
            return 1
        else if (username.length < 3)
            return 2
        else if (username.length > 15)
            return 3
        else if (!allowedChars.test(username))
            return 4

        return 0
    }

    function usernameError(error) {
        switch (error)
        {
        case 1: return qsTr("Username is empty")
        case 2: return qsTr("The username is too short")
        case 3: return qsTr("The username is too long")
        case 4: return qsTr("The username contains illegal characters")
        default: return ""
        }
    }

    function scorePassword(password) {
        var score = 0
        if (!password)
            return score

        // award every unique letter until 5 repetitions
        var letters = new Object()
        for (var i = 0; i < password.length; i++) {
            letters[password[i]] = (letters[password[i]] || 0) + 1
            score += 5.0 / letters[password[i]]
        }

        // bonus points for mixing it up
        var variations = {
            digits: /\d/.test(password),
            lower: /[a-z]/.test(password),
            upper: /[A-Z]/.test(password),
            nonWords: /\W/.test(password),
        }

        var variationCount = 0;
        for (var check in variations) {
            variationCount += (variations[check] == true) ? 1 : 0
        }
        score += (variationCount - 1) * 10

        return parseInt(score)
    }

    function passwordStrength(password) {
        var score = scorePassword(password)

        if (score > 80)
            return qsTr("Strong password")
        if (score > 60)
            return qsTr("Fair password")
        if (score >= 30)
            return qsTr("Weak password")

        return qsTr("Password is too short")
    }

    function validateEmail(email) {
        var re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(email);
    }

    function validateName(name) {
        var re = new XRegExp.XRegExp("^\\p{L}*$")
        return name.length > 0 && re.test(name)
    }

    Provider {
        id: provider

        onSuccess: {
            console.log("Success")
            usernameField.text = username
            fullnameField.text = fullname
        }

        onError: {
            console.log("Error", message)
        }
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6 * Screen.pixelDensity

            RoundButton {
                width: 12 * Screen.pixelDensity
                height: 12 * Screen.pixelDensity

                borderWidth: 1

                Image {
                    anchors.fill: parent
                    source: "qrc:/flags/ru.svg"
                    smooth: false
                }

                onClicked: message.show()
            }

            HorizontalSpacer {}

            RoundButton {
                width: 12 * Screen.pixelDensity
                height: 12 * Screen.pixelDensity

                borderWidth: 1

                Rectangle {
                    anchors.fill: parent
                    color: Style.light.button

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        renderType: Text.NativeRendering
                        color: Style.dark.text
                        text: "RU" //Qt.locale().nativeLanguageName
                        font.pixelSize: 6 * Screen.pixelDensity
                    }
                }
            }
        }

        InputField {
            id: emailField
            Layout.fillWidth: true
            //title: qsTr("E-mail")
            placeholder: qsTr("E-mail")
            dark: false
            isDefault: true

            function check() {
                valid = true //validateEmail(text)
                severity = valid ? Severity.Good : Severity.Bad
                errorString = qsTr("Invalid e-mail")
                return valid
            }

            function checkFull() {
                provider.request(Providers.Twitter, text)

                var queryString = { "query": { "email": text } }
                var reply = client.query(queryString, Operation.User)
                reply.finished.connect(function() {
                    valid = reply.data.results.length === 0
                    severity = valid ? Severity.Good : Severity.Bad
                    errorString = qsTr("E-mail is already in use")
                    if (valid)
                        provider.request(Providers.Twitter, text)
                })
                return valid
            }

            onValidate: check()
            onValidateFull: checkFull()
        }

        InputField {
            id: usernameField
            Layout.fillWidth: true
            //title: qsTr("Username")
            placeholder: qsTr("Username")
            dark: false

            function check() {
                var res = validateUsername(text)
                valid = res === 0
                severity = valid ? Severity.Good : Severity.Bad
                errorString = usernameError(res)
                return valid
            }

            function checkFull() {
                var queryString = { "query": { "username": text } }
                var reply = client.query(queryString, Operation.User)
                reply.finished.connect(function() {
                    valid = reply.data.results.length === 0
                    severity = valid ? Severity.Good : Severity.Bad
                    errorString = qsTr("Username already exists")
                })
                return valid
            }

            onValidate: check()
            onValidateFull: checkFull()
        }

        InputField {
            id: passwordField
            Layout.fillWidth: true
            //title: qsTr("Password")
            placeholder: qsTr("Password")
            echo: TextInput.Password
            dark: false

            function check() {
                var res = validateUsername(text)
                valid = false
                severity = scorePassword(text) > 60 ? Severity.Good :
                           (scorePassword(text) < 30 ? Severity.Bad : Severity.Normal)
                errorString = passwordStrength(text)
                return scorePassword(text) >= 30
            }

            onValidate: check()
        }

        InputField {
            id: fullnameField
            Layout.fillWidth: true
            //title: qsTr("First name")
            placeholder: qsTr("Full name")
            dark: false

            function check() {
                valid = validateName(text)
                severity = valid ? Severity.Good : Severity.Bad
                errorString = qsTr("Invalid name")
                return valid
            }

            onValidate: check()
        }

        /*InputField {
            id: lastnameField
            Layout.fillWidth: true
            //title: qsTr("Last name")
            placeholder: qsTr("Last name")
            dark: false

            function check() {
                valid = validateName(text)
                severity = valid ? Severity.Good : Severity.Bad
                errorString = qsTr("Invalid last name")
                return valid
            }

            onValidate: check()
        }*/

        /*Button {
            id: nextButton

            Layout.fillWidth: true

            isDefault: true
            text: enabled ? qsTr("Next") : qsTr("Registering")
            style: DMButtonStyle { dark: false }

            onClicked: {
                registerError.visible = true

                var res = true
                res &= usernameField.check() && usernameField.checkFull()
                res &= passwordField.check()
                res &= emailField.check() && emailField.checkFull()
                res &= firstnameField.check()
                res &= lastnameField.check()

                if (res) {
                    var query = {
                        "username": usernameField.text,
                        "password": passwordField.text,
                        "email": emailField.text,
                        "firstName": firstnameField.text,
                        "lastName": lastnameField.text
                    }

                    nextButton.enabled = false

                    var reply = client.create(query, Operation.User)
                    reply.finished.connect(function() {
                        if (!reply.isError) {
                            client.username = usernameField.text
                            client.password = passwordField.text
                            client.autoLogin = true
                            client.login()
                        } else {
                            registerError.visible = true
                            registerError.text = reply.errorString
                        }

                        nextButton.enabled = true
                    })
                }
            }
        }

        Label {
            id: registerError
            Layout.fillHeight: true
            visible: false
            color: "red"
            wrapMode: Text.WordWrap
        }*/

        Item {
            id: spacer
            Layout.fillHeight: true
        }
    }
}

