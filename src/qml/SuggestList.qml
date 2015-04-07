import QtQuick 2.0
import QtQuick.Window 2.0

import "style"

ListView {
    id: listView
    height: (count > 3 ? 15 : count * 5) * Screen.pixelDensity
    clip: true
    focus: true

    signal selected(var data)

    function select(index) {
        listView.currentIndex = index
        listView.visible = false
        selected(listView.currentItem.delegateData)
    }

    delegate: Item {
        id: container

        height: 5 * Screen.pixelDensity
        width: parent.width

        property var delegateData: modelData

        Text {
            anchors.fill: parent
            anchors.leftMargin: 2
            text: modelData.name
            color: Style.textColor
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: select(index)
        }
    }
    highlight: Rectangle { color: Style.selectionColor }
    highlightFollowsCurrentItem: true
}

