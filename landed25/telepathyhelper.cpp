#include "telepathyhelper.h"

#include <TelepathyQt4/Account>
#include <TelepathyQt4/Debug>
#include <TelepathyQt4/Constants>
#include <TelepathyQt4/ContactMessenger>
#include <TelepathyQt4/PendingSendMessage>
#include <TelepathyQt4/Types>


TelepathyHelper::TelepathyHelper(QObject *parent) :
    QObject(parent)
{

    Tp::registerTypes();
    Tp::enableDebug(true);
    Tp::enableWarnings(true);
}

TelepathyHelper::~TelepathyHelper()
{
}

void TelepathyHelper::sendSMS(const QString &contactIdentifier, const QString &message)
{

    Tp::AccountPtr acc = Tp::Account::create(TP_QT4_ACCOUNT_MANAGER_BUS_NAME,
                                             QLatin1String("/org/freedesktop/Telepathy/Account/ring/tel/ring"));
    //QLatin1String("/org/freedesktop/Telepathy/Account/ring/tel/account0"));
    messenger = Tp::ContactMessenger::create(acc, contactIdentifier);

    connect(messenger->sendMessage(message),
            SIGNAL(finished(Tp::PendingOperation*)),
            SLOT(onSendMessageFinished(Tp::PendingOperation*)));

}

void TelepathyHelper::onSendMessageFinished(Tp::PendingOperation *op)
{
    if (op->isError()) {
        qDebug() << "Error sending message:" << op->errorName() << "-" << op->errorMessage();
        emit errorMsg("Error sending message");
        return;
    }

    Tp::PendingSendMessage *psm = qobject_cast<Tp::PendingSendMessage *>(op);
    qDebug() << "Message sent, token is" << psm->sentMessageToken();
    emit stateMsg("FinishedState");
}

