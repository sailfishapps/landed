//Installation requirements
//1) latest version of AbstractUI for Sailfish must be installed
//2) To access the phone's contacts, the app must be added ot mapplauncherd privileges file
//  as user root:
//  cd /usr/share/mapplauncherd
//  echo /usr/bin/landed26_QT5,p >> privileges


//TODOs
//a) find out why beeping on PhoneKey does not work: possibly wav not found

//Future Changes
//v) consider saving contacts chosen from phone to Landed contacts
//d) If Phone contact has only one number, then take that without showing the selection dialog
//i) create settingsPage with following
//i.1) launch LandedSettings
//i.2) GPS on / off on start
//1.3) GPS Coords decimal / D M S
//i.4) enable access to phone contacts
//i.5) time for GPS auto off
//i.6) limit time for GPS averaging / number of hits
//1.7) error range for GPS averaging
//1.8) beeping on keypress (PhoneKey)


//Change History
//Landed26
//This is the first version with Sailfish in primary focus. The aim is porting, not adding new functionality (though some may creep in ...)
//In terms of functionality it should give equivalent functionality to Landed25 on Harmattan.
//The Harmattan version backports some refactorings / bug-fixes made while porting to Harmattan
//and some changes made to maintain (in as far as is possible) a common code base.
//a) jsonpath added: originally the idea was that a json file could be used to load the LocalStorageDB in a human-readable format.
//   However as the datamodel is simple enough, we now use json as an alternative to the LocalStorageDB!
//   The qml code does not care if the datasource is json or LocalStorage. This is handled black-box in readDataModel.js

//Landed25
//This (and all previous) versions were for the Harmattan platform, although this version already
//includes many changes made with a view to porting to Sailfish.
//The Sailfish version of Landed25 was a "work-in-progress" version with only the most important functionality supported.
//a) phone contacts are now dynamically loaded when PhoneContactsPage is visible, not on app start.
//  This is a workaround for the error: libqtcontacts-tracker: queue.cpp:104: The taskqueue's background thread stalled
//  which sometimes prevented the app GUI from being displayed (while leaving the app running in the background)
//b) SMSes now sent direct via TelepathyQt, rather than via Qt Mobility Messaging
//   This is because
//   1) App now starts in a third of the time
//   2) We only used a fraction of Qt Mobility functionality
//   3) Qt Mobility also depends on libqtcontacts-tracker, and can give the same error as above
//   4) Qt Mobility cannot be directly migrated to Sailfish - so we needed to find something else.
//c) PhoneContactsPage now has a Slider Scroll control to allow fast selection of initial letter.
//d) The PhoneContactDialog is now a child of PhoneContactsPageContent, and not of PhoneContactsDelegate.
//   this is to speed scrolling of the ContactsListView
//e) SearchBox and search functionality added to PhoneContacts
//f) PhoneContacts now loaded to an adapter model, and manipulated through the adapter
//g) added alphabet scrolling to right of ContactsPage to allow fast scrolling to corect initial letter of contact name


//Landed24
//a) move GUI and backend components to separate directories, further refactoring of BackEnd and GUI components
//b) move all icons to icons subdirectory.
//c) basic splashscreen added
//d) Bugfix: coordinate averaging fixed
//e) Bugfix: close button for visual keyboard visible on Help me SMS.
//f) flashing functionality (inc Timer) migrated from QML to C++ plugin LandedTorch

//Landed23
//a) Major refactoring of former GPSApp components:
//   This is now divided into GPSBackEnd and GPSDisplay components
//   The idea is ease porting to Sailfish etc. by separating User Interface Components as much as possible from "BackEnd"
//   functionality. This would allow for different UIs on different Qt platforms while maintaining common BackEnd.
//b) Refactoring of CompassApp into GPSBackEnd / Display. this app is not important enough to be an own component
// and is close enough to GPS to be merged.
//c) All QtMobility / Multimedia stuff moved into org.flyingsheep.abstractui.backend 1.0 to abstract the import calls

//Landed22
//a) explict customSMSPage removed (precursor to making text editable)
//   (i.e. are prefilled with text and primary contact, but both text and contact can be changed)
//b) remove ButtonStyle components as this functionality is now handled by AbstractUI
//c) make the Dialer available from the contacts selection page to allow dialing of a custom number not stored in the contacts
//d) make the phone's contacts available (work in progress, not finished yet)
//e) change from a black to a grey colour scheme (the tabs looked shit in black)
//f) added latitude and longitude to group, display this for current group on SMSSelectionPage
//g) based on saved latitude and longitudes of group, automatically set current group to the closest.
//h) added landed.js for support functions (imported to GPSApp.qml, SMSSelectionPage.qml
//i) merge mainpage and SMSSelectionPage (reduces one button press) --> SMS Buttons now on mainPage
//j) fully remove custom functionality (custom button et al.)
//k) allow switching of coords format from decimal to deg min sec by pressing on GPSApp
//l) Number of Sats in View / Use added from plugin SatInfoSource
//m) GPSApp labels and text separated, allowing different colors for lables and text
//n) alignment / margins of texts, buttons, headers made consistent
//o) GroupRadioButton and ContactRadioButtons now use SimpleHeader rather than TemplateButtonHeader?
//p) templateButtonsHeader displays location coords, distance on a second line (subHeader)
//q) mainpage Compass and CompassText integrated into one component CompassApp
//r) switch control added to GPSApp allowing easy switching on and off of the GPS (to save power)
//s) switch control added to CompassApp allowing easy switching on and off of the Compass (to save power)
//t) decreased font size on GPSApp to increase clarity and make more space
//u) added title bar to MainPage. This will probably host the icon for the settings page in the future
//v) Coordinate Averaging added (lati and longi are an average of multiple hits), can be turned on / off
//w) SMS text is now editable, Close Keyboard button added
//x) Selection of contacts from phone's contact is now works!!!!
//y) in AbastractUI, AUISelectionDialog replaces SelectionDialog. (used by ContactsPage)
//z) renamed ContactsPage to PhoneContactsPage to distinguish from contacts stored in Landed.
//aa) refactoring of MainPage.qml and GPSApp.qml

//Landed21
//a) Move ButtonStyle functionality to AbstractUI (as Sailfish does not have such components)
//Introduce Button primaryColor property instead:
//  In Harmattan sets the buttonStyle (and thus background color)
//  In Sailfish sets the color of the button text



#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <QGuiApplication>
#include <QQuickView>
#include <QQmlContext>

#include <sailfishapp.h>

//#include "landedtorch.h" //harmattan
#include "gsttorch.h" //sailfish
#include "satinfosource.h"
#include "operatingsystem.h"
#include "windowingsystem.h"
#include "telepathyhelper.h"
#include "landedtheme.h"
#include  "jsonstorage.h"

//HELPER Functions getting system information which will be exported to QML

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

static QObject *theme_singletontype_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    LandedTheme *landedTheme = new LandedTheme();
    return landedTheme;
}

static QObject *jsonStorage_singletontype_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    JSONStorage *jsonStorage = new JSONStorage();
    return jsonStorage;
}

int main(int argc, char *argv[])
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

//TODO: if both harmattan and sailfish import to QML as Torch, and offer the same apis
//then we can hide from the QML code that we are using 2 different C++ implementations!
    //qmlRegisterType<LandedTorch>("LandedTorch",1,0,"LandedTorch"); //harmattan
    qmlRegisterType<GstTorch>("GstTorch",1,0,"GstTorch");
    qmlRegisterType<TelepathyHelper>("TelepathyHelper",1,0,"TelepathyHelper");
    qmlRegisterType<SatInfoSource>("SatInfoSource",1,0,"SatInfoSource");
    qmlRegisterSingletonType<LandedTheme>("LandedTheme", 1, 0, "LandedTheme", theme_singletontype_provider);
    qmlRegisterSingletonType<JSONStorage>("JSONStorage",1,0,"JSONStorage", jsonStorage_singletontype_provider);

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    view->rootContext()->setContextProperty("OperatingSystemId",  OperatingSystemId);
    view->rootContext()->setContextProperty("WindowingSystemId",  WindowingSystemId);
    view->rootContext()->setContextProperty("simulator",  simulator);

    //change the directory where the shared DB is stored, Sailfish as standard stores in the application install directory
    //Landed shared the LocalStorage DB with LandedSettings
    qDebug() << "offlineStoragPath orig: " << view->engine()->offlineStoragePath();
    QString storagePath = QStandardPaths::locate(QStandardPaths::GenericDataLocation, QString(), QStandardPaths::LocateDirectory) + "landedcommon";
    view->engine()->setOfflineStoragePath(storagePath);
    qDebug() << "offlineStoragPath new: " << view->engine()->offlineStoragePath();

    view->setSource(SailfishApp::pathTo("qml/landed26_QT5.qml"));
    view->show();
    view->showFullScreen();
    return app->exec();

}

