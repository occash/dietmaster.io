TEMPLATE = app

QT += qml quick widgets enginio

SOURCES += *.cpp
HEADERS += *.h

TRANSLATIONS += \
    i18n/dietmaster_ru.ts

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    qml/*.qml \
    qml/*.js \
    qml/style/*.qml \
    qml/style/qmldir

