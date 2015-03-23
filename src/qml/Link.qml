import QtQuick 2.3

import "style"

Text {
    id: link

    property string linkText: ""
    signal activated()

    text: "<a href=\"xdm\">" + linkText + "</a>"
    textFormat: Text.StyledText
    color: Style.textColor
    linkColor: Style.linkColor
    horizontalAlignment: Text.AlignHCenter

    onLinkActivated: {
        console.log("activated")
        activated()
    }
}
