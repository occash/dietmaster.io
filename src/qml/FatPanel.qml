import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Grid {
    id: fatPanel

    property real fatPercentage: group.current.percent

    columns: 3
    rows: 3
    columnSpacing: 2
    rowSpacing: 2

    ListModel {
        id: model

        ListElement {
            name: "1_1"
            value: 4.0
        }
        ListElement {
            name: "1_2"
            value: 7.0
        }
        ListElement {
            name: "1_3"
            value: 11.0
        }
        ListElement {
            name: "2_1"
            value: 15.0
        }
        ListElement {
            name: "2_2"
            value: 20.0
        }
        ListElement {
            name: "2_3"
            value: 25.0
        }
        ListElement {
            name: "3_1"
            value: 30.0
        }
        ListElement {
            name: "3_2"
            value: 35.0
        }
        ListElement {
            name: "3_3"
            value: 40.0
        }
    }

    Repeater {
        id: repeater
        model: model

        FatButton {
            id: fatButton
            image: name
            percent: value
            exclusiveGroup: group
            width: fatPanel.width / 3
        }
    }

    ExclusiveGroup {
        id: group
    }

    Component.onCompleted: group.current = repeater.itemAt(0)
}

