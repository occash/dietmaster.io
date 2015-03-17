import QtQuick 2.3
import QtQuick.Controls 1.2
import Enginio 1.0

Item {
    id: centralWindow

    EnginioClient {
        id: enginio

        backendId: "550310bdc8e85c26e701e405"
        onFinished: console.log("Engino request finished. " + JSON.stringify(reply.data))
        onError: console.log("Enginio error " + reply.errorCode + ": " + JSON.stringify(reply.data))
    }

    StackView {
        id: pages
        initialItem: loginForm

        Component {
            id: loginForm

            LoginForm {
                //id: loginForm
                client: enginio

                onRegister: pages.push(userForm)
                onLogedin: {
                    var queryString = {
                        "objectType": "objects.userinfo",
                        "query": {}
                    }
                    var reply = client.query(queryString)
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
        }

        Component {
            id: userForm

            UserForm {
                //id: userForm
                client: enginio

                //onNext: pages.push(infoForm)
            }
        }

        Component {
            id: infoForm

            InfoForm {
                //id: infoForm
                client: enginio

                onNext: {
                    pages.clear()
                    pages.push(loginForm)
                    pages.push(mainForm)
                }
            }
        }

        Component {
            id: mainForm

            MainForm {
                //id: mainForm
                client: enginio
            }
        }
    }
}

