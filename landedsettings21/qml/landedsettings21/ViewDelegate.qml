import QtQuick 1.1

Item{
    id: thisDelegate
    signal clicked();
    signal doubleClicked();
    property int fontSize: 24
    property string text
    property variant model
    property variant index

    Text {
        text: thisDelegate.text
        font.pointSize: thisDelegate.fontSize
        font.weight: Font.Light
        color: "white"
        verticalAlignment: Text.AlignVCenter
    }
    MouseArea{
        anchors.fill: parent;
        onClicked:{
            thisDelegate.clicked();
        }
        onDoubleClicked:{
            thisDelegate.doubleClicked();
        }
    }
}
