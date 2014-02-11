#ifndef JSONSTORAGE_H
#define JSONSTORAGE_H

#include <QObject>
#include <QString>
#include <QFile>
#include <QDebug>
#include <QStandardPaths>
#include <QCoreApplication>

class JSONStorage : public QObject
{
    Q_OBJECT

public:
    Q_INVOKABLE QString openDatabase();
    explicit JSONStorage(QObject *parent = 0);
    ~JSONStorage();

private:
    static const QString DBNAME;
};

#endif // JSONSTORAGE_H
