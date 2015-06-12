#include "enginiosearch.h"

EnginioSearch::EnginioSearch(QObject *parent)
    : QObject(parent)
{
    m_client.setBackendId("550310bdc8e85c26e701e405");
}

EnginioReply *EnginioSearch::search(QString text)
{
    /* Request documentation
    {
        "objectTypes": ["objects.product"],
        "search": {
            "phrase": text + "*"
        },
        "iclude": {
            "group": {}
        }
    }
    */

    QJsonArray types;
    types.append("objects.product");

    QJsonObject search;
    search["phrase"] = text + "*";

    QJsonObject include;
    include["group"] = QJsonObject();

    QJsonObject query;
    query["objectTypes"] = types;
    query["search"] = search;
    query["include"] = include;

    return m_client.fullTextSearch(query);
}
