import QtQuick 2.3
import QtQuick.Window 2.0

import "style"

Rectangle {
    width: 100
    height: 62

    color: Style.dark.base

    Chart {
        id: chart
        anchors.fill: parent

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

