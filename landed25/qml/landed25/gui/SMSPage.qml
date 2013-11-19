//import QtQuick 2.0
import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "../backend"
import "../javascript/landed.js" as LJS
import "../javascript/message.js" as MSG

//This should be split between gui (most of it) and a backend equivalent, or javascript)

AUIPage {id: smsPage
    //tools: commonTools
    width: 480
    height: 828
    //height: 748 //height with toolbar
    orientationLock: AUIPageOrientation.LockPortrait

    property int toolbarHeight: 0
    //property int toolbarHeight: 110
    property color pageColor: "black"

    property string lati
    property string longi
    property string alti
    property string template_id
    property string msg_status
    property int fontSize: 16
    property string lastPage
    property string contactName
    property string contactPhone

    signal nextPage(string pageType, string template_id)
    signal cancelled()

    Component.onCompleted: {
        console.log("smsPage.onCompleted");
    }

    function contactSelected (contactName, contactPhone) {
        return ((LJS.trim(contactName).length > 0) && (LJS.trim(contactPhone).length > 0)) ? true : false
    }

    onStatusChanged: {
        if (status == AUIPageStatus.Active) {
            console.log("smsPage is active; contactName: " + contactName + " , contactPhone: " + contactPhone + ", msg_status: " + msg_status + ", lastPage: " + lastPage)
            state = (msg_status == "Ok") ? "stateOk" : "stateNotOk";

            smsDisplay.smsSent = false;
            smsDisplay.setText(MSG.buildDefaultMsg(template_id, lati, longi, alti));
            if ((lastPage =="contactSelectionPage") && (contactSelected (contactName, contactPhone))) {
                console.log("Take the contact from the ContactSelectionPage");
                smsDisplay.setContact(contactName, contactPhone);
            }
            else if (lastPage == "mainPage") {
                console.log("Page has been pushed, take contact from Template")
                var rs = favouritesBackend.getContact(template_id);
                contactName = rs.rows.item(0).name;
                contactPhone = rs.rows.item(0).phone;
                smsDisplay.setContact(contactName, contactPhone);
            }
        }
        else if (status == AUIPageStatus.Inactive) {
            console.log("smsPage is inactive");
            //lati = "";
            //longi = "";
            contactName = "";
            contactPhone = "";
        }
    }

    state: "stateOk";
    states: [
        State {
            name: "stateOk";
            PropertyChanges{ target: smsDisplay; parent: smsPage }
            PropertyChanges{ target: smsDisplay; anchors.top: parent.top }
            PropertyChanges{ target: torchApp; visible: false }
            PropertyChanges{ target: frame; color: "black" }
            PropertyChanges{ target: smsPage; height: 828 }

        },
        State {
            name: "stateNotOk";
            PropertyChanges{ target: smsDisplay; parent: frame }
            PropertyChanges{ target: smsDisplay; anchors.top: torchApp.bottom }
            PropertyChanges{ target: torchApp; visible: true }
            PropertyChanges{ target: frame; color: "red" }
            PropertyChanges{ target: smsPage; height: 818 }
        }
    ]

    Rectangle { id: frame
        anchors.fill: parent;
        //anchors.margins: {left: 5; right: 5; top:5; bottom: 5}
        color: "red"

        TorchApp { id: torchApp
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5
            height: 100
            anchors.top: parent.top
            anchors.topMargin: 5
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////
    //SMS related components and functions
    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////

    SMSDisplay{id: smsDisplay
        //property int defaultBottomMargin: 0
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        //anchors.bottomMargin: defaultBottomMargin
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
        //color: set by states
        color: "black"
        fontSize: smsPage.fontSize
        opacity: 1
        onCancelled: {
            console.log("cancelled Signal received by smsPage");
            smsPage.cancelled();
            //reset the state, so next time we enter we don't see a brief state change
            smsPage.state = "stateOk";
        }
        onPhoneNrClicked: {
            nextPage("Contact", template_id);
        }
        onSendSMS: {
            smsBackEnd.sendSMS(phoneNumber, text);
        }
    }

    SMSBackEnd {
        id: smsBackEnd
        onMessageState: smsDisplay.setState(msgState);
    }

    FavouriteContactsBackEnd {
        id: favouritesBackend
    }

}
