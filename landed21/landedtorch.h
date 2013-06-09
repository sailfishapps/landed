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

public:
    explicit LandedTorch(QDeclarativeItem *parent = 0);

    ~LandedTorch();


signals:


public slots:

    void initialize();
    void torchOn();
    void torchOff();
    void torchToggle();

protected slots:

private:
    QCamera* camera;
};

#endif // LANDEDTORCH_H
