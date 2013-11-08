// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
//import com.nokia.meego 1.0

//move to gui

Item {
//Rectangle {
    id: thisHeader
    signal clicked();

    property int fontSize: 24
    property string text
    property color textColor

    Text{
        id: mainText
        text: thisHeader.text
        font.pointSize: thisHeader.fontSize
        font.weight: Font.DemiBold
        color: thisHeader.textColor
        verticalAlignment: Text.AlignVCenter
    }
}
