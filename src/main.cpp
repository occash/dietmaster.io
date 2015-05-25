#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QQmlContext>
#include <QQmlEngine>
#include <QTranslator>

#include "enginiosearch.h"
#include "translator.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    app.setOrganizationName("Shalby");
    app.setOrganizationDomain("shalby.com");
    app.setApplicationName("DietMaster");

    QTranslator translator;
    if (translator.load(QLocale(), ":/dietmaster_"))
        app.installTranslator(&translator);

    qmlRegisterType<EnginioSearch>("DietMaster", 1, 0, "EnginioSearch");
    qmlRegisterType<Translator>("DietMaster", 1, 0, "Translator");
    qmlRegisterType<Country>("DietMaster", 1, 0, "Country");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
