//For showing me how: Thanks to:
//http://projects.developer.nokia.com/camerademo
//https://build.pub.meego.com/package/files?package=mirror&project=home%3Anicolai

#include "landedtorch.h"
#include <QDebug>

LandedTorch::LandedTorch(QDeclarativeItem *parent) :
    QDeclarativeItem(parent)
    ,camera(0)
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

void LandedTorch::torchOn()
{
    if (!camera) {
        return;
    }
    camera->start();
}

void LandedTorch::torchOff()
{
    if (!camera) {
        return;
    }
    camera->stop();
}


void LandedTorch::torchToggle()
{
    qDebug() << "torchToggle called";

    if (!camera) {
        return;
    }

    if (camera->state() == QCamera::ActiveState) {
        qDebug() << "camera state is active ";
        camera->stop();
    }
    else if (camera->state() == QCamera::LoadedState) {
        qDebug() << "camera state is loaded ";
        camera->start();
    }
    else {      
        qDebug() << "camera state is other ";
        camera->start();
    }
}




