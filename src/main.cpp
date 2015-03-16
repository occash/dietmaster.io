#include <QApplication>
#include <QQmlApplicationEngine>
#include <QTranslator>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    app.setOrganizationName("Shalby");
    app.setOrganizationDomain("shalby.com");
    app.setApplicationName("DietMaster");

    QTranslator translator;
    if (translator.load(QLocale(), ":/i18n/dietmaster_"))
        app.installTranslator(&translator);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
