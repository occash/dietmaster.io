import QtQuick 2.0

Rectangle {
    id: panel

    property real minValue
    property real maxValue
    property real currentValue

    property color goodColor: "#98df8a"
    property color badColor: "#ff9896"

    color: currentValue > maxValue ? badColor : goodColor

    Text {
        id: text
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: currentValue + "/" + maxValue
    }
}
