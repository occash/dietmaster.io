import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Rectangle {
    id: fatButton

    width: 50
    height: 50

    implicitWidth: fatImage.implicitWidth
    implicitHeight: fatImage.implicitHeight

    property string image: ""
    property real percent: 0.0
    property bool checked: false
    property ExclusiveGroup exclusiveGroup: null

    onExclusiveGroupChanged: {
        if (exclusiveGroup)
            exclusiveGroup.bindCheckable(fatButton)
    }

    border.width: 1
    border.color: (checked || mouseArea.containsMouse) ? "#2ca02c" : "transparent"

    Image {
        id: fatImage
        anchors.fill: parent
        anchors.margins: 1
        source: "qrc:/images/male/" + image + ".png"
        fillMode: Image.PreserveAspectFit
        smooth: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: fatButton.checked = true
        hoverEnabled: true
    }
}
