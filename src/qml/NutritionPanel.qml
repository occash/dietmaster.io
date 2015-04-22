import QtQuick 2.0

import "style"

Rectangle {
    id: panel

    property string title: ""

    property real minValue
    property real maxValue
    property real currentValue

    property color goodColor: "#98df8a"
    property color badColor: "#ff9896"

    color: currentValue > maxValue ? badColor : goodColor
    border.color: Style.dark.alternateBase

    Text {
        id: value
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }
        height: parent.height / 2
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: title
        elide: Text.ElideRight
        color: Style.dark.alternateBase
        font.weight: Font.DemiBold
    }

    Text {
        id: nutrition
        anchors {
            left: parent.left
            bottom: parent.bottom
            right: parent.right
        }
        height: parent.height / 2
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: (maxValue - currentValue).toFixed(1)
        color: Style.dark.alternateBase
        font.weight: Font.DemiBold
    }
}
