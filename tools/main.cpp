#include <QCoreApplication>
#include <Enginio>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QDebug>
#include <QFile>
#include <QTextStream>
#include <QEventLoop>


int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    EnginioClient client;
    client.setBackendId("550310bdc8e85c26e701e405");

    /*QJsonArray types;
    types.append("objects.product");

    QJsonObject search;
    search["phrase"] = "М*";

    QJsonObject query;
    query["objectTypes"] = types;
    query["search"] = search;
    query["limit"] = 1;

    EnginioReply *reply = client.fullTextSearch(query);
    QObject::connect(reply, &EnginioReply::finished, [](EnginioReply *reply) {
        if (reply->isError())
            qDebug() << "Ooops! Something went wrong!" << reply->data();
        else
            qDebug() << "The object was created" << reply->data();
        reply->deleteLater();
    });*/

    QFile file("D:/projects/DietMaster/tools/data.csv");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
       return 1;

    QMap<QString, QString> groups;
    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList values = line.split(';');
        QString name = values.at(0);
        name = name.simplified();
        name[0] = name[0].toUpper();
        groups.insert(name, "");
    }

    for (QString group : groups.keys()) {
        qDebug() << group;
        QJsonObject object;
        object["objectType"] = "objects.group";
        object["name"] = group;
        EnginioReply *reply = client.create(object);

        QEventLoop loop;
        QObject::connect(reply, SIGNAL(finished(EnginioReply *)), &loop, SLOT(quit()));
        loop.exec();

        if (reply->isError())
            qDebug() << "Ooops! Something went wrong!" << reply->data();
        else
        {
            QJsonObject data = reply->data();
            QJsonDocument doc(data);
            qDebug() << doc.toJson();
            QString id = data["id"].toString();
            qDebug() << "Group was created" << group << id;
            groups.insert(group, id);
        }
        reply->deleteLater();

        /*QObject::connect(reply, &EnginioReply::finished, [&](EnginioReply *reply) {
            
        });*/
    }

    //Группа продуктов;Наименоване продукта;Гликемический индекс;Ккал;Белки;Жиры;Углеводы
    in.seek(0);
    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList values = line.split(';');

        QString name = values.at(0);
        name = name.simplified();
        name[0] = name[0].toUpper();

        QString groupId = groups.value(name, "");
        qDebug() << "Test" << groupId;

        QJsonObject group;
        group["objectType"] = "objects.group";
        group["id"] = groups.value(name, "");

        qDebug() << group["id"];

        QJsonObject object;
        object["objectType"] = "objects.product";
        object["name"] = values.at(1).simplified();
        object["group"] = group;
        object["gi"] = 0;//values.at(2).toDouble();
        object["calories"] = values.at(5).toDouble();
        object["protein"] = values.at(2).toDouble();
        object["fat"] = values.at(3).toDouble();
        object["carbohydrate"] = values.at(4).toDouble();

        EnginioReply *reply = client.create(object);
        QObject::connect(reply, &EnginioReply::finished, [](EnginioReply *reply) {
            if (reply->isError())
                qDebug() << "Ooops! Something went wrong!" << reply->data();
            else
                qDebug() << "The object was created" << reply->data();
            reply->deleteLater();
        });
    }

    return a.exec();
}
