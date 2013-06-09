// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1



Rectangle {
    id: rectangle1

    radius: 7

    property int fontSize: 16
    property string fontFamily
    //property string textColor
    property color textColor
    property bool simpleMode: true

    signal pressAndHold
    signal keysOpened
    signal keysClosed

    onFontSizeChanged: {
        console.log("fontSize Changed")
        //editableText.font.pointSize = fontSize
    }
    onFontFamilyChanged:   {
        editableText.font.family = fontFamily
    }
    onTextColorChanged: {
        editableText.color = textColor
    }

    Component.onCompleted: {
        if (simpleMode == true) {
            editableText.visible = false;
            editableText.enabled = false;
            readonlyText.visible = true;
            readonlyText.enabled = true;
        }
        else
        {
            editableText.visible = true;
            editableText.enabled = true;
            readonlyText.visible = false;
            readonlyText.enabled = false;
        }

        console.log("ChrisTextEdit.onCompleted")
    }

    function length() {
        return readonlyText.text.length + editableText.text.length;
    }

    function setText(myText) {
        if (simpleMode) {
            readonlyText.text = myText;
            editableText.text = "";
        }
        else{
            editableText.text = myText;
            readonlyText.text = "";
        }
    }

    function getText() {
        if (simpleMode) {
            return readonlyText.text;
        }
        else{
            return editableText.text;
        }
    }

    Text{ id: readonlyText
        anchors.fill: parent
        anchors.margins: 10
        //font.pointSize: editableText.font.pointSize
        font.pointSize: parent.fontSize
        //color: editableText.color
        color: parent.textColor
        wrapMode: Text.Wrap
    }

    TextEdit {
        id: editableText
        anchors.fill: parent
        anchors.topMargin: 7
        anchors.bottomMargin: 7
        anchors.leftMargin: 7.
        anchors.rightMargin: 7
        font.pointSize: parent.fontSize
        fillColor: parent.color
        property bool panelOpen: false

        signal pressAndHold
        onPressAndHold: {
            parent.pressAndHold();
        }
        signal keysOpened
        onKeysOpened: {
            console.log("rectangle1.onKeysOpened")
            if (panelOpen == false) {
                panelOpen = true;
                parent.keysOpened();
            }
        }

        onFocusChanged: {
            console.log("focusChanged")
        }
        Keys.onReturnPressed: {
            if (panelOpen == true) {
                panelOpen = false;
                closeSoftwareInputPanel();
                parent.keysClosed();
            }
        }

        MouseArea{
            anchors.fill: parent

            onPressed: {
                console.log("onPressed")
                parent.focus = true;
            }
            onReleased: {
                console.log("onReleased")
            }
            onClicked: {
                console.log("onClicked")
                parent.openSoftwareInputPanel();
                parent.keysOpened();
            }
            onPressAndHold: {
                console.log("onPressAndHold")
                parent.pressAndHold();
                //smsDialog.open();
            }
            onDoubleClicked: {
                console.log("onDoubleClicked")
            }

        }

    }

}
