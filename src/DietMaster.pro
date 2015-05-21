TEMPLATE = app

QT += qml quick widgets enginio xml svg
QTPLUGIN += qsvg

SOURCES += *.cpp
HEADERS += *.h

TRANSLATIONS += \
    i18n/dietmaster_ru.ts

RESOURCES += \
	i18n.qrc \
	images.qrc \
	qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    qml/*.qml \
    qml/*.js \
    qml/style/*.qml \
    qml/style/qmldir

