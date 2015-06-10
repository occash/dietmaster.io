import QtQuick 2.3
import QtQuick.Window 2.0
import Qt.labs.folderlistmodel 2.1

import "style"

Item {
    id: imageForm

    clip: true

    FolderListModel {
        id: folderModel

        folder: "file://" + ImagePath
        rootFolder: "file://" + ImagePath
        showDirs: false
        nameFilters: [ "*.png", "*.jpg", "*.jpeg", "*.gif" ]
    }

    GridView {
        id: grid

        cacheBuffer: 0
        anchors.fill: parent
        anchors.margins: 2 * Screen.pixelDensity

        cellWidth: width / 3
        cellHeight: width / 3

        model: folderModel
        delegate: Item {
            width: grid.cellWidth
            height: grid.cellHeight

            Rectangle {
                anchors.fill: parent
                anchors.margins: 1 * Screen.pixelDensity
                color: Style.dark.alternateBase

                Image {
                    anchors.fill: parent
                    //cache: false
                    smooth: true
                    asynchronous: true
                    fillMode: Image.PreserveAspectCrop
                    source: fileURL
                    sourceSize.width: parent.width
                    sourceSize.height: parent.height
                }
            }
        }
    }
}

