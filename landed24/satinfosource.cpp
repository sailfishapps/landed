#include "SatInfoSource.h"
#include <QDebug>
#include <sstream>


//The constructor
SatInfoSource::SatInfoSource(QObject *parent) :
    QObject(parent), _satsInView(0), _satsInUse(0)
{

    myGeoSatelliteInfoSource = QGeoSatelliteInfoSource::createDefaultSource(0);

    //connect(myGeoSatelliteInfoSource, SIGNAL(satellitesInViewUpdated(const QList<QGeoSatelliteInfo> &)), this, SIGNAL(satellitesInViewUpdated(const QList<QGeoSatelliteInfo> &)));
    connect(myGeoSatelliteInfoSource, SIGNAL(satellitesInViewUpdated(const QList<QGeoSatelliteInfo> &)), this, SLOT(onSatsInViewUpdated(const QList<QGeoSatelliteInfo> &)));


    //connect(myGeoSatelliteInfoSource, SIGNAL(satellitesInUseUpdated(const QList<QGeoSatelliteInfo> &)), this, SIGNAL(satellitesInUseUpdated(const QList<QGeoSatelliteInfo> &)));
    connect(myGeoSatelliteInfoSource, SIGNAL(satellitesInUseUpdated(const QList<QGeoSatelliteInfo> &)), this, SLOT(onSatsInUseUpdated(const QList<QGeoSatelliteInfo> &)));

}

//I think this is the deconstructor
SatInfoSource::~SatInfoSource()
{
}

void SatInfoSource::startUpdates() {
    myGeoSatelliteInfoSource->startUpdates();
}

void SatInfoSource::stopUpdates() {
    myGeoSatelliteInfoSource->stopUpdates();
}

int SatInfoSource::satsInView() const
{
    return _satsInView;
}


int SatInfoSource::satsInUse() const
{
    return _satsInUse;
}


void SatInfoSource::onSatsInUseUpdated(const QList<QGeoSatelliteInfo> &list) {
    int newInView = list.count();
    if (newInView != _satsInUse) {
        qDebug() << "satInfoSource.cpp: onSatsinUseUpdated: " << QString::number(newInView, 'g', 2);
        _satsInUse = newInView;
        emit satellitesInUseChanged(newInView);
    }

}

void SatInfoSource::onSatsInViewUpdated(const QList<QGeoSatelliteInfo> &list) {
    int newInUse = list.count();
    if (newInUse != _satsInView) {
        qDebug() << "satInfoSource.cpp: onSatsinViewUpdated: " << QString::number(newInUse, 'g', 2);
        _satsInView = newInUse;
        emit satellitesInViewChanged(newInUse);
    }
}

