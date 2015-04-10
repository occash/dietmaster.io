pragma Singleton
import QtQuick 2.3

QtObject {
    property DMTheme dark: DMDarkTheme {}
    property DMTheme light: DMLightTheme {}

    readonly property color colorGood: "#4CAF50"
    readonly property color colorNormal: "#FF9800"
    readonly property color colorBad: "#F44336"
}

