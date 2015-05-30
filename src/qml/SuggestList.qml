import QtQuick 2.0
import QtQuick.Window 2.0

import "style"

Rectangle {
    id: suggestBox
    color: Style.dark.alternateBase
    border.width: 1
    border.color: Style.dark.button
    height: (listView.count > 3 ? 15 : listView.count * 5) * Screen.pixelDensity

    property alias model: listView.model
    signal selected(var data)

    function select(index) {
        listView.currentIndex = index
        listView.visible = false
        selected(listView.currentItem.delegateData)
    }

    ListView {
        id: listView
        anchors.fill: parent
        clip: true
        focus: true

        delegate: Item {
            id: container

            height: 5 * Screen.pixelDensity
            width: parent.width

            property var delegateData: modelData

            Text {
                anchors.fill: parent
                anchors.leftMargin: 2
                text: modelData.name
                color: Style.dark.text
                verticalAlignment: Text.AlignVCenter
                renderType: Text.NativeRendering
            }

            MouseArea {
                anchors.fill: parent
                onClicked: select(index)
            }
        }
        highlight: Rectangle { color: Style.dark.highlight }
        highlightFollowsCurrentItem: true
    }
}

