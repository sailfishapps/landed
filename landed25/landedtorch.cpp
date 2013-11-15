//For showing me how: Thanks to:
//http://projects.developer.nokia.com/camerademo
//https://build.pub.meego.com/package/files?package=mirror&project=home%3Anicolai

#include "landedtorch.h"
#include <QDebug>

LandedTorch::LandedTorch(QDeclarativeItem *parent) :
    QDeclarativeItem(parent)
  ,_camera(0), _timer(0), _active(false), _torchOn(false), _mode(beam), _flashTime(0.75*1000), _isBeam(true), _isFlash(false)
{
    this->initCamera();
    this->initTimer();
}

void LandedTorch::initCamera() {
    qDebug() << "camera initialised";
    _camera = new QCamera("primary");
    _camera->setCaptureMode(QCamera::CaptureVideo);
    _camera->exposure()->setFlashMode(QCameraExposure::FlashMode(QCameraExposure::FlashTorch));
    _camera->load();
}

void LandedTorch::initTimer() {
    qDebug() << "timer initialised";
    _timer = new QTimer(this);
    setFlashTime(750);
    _timer->setInterval(_flashTime);
    _timer->setSingleShot(false);
    QObject::connect(_timer, SIGNAL(timeout()), this, SLOT(toggleFlash()));
}

LandedTorch::~LandedTorch()
{
    _camera ->unload();
    delete _camera;
    if(_timer)
        _timer->stop();
    delete _timer;
}


//Methods associated with Q_PROPERTIES

bool LandedTorch::active() const
{
    return _active;
}

void LandedTorch::setActive(bool active)
{
    if (active == _active)
        return;
    if (active == true && _mode == beam) {
        qDebug() << "torch will be activated in beam mode";
        beamOn();
    }
    else if (active == true && _mode == flash) {
        qDebug() << "torch will be activated in flash mode";
        flashingOn();
    }
    else if (active == false && _mode == beam) {
        qDebug() << "torch will be deactivated";
        beamOff();
    }
    else if (active == false && _mode == flash) {
        qDebug() << "torch will be deactivated";
        flashingOff();
    }
    else
        beamOff();

    _active = active;
    emit activeChanged(active);
}


bool LandedTorch::torchOn() const
{
    return _torchOn;
}

void LandedTorch::setTorchOn(bool torchOn)
{
    if (torchOn == _torchOn)
        return;
    if (torchOn == true)
        _camera->start();
    else
        _camera->stop();
    _torchOn = torchOn;
    emit torchOnChanged(torchOn);
}

LandedTorch::TorchMode LandedTorch::mode() const
{
    return _mode;
}

void LandedTorch::setMode(TorchMode mode)
{
    qDebug() << "c++ setMode called";
    bool wasActive = false;
    if (_active) {
        wasActive = true;
        setActive(false);
    }
    if (mode == _mode) {
        qDebug() << "new mode same as old";
        return;
    }
    if (mode == beam ) {
        qDebug() << "setting mode to beam";
        setIsBeam(true);
        setIsFlash(false);
    }
    else if (mode == flash) {
        qDebug() << "setting mode to flash";
        setIsFlash(true);
        setIsBeam(false);
    }
    _mode = mode;
    emit modeChanged(mode);
    if (wasActive) {
        setActive(true);
    }
    return;
}

int LandedTorch::flashTime() const
{
    return _flashTime;
}

void LandedTorch::setFlashTime(int flashTime)
{
   qDebug() << "c++ setFlashTime called";
   if (flashTime == _flashTime)
   {
       qDebug() << "value is same ...";
       return;
   }
   qDebug() << "about to emit flashTimeChanged";
   _flashTime = flashTime;
   emit flashTimeChanged(flashTime);
}

bool LandedTorch::isBeam() const
{
    return _isBeam;
}

void LandedTorch::setIsBeam(bool isBeam)
{
    if (isBeam == _isBeam)
        return;
    _isBeam = isBeam;
    emit isBeamChanged(isBeam);
}

bool LandedTorch::isFlash() const
{
    return _isFlash;
}

void LandedTorch::setIsFlash(bool isFlash)
{
    if (isFlash == _isFlash)
        return;
    _isFlash = isFlash;
    emit isFlashChanged(isFlash);
}



//public slots

void LandedTorch::beamOn()
{
    qDebug() << "c++ beamOn called";
    if (!_camera) {
        return;
    }
    _camera->start();
    setTorchOn(true);
}

void LandedTorch::beamOff()
{
    qDebug() << "c++ beamOff called";
    if (!_camera) {
        return;
    }
    _camera->stop();
    setTorchOn(false);
}

void LandedTorch::flashingOn()
{
    qDebug() << "c++ flashingOn called";
    if (!_camera) {
        return;
    }
    _camera->start();
    setTorchOn(true);
    _timer->start();
}

void LandedTorch::flashingOff()
{
    qDebug() << "c++ flashingOff called";
    if (!_camera) {
        return;
    }
    _timer->stop();
    _camera->stop();
    setTorchOn(false);
}

void LandedTorch::toggleFlash()
{
    qDebug() << "toggleFlash called";

    if (!_camera) {
        return;
    }
    bool newOn;
    if (_torchOn == true) {
        qDebug() << "turning torch off... ";
        newOn = false;
    }
    else if (_torchOn == false) {
        qDebug() << "turning torch off... ";
        newOn = true;
    }
    setTorchOn(newOn);
}

void LandedTorch::toggleMode()
{
    qDebug() << "c++ toggleMode called ";
    TorchMode newMode;
    if (_mode == flash)
        newMode = beam;
    if (_mode == beam)
        newMode = flash;
    setMode(newMode);
}
