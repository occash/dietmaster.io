TEMPLATE = app

QT += qml quick widgets

SOURCES += main.cpp

TRANSLATIONS += \
    i18n/dietmaster_ru.ts

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    qml/*.qml \
    qml/*.js

