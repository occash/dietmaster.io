#ifndef ENGINIOSEARCH_H
#define ENGINIOSEARCH_H

#include <QObject>
#include <Enginio/Enginio>


class EnginioSearch : public QObject
{
    Q_OBJECT
    Q_PROPERTY(EnginioIdentity *identity READ identity WRITE setIdentity)

public:
    EnginioSearch(QObject *parent = 0);

    EnginioIdentity *identity() const { return m_client.identity(); }
    void setIdentity(EnginioIdentity *identity) { m_client.setIdentity(identity); }

public slots:
    EnginioReply *search(QString text);

private:
    EnginioClient m_client;

};

#endif // ENGINIOSEARCH_H
