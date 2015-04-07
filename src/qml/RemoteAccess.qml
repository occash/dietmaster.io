import QtQuick 2.3
import Enginio 1.0
import Qt.labs.settings 1.0
import Search 1.0 //Qt bug #45050 workaround

import "utils.js" as Utils
import "operation.js" as Operation

Item {
    id: remoteAccess

    property alias username: config.username
    property alias password: config.password
    property alias autoLogin: config.autoLogin

    property bool busy: client.authenticationState == Enginio.Authenticating
    property bool failed: client.authenticationState == Enginio.AuthenticationFailure

    signal loggedin()
    signal loggedout()
    signal authError(string error)
    signal error(string error)

    function login() {
        client.identity = identity
        //searchClient.identity = identity
    }

    function logout() {
        client.identity = null
        //searchClient.identity = null
    }

    function query(data, operation) {
        operation = operation || Operation.Object
        return client.query(data, operation)
    }

    function create(data, operation) {
        operation = operation || Operation.Object
        return client.create(data, operation)
    }

    function search(text) {
        return searchClient.search(text)
    }

    Component.onCompleted: {
        if (config.autoLogin
                && config.username.length > 0
                && config.password.length > 0)
            login()
    }

    Settings {
        id: config

        property string username: ""
        property string password: ""
        property bool autoLogin: true
    }

    EnginioOAuth2Authentication {
        id: identity

        user: config.username
        password: config.password
    }

    EnginioClient {
        id: client

        backendId: "550310bdc8e85c26e701e405"

        onSessionAuthenticated: {
            searchClient.identity = identity
            loggedin()
        }
        onSessionTerminated: {
            searchClient.identity = null
            loggedout()
        }

        onSessionAuthenticationError: {
            client.identity = null
            var description = Utils.capitalizeFirst(reply.data.error_description)
            authError(description)
        }

        onError: {
            var description = Utils.capitalizeFirst(reply.data.error_description)
            error(description)
        }

        //Uncomment to enable debug output
        onFinished: console.log("Request finished. " + JSON.stringify(reply.data))

    }

    EnginioSearch {
        id: searchClient
    }
}

