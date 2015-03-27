#include "enginiosearch.h"

EnginioSearch::EnginioSearch(QObject *parent)
    : QObject(parent)
{
    m_client.setBackendId("550310bdc8e85c26e701e405");
}

EnginioReply *EnginioSearch::search(QString text)
{
    /*var q = {
        "objectTypes": [0, "objects.product"],
        "search": {
            "phrase": text + "*",
            "properties": ["objectType"]
        },
        "limit": 10
    }
    var reply = client.fullTextSearch(q)*/
    QJsonArray types;
    types.append("objects.product");

    QJsonObject search;
    search["phrase"] = text + "*";

    QJsonObject query;
    query["objectTypes"] = types;
    query["search"] = search;

    return m_client.fullTextSearch(query);
}
