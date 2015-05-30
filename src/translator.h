#ifndef TRANSLATOR_H
#define TRANSLATOR_H

#include <QObject>
#include <QQmlListProperty>

class Country : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(QString code READ code NOTIFY codeChanged)

public:
    Country() {}
    Country(QString name, QString code);

    QString name() const;
    QString code() const;

signals:
    void nameChanged();
    void codeChanged();

private:
    QString m_name;
    QString m_code;

};

class Translator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<Country> countries READ countries NOTIFY countriesChanged)
    Q_PROPERTY(int currentCountry READ currentCountry WRITE setCurrentCountry NOTIFY currentCountryChanged)

public:
    Translator(QObject *parent = 0);
    ~Translator();

    QQmlListProperty<Country> countries() const;
    int currentCountry() const;
    void setCurrentCountry(int arg);

signals:
    void countriesChanged();
    void currentCountryChanged(int arg);

private:
    QList<Country *> m_countries;
    int m_currentCountry;

};

#endif // TRANSLATOR_H
