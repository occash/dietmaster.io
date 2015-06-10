#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QQmlContext>
#include <QQmlEngine>
#include <QTranslator>
#include <QStandardPaths>

#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#endif

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

    QString imagePath;

#ifdef Q_OS_ANDROID
    QAndroidJniObject dcim = QAndroidJniObject::getStaticObjectField(
                    "android/os/Environment",
                    "DIRECTORY_DCIM",
                    "Ljava/lang/String;"
                    );
    QAndroidJniObject dcimDir = QAndroidJniObject::callStaticObjectMethod(
                    "android/os/Environment",
                    "getExternalStoragePublicDirectory",
                    "(Ljava/lang/String;)Ljava/io/File;",
                    dcim.object<jstring>()
                    );
    imagePath = dcimDir.toString() + "/Camera";
#else
    QStringList imagePaths = QStandardPaths::standardLocations(QStandardPaths::PicturesLocation);
    imagePath = imagePaths[0];
#endif

    qDebug() << imagePath;

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("ImagePath", imagePath);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
