#ifndef TELEPATHYHELPER_H
#define TELEPATHYHELPER_H

#include <TelepathyQt/Types>
//Enable the line below when debugging accounts available on device
//#include <TelepathyQt/AccountManager>

#include <QObject>
#include <QString>


namespace Tp
{
    class PendingOperation;
}

class TelepathyHelper : public QObject
{
    Q_OBJECT

public:
    explicit TelepathyHelper(QObject *parent = 0);
    ~TelepathyHelper();
    Q_INVOKABLE void sendSMS(const QString &contactIdentifier, const QString &message);

signals:
    void stateMsg(const QString &statemsg);
    void errorMsg(const QString &errormsg);

private Q_SLOTS:
    void onSendMessageFinished(Tp::PendingOperation *op);

private:
    Tp::ContactMessengerPtr messenger;
    //Enable the line below when debugging accounts available on device
    //Tp::AccountManagerPtr m_AM;
};

#endif // TELEPATHYHELPER_H
