#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QQmlContext>
#include <QQmlEngine>
#include <QTranslator>

#include "enginiosearch.h"


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    app.setOrganizationName("Shalby");
    app.setOrganizationDomain("shalby.com");
    app.setApplicationName("DietMaster");

    QTranslator translator;
    if (translator.load(QLocale(), ":/i18n/dietmaster_"))
        app.installTranslator(&translator);

    qmlRegisterType<EnginioSearch>("Search", 1, 0, "EnginioSearch");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
