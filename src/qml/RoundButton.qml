import QtQuick 2.3
import QtQuick.Window 2.0

DMRoundComponent {
    id: button

    width: 10 * Screen.pixelDensity
    height: 10 * Screen.pixelDensity

    signal clicked()

    overlay: [
        MouseArea {
            anchors.fill: parent
            onClicked: button.clicked()
        }
    ]
}
