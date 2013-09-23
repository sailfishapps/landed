import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import OperatingSystem 1.0
import WindowingSystem 1.0

/*
Setting up abstractui plugin library on SDK(s) during development: Creating sym link(s)

Rather than copying the components to the respective /imports directories, we create sym links to the abstractui project directories

For Harmattan
cd /Users/christopherlamb/QtSDK/Madde/sysroots/harmattan_sysroot_10.2011.34-1_slim/usr/lib/qt4/imports/
ln -s /Users/christopherlamb/QTProjects/abstractui/org org

For SailfishOS
cd /Users/christopherlamb/SailfishOS/mersdk/targets/SailfishOS-i486-x86/usr/lib/qt4/imports
ln -s /Users/christopherlamb/SailfishProjects/abstractui/org org

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
    property int largeFonts: (simulator == true) ? 11 : 26
    property int smallFonts: (simulator == true) ? 6 : 13

    //font { family: platformStyle.fontFamilyRegular; pixelSize: platformStyle.fontSizeLarge }

    //hack from http://forum.meego.com/showthread.php?t=3924 // to force black theme
    Component.onCompleted: {
        console.log("appWindow.onCompleted");
        //theme.inverted = true;
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
        onNextPage: {
            pageStack.push(smsSelectionPage)
        }
    }

    SMSSelectionPage {
        id: smsSelectionPage
        fontSize: appWindow.fontSize
        onNextPage: {
            if (pageType =="SMS") {
                console.log("smsType is: " + smsType)
                if (smsType =="Default") pageStack.push(defaultSMSPage, {lati: mainPage.getLati(), longi: mainPage.getLongi(), alti: mainPage.getAlti(), template_id: template_id, msg_status: msg_status, lastPage: "smsSelectionPage"})
                else if (smsType =="Custom") pageStack.push(customSMSPage);
            }
            else {
                pageStack.push(groupSelectionPage)
            }

        }
        onCancelled: pageStack.pop();
     }

    GroupSelectionPage {
        id: groupSelectionPage
        fontSize: appWindow.fontSize
        onNextPage: {
            pageStack.pop(smsSelectionPage)
        }
        onCancelled: pageStack.pop(smsSelectionPage);
     }

    DefaultSMSPage {
        id: defaultSMSPage     
        fontSize: appWindow.fontSize
        onCancelled: pageStack.pop(mainPage);
        onNextPage: {
            pageStack.push(contactSelectionPage, {template_id: template_id})
        }
     }

    ContactSelectionPage {
        id: contactSelectionPage
        fontSize: appWindow.fontSize
        onBackPage: {
            console.log("About to pop defaultSMSPage; contactName: " + contactName + ", contactPhone: " + contactPhone);
            defaultSMSPage.contactName = contactName;
            defaultSMSPage.contactPhone = contactPhone;
            defaultSMSPage.lastPage = "contactSelectionPage";
            pageStack.pop(defaultSMSPage);
        }
        onCancelled: pageStack.pop(defaultSMSPage);
     }

/*
Pre AbstractUI / Port to Sailfish the Toolbar and menu would have been here
and were available to all pages.
We now make this menu only avaliable on the MainPage.
This frees up screen real estate on other screens

    AUIToolBarLayout {
        id: commonTools
        visible: true
        AUIToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === AUIDialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    AUIMenu {
        id: myMenu
        visualParent: pageStack
        AUIMenuLayout {
            AUIMenuItem {
                 text: qsTr("Fake GPS Aquired");
                 onClicked: {
                     mainPage.fakeGPSAquired();
                 }
            }
            AUIMenuItem {
                 text: (appWindow.fontSize >= appWindow.largeFonts) ? qsTr("Small Fonts" ) : qsTr("Large Fonts");
                 onClicked: (appWindow.fontSize == appWindow.largeFonts) ? appWindow.fontSize = appWindow.smallFonts : appWindow.fontSize = appWindow.largeFonts;
            }
            AUIMenuItem {
                 text: qsTr("Increase fontSize");
                 onClicked: {
                    appWindow.fontSize++;
                    console.log ("fontSize is now: " + appWindow.fontSize + "; Operating System is: " + OSId)
                 }
            }
            AUIMenuItem {
                 text: qsTr("Decrease fontSize");
                 onClicked: {
                    appWindow.fontSize--;
                    console.log ("fontSize is now: " + appWindow.fontSize + "; Operating System is: " + OSId)
                 }
            }
        }
    }
*/

}
