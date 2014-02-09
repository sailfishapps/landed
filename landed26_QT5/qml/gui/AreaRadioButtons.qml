import QtQuick 2.0
//import QtQuick 1.1
import "../backend"

Rectangle {
    id: thisModel
    signal populated(string area_id);
    signal headerClicked();
    signal delegateClicked(string area_id);

    //"outward" looking properties, should be bound by parent
    property int itemHeight: 60;
    property int headerHeight: itemHeight;
    property string headerText
    property int fontSize: 24
    property bool arrowVisible: true
    property color backgroundColor
    property color labelColorActive

    //inward looking, bound to inner objects.
    height: areaView.height
    color: backgroundColor
    property alias currentIndex: areaView.currentIndex;

    function populate(area_id) {
        areaModel.populate(area_id);
    }

    AreaListModel {
        id: areaModel
    }

    Component{
        id: areaHeader
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
                console.log("Area Header Clicked");
                thisModel.headerClicked();
            }
        }
    }

    Component {
        id: areaDelegate
        AreaButtonsDelegate{
            width: thisModel.width
            height: thisModel.itemHeight
            text: name
            checked: (model.primary_area == 1) ? true : false
            fontSize: thisModel.fontSize
            backgroundColor: thisModel.backgroundColor
            onClicked:{
                console.log("Area Delegate Clicked: area_id is: " + area_id);
                thisModel.delegateClicked(area_id);
                //clear here so model is really empty when page is called again.
                areaModel.clear();
            }

            onPressedChanged: {
                console.log ("onPressedChanged, pressed: " + pressed)
                if (pressed) {
                    console.log("index: " + index);
                    areaModel.setExclusiveActiveItem(index);
                }
            }
        }
    }

    ListView {
        id: areaView
        anchors.left: parent.left
        //anchors.leftMargin: 10 //harmattan
        anchors.leftMargin: 0 //sailfish
        anchors.right:parent.right
        anchors.rightMargin: 30
        model: areaModel
        delegate: areaDelegate
        header: areaHeader
        // Set the highlight delegate. Note we must also set highlightFollowsCurrentItem
        // to false so the highlight delegate can control how the highlight is moved.
        //stop dragging of the listview: we will need to change this if more buttons used
        interactive: false
        function resize(items){
            console.log("resizing");
            areaView.height = (items * itemHeight) + headerHeight;
        }
    }

}

