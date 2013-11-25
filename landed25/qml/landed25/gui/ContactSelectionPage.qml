import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

//gives access to contacts (landed favourites, dialer, phone contacts)

AUIPage {id: pageContactSelection

    property string template_id

    width: 480
    height: 828
    //height: 740
    orientationLock: AUIPageOrientation.LockPortrait

    property int toolbarHeight: 0
    //property int toolbarHeight: 110
    backgroundColor: "lightgrey"
    property int itemHeight: 100;
    property int headerHeight: itemHeight;
    property int fontSize: 30
    property color labelColorActive

    signal backPage(string contactName, string contactPhone)
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

        FavouriteContactsPage { id: favouriteTab

            fontSize: pageContactSelection.fontSize
            itemHeight: pageContactSelection.itemHeight
            headerHeight: pageContactSelection.headerHeight
            backgroundColor: pageContactSelection.backgroundColor
            labelColorActive: pageContactSelection.labelColorActive

            onContactSelected: {
                pageContactSelection.backPage(name, phoneNumber)
            }
            onCancelled: {
                pageContactSelection.cancelled();
            }
        }

        PhoneDialer {id: keyPadTab
            onNumberEntered: {
                pageContactSelection.backPage("Custom number", phoneNumber)
            }
            onCancelled: {
                pageContactSelection.cancelled();
            }
        }

        PhoneContactsPage {id: contactsTab
            onContactSelected: {
                pageContactSelection.backPage(name, phoneNumber)
            }
        }
    }
    Rectangle {
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
                iconSource: (theme.inverted) ? "icons/icon-m-toolbar-favorite-mark-white.png" : "icons/icon-m-toolbar-favorite-mark.png";
                onClicked: {console.log("button1.onClicked");
                }
            }
            AUITabButton { id: button2;
                visible: true;
                enabled: true;
                tab: keyPadTab;
                iconSource: (theme.inverted) ? "icons/icon-m-toolbar-dialer-white.png": "icons/icon-m-toolbar-dialer.png";
                onClicked: {
                    console.log("button2.onClicked");
                }
            }
            AUITabButton { id: button3
                visible: true;
                enabled: true;
                tab: contactsTab;
                iconSource: (theme.inverted) ? "icons/icon-m-toolbar-contact-white.png" : "icons/icon-m-toolbar-contact.png";
                onClicked: console.log("button3.onClicked");
            }
        }
    }
}
