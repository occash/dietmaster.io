import QtQuick 2.0
import QtQuick.Window 2.0

import "style"

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
            anchors.leftMargin: 2
            text: modelData.name
            color: Style.textColor
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                container.ListView.view.currentIndex = index
                container.ListView.view.visible = false
            }
        }
    }
    highlight: Rectangle { color: Style.selectionColor }
    highlightFollowsCurrentItem: true
}

