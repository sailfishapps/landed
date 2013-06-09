import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

AUISheet {id: thisSheet
    width: 480
    height: 854-35

    signal numberEntered(string phoneNumber)

    Component.onCompleted: {
        //set the initial tab and button selected
        tabGroup.currentTab = keyPadTab;
        tabButtonRow.checkedButton = button2;
    }

     //container for the 3 tab-pages
    AUITabGroup {id: tabGroup

        AUIPage {id: historyTab
            AUIButton{text: "historyTab"; y:200; anchors.horizontalCenter: parent.horizontalCenter;}
            //tools: commonTools
        }

        DialPage {id: keyPadTab
            onNumberEntered: {
                thisSheet.numberEntered(phoneNumber);
                thisSheet.close();
            }
            onCancelled: {
                thisSheet.close();
            }

        }

        ContactsPage {id: contactsTab
            AUIButton{text: "contactsTab"; y: 400; anchors.horizontalCenter: parent.horizontalCenter;}
            //tools: commonTools
        }
    }

    //the layout of toolbar: a row of 3 bottons
    AUIToolBarLayout {
        id: commonTools
        visible: true
        //height: 109;
        height: 74;
        //y:800;
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
                tab: historyTab;
                iconSource: "icon-m-toolbar-callhistory.png";
                onClicked: {console.log("button1.onClicked");
                }
            }
            AUITabButton { id: button2;
                visible: true;
                enabled: true;
                tab: keyPadTab;
                iconSource: "icon-m-toolbar-dialer.png";
                onClicked: {console.log("button2.onClicked");
                    console.log("commonTools.parent: " + commonTools.parent)
                }
            }
            AUITabButton { id: button3
                visible: true;
                enabled: true;
                tab: contactsTab;
                iconSource: "icon-m-toolbar-contact.png";
                onClicked: console.log("button3.onClicked");
            }
        }
    }
}
