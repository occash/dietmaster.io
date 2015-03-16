import QtQuick 2.3

Text {
    id: link

    property string linkText: ""
    signal activated()

    text: "<a href=\"xdm\">" + linkText + "</a>"
    textFormat: Text.RichText
    color: "blue"
    horizontalAlignment: Text.AlignHCenter

    onLinkActivated: activated()
}
