#ifndef SATINFOSOURCE_H
#define SATINFOSOURCE_H


#include <QObject>


#include <QtLocation/QGeoSatelliteInfoSource>

// macro for Qt Mobility namespace
QTM_USE_NAMESPACE


class SatInfoSource : public QObject
{
    Q_OBJECT

public:
    explicit SatInfoSource(QObject *parent = 0);
    ~SatInfoSource();

    Q_INVOKABLE void startUpdates();
    Q_INVOKABLE void stopUpdates();

signals:
    //void satellitesInViewUpdated(const QList<QGeoSatelliteInfo> &list);
    //void satellitesInUseUpdated(const QList<QGeoSatelliteInfo> &list);
    void satellitesInViewUpdated(const int &satsInView);
    void satellitesInUseUpdated(const int &satsInUse);

private slots:
    void onSatsInViewUpdated(const QList<QGeoSatelliteInfo> &list);
    void onSatsInUseUpdated(const QList<QGeoSatelliteInfo> &list);

private:

     QGeoSatelliteInfoSource *myGeoSatelliteInfoSource;
};

#endif // SATINFOSOURCE_H
