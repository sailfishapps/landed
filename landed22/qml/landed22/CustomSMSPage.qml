//consider here if we really need a separate custom page,
// or if we cannot add the custom functionality to the DefaultSMSPage with a Custom State
//The main difference seems to be that
// a) this page has explicit onKeysOpened/Closed event handlers
// on the SMSApp instance.
// b) SMSApp.simpleMode = false --> surely we can set this via the state of DefaultSMSPage

//Action plan
//1) when custom button pressed, open DefaultSMSPage


//BIG QUESTION!!!!
//Do we need a custom mode / page at all

import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
//Might it not be easier to allow editing to default emails
//a) click in the SMS textbox to edit
//b) click on the contact to open contactSelectionPage, which should now have an "opend dialer" button
//to allow entering a custome number

//I think that would merit a new version landed22

AUIPage {id: pageCustomSMS
    width: 480
    height: 828
    orientationLock: AUIPageOrientation.LockPortrait

    property int toolbarHeight: 0
    //property int toolbarHeight: 110
    property color pageColor: "grey"

    signal nextPage(string smsType)
    signal cancelled()

    Component.onCompleted: {
        console.log("pageCustomSMS.onCompleted")
    }

    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////
    //SMS related components and functions
    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////


    function addCoords2SMS() {
        //Expose function to MainPage
//TODO: This function no longer exists in SMSApp component.
        thisSMSApp.addCoords2SMS()
    }

    SMSApp{id: thisSMSApp
        //property int defaultBottomMargin: 0
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        //anchors.bottomMargin: defaultBottomMargin
        anchors.left: parent.left
        anchors.right: parent.right
        color: parent.pageColor
        opacity: 1
        simpleMode: false

        onKeysOpened: {
            console.log("thisSMSApp: keysOpened signal received");
            anchors.bottomMargin = 410
        }
        onKeysClosed: {
            console.log("thisSMSApp: keysClosed signal received");
            anchors.bottomMargin = defaultBottomMargin
        }

        onCancelled: {
            console.log("cancelled Signal received by CustomSMSPage");
            parent.cancelled();
        }

    }

}
