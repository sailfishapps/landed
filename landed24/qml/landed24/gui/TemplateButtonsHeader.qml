// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
//import com.nokia.meego 1.0

//move to gui

Item {
//Rectangle {
    id: thisHeader
    signal clicked();
    signal editClicked();
    signal copyClicked();
    signal deleteClicked();

    property int fontSize: 24
    property string text
    property string subText: "sub Text will be here"
    property bool arrowVisible: true
    property color textColor

//    color: "black"
//    radius: 7
    Text{
        id: mainText
        text: thisHeader.text
        font.pointSize: thisHeader.fontSize
        font.weight: Font.DemiBold
        //color: "black"
        color: thisHeader.textColor
        verticalAlignment: Text.AlignVCenter
    }
    Text{
        text: ">"
        font.pointSize: thisHeader.fontSize
        font.weight: Font.DemiBold
        color: "white"
        //verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        anchors.right: thisHeader.right
        anchors.rightMargin: 10
        width: 30
        visible: thisHeader.arrowVisible
    }
    Text{
        id: subText
        text: thisHeader.subText
        font.pointSize: thisHeader.fontSize * 0.666
        font.weight: Font.DemiBold
        //color: "black"
        color: thisHeader.textColor
        //verticalAlignment: Text.AlignVCenter
        width: parent.width
        anchors.top: mainText.bottom
    }

    MouseArea{
        enabled: thisHeader.arrowVisible
        anchors.fill: thisHeader;
        onClicked:{
            console.log("Header Clicked")
            thisHeader.clicked();
        }
    }
}
