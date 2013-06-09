#include <QtGui/QApplication>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{

#if defined(Q_OS_SYMBIAN)
    int platformId = 0;
#elif defined(Q_WS_MAEMO_5)
    int platformId = 1;
#elif defined(Q_WS_MAEMO_6)
    int platformId = 2;
#elif defined(QT_WS_SIMULATOR)
    int platformId = 3;
#elif defined(QT_SIMULATOR)
    int platformId = 4;
#elif defined(Q_OS_MAC64)
    int platformId = 5;
#elif defined(Q_WS_MEEGO)
    int platformId = 6;
#else
    // desktop probably
    int platformId = 99;
#endif


    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;
    viewer.rootContext()->setContextProperty("platform",  platformId);
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/landedsettings21/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
