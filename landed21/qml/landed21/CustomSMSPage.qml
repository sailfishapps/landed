import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0


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
            console.log("cancelled Signal received by DefaultSMSPage");
            parent.cancelled();
        }

    }

}
