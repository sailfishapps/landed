#include <QtGui/QApplication>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"

#include "landedtorch.h"
#include "operatingsystem.h"
#include "windowingsystem.h"

#  define Q_MESSAGING

#ifdef Q_MESSAGING
    #include "smshelper.h"
#endif

//HELPER Functions getting system information which will be exported to QML
    //DEFS from /Users/christopherlamb/QtSDK/Madde/sysroots/harmattan_sysroot_10.2011.34-1_slim/usr/include/qt4/Qt/qglobal.h
    //or //Users/christopherlamb/SailfishOS/mersdk/targets/SailfishOS-i486-x86/usr/include/qt4/Qt/qglobal.h

bool isSimulator()
{
    bool simulator;
    #if defined(QT_SIMULATOR)
        simulator = true;
    #else
        // real device or emulator
        simulator = false;
    #endif
    return simulator;
}

int getOperatingSystem()
{
    //C++ representation of the OperatingSystem enumg
    const OperatingSystem Os;
    int OSId;
    #if defined(Q_OS_SYMBIAN)
        OSId = Os.Symbian;
    #elif defined(Q_OS_MAC64)
        OSId = Os.Mac64;
    #elif defined(Q_OS_UNIX)
        OSId = Os.Unix;
    #elif defined(Q_OS_WIN32)
        OSId = Os.Win32;
    #elif defined(Q_OS_WIN64)
        OSId = Os.Win64;
    #elif defined(Q_OS_WINCE)
        OSId = Os.WinCE;
    #elif defined(Q_OS_SIMULATOR)
        OSId = Os.Simulator;
    #else
        // other OS
        OSId = Os.Other;
    #endif
    return OSId;
}

int getWindowingSystem()
{
    //C++ representation of the WindowingSystem enum
    const WindowingSystem Ws;
    int WindowSysId;

    #if defined(Q_WS_MAEMO_5)
        WindowSysId = Ws.Maemo5;
    #elif defined(Q_WS_MAEMO_6)
        WindowSysId = Ws.Maemo6;
    #elif defined(Q_WS_MEEGO)
        WindowSysId = Ws.Meego;
    #elif defined(Q_WS_SIMULATOR)
        WindowSysId = Ws.Simulator;
    #elif defined(Q_WS_WIN)
        WindowSysId = Ws.Win;
    #elif defined(Q_WS_WINCE)
        WindowSysId = Ws.WinCE;
    #elif defined(Q_WS_MAC)
        WindowSysId = Ws.Mac;
    #elif defined(Q_WS_QWS)
        WindowSysId = Ws.QWS;
    #elif defined(Q_WS_QPA)
        WindowSysId = Ws.QPA;
    #elif defined(Q_WS_X11)
        WindowSysId = Ws.X11;
    #else
        // not known
        WindowSysId = Ws.Other;
    #endif

    return WindowSysId;
}
//END HELPER Functions


Q_DECL_EXPORT int main(int argc, char *argv[])
{

    bool simulator = isSimulator();

    //expose an enum of operating systems types to QML
    qmlRegisterUncreatableType<OperatingSystem>("OperatingSystem", 1, 0, "OperatingSystem", "");
    int OperatingSystemId = getOperatingSystem();

    //expose an enum of windowing system types to QML
    qmlRegisterUncreatableType<WindowingSystem>("WindowingSystem", 1, 0, "WindowingSystem", "");
    int WindowingSystemId = getWindowingSystem();

    /*
    QT Simulator running on OSX gives:
    simulator is : true
    operating system is : Mac64 --> Q_OS_MAC64
    windowing system is : Simulator --> Q_WS_SIMULATOR)

    SailfishOS Emulator hosted on OSX gives:
    simulator is : false
    operating system is : Unix --> Q_OS_UNIX
    windowing system is : X11 --> Q_WS_X11

    Nokia N9 Harmattan gives:
    simulator is : false
    operating system is : Unix --> Q_OS_UNIX
    windowing system is : X11 --> Q_WS_X11
    */

    QScopedPointer<QApplication> app(createApplication(argc, argv));
    #ifdef Q_MESSAGING
        qmlRegisterType<SMSHelper>("SMSHelper",1,0,"SMSHelper");
    #endif
    qmlRegisterType<LandedTorch>("LandedTorch",1,0,"LandedTorch");
    //qmlRegisterUncreatableType<SysInf>("SysInf", 1, 0, "SysInf", "Expose System Info to QML");

    QmlApplicationViewer viewer;
    viewer.rootContext()->setContextProperty("OperatingSystemId",  OperatingSystemId);
    viewer.rootContext()->setContextProperty("WindowingSystemId",  WindowingSystemId);
    viewer.rootContext()->setContextProperty("simulator",  simulator);
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/landed21/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
