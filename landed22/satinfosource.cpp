#include "SatInfoSource.h"
#include <QDebug>

//The constructor
SatInfoSource::SatInfoSource(QObject *parent) :
    QObject(parent)
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
void SatInfoSource::onSatsInUseUpdated(const QList<QGeoSatelliteInfo> &list) {
    qDebug() << "satInfoSource: onSatsinUseUpdated";
    emit satellitesInUseUpdated(list.count());
}

void SatInfoSource::onSatsInViewUpdated(const QList<QGeoSatelliteInfo> &list) {
    qDebug() <<"satInfoSource: onSatsinViewUpdated";
    emit satellitesInViewUpdated(list.count());
}

