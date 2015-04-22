import QtQuick 2.3
import QtQuick.Window 2.0

MouseArea {
    id: sizeGrip

    property Window target: null
    property int delta: 5

    //private
    property bool resizing: false
    property int resizeWidth: 0
    property int resizeHeight: 0
    property point clickPos: Qt.point(0, 0)

    hoverEnabled: true
    propagateComposedEvents: true

    cursorShape: {
        if (mouseX < delta || mouseX > width - delta)
            if ((mouseX < delta && mouseY < delta) ||
                    (mouseX > width - delta &&
                     mouseY > height - delta))
                return Qt.SizeFDiagCursor
            else if ((mouseX < delta && mouseY > width - delta) ||
                     (mouseX > width - delta && mouseY < delta))
                return Qt.SizeBDiagCursor
            else
                return Qt.SizeHorCursor
        else if (mouseY < delta || mouseY > height - delta)
            return Qt.SizeVerCursor

        return Qt.ArrowCursor
    }

    onPressed: {
        if (mouse.x < delta || mouse.x > width - delta) {
            resizing = true
            resizeWidth = width / 2 - mouse.x
        }
        if (mouse.y < delta || mouse.y > height - delta) {
            resizing = true
            resizeHeight = height / 2 - mouse.y
        }

        if (resizing)
            clickPos = Qt.point(mouse.x, mouse.y)
        else
            mouse.accepted = false
    }

    onReleased: {
        resizing = false
        resizeWidth = 0
        resizeHeight = 0
    }

    onPositionChanged: {
        if (resizing) {
            var deltaX = mouse.x - clickPos.x
            var deltaY = mouse.y - clickPos.y

            if (resizeWidth > 0) {
                target.x += deltaX
                target.width -= deltaX
            } else if (resizeWidth < 0) {
                target.width = mouse.x
            }

            if (resizeHeight > 0) {
                target.y += deltaY
                target.height -= deltaY
            } else if (resizeHeight < 0)
                target.height = mouse.y
        }

        mouse.accepted = false
    }
}

