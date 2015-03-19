import QtQuick 2.3
import QtQuick.Layouts 1.1

RowLayout {
    id: rowLayout

    property OptimalNutrient nutrient: null

    property alias calories: caloriesPanel.currentValue
    property alias protein: proteinPanel.currentValue
    property alias fat: fatPanel.currentValue
    property alias carbohydrate: carbohydratePanel.currentValue

    spacing: -1

    NutritionPanel {
        id: caloriesPanel

        Layout.fillWidth: true
        Layout.fillHeight: true

        title: qsTr("Calories")
        maxValue: nutrient.calories
        currentValue: 0
    }

    NutritionPanel {
        id: proteinPanel

        Layout.fillWidth: true
        Layout.fillHeight: true

        title: qsTr("Protein")
        maxValue: nutrient.protein
        currentValue: 0
    }

    NutritionPanel {
        id: fatPanel

        Layout.fillWidth: true
        Layout.fillHeight: true

        title: qsTr("Fat")
        maxValue: nutrient.fat
        currentValue: 0
    }

    NutritionPanel {
        id: carbohydratePanel

        Layout.fillWidth: true
        Layout.fillHeight: true

        title: qsTr("Carbohydrate")
        maxValue: nutrient.carbohydrate
        currentValue: 0
    }
}

