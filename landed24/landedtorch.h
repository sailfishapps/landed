//For showing me how: Thanks to:
//http://projects.developer.nokia.com/camerademo
//https://build.pub.meego.com/package/files?package=mirror&project=home%3Anicolai

#ifndef LANDEDTORCH_H
#define LANDEDTORCH_H

#include <QDeclarativeItem>
#include <QCamera>

class LandedTorch : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(bool flashing READ flashing WRITE setFlashing NOTIFY flashingChanged)
    Q_PROPERTY(int flashInterval READ flashInterval WRITE setFlashInterval NOTIFY flashIntervalChanged)
    Q_PROPERTY(bool torchOn READ torchOn WRITE setTorchOn NOTIFY torchOnChanged)

public:
    explicit LandedTorch(QDeclarativeItem *parent = 0);

    ~LandedTorch();

    bool flashing() const;
    void setFlashing(bool flashing);

    int flashInterval() const;
    void setFlashInterval(int flashInterval);

    bool torchOn() const;
    void setTorchOn(bool torchOn);

signals:
    void flashingChanged(const bool &flashing);
    void flashIntervalChanged(const int &interval);
    void torchOnChanged(const bool &torchOn);

public slots:

    void initialize();
    void turnOn();
    void turnOff();
    void torchToggle();

protected slots:

private:
    QCamera* camera;
    QTimer* timer;
    bool _flashing;
    bool _torchOn;
    bool _flashInterval;
};

#endif // LANDEDTORCH_H
