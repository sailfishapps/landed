import QtQuick 2.0
//import QtQuick 1.1
//user interface abstraction layer so both harmattan and sailfish can be supported with the same code base
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
import LandedTheme 1.0

Item {
    signal clicked();
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
        //big big aha, label fontSize seems only to take certain values, those from Sailfish Theme.
        //We will use equivalents from LandedTheme object
        //40 pixels works, 30 does not!
        //fontPixelSize: LandedTheme.FontSizeLarge
        fontPixelSize: LandedTheme.FontSizeLarge
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


