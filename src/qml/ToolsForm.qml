import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1

import "style"

Item {
    id: toolsForm
    clip: true

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
                model: ListModel {
                    ListElement {
                        title: "Gender"
                        value: "Male"
                    }

                    ListElement {
                        title: "Birthday"
                        value: "23.06.1989"
                    }
                }
            }

            VCardGroup {
                id: physicalInfo

                width: parent.width
                title: "Physical info"
                model: ListModel {
                    ListElement {
                        title: "Height"
                        value: "182"
                    }

                    ListElement {
                        title: "Weight"
                        value: "92"
                    }

                    ListElement {
                        title: "Activity"
                        value: "No activity"
                    }

                    ListElement {
                        title: "Diabetic"
                        value: "No"
                    }
                }
            }

            VCardGroup {
                id: extraInfo

                width: parent.width
                title: "Extra info"
                model: ListModel {
                    ListElement {
                        title: "Weist"
                        value: 105
                    }

                    ListElement {
                        title: "Neck"
                        value: 55
                    }

                    ListElement {
                        title: "Hip"
                        value: 24
                    }
                }
            }
        }
    }
}

