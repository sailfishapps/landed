#include "telepathyhelper.h"
#include "conversationchannel.h"

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
    //!!!!Do not forget to enable the AccountManager include and variable declaration in the telepathy.h file!!!!
    qDebug() << "TelepathyHelper::org.freedesktop accounts on device:";
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

    ConversationChannel *conversationChannel = new ConversationChannel("/org/freedesktop/Telepathy/Account/ring/tel/account0", contactIdentifier);

    //1) the standard ConversationChannel sendMessage return(ed) type VOID
    // ->sendMessage(message)
    //   --> now pimped in LandedConversationChannel to return PendingSendMessage
    //2) but the ContactMessenger sendMessge returned type PendingSendMessage!
    //The connect below cannot handle a VOID

    //in this version we listen to the signal finished emitted by conversationChannel
    connect(conversationChannel,
            SIGNAL(finished(Tp::PendingOperation*)),
            SLOT(onSendMessageFinished(Tp::PendingOperation*)));

    //this works! SMS is sent!!!! yippeee !!!
    conversationChannel->sendMessage(message);

}


void TelepathyHelper::onSendMessageFinished(Tp::PendingOperation *op)
{
    qDebug() << "TelepathyHelper::onSendMessageFinished";
    if (op->isError()) {
        qDebug() << "Error sending message:" << op->errorName() << "-" << op->errorMessage();
        emit errorMsg("Error sending message");
        return;
    }

    Tp::PendingSendMessage *psm = qobject_cast<Tp::PendingSendMessage *>(op);
    qDebug() << "Message sent, token is" << psm->sentMessageToken();
    emit stateMsg("FinishedState");
}






//The code for telepathyhelper below is temporarily commented out, this approach is broken by inconsitency in interface
//between Telepathy-Qt5 and telepathy-mission-control, preventing contactMessenger.sendMessage()
//from working.
//This means we need to find another vector to send smses via telepathy
//given that that the Jolla SMS app can send, this must be possible!

//#include "telepathyhelper.h"

//#include <TelepathyQt/Account>
//#include <TelepathyQt/Debug>
//#include <TelepathyQt/Constants>
//#include <TelepathyQt/ContactMessenger>
//#include <TelepathyQt/PendingSendMessage>
//#include <TelepathyQt/Types>


//TelepathyHelper::TelepathyHelper(QObject *parent) :
//    QObject(parent)
//{
//    Tp::registerTypes();
//    Tp::enableDebug(true);
//    Tp::enableWarnings(true);

///*
//    //This little block of code can be enabled to findout what org.freedesktop accounts are available on the device
//    //see the application output for the accounts.
//    //!!!!Do not forget to enable the AccountManager include and variable declaration in the telepathy.h file!!!!
//    qDebug() << "TelepathyHelper::org.freedesktop accounts on device:";
//    m_AM = Tp::AccountManager::create();
//    if (!m_AM) {
//        qWarning() << __FUNCTION__ << "Cannot create Account Manager (m_am)";
//        return;
//    }
//*/
//}

//TelepathyHelper::~TelepathyHelper()
//{
//}

//void TelepathyHelper::sendSMS(const QString &contactIdentifier, const QString &message)
//{

//    //Accounts used:
//    //Harmattan: QLatin1String("/org/freedesktop/Telepathy/Account/ring/tel/ring")
//    //Sailfish: QLatin1String("/org/freedesktop/Telepathy/Account/ring/tel/account0")

//    Tp::AccountPtr acc = Tp::Account::create(TP_QT_ACCOUNT_MANAGER_BUS_NAME,
//                                             QLatin1String("/org/freedesktop/Telepathy/Account/ring/tel/account0"));

//    messenger = Tp::ContactMessenger::create(acc, contactIdentifier);

//    connect(messenger->sendMessage(message),
//            SIGNAL(finished(Tp::PendingOperation*)),
//            SLOT(onSendMessageFinished(Tp::PendingOperation*)));


//}


///*
//    connect(messenger.data(),
//            SIGNAL(finished(Tp::PendingOperation*)),
//            SLOT(onSendMessageFinished(Tp::PendingOperation*)));

//    messenger->sendMessage(message);

//    gives

//[D] Tp::Debug::invokeDebugCallback:146 - tp-qt 0.9.3 DEBUG: Contact id requires normalization. Queueing events until it is normalized
//QObject::connect: No such signal Tp::ContactMessenger::finished(Tp::PendingOperation*) in ../landed26_QT5/src/telepathyhelper.cpp:48

//*/


//void TelepathyHelper::onSendMessageFinished(Tp::PendingOperation *op)
//{
//    qDebug() << "TelepathyHelper::onSendMessageFinished";
//    if (op->isError()) {
//        qDebug() << "Error sending message:" << op->errorName() << "-" << op->errorMessage();
//        emit errorMsg("Error sending message");
//        return;
//    }

//    Tp::PendingSendMessage *psm = qobject_cast<Tp::PendingSendMessage *>(op);
//    qDebug() << "Message sent, token is" << psm->sentMessageToken();
//    emit stateMsg("FinishedState");
//}

