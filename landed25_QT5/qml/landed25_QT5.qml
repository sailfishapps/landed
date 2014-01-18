import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import org.flyingsheep.abstractui.backend 1.0
//import org.flyingsheep.abstractui.qtquick 1.0
//import com.nokia.meego 1.0
import OperatingSystem 1.0
import WindowingSystem 1.0
import "gui"

//If we could get rid of the Component.onCompleted call, then we could removed the import of QtQuick
//Can I move Component.onCompleted  to AUI, and offer a signal on this event?

/*
Setting up abstractui plugin library on SDK(s) during development: Creating sym link(s)

Rather than copying the components to the respective /imports directories, we create sym links to the abstractui project directories

For Harmattan
cd ~/QtSDK/Madde/sysroots/harmattan_sysroot_10.2011.34-1_slim/usr/lib/qt4/imports/
ln -s ~/QTProjects/abstractui/org org

For SailfishOS Qt5 Alpha 3
cd ~/SailfishOS/mersdk/targets/SailfishOS-i486-x86/usr/lib/qt5/qml/org
ln -s ~/SailfishProjects/abstractui/org/flyingsheep flyingsheep

This means that any changes made to the abstractui project are immediately available to the Harmattan / SailfishOS SDKs
and avoids the need to copy files about / or the dangers or "which version am I running".

Note: the plugin library still needs installing on the physical device / Emulator itself
*/

AUIPageStackWindow {
    id: appWindow

    property int fontSize: largeFonts;
    //Note for some reason on the simulator (platform = 4), fonts are 2 1/3 larger than the N9 and QEMU, and thus smaller sizes must be used.
    //property int largeFonts: (platform == 4) ? 11 : 26
    //property int smallFonts: (platform == 4) ? 6 : 13
    //property int largeFonts: (simulator == true) ? 11 : 26
    property int largeFonts: (simulator == true) ? 8 : 22
    property int smallFonts: (simulator == true) ? 6 : 13
    //property color backgroundColor: (theme.inverted) ? "black" :"lightgrey"
    property color backgroundColor: "transparent"

    /*
    // For Harmattan switch color scheme according to dark or light theme
    property color textColorActive: (theme.inverted) ? "lightgreen" : "darkgreen"
    property color textColorInactive: (theme.inverted) ? "grey" : "grey"
    property color labelColorActive: (theme.inverted) ? "darkgrey" : "black"
    property color labelColorInactive: (theme.inverted) ?  "grey" : "darkgrey"
    */
    property color textColorActive: "lightgreen"
    property color textColorInactive: "grey"
    property color labelColorActive: "darkgrey"
    property color labelColorInactive: "grey"

    //font { family: platformStyle.fontFamilyRegular; pixelSize: platformStyle.fontSizeLarge }

    //hack from http://forum.meego.com/showthread.php?t=3924 // to force black theme
    Component.onCompleted: {
        console.log("appWindow.onCompleted");
//        theme.inverted = true;
        console.log("simulator is : " + simulator);
        console.log("operating system is : " + OperatingSystemId);
        console.log("windowing system is : " + WindowingSystemId);
        console.log("First SysInf Test : " + OperatingSystem.Unix)
        console.log("Second SysInf Test : " + WindowingSystem.X11)
    }

    initialPage: mainPage

    MainPage {
        id: mainPage
        fontSize: appWindow.fontSize
        backgroundColor: appWindow.backgroundColor
        textColorActive: appWindow.textColorActive
        textColorInactive: appWindow.textColorInactive
        labelColorActive: appWindow.labelColorActive
        labelColorInactive: appWindow.labelColorInactive
        onNextPage: {
             if (pageType =="SMS") {
                console.log("smsType is: " + smsType)
                if (smsType =="Default") pageStack.push(smsPage, {lati: mainPage.getLati(), longi: mainPage.getLongi(), alti: mainPage.getAlti(), template_id: template_id, msg_status: msg_status, lastPage: "mainPage"})
            }
            else {
                pageStack.push(groupSelectionPage)
            }
        }
    }

    GroupSelectionPage {
        id: groupSelectionPage
        fontSize: appWindow.fontSize
        backgroundColor: appWindow.backgroundColor
        labelColorActive: appWindow.labelColorActive
        onBackPageWithInfo: {
            mainPage.groupSet = true;
            pageStack.pop(mainPage);
        }
        onCancelled: pageStack.pop(mainPage);
     }

    SMSPage {
        id: smsPage
        fontSize: appWindow.fontSize
        onCancelled: pageStack.pop(mainPage);
        onNextPage: {
            pageStack.push(contactSelectionPage, {template_id: template_id})
        }
     }
/*
    ContactSelectionPage {
        id: contactSelectionPage
        fontSize: appWindow.fontSize
        backgroundColor: appWindow.backgroundColor
        labelColorActive: appWindow.labelColorActive
        onBackPage: {
            console.log("About to pop smsPage; contactName: " + contactName + ", contactPhone: " + contactPhone);
            smsPage.contactName = contactName;
            smsPage.contactPhone = contactPhone;
            smsPage.lastPage = "contactSelectionPage";
            pageStack.pop(smsPage);
        }
        onCancelled: pageStack.pop(smsPage);
     }
*/
}
