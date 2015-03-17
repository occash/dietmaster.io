#include <QCoreApplication>
#include <Enginio>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QDebug>
#include <QFile>
#include <QTextStream>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    EnginioClient client;
    client.setBackendId("550310bdc8e85c26e701e405");

    QJsonArray types;
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
    });

    /*QFile file("W:/projects/DietTools/data.csv");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
       return 1;*/

    /*QSet<QString> groups;
    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList values = line.split(';');
        groups.insert(values.at(0));
    }

    foreach (QString group, groups) {
        QJsonObject object;
        object["objectType"] = "objects.group";
        object["name"] = group;
        EnginioReply *reply = client.create(object);
        QObject::connect(reply, &EnginioReply::finished, [](EnginioReply *reply) {
            if (reply->isError())
                qDebug() << "Ooops! Something went wrong!" << reply->data();
            else
                qDebug() << "The object was created" << reply->data();
            reply->deleteLater();
        });
    }*/

    /*QMap<QString, QString> groupMap;
    groupMap["Молочные продукты"] = "5507f9c2c8e85c1ab802a534";
    groupMap["Напитки"] = "5507f9c2c8e85c1ab802a531";
    groupMap["Прочее"] = "5507f9c2c8e85c1ab802a52e";
    groupMap["Зерновые продукты и изделия из муки"] = "5507f9c2c8e85c1ab802a52b";
    groupMap["Супы"] = "5507f9c2c8e85c1ab802a528";
    groupMap["Рыба и морепродукты"] = "5507f9c2c8e85c42e5048594";
    groupMap["Блюда"] = "5507f9c1c8e85c1ab802a525";
    groupMap["Жиры, масла и соусы"] = "5507f9c1c8e85c1ab802a51c";
    groupMap["Фрукты и ягоды"] = "5507f9c1c8e85c1ab802a51b";
    groupMap["Сладости"] = "5507f9c1c8e85c1ab802a517";
    groupMap["Мясные продукты"] = "5507f9c1c8e85c42e504858b";
    groupMap["Овощи"] = "5507f9c1c8e85c42e5048588";

    //Группа продуктов;Наименоване продукта;Гликемический индекс;Ккал;Белки;Жиры;Углеводы
    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList values = line.split(';');

        QJsonObject group;
        group["objectType"] = "objects.group";
        group["id"] = groupMap.value(values.at(0), "Прочее");

        QJsonObject object;
        object["objectType"] = "objects.product";
        object["name"] = values.at(1);
        object["group"] = group;
        object["gi"] =  values.at(2).toDouble();
        object["calories"] = values.at(3).toDouble();
        object["protein"] = values.at(4).toDouble();
        object["fat"] = values.at(5).toDouble();
        object["carbohydrate"] = values.at(6).toDouble();

        EnginioReply *reply = client.create(object);
        QObject::connect(reply, &EnginioReply::finished, [](EnginioReply *reply) {
            if (reply->isError())
                qDebug() << "Ooops! Something went wrong!" << reply->data();
            else
                qDebug() << "The object was created" << reply->data();
            reply->deleteLater();
        });
    }*/

    /*QJsonObject query;
    query["objectType"] = "objects.product";
    query["query"] = QJsonObject();

    EnginioModel model;
    model.setClient(&client);
    model.setQuery(query);

    qDebug() << "Model created";*/

    return a.exec();
}
