import QtQuick 2.3

ListView {
    id: pages

    anchors.fill: parent
    orientation: Qt.Horizontal
    snapMode: ListView.SnapOneItem

    model: 3
    delegate: Text {
        width: pages.width
        height: pages.height
        text: "Lol" + index
    }
}
