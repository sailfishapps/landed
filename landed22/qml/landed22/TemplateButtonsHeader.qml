// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
//import com.nokia.meego 1.0

Item {
//Rectangle {
    id: thisHeader
    signal clicked();
    signal editClicked();
    signal copyClicked();
    signal deleteClicked();

    property int fontSize: 24
    property string text
    property bool arrowVisible: true

//    color: "black"
//    radius: 7
    Text{
        text: thisHeader.text
        font.pointSize: thisHeader.fontSize
        font.weight: Font.DemiBold
        color: "white"
        verticalAlignment: Text.AlignVCenter
    }
    Text{
        text: ">"
        font.pointSize: thisHeader.fontSize
        font.weight: Font.DemiBold
        color: "white"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        anchors.right: thisHeader.right
        anchors.rightMargin: 10
        width: 30
        visible: thisHeader.arrowVisible
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
