import QtQuick 2.0
import QtQuick.Window 2.0

ListView {
    id: listView
    height: (count > 3 ? 15 : count * 5) * Screen.pixelDensity
    clip: true
    focus: true

    delegate: Item {
        id: container

        height: 5 * Screen.pixelDensity
        width: parent.width

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

