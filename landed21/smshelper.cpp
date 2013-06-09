//http://www.developer.nokia.com/Community/Wiki/QML_SMShelper_Plugin

#include "smshelper.h"

#ifndef SENDSMS_ENABLED
#include <QTimer>
#endif

SMSHelper::SMSHelper(QObject *parent) :
    QObject(parent)
{
    state = QMessageService::InactiveState;
    connect(&iMessageService, SIGNAL(stateChanged(QMessageService::State)), this, SLOT(messageStateChanged(QMessageService::State)));

}

SMSHelper::~SMSHelper()
{
}


bool SMSHelper::sendsms(QString phonenumber, QString message)
{

#ifdef SENDSMS_ENABLED
    if (!QMessageAccount::defaultAccount(QMessage::Sms).isValid())
    {
        emit errorMsg("No messageaccount for sms sending.");
        return false;
    }

    if (state == QMessageService::InactiveState || state == QMessageService::FinishedState)
    {
        QMessage sms;

        sms.setType(QMessage::Sms);
        sms.setParentAccountId(QMessageAccount::defaultAccount(QMessage::Sms));
        sms.setTo(QMessageAddress(QMessageAddress::Phone, phonenumber));
        sms.setBody(message);

        return iMessageService.send(sms);
    }
    else
    {
        return false;
    }

#else
    QTimer::singleShot(1000,this,SLOT(signalFinishedState()));
    return true;
#endif



}

void SMSHelper::messageStateChanged(QMessageService::State s)
{
    state = s;

    if (s == QMessageService::InactiveState)
    {
        emit stateMsg("InactiveState");
    }
    else if (s == QMessageService::ActiveState)
    {
        emit stateMsg("ActiveState");
    }
    else if (s == QMessageService::CanceledState)
    {
        emit stateMsg("CanceledState");
    }
    else if (s == QMessageService::FinishedState)
    {
        emit stateMsg("FinishedState");
    }
    else
    {
         emit stateMsg(QString("QMessageService::%1").arg(s));
    }
}

