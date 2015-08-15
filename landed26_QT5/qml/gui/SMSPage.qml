import QtQuick 2.0
//import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "../backend"
import "../javascript/landed.js" as LJS
import "../javascript/message.js" as MSG
import LandedTheme 1.0

//This should be split between gui (most of it) and a backend equivalent, or javascript)

AUIPage {id: smsPage

    orientationLock: AUIPageOrientation.LockPortrait
    showNavigationIndicator: true //sailfish

    property int toolbarHeight: 0
    property color pageColor: "black"
    property string lati
    property string longi
    property string alti
    property string area_id
    property string template_id
    property string msg_status
    property int fontPixelSize: 16
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
            console.log("smsPage is active; area_id: " + area_id + ", contactName: " + contactName + " , contactPhone: " + contactPhone + ", msg_status: " + msg_status + ", lastPage: " + lastPage)
            state = (msg_status == "Ok") ? "stateOk" : "stateNotOk";

            smsDisplay.smsSent = false;
            smsDisplay.setText(MSG.buildDefaultMsg(area_id, template_id, lati, longi, alti));
            if ((lastPage =="contactSelectionPage") && (contactSelected (contactName, contactPhone))) {
                console.log("Take the contact from the ContactSelectionPage");
                smsDisplay.setContact(contactName, contactPhone);
            }
            else if (lastPage == "mainPage") {
                console.log("Page has been pushed, take contact from Template")
                var rs = favouritesBackend.getPrimaryContact(area_id, template_id);
                contactName = rs.rows.item(0).name;
                contactPhone = rs.rows.item(0).phone;
                smsDisplay.setContact(contactName, contactPhone);
                smsDisplay.setState(null, "Ready");
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
            PropertyChanges{ target: smsPage; showNavigationIndicator: true }
            PropertyChanges{ target: smsDisplay; parent: smsPage }
            //PropertyChanges{ target: smsDisplay; anchors.top: parent.top }
            PropertyChanges{ target: smsDisplay; anchors.top: smsPage.top }
            PropertyChanges{ target: smsDisplay; anchors.topMargin: 30 }
            PropertyChanges{ target: smsDisplay; color: LandedTheme.BackgroundColorA }
            PropertyChanges{ target: torchApp; visible: false }
            PropertyChanges{ target: frame; color: LandedTheme.BackgroundColorA }
            PropertyChanges{ target: smsDisplay; textColor: LandedTheme.TextColorActive }
        },
        State {
            name: "stateNotOk";
            PropertyChanges{ target: smsPage; showNavigationIndicator: false }
            PropertyChanges{ target: smsDisplay; parent: frame }
            PropertyChanges{ target: smsDisplay; anchors.top: torchApp.bottom }
            PropertyChanges{ target: smsDisplay; anchors.topMargin: 0 }
            PropertyChanges{ target: smsDisplay; color: LandedTheme.BackgroundColorA }
            PropertyChanges{ target: torchApp; visible: true }
            PropertyChanges{ target: frame; color: LandedTheme.BackgroundColorD }
            PropertyChanges{ target: smsDisplay; textColor: LandedTheme.TextColorEmergency }
        }
    ]

    Rectangle { id: frame
        anchors.fill: parent;

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
        //anchors.top //set by state
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        //anchors.bottomMargin: defaultBottomMargin
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        fontPixelSize: smsPage.fontPixelSize
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
            console.log("about to send SMS to number: " + "tel:" + phoneNumber);
            smsBackEnd.sendSMS("tel:" + phoneNumber, text);
            //The old SMSHelper used to emit this state, as a temporary workaround, do it here
            //later we can add this to the TelepathyHelper
            setState("ActiveState", null)
        }
    }

    SMSBackEnd {
        id: smsBackEnd
        onMessageState: smsDisplay.setState(msgState, null);
    }

    FavouriteContactsBackEnd {
        id: favouritesBackend
    }

}

