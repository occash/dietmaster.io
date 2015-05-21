#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QQmlContext>
#include <QQmlEngine>
#include <QTranslator>
#include <QLocale>
#include <QDebug>

#include "enginiosearch.h"


void checkLocale()
{
    for (int i = 1; i < 256; ++i)
    {
        QList<QLocale> locales = QLocale::matchingLocales(QLocale::AnyLanguage,
                                                          QLocale::AnyScript,
                                                          (QLocale::Country)i);

        if (!locales.isEmpty()) {
            qDebug() << "Country" << locales[0].nativeCountryName();
            foreach (QLocale locale, locales)
                qDebug() << "Language" << locale.nativeLanguageName();
        }
    }
}

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    checkLocale();

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
