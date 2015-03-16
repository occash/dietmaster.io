import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

GridLayout {
    id: fatPanel

    property real fatPercentage: group.current.percent

    columns: 3
    rows: 3
    columnSpacing: 2
    rowSpacing: 2

    ExclusiveGroup {
        id: group
    }

    FatButton {
        id: fat1_1
        image: "1_1"
        percent: 4.0

        exclusiveGroup: group

        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    FatButton {
        id: fat1_2
        image: "1_2"
        percent: 7.0

        exclusiveGroup: group

        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    FatButton {
        id: fat1_3
        image: "1_3"
        percent: 11.0

        exclusiveGroup: group
        checked: true

        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    FatButton {
        id: fat2_1
        image: "2_1"
        percent: 15.0

        exclusiveGroup: group

        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    FatButton {
        id: fat2_2
        image: "2_2"
        percent: 20.0

        exclusiveGroup: group

        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    FatButton {
        id: fat2_3
        image: "2_3"
        percent: 25.0

        exclusiveGroup: group

        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    FatButton {
        id: fat3_1
        image: "3_1"
        percent: 30.0

        exclusiveGroup: group

        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    FatButton {
        id: fat3_2
        image: "3_2"
        percent: 35.0

        exclusiveGroup: group

        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    FatButton {
        id: fat3_3
        image: "3_3"
        percent: 40.0

        exclusiveGroup: group

        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}

