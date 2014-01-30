import QtQuick 2.0
//import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

Rectangle {
    id: searchBox
    color: "lightgrey"
    height: 80
    width: parent.width

    signal requestSearch(string searchKey)

    property alias font: textEdit.font

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        radius: 10
        color: "white"
        AUITextField {
            id: textEdit
            anchors.fill: parent
            //imH are important, otherwise changes to a word are NOT committed after each char entered
            inputMethodHints: Qt.ImhNoPredictiveText
/*
            platformSipAttributes: sipAttributes
            onAccepted:  {
                console.log ("Action key pressed");
                platformCloseSoftwareInputPanel();
            }
*/
            onTextChanged: {
                console.log ("Text Changed")
                searchBox.requestSearch(textEdit.text);
            }

            AUIButton{id: searchButton
                width: 64;
                height: 32;
                anchors {right: parent.right; verticalCenter: parent.verticalCenter}
                transparent: true
                iconSource: (textEdit.text.length == 0) ? "icons/icon-m-toolbar-search.png" : "icons/icon-m-input-clear.png"
                onClicked: {
                    console.log("searchButton.onClicked: " + textEdit.text);
                    textEdit.text = "";
                    textEdit.platformCloseSoftwareInputPanel();
                }
            }
        }
/*
Sailfish TextArea does not support thsi

        SipAttributes {
            id: sipAttributes
            actionKeyLabel: "Close"
            //actionKeyIcon: "/path/to/icon.svg"
            actionKeyHighlighted: true
            actionKeyEnabled: true
        }
*/

    }
}



