#ifndef JSONSTORAGE_H
#define JSONSTORAGE_H

#include <QObject>
#include <QString>
#include <QFile>
#include <QDebug>
#include <QStandardPaths>
#include <QCoreApplication>

#include <QJsonObject>
#include <QJsonDocument>

class JSONStorage : public QObject
{
    Q_OBJECT
    Q_ENUMS(DBType)
    Q_ENUMS(DBLevel)

public:
    enum DBType { Masterdata, Settings };
    enum DBLevel { Prod, Test };
    Q_INVOKABLE QString openDatabase(DBType dbType);
    Q_INVOKABLE void setDbLevel(DBLevel dbLevel);
    explicit JSONStorage(QObject *parent = 0);
    ~JSONStorage();

    Q_INVOKABLE QString readSetting(const QJsonObject &json, QString settingName);
    Q_INVOKABLE void writeSetting(QJsonObject &json, QString settingName, QString settingValue) const;
    Q_INVOKABLE bool loadSettings();
    Q_INVOKABLE bool saveSettings() const;

private:
    static const QString MASTERDBNAMETEST;
    static const QString MASTERDBNAMEPROD;
    static const QString SETTINGSDBNAME;

    QString buildFullPath(DBType dbType);

    DBLevel _dbLevel;
    QJsonDocument _settingsJson;
};

#endif // JSONSTORAGE_H
