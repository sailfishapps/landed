#include "telepathyhelper.h"

#include <TelepathyQt/Account>
#include <TelepathyQt/Debug>
#include <TelepathyQt/Constants>
#include <TelepathyQt/ContactMessenger>
#include <TelepathyQt/PendingSendMessage>
#include <TelepathyQt/Types>


TelepathyHelper::TelepathyHelper(QObject *parent) :
    QObject(parent)
{
    Tp::registerTypes();
    Tp::enableDebug(true);
    Tp::enableWarnings(true);

    /*
    //This little block of code can be enabled to findout what org.freedesktop accounts are available on the device
    //see the application output for the accounts.
    //Do not forget to enable the AccountManager include and varaible declaration in the telepathy.h file
    m_AM = Tp::AccountManager::create();
    if (!m_AM) {
        qWarning() << __FUNCTION__ << "Cannot create Account Manager (m_am)";
        return;
    }
    */
}

TelepathyHelper::~TelepathyHelper()
{
}

void TelepathyHelper::sendSMS(const QString &contactIdentifier, const QString &message)
{

    //Accounts used:
    //Harmattan: QLatin1String("/org/freedesktop/Telepathy/Account/ring/tel/ring")
    //Sailfish: QLatin1String("/org/freedesktop/Telepathy/Account/ring/tel/account0")

    Tp::AccountPtr acc = Tp::Account::create(TP_QT_ACCOUNT_MANAGER_BUS_NAME,
                                             QLatin1String("/org/freedesktop/Telepathy/Account/ring/tel/account0"));

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

