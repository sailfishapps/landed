import QtQuick 2.0
//import QtQuick 1.1
//import com.nokia.meego 1.0
import LandedTheme 1.0

Item {
    id: thisHeader
    signal clicked();

    //property int fontPixelSize: 24
    property bool fontBold
    property string text
    property color textColor

    Text{
        id: mainText
        text: thisHeader.text
        font.pixelSize: LandedTheme.FontSizeLarge
        font.weight: thisHeader.fontBold ? Font.Bold : Font.DemiBold
        color: thisHeader.textColor
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        anchors.right: parent.right
    }
}
