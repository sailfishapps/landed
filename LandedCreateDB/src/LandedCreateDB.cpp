#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>


int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());
    qDebug() << "offlineStoragPath orig: " << view->engine()->offlineStoragePath();
    QString storagePath = QStandardPaths::locate(QStandardPaths::GenericDataLocation, QString(), QStandardPaths::LocateDirectory) + "landedcommon";
    view->engine()->setOfflineStoragePath(storagePath);
    qDebug() << "offlineStoragPath new: " << view->engine()->offlineStoragePath();
    view->setSource(SailfishApp::pathTo("qml/LandedCreateDB.qml"));
    view->show();
    view->showFullScreen();
    return app->exec();
}

