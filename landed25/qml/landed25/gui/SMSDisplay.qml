//import QtQuick 2.0
import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

Rectangle{id: smsDisplay

    property bool smsSent: false
    property int defaultBottomMargin: 160
    property int fontSize: 16

    signal cancelled()
    signal phoneNrClicked()
    signal sendSMS(string phoneNumber, string text)

    function setState(msgState) {
        if (msgState == "ActiveState") {
            phoneNrGroup.state = "stateSending";
        }
        else if (msgState == "FinishedState") {
            phoneNrGroup.state = "stateSent";
        }
    }

    function setText(text) {
        smsBody.setText(text);
        if (phoneNrGroup.state == "stateNotReady" && phoneNrGroup.length() > 0) {
            phoneNrGroup.state ="stateReady";
        }
    }

    function setContact (contactName, contactPhone) {
        phoneNrGroup.setContact (contactName, contactPhone);
        if (phoneNrGroup.state == "stateNotReady" && smsBody.length() > 0) {
            phoneNrGroup.state ="stateReady";
        }
    }

    //This is variable height
    SMSTextEdit { id: smsBody
        //height: 320
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.bottom: phoneNrGroup.top
        anchors.bottomMargin: 5
        //anchors.bottomMargin: parent.defaultBottomMargin
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        //color: "white"
        color: "white"
        fontFamily: "Arial"
        fontSize: smsDisplay.fontSize
    }

    Rectangle { id: phoneNrGroup

        state: "stateNotReady";
        states: [
            State {
                name: "stateNotReady";
                PropertyChanges{ target: sendButton; enabled: false }
                PropertyChanges{ target: sendButton; text: "Send" }
                PropertyChanges{ target: phoneNrField; textColor: "black" }
                PropertyChanges{ target: phoneNrField; horizontalAlignment: Text.AlignRight }
                PropertyChanges{ target: phoneNrField; text: "" }
                PropertyChanges{ target: smsBody; textColor: "black" }
                StateChangeScript {
                         name: "myScript"
                         script: smsBody.setText("");
                }
            },
            State {
                name: "stateReady";
                PropertyChanges{ target: sendButton; enabled: true }
                PropertyChanges{ target: sendButton; text: "Send" }
                PropertyChanges{ target: phoneNrField; textColor: "black" }
                PropertyChanges{ target: phoneNrField; text: phoneNrField.displayText() }
                PropertyChanges{ target: phoneNrField; horizontalAlignment: Text.AlignRight }
                PropertyChanges{ target: smsBody; textColor: "black" }
            },
            State {
                name: "stateSending";
                PropertyChanges{ target: sendButton; enabled: false }
                PropertyChanges{ target: sendButton; text: "Sending..." }
                PropertyChanges{ target: phoneNrField; textColor: "darkgreen" }
                PropertyChanges{ target: phoneNrField; horizontalAlignment: Text.AlignLeft }
                PropertyChanges{ target: phoneNrField; text: "Sending to: " + phoneNrField.displayText() }
                PropertyChanges{ target: smsBody; textColor: "darkgreen" }
            },
            State {
                name: "stateSent";
                PropertyChanges{ target: sendButton; enabled: false }
                PropertyChanges{ target: sendButton; text: "" }
                PropertyChanges{ target: cancelButton; text: "Back" }
                PropertyChanges{ target: cancelButton; primaryColor: "#008000" }
                PropertyChanges{ target: phoneNrField; textColor: "grey" }
                PropertyChanges{ target: phoneNrField; horizontalAlignment: Text.AlignLeft }
                PropertyChanges{ target: phoneNrField; text: "Sent to: " + phoneNrField.displayText() }
                PropertyChanges{ target: smsBody; textColor: "grey" }
            }
        ]

        height: phoneNrField.height + sendButton.height + (3*5)
        anchors {left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; bottom: parent.bottom; bottomMargin: 10}
        color: parent.color
        //color: "lightyellow"

        function length() {
            return phoneNrField.phoneNumber.length;
        }

        function setContact (contactName, contactPhone) {
            console.log ("Contact is : " + contactName +"; Phone is: " + contactPhone)
            setContactName (contactName);
            setPhoneNr(contactPhone);
        }

        function setPhoneNr (phoneNumber) {
            //phoneNrField.text = phoneNumber;
            phoneNrField.phoneNumber = phoneNumber;
        }

        function setContactName(name) {
            phoneNrField.contactName = name;
        }

        Rectangle{id: phoneNrField
            property alias text: label.text;
            property alias textColor: label.color
            property alias horizontalAlignment: label.horizontalAlignment
            property string phoneNumber
            property string contactName
            radius: 7;
            width: parent.width
            height: 120;
            anchors {top: parent.top; topMargin: 5}
            color:  "lightyellow"
            Text { id: label
                font.pointSize: smsDisplay.fontSize;
                font.family: "Arial";
                anchors.fill: parent;
                anchors.leftMargin: 10;
                anchors.rightMargin: 10;
                horizontalAlignment: Text.AlignRight;
                verticalAlignment: Text.AlignVCenter;
                //text: "this field is set in State above"
                //text: parent.contactName + " on: " + parent.phoneNumber;
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("phoneNrField.MouseArea.onCicked");
                    phoneNrClicked();
                }
            }
            function displayText() {
                return phoneNrField.contactName + " on: " + "\n" + phoneNrField.phoneNumber;
            }
        }

        RumbleEffect {id: rumbleEffect}

        //Buttons have fixed height, and are anchored to the bottom of the page
        AUIButton {id: sendButton
            height: 60
            width: (parent.width - (3 * 10)) / 2
            anchors{right: parent.right; bottom: parent.bottom; topMargin: 5;}
            primaryColor: "#008000" //"green"
            onClicked: {
                rumbleEffect.start();
                console.log("sendButton.onCicked");
                console.log("Sending text: " + smsBody.getText());
                console.log("to: " + phoneNrField.phoneNumber)
                smsDisplay.sendSMS(phoneNrField.phoneNumber, smsBody.getText());
                smsSent = true;
            }
        }

        AUIButton {id: cancelButton
            height: sendButton.height
            width: sendButton.width
            //anchors{left: parent.left; top: phoneNrField.bottom; topMargin: 10;};
            anchors{left: parent.left; bottom: parent.bottom; topMargin: 5;}
            text: "Cancel";
            primaryColor: "#808080" //"grey"
            onClicked: {
                rumbleEffect.start();
                console.log("SMSApp cancelButton.onCicked");
                phoneNrGroup.state ="stateNotReady";
                cancelled();
            }
        }

    }

}


