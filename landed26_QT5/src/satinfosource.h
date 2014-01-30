#ifndef SATINFOSOURCE_H
#define SATINFOSOURCE_H


#include <QObject>


//#include <QtLocation/QGeoSatelliteInfoSource>
#include <QtPositioning/QGeoSatelliteInfoSource>


class SatInfoSource : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int satsInView READ satsInView NOTIFY satellitesInViewChanged)
    Q_PROPERTY(int satsInUse READ satsInUse NOTIFY satellitesInUseChanged)


public:
    explicit SatInfoSource(QObject *parent = 0);
    ~SatInfoSource();

    Q_INVOKABLE void startUpdates();
    Q_INVOKABLE void stopUpdates();

    int satsInView() const;
    int satsInUse() const;

signals:
    void satellitesInViewChanged(const int &satsInView);
    void satellitesInUseChanged(const int &satsInUse);


private slots:
    void onSatsInViewUpdated(const QList<QGeoSatelliteInfo> &list);
    void onSatsInUseUpdated(const QList<QGeoSatelliteInfo> &list);

private:

     QGeoSatelliteInfoSource *myGeoSatelliteInfoSource;
     int _satsInUse;
     int _satsInView;

};

#endif // SATINFOSOURCE_H
