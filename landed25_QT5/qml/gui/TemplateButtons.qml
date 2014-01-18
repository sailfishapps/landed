import QtQuick 2.0
//import QtQuick 1.1
import "../backend"

Item {
    id: thisModel
    signal populated(string template_id);
    signal headerClicked();
    signal delegateClicked(string template_id, string msg_status);

    //"outward" looking properties, should be bound by parent
    property int itemHeight: 60;
    property int marginWidth: 10;
    property int headerHeight: itemHeight;
    property string headerText
    property string headerSubText
    property int fontSize: 24
    property bool arrowVisible: true
    property color textColor
    //Commented out for Sailfish
    //property color backgroundColor: "black"

    //inward looking, bound to inner objects.
    height: templateView.height

    //Commented out for Sailfish
    //color: backgroundColor

    property alias currentIndex: templateView.currentIndex;

    function populate(group_id) {
        templateModel.populate(group_id);
    }

    function clear() {
        headerText = "";
        templateModel.clear();
    }

    SMSTemplateListModel {
        id: templateModel
    }

    ListView {
        id: templateView
        anchors.left: parent.left
        anchors.right:parent.right
        anchors.leftMargin: marginWidth
        anchors.rightMargin: marginWidth
        model: templateModel
        delegate: templateDelegate
        header: templateHeader
        //stop dragging of the listview: we will need to change this if more buttons used
        interactive: false
        // Set the highlight delegate. Note we must also set highlightFollowsCurrentItem
        // to false so the highlight delegate can control how the highlight is moved.
        function resize(items){
            console.log("resizing");
            templateView.height = (items * itemHeight) + headerHeight;
        }
    }

    Component{
        id: templateHeader
        TemplateButtonsHeader {
            text: thisModel.headerText;
            subText: thisModel.headerSubText
            width: thisModel.width;
            //TODO: find a better way of calculating the height based on height of text + subText
            height: thisModel.headerHeight * 1.666
            fontSize: thisModel.fontSize
            arrowVisible: thisModel.arrowVisible
            textColor: thisModel.textColor
            onClicked:{
                console.log("Template Header Clicked");
                thisModel.headerClicked();
            }
        }
    }

    Component {
        id: templateDelegate
        TemplateButtonsDelegate{
            width: thisModel.width - (marginWidth*2)
            height: thisModel.itemHeight
            text: button_label
            fontSize: thisModel.fontSize
            buttonColor: (msg_status == "Ok") ? "green" : "red";
            onClicked:{
                console.log("Template Delegate Clicked: template_id is: " + template_id);
                templateView.currentIndex = index;
                thisModel.delegateClicked(template_id, msg_status);
            }
        }
    }
}
