#include "jsonstorage.h"

JSONStorage::JSONStorage(QObject *parent) :
    QObject(parent), _dbLevel(Prod), _settingsJson()
{  
    if (!loadSettings()) {
        qWarning("Couldn't load settings.");
    }
}

JSONStorage::~JSONStorage()
{
}

//These 3 files should be stored in the QStandardPaths DocumentsLocation: /home/nemo/Documents/landed26_QT5/
const QString JSONStorage::MASTERDBNAMETEST = "landeddb.masterdata.test.json";
const QString JSONStorage::MASTERDBNAMEPROD = "landeddb.masterdata.prod.json";
const QString JSONStorage::SETTINGSDBNAME = "landeddb.settings.json";


/*
landeddb.settings.json should look like this:
{
"dblevel" : "test"
}
*/


QString JSONStorage::buildFullPath(DBType dbType){
    QString docPath = QStandardPaths::locate(QStandardPaths::DocumentsLocation, QString(), QStandardPaths::LocateDirectory);
    qDebug() << "Document Path: " << docPath;
    QString appName = QCoreApplication::applicationName();
    qDebug() << "App Name: " << appName;

    qDebug() << "dbType: " << dbType;
    QString fullPath;
    switch (dbType) {
        case Settings:
            fullPath = docPath   + appName + "/" + SETTINGSDBNAME;
            break;
        case Masterdata:
            switch (_dbLevel) {
                case Prod:
                    fullPath = docPath   + appName + "/" + MASTERDBNAMEPROD;
                    break;
                case Test:
                    fullPath = docPath   + appName + "/" + MASTERDBNAMETEST;
                    break;
                default:
                    fullPath = docPath   + appName + "/" + MASTERDBNAMEPROD;
            }
            break;
    }

    qDebug() << "Full path: " + fullPath;
    return fullPath;
}


QString JSONStorage::openDatabase(DBType dbType) {

    QString fullPath = buildFullPath(dbType);
    QFile file;
    file.setFileName(fullPath);
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    QString cargo;
    cargo = file.readAll();
    file.close();
    qDebug() << cargo;

    return cargo;
}



//functions below are associated with settings
//and may be refactored into a separate class / plugin
void JSONStorage::setDbLevel(DBLevel dbLevel) {
    _dbLevel = dbLevel;
}



void JSONStorage::writeSetting(QJsonObject &json, QString settingName, QString settingValue) const
{
    json[settingName] = settingValue;
}


QString JSONStorage::readSetting(const QJsonObject &json, QString settingName)
{

    return json[settingName].toString();

}

bool JSONStorage::loadSettings()
{
    //open the json settings file
    QString fullPath = buildFullPath(Settings);
    QFile settingsFile(fullPath);
    if (!settingsFile.open(QIODevice::ReadOnly)) {
        qWarning("Couldn't open save file.");
        return false;
    }

    //read the contents into a bytearray
    QByteArray settingsData = settingsFile.readAll();
    settingsFile.close();

    //store content as a local json structure
    _settingsJson.fromJson(settingsData);

    return true;
}

bool JSONStorage::saveSettings() const
{
    QFile saveFile(QStringLiteral("save.json"));

    if (!saveFile.open(QIODevice::WriteOnly)) {
        qWarning("Couldn't open save file.");
        return false;
    }
/*
    QJsonObject gameObject;
    write(gameObject);
    QJsonDocument saveDoc(gameObject);
    saveFile.write(saveDoc.toJson());
*/
    return true;
}

