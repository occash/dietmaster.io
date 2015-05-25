#include "translator.h"

#include <QLocale>
#include <QDebug>

/*void checkLocale()
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
}*/

Translator::Translator(QObject *parent) :
    QObject(parent)
{
    int systemCountry = QLocale().country();
    for (int i = 1; i < 256; ++i)
    {
        QList<QLocale> locales = QLocale::matchingLocales(QLocale::AnyLanguage,
                                                          QLocale::AnyScript,
                                                          (QLocale::Country)i);
        if (!locales.isEmpty()) {
            QLocale locale = locales[0];
            QString name = locale.nativeCountryName();
            QString code = locale.name().right(2).toLower();
            m_countries.append(new Country(name, code));
        }

        if (systemCountry == i) {
            m_currentCountry = m_countries.size() - 1;
        }
    }
}

Translator::~Translator()
{
}

QQmlListProperty<Country> Translator::countries() const
{
    return { (QObject *)this, (QList<Country *>&)m_countries };
}

int Translator::currentCountry() const
{
    return m_currentCountry;
}

void Translator::setCurrentCountry(int arg)
{
    if (m_currentCountry == arg)
        return;

    m_currentCountry = arg;
    emit currentCountryChanged(arg);
}


Country::Country(QString name, QString code) :
    m_name(name),
    m_code(code)
{
}

QString Country::name() const
{
    return m_name;
}

QString Country::code() const
{
    return m_code;
}
