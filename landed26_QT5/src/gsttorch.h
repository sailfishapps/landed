#ifndef GSTTORCH_H
#define GSTTORCH_H

#include <QObject>
#include <gst/gstelement.h>
#include <QTimer>


class GstTorch : public QObject
{
    Q_OBJECT
    Q_ENUMS(Status)
    Q_ENUMS(Mode)

public:
    enum Status { offBeam, onBeam, onFlashOn, onFlashOff, offFlash };
    enum Mode { Beam, Flash };
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(bool lightOnEnabled READ lightOnEnabled WRITE setLightOnEnabled NOTIFY lightOnEnabledChanged)
    Q_PROPERTY(bool torchOn READ torchOn WRITE setTorchOn NOTIFY torchOnChanged)
    Q_PROPERTY(Mode torchMode READ torchMode WRITE setTorchMode NOTIFY torchModeChanged)
    Q_PROPERTY(int flashRate READ flashRate WRITE setFlashRate NOTIFY flashRateChanged)
    explicit GstTorch(QObject *parent = 0);
    ~GstTorch();

    void start();
    void stop();
    Q_INVOKABLE void toggleTorchOnOff();
    Q_INVOKABLE void toggleTorchMode(); // toggle between Beam and Torch

    bool enabled();
    bool lightOnEnabled();
    bool torchOn();
    Mode torchMode();
    int flashRate();
    void setEnabled(bool enabled);
    void setLightOnEnabled(bool lightOnEnabled);
    void setTorchOn(bool on);
    void setTorchMode(Mode mode);
    void setFlashRate(int flashRate);

signals:
    void enabledChanged(bool enabled);
    void lightOnEnabledChanged(bool lightOnEnabled);
    void torchOnChanged(bool on);
    void torchModeChanged(Mode mode);
    void flashRateChanged(int flashRate);

protected slots:
    void flashEvent();

private:
    void initTimer();
    void releaseTimer();
    void initTorch();
    void releaseTorch();
    void setStatus(bool torchOn, Mode torchMode, bool flashOn);

    GstElement *pipeline;
    GstElement *src;
    GstElement *sink;
    QTimer *timer;
    bool mEnabled;
    bool mlightOnEnabled;
    bool mTorchOn; // true = on
    Mode mtorchMode; // true = on, i.e if the torch is active, it will flash.
    int mFlashRate;
    Status mStatus;

};

#endif // GSTTORCH_H
