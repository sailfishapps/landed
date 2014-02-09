#include "satinfosource.h"
#include <QDebug>

SatInfoSource::SatInfoSource(QObject *parent) :
    QObject(parent),
    myGeoSatelliteInfoSource(QGeoSatelliteInfoSource::createDefaultSource(this)),
    _satsInUse(0),
    _satsInView(0)
{
    //myGeoSatelliteInfoSource = QGeoSatelliteInfoSource::createDefaultSource(0);

    if (myGeoSatelliteInfoSource) {
        qDebug() << "satellite info source available";
        connect(myGeoSatelliteInfoSource, SIGNAL(satellitesInViewUpdated(const QList<QGeoSatelliteInfo> &)), this, SLOT(onSatsInViewUpdated(const QList<QGeoSatelliteInfo> &)));
        connect(myGeoSatelliteInfoSource, SIGNAL(satellitesInUseUpdated(const QList<QGeoSatelliteInfo> &)), this, SLOT(onSatsInUseUpdated(const QList<QGeoSatelliteInfo> &)));
    }
    else {
        qDebug() << "No satellite info source available";
    }
}

SatInfoSource::~SatInfoSource()
{
}

void SatInfoSource::startUpdates() {
    if (myGeoSatelliteInfoSource) {
        myGeoSatelliteInfoSource->startUpdates();
    }
    else {
        qDebug() << "Start Updates requested, but no satellite info source available";
    }
}

void SatInfoSource::stopUpdates() {
    if (myGeoSatelliteInfoSource) {
        myGeoSatelliteInfoSource->stopUpdates();
    }
    else {
        qDebug() << "Stop Updates requested, but no satellite info source available";
    }
}

int SatInfoSource::satsInView() const
{
    return _satsInView;
}


int SatInfoSource::satsInUse() const
{
    return _satsInUse;
}


void SatInfoSource::onSatsInViewUpdated(const QList<QGeoSatelliteInfo> &list) {
    int newInView = list.count();
    if (newInView != _satsInView) {
        qDebug() << "satInfoSource.cpp: onSatsinViewUpdated: " << QString::number(newInView, 'g', 2);
        for (int i = 0; i < newInView; i++ ) {
            qDebug() << "satsInView: id: "  << list[i].satelliteIdentifier() << ", system: " << list[i].satelliteSystem() << ", strength: " + list[i].signalStrength();
        }
        _satsInView = newInView;
        emit satellitesInViewChanged(newInView);
    }
}

void SatInfoSource::onSatsInUseUpdated(const QList<QGeoSatelliteInfo> &list) {
    int newInUse = list.count();
    if (newInUse != _satsInUse) {
        qDebug() << "satInfoSource.cpp: onSatsinUseUpdated: " << QString::number(newInUse, 'g', 2);
        for (int i = 0; i < newInUse; i++ ) {
            qDebug() << "satsInUse: id: "  << list[i].satelliteIdentifier() << ", system: " << list[i].satelliteSystem() << ", strength: " + list[i].signalStrength();
        }
        _satsInUse = newInUse;
        emit satellitesInUseChanged(newInUse);
    }
}

