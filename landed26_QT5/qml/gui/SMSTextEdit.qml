import QtQuick 2.0
//import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
import LandedTheme 1.0

Rectangle {
    id: smsTextEdit

    radius: 7
    property int fontSize: 16
    property string fontFamily
    property color textColor
    property bool panelOpen: false
    signal keysOpened()
    signal keysClosed()

    function length() {
        return editableText.text.length;
    }

    function setText(myText) {
        editableText.text = myText;
        //set default cursor position to after standard text
        editableText.cursorPosition = editableText.text.length
    }

    function getText() {
        return editableText.text;
    }

    function openSoftwareInputPanel() {
        Qt.inputMethod.show()
        panelOpen = true;
        smsTextEdit.keysOpened();
    }
    function closeSoftwareInputPanel() {
        console.log("closing SIP")
        Qt.inputMethod.hide();
        panelOpen = false;
        smsTextEdit.keysClosed();
    }

    //TextEdit { //harmattan
    AUITextArea {
        id: editableText
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: closeKeyboard.top
        anchors.topMargin: LandedTheme.MarginText
        anchors.bottomMargin: LandedTheme.MarginText
        anchors.leftMargin: LandedTheme.MarginText
        anchors.rightMargin: LandedTheme.MarginText
        textMargin: 5
        background: null // override the stupid default Separator component
        font.pointSize: smsTextEdit.fontSize
        font.family: smsTextEdit.fontFamily
        horizontalAlignment: TextEdit.AlignRight
        color: smsTextEdit.textColor
        //fillColor: smsTextEdit.color
        wrapMode: TextEdit.Wrap
        //inputMethodHints: Qt.ImhNoPredictiveText stops a silly bug, whereby when the cursor is repositioned, the last word typed before repositioning
        //is pasted at the new cursor position!!
        //thanks to http://psychedelic-tiger.com/qmls-t9-bug/ for suggesting this as a fix to a different (but probably related) bug.
        inputMethodHints: Qt.ImhNoPredictiveText


        onActiveFocusChanged: {
            if (activeFocus) {
                console.log("activeFocusChanged")
                openSoftwareInputPanel()
            }
        }
    }

    AUIButton {
        id: closeKeyboard
        visible: smsTextEdit.panelOpen
        text: "Close keyboard"
        //primaryColor: "#008000" //"green"
        primaryColor: "lightblue"
        anchors.left: editableText.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: LandedTheme.MarginText
        height: visible ? 40 : 0
        width: 240
        onClicked: {
            console.log("closeKeyboard button onClicked")
            smsTextEdit.closeSoftwareInputPanel();
        }
        onPressAndHold: {
            console.log("closeKeyboard button onPressAndHold")
            smsTextEdit.closeSoftwareInputPanel();
        }
    }

}
