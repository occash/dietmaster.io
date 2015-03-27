import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls 1.2

import "style"

StackView {
    id: pages
    initialItem: loginForm

    RemoteAccess {
        id: remoteAccess

        onLoggedin: {
            var queryString = {
                "objectType": "objects.userinfo",
                "query": {}
            }
            var reply = query(queryString)
            reply.finished.connect(function() {
                if (!reply.isError) {
                    if (reply.data.results.length > 0)
                        pages.push(mainForm)
                    else
                        pages.push(infoForm)
                }
            })
        }
    }

    LoginForm {
        id: loginForm

        //LoginForm {
            client: remoteAccess
            onRegister: pages.push(userForm)
        //}
    }

    Component {
        id: userForm

        UserForm {
            client: remoteAccess
        }
    }

    Component {
        id: infoForm

        InfoForm {
            client: remoteAccess
            onNext: pages.push(mainForm)
        }
    }

    Component {
        id: mainForm

        MainForm {
            client: remoteAccess
        }
    }
}

