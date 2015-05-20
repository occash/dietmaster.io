import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2

import "style"

Rectangle {
    id: splash
    color: "white"

    property alias client: loginForm.client

    property bool loading: true
    property bool login: false

    property alias logo: logo.source
    property alias text: text.text

    states: [
        State {
            name: "login"
            when: !loading
            PropertyChanges { target: indicator; opacity: 0 }
            PropertyChanges { target: loginForm; opacity: 1 }
        }

    ]

    transitions: [
        Transition {
            to: "login"

            SequentialAnimation {
                NumberAnimation {
                    target: indicator
                    property: "opacity"
                    duration: 400
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: loginForm
                    property: "opacity"
                    duration: 400
                    easing.type: Easing.InQuart
                }
            }
        }
    ]

    Image {
        id: logo
        anchors.left: parent.left
        anchors.right: parent.right
        y: (parent.height - loginForm.height - text.height) / 2 - height / 2
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

        color: Style.dark.base
        font.pointSize: 20
        horizontalAlignment: Text.AlignHCenter
    }

    ProgressBar {
        id: indicator
        anchors.centerIn: loginForm
        indeterminate: true
        style: DMProgressBarStyle { dark: false }
    }

    LoginForm {
        id: loginForm
        opacity: 0
        height: 100

        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right

            leftMargin: 2 * Screen.pixelDensity
            bottomMargin: 5 * Screen.pixelDensity
            rightMargin: 2 * Screen.pixelDensity
        }
    }
}

