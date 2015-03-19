import QtQuick 2.0

ListView {
    id: listView
    height: count > 3 ? 60 : count * 20
    clip: true
    focus: true

    delegate: Item {
        id: container

        height: 20
        width: 250

        Text {
            anchors.fill: parent
            text: modelData.name
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                container.ListView.view.currentIndex = index
            }
        }
    }
    highlight: Rectangle { color: "lightsteelblue" }
    highlightFollowsCurrentItem: true
}

