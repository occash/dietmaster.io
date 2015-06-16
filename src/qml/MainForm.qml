import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

import "style"
import "js/severity.js" as Severity
import "js/operation.js" as Operation

Rectangle {
    id: mainForm
    color: Style.dark.base

    property var client: null
    property var user: null
    property var currentProduct

    onClientChanged:  {
        if (client) {
            updateInfo()
        }
     }

    function updateInfo() {
        var queryString = {
            "objectType": "users",
            "limit": 1,
            "query": {
                "username": client.username
            }
        }
        var reply = client.query(queryString, Operation.User)
        reply.finished.connect(function() {
            if (!reply.isError) {
                user.update(reply.data.results[0])
            }
        })
    }

    VCard {
        id: board

        user: mainForm.user
        height: 28 * Screen.pixelDensity

        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }
    }

    Component {
        id: homeForm

        HomeForm {}
    }

    Component {
        id: statsForm

        StatsForm {}
    }

    Component {
        id: toolsForm

        ToolsForm {}
    }

    Component {
        id: imageForm

        ImageForm {}
    }

    Loader {
        id: view

        anchors {
            left: parent.left
            top: board.bottom
            right: parent.right
            bottom: buttons.top
        }

        asynchronous: true
        sourceComponent: homeForm

        Binding {
            when: view.status === Loader.Ready
            target: view.item
            property: "client"
            value: mainForm.client
        }

        Binding {
            when: view.status === Loader.Ready
            target: view.item
            property: "user"
            value: mainForm.user
        }
    }

    Rectangle {
        id: buttons
        height: 8 * Screen.pixelDensity
        color: Style.light.button

        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right
        }

        ExclusiveGroup {
            id: group
        }

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Button {
                Layout.fillHeight: true
                Layout.fillWidth: true
                iconSource: "home.png"
                style: DMButtonStyle { dark: false }
                exclusiveGroup: group
                checkable: true
                checked: true
                onCheckedChanged: {
                    if (checked) {
                        view.sourceComponent = homeForm
                    }
                }
            }
            Button {
                Layout.fillHeight: true
                Layout.fillWidth: true
                iconSource: "stats.png"
                style: DMButtonStyle { dark: false }
                exclusiveGroup: group
                checkable: true
                onCheckedChanged: {
                    if (checked) {
                        view.sourceComponent = statsForm
                    }
                }
            }
            Button {
                Layout.fillHeight: true
                Layout.fillWidth: true
                iconSource: "tools.png"
                style: DMButtonStyle { dark: false }
                exclusiveGroup: group
                checkable: true
                onCheckedChanged: {
                    if (checked) {
                        view.sourceComponent = toolsForm
                    }
                }
            }
        }
    }
}

