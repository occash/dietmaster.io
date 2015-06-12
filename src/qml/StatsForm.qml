import QtQuick 2.3
import QtQuick.Window 2.0

import "style"
import "js/facts.js" as Facts

Item {
    id: statsForm
    clip: true

    property var client: null
    property var user: null

    ListModel { id: infoModel }

    onUserChanged: {
        if (!user)
            return

        infoModel.append({
            "title": qsTr("Body Mass Index"),
            "value": Facts.bmi(user).toFixed()
        })
        infoModel.append({
            "title": qsTr("Body Fat Percentage"),
            "value": Facts.bfp(user).toFixed() + "%"
        })
        infoModel.append({
            "title": qsTr("Basal Metabolic Rate"),
            "value": Facts.bmr(user).toFixed()
        })
    }

    Flickable {
        id: flickable

        anchors.fill: parent
        anchors.margins: 2 * Screen.pixelDensity

        contentWidth: width
        contentHeight: flickable.height + 1

        VCardGroup {
            id: info
            model: infoModel
            title: "Parameters"

            anchors{
                top: parent.top
                left: parent.left
                right: parent.right
            }
        }

        Item {
            id: chartContainer

            anchors{
                top: info.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            Chart {
                id: chart

                anchors.fill: parent
                anchors.margins: 2 * Screen.pixelDensity

                animation: false
                chartAnimationEasing: Easing.InOutElastic
                chartAnimationDuration: 2000

                chartType: "Pie"
                chartOptions: {
                    "segmentStrokeWidth": 1,
                    "segmentStrokeColor": Style.dark.alternateBase,
                    "tooltipFontSize": 4 * Screen.pixelDensity
                }
                chartData: [
                    {
                        value: 300,
                        color:"#1f77b4",
                        highlight: "#aec7e8",
                        label: "Protein"
                    },
                    {
                        value: 50,
                        color: "#ff7f0e",
                        highlight: "#ffbb78",
                        label: "Fat"
                    },
                    {
                        value: 100,
                        color: "#2ca02c",
                        highlight: "#98df8a",
                        label: "Carbs"
                    },
                    {
                        value: 40,
                        color: "#d62728",
                        highlight: "#ff9896",
                        label: "Alcohol"
                    }
                ]
            }
        }
    }
}

