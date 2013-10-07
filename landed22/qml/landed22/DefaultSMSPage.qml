import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import "settingsDB.js" as DB

//TODO:
//1) Add a state, normal and SOS
//2) In SOS state, add button across top of screen to flash led
//3) consider if a clear method is needed after leaving contact selection screen, may cure 4
//4) sometimes the contact Stefan Thur is displayed twice, after flipping back and forth


AUIPage {id: pageDefaultSMS
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
        console.log("pageDefaultSMS.onCompleted");
    }

    function trim (str){
        //http://blog.stevenlevithan.com/archives/faster-trim-javascript
        return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
    }

    function contactSelected (contactName, contactPhone) {
        return ((trim(contactPhone).length > 0) && (trim(contactPhone).length > 0)) ? true : false
    }

    onStatusChanged: {
        if (status == AUIPageStatus.Active) {
            console.log("pageDefaultSMS is active; contactName: " + contactName + " , contactPhone: " + contactPhone + ", msg_status: " + msg_status + ", lastPage: " + lastPage)
            state = (msg_status == "Ok") ? "stateOk" : "stateNotOk";

            thisSMSApp.smsSent = false;
            thisSMSApp.setText(buildDefaultMsg(template_id));
            if ((lastPage =="contactSelectionPage") && (contactSelected (contactName, contactPhone))) {
                console.log("Take the contact from the ContactSelectionPage");
                thisSMSApp.setContact(contactName, contactPhone);
            }
            else if (lastPage == "smsSelectionPage") {
//TODO: below is how we prefill the contact if in default mode
//In Custom Mode I suggest we do a seclect distinct of the OK and NotOK contacts for the template_id
//AND allow the user to override the number by using the keypad.
                console.log("Page has been pushed, take contact from Template")
                var rs = getContact(template_id);
                contactName = rs.rows.item(0).name;
                contactPhone = rs.rows.item(0).phone;
                thisSMSApp.setContact(contactName, contactPhone);
            }
        }
        else if (status == AUIPageStatus.Inactive) {
            console.log("pageDefaultSMS is inactive");
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
            PropertyChanges{ target: thisSMSApp; parent: pageDefaultSMS }
            PropertyChanges{ target: thisSMSApp; anchors.top: parent.top }
            PropertyChanges{ target: torchApp; visible: false }
            PropertyChanges{ target: frame; color: "black" }
            PropertyChanges{ target: pageDefaultSMS; height: 828 }

        },
        State {
            name: "stateNotOk";
            PropertyChanges{ target: thisSMSApp; parent: frame }
            PropertyChanges{ target: thisSMSApp; anchors.top: torchApp.bottom }
            PropertyChanges{ target: torchApp; visible: true }
            PropertyChanges{ target: frame; color: "red" }
            PropertyChanges{ target: pageDefaultSMS; height: 818 }
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

    SMSApp{id: thisSMSApp
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
        fontSize: pageDefaultSMS.fontSize
        opacity: 1

        onCancelled: {
            console.log("cancelled Signal received by DefaultSMSPage");
            pageDefaultSMS.cancelled();
            //reset the state, so next time we enter we don't see a brief state change
            pageDefaultSMS.state = "stateOk";
        }
        onPhoneNrClicked: {
            nextPage("Contact", template_id);
        }

    }

    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////
    //Message related components and functions
    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////

    function buildDefaultMsg(template_id) {
        var text = "";
        var tag = "";
        var rs = DB.getTags(template_id);
        for(var i = 0; i < rs.rows.length; i++) {
            tag = rs.rows.item(i).default_value;
            tag = swapPlaceHolders(tag) + "\n";
            text = text + tag;
        }
        return text;

    }

    function swapPlaceHolders (tag) {
        var headerTag = "@header@";
        var latiTag = "@lati@";
        var longiTag = "@longi@";
        var altiTag = "@alti@";
        var datetime = "@datetime@"

        if (tag == headerTag) {
            return "*Landed*";
        }if (tag == latiTag) {
            return lati;
        }
        else if (tag == longiTag) {
            return longi;
        }
        else if (tag == altiTag) {
            return alti;
        }
        else if (tag == datetime) {
            var today = new Date();
            return Qt.formatDateTime(today, "dd.MM.yyyy hh:mm:ss")
            //today;
        }
        else return tag;
    }

    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////
    //Phone Number / Contact functions
    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////


    function getContact(template_id) {
        var rs = DB.getActiveContact(template_id, 1);
        return rs;
    }

    function getPhoneNr(template_id) {
        var rs = DB.getContacts(template_id);
        return rs;
    }

}
