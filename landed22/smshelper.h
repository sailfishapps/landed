//http://www.developer.nokia.com/Community/Wiki/QML_SMShelper_Plugin

#ifndef SMSHELPER_H
#define SMSHELPER_H


#include <QObject>
//#include <QtDeclarative>

#include <qmessage.h>
#include <qmessageservice.h>



QTM_USE_NAMESPACE

/*
#ifdef Q_OS_SYMBIAN
#  define SENDSMS_ENABLED
#elif defined(Q_WS_MAEMO_5) || defined(Q_WS_MAEMO_6)
#  define SENDSMS_ENABLED
#endif
*/

#  define SENDSMS_ENABLED

class SMSHelper : public QObject
{
    Q_OBJECT

public:
    explicit SMSHelper(QObject *parent = 0);
    ~SMSHelper();

    Q_INVOKABLE bool sendsms(QString phonenumber, QString message);

signals:
    void stateMsg(const QString &statemsg);
    void errorMsg(const QString &errormsg);
    void debugMsg(const QString &dbgmsg);

private slots:
    void messageStateChanged(QMessageService::State s);
#ifndef SENDSMS_ENABLED
    void signalFinishedState() { emit stateMsg("FinishedState");};
#endif
private:
    QMessageService iMessageService;
    QMessageManager iManager;
    QMessageService::State state;


};


#endif // SMSHELPER_H
