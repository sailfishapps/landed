#include "jsonstorage.h"

JSONStorage::JSONStorage(QObject *parent) :
    QObject(parent)
{

}

JSONStorage::~JSONStorage()
{
}

const QString JSONStorage::DBNAME = "landeddb.json";

QString JSONStorage::openDatabase() {

    QString cargo;
    QFile file;
    QString docPath = QStandardPaths::locate(QStandardPaths::DocumentsLocation, QString(), QStandardPaths::LocateDirectory);
    qDebug() << "Document Path: " << docPath;
    QString appName = QCoreApplication::applicationName();
    qDebug() << "App Name: " << appName;
    QString fullPath = docPath   + appName + "/" + DBNAME;
    qDebug() << "Full path: " + fullPath;
    file.setFileName(fullPath);
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    cargo = file.readAll();
    file.close();
    qWarning() << cargo;

    return cargo;
}

