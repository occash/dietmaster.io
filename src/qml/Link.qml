import QtQuick 2.3

import "style"

Text {
    id: link

    property string linkText: ""
    signal activated()

    text: "<a href=\"xdm\">" + linkText + "</a>"
    textFormat: Text.StyledText
    color: Style.dark.text
    linkColor: Style.dark.highlight
    horizontalAlignment: Text.AlignHCenter

    onLinkActivated: activated()
}
