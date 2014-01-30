import QtQuick 2.0
//import QtQuick 1.1
import "../backend"

Rectangle {
    id: thisModel
    signal populated(string group_id);
    signal headerClicked();
    signal delegateClicked(string group_id);

    //"outward" looking properties, should be bound by parent
    property int itemHeight: 60;
    property int headerHeight: itemHeight;
    property string headerText
    property int fontSize: 24
    property bool arrowVisible: true
    property color backgroundColor
    property color labelColorActive

    //inward looking, bound to inner objects.
    height: groupView.height
    color: backgroundColor
    property alias currentIndex: groupView.currentIndex;

    function populate(group_id) {
        groupModel.populate(group_id);
    }

    GroupListModel {
        id: groupModel
    }

    Component{
        id: groupHeader
        SimpleHeader {
            text: thisModel.headerText;
            textColor: thisModel.labelColorActive
            width: thisModel.width;
            height: thisModel.headerHeight
            anchors.left: parent.left
            anchors.right: parent.right
            fontSize: thisModel.fontSize * 1.5
            fontBold: true
            onClicked:{
                console.log("Group Header Clicked");
                thisModel.headerClicked();
            }
        }
    }

    Component {
        id: groupDelegate
        GroupButtonsDelegate{
            width: thisModel.width
            height: thisModel.itemHeight
            text: name
            checked: (active == 1) ? true : false
            fontSize: thisModel.fontSize
            backgroundColor: thisModel.backgroundColor
            onClicked:{
                console.log("Group Delegate Clicked: group_id is: " + group_id);
                thisModel.delegateClicked(group_id);
                //clear here so model is really empty when page is called again.
                groupModel.clear();
            }

            onPressedChanged: {
                console.log ("onPressedChanged, pressed: " + pressed)
                if (pressed) {
                    console.log("index: " + index);
                    groupModel.setExclusiveActiveItem(index);
                }
            }
        }
    }

    ListView {
        id: groupView
        anchors.left: parent.left
        //anchors.leftMargin: 10 //harmattan
        anchors.leftMargin: 0 //sailfish
        anchors.right:parent.right
        anchors.rightMargin: 30
        model: groupModel
        delegate: groupDelegate
        header: groupHeader
        // Set the highlight delegate. Note we must also set highlightFollowsCurrentItem
        // to false so the highlight delegate can control how the highlight is moved.
        //stop dragging of the listview: we will need to change this if more buttons used
        interactive: false
        function resize(items){
            console.log("resizing");
            groupView.height = (items * itemHeight) + headerHeight;
        }
    }

}

