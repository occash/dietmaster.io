#ifndef ENGINIOSEARCH_H
#define ENGINIOSEARCH_H

#include <QObject>
#include <Enginio/Enginio>


class EnginioSearch : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl serviceUrl READ serviceUrl WRITE setServiceUrl NOTIFY serviceUrlChanged)
    Q_PROPERTY(EnginioIdentity *identity READ identity WRITE setIdentity NOTIFY identityChanged)

public:
    EnginioSearch(QObject *parent = 0);

    QUrl serviceUrl() const { return m_client.serviceUrl(); }
    void setServiceUrl(QUrl serviceUrl) {
        if (m_client.serviceUrl() != serviceUrl) {
            m_client.setServiceUrl(serviceUrl);
            emit serviceUrlChanged(serviceUrl);
        }
    }

    EnginioIdentity *identity() const { return m_client.identity(); }
    void setIdentity(EnginioIdentity *identity) {
        if (m_client.identity() != identity) {
            m_client.setIdentity(identity);
            emit identityChanged(identity);
        }
    }

public slots:
    EnginioReply *search(QString text);

signals:
    void serviceUrlChanged(QUrl serviceUrl);
    void identityChanged(EnginioIdentity *identity);

private:
    EnginioClient m_client;

};

#endif // ENGINIOSEARCH_H
