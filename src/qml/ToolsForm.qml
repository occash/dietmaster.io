import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1

import "style"
import "js/facts.js" as Facts

Item {
    id: toolsForm
    clip: true

    property var user: null

    ListModel { id: basicModel; dynamicRoles: true }
    ListModel { id: physicalModel; dynamicRoles: true }
    ListModel { id: extraModel; dynamicRoles: true }

    onUserChanged: {
        if (!user)
            return

        basicModel.clear()
        basicModel.append({
            "title": qsTr("Gender"),
            "value": user.gender ? qsTr("Male") : qsTr("Female")
        })
        basicModel.append({
            "title": qsTr("Birthday"),
            "value": user.birthdate.toLocaleDateString()
        })

        physicalModel.clear()
        physicalModel.append({
            "title": qsTr("Height"),
            "value": user.height
        })
        physicalModel.append({
            "title": qsTr("Weight"),
            "value": user.weight
        })
        physicalModel.append({
            "title": qsTr("Activity"),
            "value": Facts.activityString(user.lifestyle)
        })
        physicalModel.append({
            "title": qsTr("Diabetic"),
            "value": user.diabetic ? qsTr("Yes") : qsTr("No")
        })

        extraModel.clear()
        extraModel.append({
            "title": qsTr("Waist"),
            "value": user.abdomen
        })
        extraModel.append({
            "title": qsTr("Neck"),
            "value": user.neck
        })
        if (!user.gender)
            extraModel.append({
                "title": qsTr("Hip"),
                "value": user.hip
            })
    }

    Flickable {
        id: flickable

        anchors.fill: parent
        anchors.margins: 2 * Screen.pixelDensity

        contentWidth: width
        contentHeight: infoPanel.height

        Column {
            id: infoPanel

            width: parent.width
            //height: parent.height + 1
            spacing: 1 * Screen.pixelDensity

            VCardGroup {
                id: basicInfo

                width: parent.width
                title: "Basic info"
                model: basicModel
            }

            VCardGroup {
                id: physicalInfo

                width: parent.width
                title: "Physical info"
                model: physicalModel
            }

            VCardGroup {
                id: extraInfo

                width: parent.width
                title: "Extra info"
                model: extraModel
            }
        }
    }
}

