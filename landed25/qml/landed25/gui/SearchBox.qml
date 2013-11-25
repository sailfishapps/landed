import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
import com.nokia.meego 1.0

Rectangle {
    id: searchBox
    color: "lightgrey"
    height: 80
    width: parent.width

    signal requestSearch(string serachforme)

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
        TextField {
            id: textEdit
            anchors.fill: parent
            platformSipAttributes: sipAttributes
            onAccepted:  {
                console.log ("Action key pressed");
                platformCloseSoftwareInputPanel();
            }
            AUIButton{id: searchButton
                width: 64;
                height: 32;
                //y: 50
                anchors {right: parent.right; verticalCenter: parent.verticalCenter}
                transparent: true
                iconSource: "icons/icon-m-toolbar-search.png"
                onClicked: {
                    console.log("searchButton.onClicked");
                    searchBox.requestSearch(textEdit.text);
                    parent.platformCloseSoftwareInputPanel();
                }
            }
        }

        SipAttributes {
            id: sipAttributes
            actionKeyLabel: "Done"
            //actionKeyIcon: "/path/to/icon.svg"
            actionKeyHighlighted: true
            actionKeyEnabled: true

        }

    }
}


