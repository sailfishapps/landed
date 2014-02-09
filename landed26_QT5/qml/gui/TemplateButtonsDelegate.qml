import QtQuick 2.0
//import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

Item {
    signal clicked();
    property int fontSize: 26
    property color buttonColor
    property string text
//    color: "black";

    AUIButton {
        id: thisButton
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        text: parent.text

        primaryColor: parent.buttonColor

        onTextChanged: console.log ("onTextChanged, text is: " + text)
        //onPlatformStyleChanged: console.log ("onPlatformStyleChanged, buttonColor is: " + buttonColor)
        onClicked: {
            console.log ("text is: " + text)
            console.log ("buttonColor: " + parent.buttonColor)
            parent.clicked();
        }


    }
}


