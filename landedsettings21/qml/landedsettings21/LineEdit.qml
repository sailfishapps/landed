import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

//Abstract Component, is "inherited" by the LinePhoneEdit and LineTextEdit components.

Item { id: thisLineEdit

    property alias text: textEdit1.text
    property alias labelText: label1.text
    property alias fontSize: textEdit1.font.pointSize
    property alias cursorPosition: textEdit1.cursorPosition
    property alias inputMethodHints: textEdit1.inputMethodHints

    height: 120
    AUILabel { id: label1
        height: 50
        anchors.top: parent.top
        verticalAlignment: Text.AlignBottom
    }
    Rectangle {
        //Rectangle used to give background color to textEdit
        width: parent.width
        height: 60
        anchors.top: label1.bottom
        anchors.topMargin: 10
        color: "white"
        radius: 7
        property int cursorPosition
//TextInput
        TextEdit { id: textEdit1
            anchors.fill: parent
            color: "black"
            verticalAlignment: TextEdit.AlignVCenter
            activeFocusOnPress: false
            property bool panelOpen: false
            onActiveFocusChanged: {
                if (!textEdit1.activeFocus) textEdit1.closeSoftwareInputPanel();
            }
    //TODO: The three key events below do not trap the enter key with Text Input - is probably
    //  already filtered out

            Keys.onReturnPressed: {
                if (panelOpen == true) {
                    panelOpen = false;
                    closeSoftwareInputPanel();
                    //parent.keysClosed();
                }
            }
            Keys.onEnterPressed: {
                if (panelOpen == true) {
                    panelOpen = false;
                    console.log ("Enter Pressed");
                    closeSoftwareInputPanel();
                    //parent.keysClosed();
                }
            }
            Keys.onPressed: {
                console.log ("Key pressed is: " + event.key);
                if (event.key ==Qt.Key_Enter) {
                    console.log ("Enter Pressed xxx");
                }
            }
            Keys.onFlipPressed: {
                    console.log ("Flipping Nora Pressed xxx");
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (!parent.activeFocus) {
                        parent.forceActiveFocus();
                        parent.openSoftwareInputPanel();
                    } else {
                        parent.focus = false;
                    }
                }
                onPressAndHold: {
                    parent.closeSoftwareInputPanel();
                    console.log ("onPressandHold");
                    parent.focus = false;
                }

            }
        }
    }
}
