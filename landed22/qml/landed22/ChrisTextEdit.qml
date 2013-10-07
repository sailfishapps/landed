//import QtQuick 2.0
import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0

Rectangle {
    id: rectangle1

    radius: 7

    property int fontSize: 16
    property string fontFamily
    //property string textColor
    property color textColor

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

    TextEdit {
        id: editableText
        anchors.fill: parent
        anchors.topMargin: 7
        anchors.bottomMargin: 7
        anchors.leftMargin: 7.
        anchors.rightMargin: 7
        font.pointSize: rectangle1.fontSize
        font.family: rectangle1.fontFamily
        color: rectangle1.textColor
        fillColor: rectangle1.color
        wrapMode: TextEdit.Wrap
        //inputMethodHints: Qt.ImhNoPredictiveText stops a silly bug, whereby when the cursor is repositioned, the last word typed before repositioning
        //is pasted at the new cursor position!!
        //thanks to http://psychedelic-tiger.com/qmls-t9-bug/ for suggesting this as a fix to a different (but probably related) bug.
        inputMethodHints: Qt.ImhNoPredictiveText

        selectByMouse: true;

        property bool panelOpen: false
        signal keysOpened
        signal pressAndHold

        AUIButton {
            id: closeKeyboard
            visible: editableText.panelOpen
            text: "Close keyboard"
            primaryColor: "#008000" //"green"
            anchors.right: editableText.right
            z: editableText.z + 1;
            y: 420
            width: 240
            onClicked: {
                editableText.panelOpen = false;
                editableText.closeSoftwareInputPanel();
            }
        }

        onKeysOpened: {
            console.log("editableText.onKeysOpened")
            if (panelOpen == false) {
                openSoftwareInputPanel();
                //editableText.cursorPosition = editableText.text.length
                panelOpen = true;
            }
        }

        onFocusChanged: {
            console.log("focusChanged")
        }
        onPressAndHold: {
            if (panelOpen == true) {
                panelOpen = false;
                closeSoftwareInputPanel();
            }
        }
        /*
        Keys.onReturnPressed: {
            if (panelOpen == true) {
                panelOpen = false;
                closeSoftwareInputPanel();
            }
        }
*/
        MouseArea{
            anchors.fill: parent
            preventStealing: true

            function characterPositionAt(mouse) {
                var mappedMouse = mapToItem(editableText, mouse.x, mouse.y);
                return editableText.positionAt(mappedMouse.x, mappedMouse.y);
            }

            onPressed: {
                console.log("MouseArea.onPressed: mouseX: " + mouseX + ", mouseY: " + mouseY);
                if (editableText.panelOpen) {
                    var pos = characterPositionAt(mouse);
                    editableText.cursorPosition = pos;


                }
                parent.focus = true;
            }
            onPressAndHold: {
                parent.pressAndHold();
            }

            onReleased: {
                console.log("MouseArea.onReleased")
            }
            onClicked: {
                console.log("MouseArea.onClicked")
                //parent.openSoftwareInputPanel();
                parent.keysOpened();
            }
            onDoubleClicked: {
                console.log("MouseArea.onDoubleClicked")
            }

        }
    }
}
