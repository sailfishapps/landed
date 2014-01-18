//For showing me how: Thanks to:
//http://projects.developer.nokia.com/camerademo
//https://build.pub.meego.com/package/files?package=mirror&project=home%3Anicolai

#ifndef LANDEDTORCH_H
#define LANDEDTORCH_H

#include <QQuickItem>
//#include <QtMultimedia/QCamera>

#include <QCamera>
#include <QDebug>
#include <QTimer>

class LandedTorch : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(bool active READ active WRITE setActive NOTIFY activeChanged)
    Q_PROPERTY(bool torchOn READ torchOn WRITE setTorchOn NOTIFY torchOnChanged)
    Q_PROPERTY(bool isBeam READ isBeam NOTIFY isBeamChanged)
    Q_PROPERTY(bool isFlash READ isFlash NOTIFY isFlashChanged)
    Q_PROPERTY(TorchMode mode READ mode WRITE setMode NOTIFY modeChanged )
    //Q_PROPERTY(int flashInterval READ flashInterval WRITE setFlashInterval NOTIFY flashIntervalChanged)
    Q_PROPERTY(int flashTime READ flashTime WRITE setFlashTime NOTIFY flashTimeChanged)
    Q_ENUMS(TorchMode)

    //Q_PRIVATE_SLOT investigate this one

public:
    explicit LandedTorch(QQuickItem *parent = 0);

    ~LandedTorch();

    //mode is either flash or beam
    //active implies the torch is activated, this value stays true while flashing
    //torchOn implies the torch is on, this value will change while flashing (true / false)

    bool active() const;
    void setActive(bool active);

    bool torchOn() const;
    void setTorchOn(bool torchOn);

    enum TorchMode { flash = 0, beam };

    TorchMode mode() const;
    void setMode(TorchMode mode);

    //int flashInterval() const;
    //void setFlashInterval(int flashInterval);

    int flashTime() const;
    void setFlashTime(int flashTime);

    bool isBeam() const;
    void setIsBeam(bool isBeam);
    bool isFlash() const;
    void setIsFlash(bool isFlash);


signals:
    void activeChanged(const bool &active);
    void torchOnChanged(const bool &torchOn);
    void modeChanged(const TorchMode &mode);
    //void flashIntervalChanged(const int &flashInterval);
    void flashTimeChanged(const int &flashTime);
    void isBeamChanged(const bool &isBeam);
    void isFlashChanged(const bool &isFlash);

public slots:
    void toggleFlash();
    void toggleMode();

protected slots:
//investigate what this is

private:

    void initCamera();
    void initTimer();

    // turn torch on or off with beam mode
    void beamOn();
    void beamOff();
    // turn torch on or off with flashing mode
    void flashingOn();
    void flashingOff();

    QCamera* _camera;
    QTimer* _timer;
    bool _active;
    bool _torchOn;
    TorchMode _mode;
    //int _flashInterval;
    int _flashTime;
    bool _isBeam;
    bool _isFlash;
};

#endif // LANDEDTORCH_H
