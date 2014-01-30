import QtQuick 2.0
//import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

//gives access to contacts (landed favourites, dialer, phone contacts)

AUIPage {id: pageContactSelection

    property string template_id

    //width: 480
    //height: 828
    //height: 740
    orientationLock: AUIPageOrientation.LockPortrait

    property int toolbarHeight: 0
    //property int toolbarHeight: 110
    backgroundColor: "lightgrey"
    property int itemHeight: 100;
    property int headerHeight: itemHeight;
    property int fontSize: 30
    property color labelColorActive

    signal backPageWithInfo(string contactName, string contactPhone)
    signal cancelled()

    Component.onCompleted: {
        console.log("pageContactSelection.onCompleted")
        //set the initial tab and button selected
        tabGroup.currentTab = favouriteTab;
        tabButtonRow.checkedButton = button1;
    }

    onStatusChanged: {
        if (status == AUIPageStatus.Active)  {
            console.log ("Contact Selection Page now active with template_id: " + template_id)
            favouriteTab.populate(template_id)
        }
    }

    //container for the 3 tab-pages
    AUITabGroup {id: tabGroup
        anchors.top: parent.top
        anchors.bottom: tabBar.top
        width: parent.width

        FavouriteContactsPage { id: favouriteTab
            anchors.top: tabGroup.top
            anchors.bottom: tabGroup.bottom
            fontSize: pageContactSelection.fontSize
            itemHeight: pageContactSelection.itemHeight
            headerHeight: pageContactSelection.headerHeight
            backgroundColor: pageContactSelection.backgroundColor
            labelColorActive: pageContactSelection.labelColorActive

            onContactSelected: {
                pageContactSelection.backPageWithInfo(name, phoneNumber)
            }
            onCancelled: {
                pageContactSelection.cancelled();
            }
        }

        PhoneDialer {id: keyPadTab
            anchors.topMargin: 60
            anchors.top: tabGroup.top
            anchors.bottom: tabGroup.bottom
            width: tabGroup.width
            //width: pageContactSelection.width
            onNumberEntered: {
                pageContactSelection.backPageWithInfo("Custom number", phoneNumber)
            }
            onCancelled: {
                pageContactSelection.cancelled();
            }
        }

        PhoneContactsPage {id: contactsTab
            anchors.topMargin: 60
            onContactSelected: {
                pageContactSelection.backPageWithInfo(name, phoneNumber)
            }
        }
    }
    Rectangle {
        id: tabBar
        //color: "grey"
        color: "black"
        visible: true
        //height: 109;
        height: 74;
        width: parent.width
        anchors.bottom: parent.bottom;

        AUIButtonRow {id: tabButtonRow
            visible: true;
            enabled: true;
            anchors.bottom: parent.bottom;
            height: parent.height;
            width: parent.width;

            AUITabButton { id: button1;
                visible: true;
                enabled: true;
                tab: favouriteTab;
                iconSource: "icons/icon-m-toolbar-favorite-mark-white.png";
                onClicked: {console.log("button1.onClicked");
                }
            }
            AUITabButton { id: button2;
                visible: true;
                enabled: true;
                tab: keyPadTab;
                iconSource: "icons/icon-m-toolbar-dialer-white.png";
                onClicked: {
                    console.log("button2.onClicked");
                }
            }
            AUITabButton { id: button3
                visible: true;
                enabled: true;
                tab: contactsTab;
                iconSource: "icons/icon-m-toolbar-contact-white.png";
                onClicked: console.log("button3.onClicked");
            }
        }
    }
}
