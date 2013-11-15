//For showing me how: Thanks to:
//http://projects.developer.nokia.com/camerademo
//https://build.pub.meego.com/package/files?package=mirror&project=home%3Anicolai

#include "landedtorch.h"
#include <QDebug>

LandedTorch::LandedTorch(QDeclarativeItem *parent) :
    QDeclarativeItem(parent)
  ,camera(0), _flashing(false), _torchOn(false), _flashInterval(0.75*1000)
{
    camera = new QCamera("primary");
    camera->setCaptureMode(QCamera::CaptureVideo);
    camera->exposure()->setFlashMode(QCameraExposure::FlashMode(QCameraExposure::FlashTorch));
    camera->load();
}

LandedTorch::~LandedTorch()
{
    camera ->unload();
    delete camera;
}


void LandedTorch::initialize()
{
    if (!camera) {
        return;
    }
    qDebug() << "Initializing torch";
    camera->start();
    camera->stop();
}

bool LandedTorch::flashing() const
{
    return _flashing;
}

void LandedTorch::setFlashing(bool flashing)
{
    if (flashing == _flashing)
        return;
    _flashing = flashing;
    emit flashingChanged(flashing);
}

int LandedTorch::flashInterval() const
{
    return _flashInterval;
}

void LandedTorch::setFlashInterval(int flashInterval)
{
    if (flashInterval == _flashInterval)
        return;
    _flashInterval = flashInterval;
    emit flashIntervalChanged(flashInterval);
}


bool LandedTorch::torchOn() const
{
    return _torchOn;
}

void LandedTorch::setTorchOn(bool torchOn)
{
    if (torchOn == _torchOn)
        return;
    _torchOn = torchOn;
    emit torchOnChanged(torchOn);
}

void LandedTorch::turnOn()
{
    qDebug() << "c++ turn on called";
    if (!camera) {
        return;
    }
    _torchOn = true;
    camera->start();
    emit torchOnChanged(true);
}

void LandedTorch::turnOff()
{
    qDebug() << "c++ turn off called";
    if (!camera) {
        return;
    }
    _torchOn = false;
    camera->stop();
    emit torchOnChanged(false);
}


void LandedTorch::torchToggle()
{
    qDebug() << "torchToggle called";

    if (!camera) {
        return;
    }

    if (camera->state() == QCamera::ActiveState) {
        qDebug() << "camera state is active ";
        //camera->stop();
        turnOff();
    }
    else if (camera->state() == QCamera::LoadedState) {
        qDebug() << "camera state is loaded ";
        //camera->start();
        turnOn();
    }
    else {      
        qDebug() << "camera state is other ";
        //camera->start();
        turnOff();
    }
}




