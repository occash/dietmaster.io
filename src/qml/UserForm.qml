import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import Enginio 1.0
import Qt.labs.settings 1.0

import "xregexp.js" as XRegExp
import "enums.js" as Severity

Rectangle {
    id: userForm

    property EnginioClient client: null

    signal next()

    function validateUsername(username) {
        var illegalChars = /\W/;

        if (username.length === 0)
            return 1
        else if (username.length < 3)
            return 2
        else if (username.length > 15)
            return 3
        else if (illegalChars.test(username))
            return 4

        return 0;
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

    Settings {
        id: config

        property string username
        property string password
        property bool autoLogin
    }

    EnginioOAuth2Authentication {
        id: user

        user: usernameField.text
        password: Qt.md5(passwordField.text)
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent

        InputField {
            id: usernameField
            Layout.fillWidth: true
            title: qsTr("Username")
            placeholder: qsTr("Enter username")

            function check() {
                var res = validateUsername(text)
                valid = res === 0
                severity = valid ? Severity.Good : Severity.Bad
                errorString = usernameError(res)
                return valid
            }

            function checkFull() {
                var queryString = { "query": { "username": text } }
                var reply = client.query(queryString, Enginio.UserOperation)
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
            title: qsTr("Password")
            placeholder: qsTr("Enter password")
            echo: TextInput.Password

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
            id: emailField
            Layout.fillWidth: true
            title: qsTr("E-mail")
            placeholder: qsTr("Enter e-mail")

            function check() {
                valid = validateEmail(text)
                severity = valid ? Severity.Good : Severity.Bad
                errorString = qsTr("Invalid e-mail")
                return valid
            }

            function checkFull() {
                var queryString = { "query": { "email": text } }
                var reply = client.query(queryString, Enginio.UserOperation)
                reply.finished.connect(function() {
                    valid = reply.data.results.length === 0
                    severity = valid ? Severity.Good : Severity.Bad
                    errorString = qsTr("E-mail is already in use")
                })
                return valid
            }

            onValidate: check()
            onValidateFull: checkFull()
        }

        InputField {
            id: firstnameField
            Layout.fillWidth: true
            title: qsTr("First name")
            placeholder: qsTr("Enter first name")

            function check() {
                valid = validateName(text)
                severity = valid ? Severity.Good : Severity.Bad
                errorString = qsTr("Invalid first name")
                return valid
            }

            onValidate: check()
        }

        InputField {
            id: lastnameField
            Layout.fillWidth: true
            title: qsTr("Last name")
            placeholder: qsTr("Enter last name")

            function check() {
                valid = validateName(text)
                severity = valid ? Severity.Good : Severity.Bad
                errorString = qsTr("Invalid last name")
                return valid
            }

            onValidate: check()
        }

        Button {
            id: nextButton

            Layout.fillWidth: true

            isDefault: true
            text: qsTr("Next")

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
                        "password": Qt.md5(passwordField.text),
                        "email": emailField.text,
                        "firstName": firstnameField.text,
                        "lastName": lastnameField.text
                    }

                    var reply = client.create(query, Enginio.UserOperation)
                    reply.finished.connect(function() {
                        if (!reply.isError) {
                            config.username = usernameField.text
                            config.password = passwordField.text
                            config.autoLogin = true
                            client.identity = user
                            next()
                        } else {
                            registerError.visible = true
                            registerError.text = reply.errorString
                        }
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
        }

        Item {
            id: spacer
            Layout.fillHeight: true
        }
    }
}

