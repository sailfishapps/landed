/* Copyright (C) 2013 Jolla Ltd
 * Copyright (C) 2012 John Brooks <john.brooks@dereferenced.net>
 *
 * You may use this file under the terms of the BSD license as follows:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *   * Neither the name of Nemo Mobile nor the names of its contributors
 *     may be used to endorse or promote products derived from this
 *     software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Copyright (C) 2015 Chris Lamb, any modifications to Jolla / John Brooks Code.
 * This code is simplified / reduced for nemomobile original
 * found under https://github.com/nemomobile/nemo-qml-plugin-messages.
 *
 * It is only included in Landed as a temporary workaround for a bug
 * caused by inconsitency of the versions of telepathyQt and telepathy-mission-control
 * installed on the Jolla in version 1.1.7.25.
 * The CD.I.Messages interface is supported by:
 *    telepathy-mission-control 5.15.0 in DRAFT form.
 *    telepathy-qt5-0.9.4 in "undrafted" form.
 * This inconsistency prevents sending of SMS via the existing Landed telepathyhelper code:
 * i.e. Jolla / nemomobile broke my app!
 * see https://bugs.nemomobile.org/show_bug.cgi?id=847
 *
*/

#ifndef CONVERSATIONCHANNEL_H
#define CONVERSATIONCHANNEL_H

#include <QObject>
#include <TelepathyQt/PendingChannelRequest>
#include <TelepathyQt/ChannelRequest>
#include <TelepathyQt/Channel>
#include <TelepathyQt/PendingSendMessage>
#include <TelepathyQt/ReceivedMessage>


/* ConversationChannel represents a telepathy channel for QML. */
class ConversationChannel : public QObject
{
    Q_OBJECT
    Q_ENUMS(State)

    Q_PROPERTY(State state READ state NOTIFY stateChanged)
    Q_PROPERTY(QString localUid READ localUid CONSTANT)
    Q_PROPERTY(QString remoteUid READ remoteUid CONSTANT)

public:
    enum State {
        Null,
        PendingRequest,
        Requested,
        PendingReady,
        Ready,
        Error
    };

    ConversationChannel(const QString &localUid, const QString &remoteUid, QObject *parent = 0);
    virtual ~ConversationChannel();

    State state() const { return mState; }
    QString localUid() const { return mLocalUid; }
    QString remoteUid() const { return mRemoteUid; }

    Q_INVOKABLE void ensureChannel();
    void setChannel(const Tp::ChannelPtr &channel);

    void sendMessage(const Tp::MessagePartList &parts);

public slots:
    void sendMessage(const QString &text, int eventId = -1);


signals:
    void stateChanged(int newState);
    void requestSucceeded();
    void requestFailed(const QString &errorName, const QString &errorMessage);
    void sendingFailed(int eventId);
    void finished(Tp::PendingOperation *op);

private slots:
    void accountReadyForChannel(Tp::PendingOperation *op);
    void channelRequestCreated(const Tp::ChannelRequestPtr &request);
    void channelRequestSucceeded(const Tp::ChannelPtr &channel);
    void channelRequestFailed(const QString &errorName, const QString &errorMessage);
    void channelReady();

    void channelInvalidated(Tp::DBusProxy *proxy, const QString &errorName, const QString &errorMessage);

    void sendingFinished(Tp::PendingOperation *op);

private:
    Tp::PendingChannelRequest *mPendingRequest;
    Tp::ChannelRequestPtr mRequest;
    Tp::ChannelPtr mChannel;
    Tp::AccountPtr mAccount;
    State mState;

    QString mLocalUid;
    QString mRemoteUid;

    Tp::MessagePartListList mPendingMessages;

    void setState(State newState);
    void start(Tp::PendingChannelRequest *request);

    void sendingFailed(const Tp::MessagePartList &parts);
};


#endif
