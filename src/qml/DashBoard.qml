import QtQuick 2.3
import QtQuick.Layouts 1.1

Row {
    id: rowLayout

    property OptimalNutrient nutrient: null

    property alias calories: caloriesPanel.currentValue
    property alias protein: proteinPanel.currentValue
    property alias fat: fatPanel.currentValue
    property alias carbohydrate: carbohydratePanel.currentValue

    spacing: -1

    NutritionPanel {
        id: caloriesPanel

        width: parent.width / 4
        height: parent.height

        title: qsTr("Calories")
        maxValue: nutrient.calories
        currentValue: 0
    }

    NutritionPanel {
        id: proteinPanel

        width: parent.width / 4
        height: parent.height

        title: qsTr("Protein")
        maxValue: nutrient.protein
        currentValue: 0
    }

    NutritionPanel {
        id: fatPanel

        width: parent.width / 4
        height: parent.height

        title: qsTr("Fat")
        maxValue: nutrient.fat
        currentValue: 0
    }

    NutritionPanel {
        id: carbohydratePanel

        width: parent.width / 4
        height: parent.height

        title: qsTr("Carbohydrate")
        maxValue: nutrient.carbohydrate
        currentValue: 0
    }
}

