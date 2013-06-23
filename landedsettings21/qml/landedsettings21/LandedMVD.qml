import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

//This is a generic, resusable Model, View, Delegate, Header and HighlightBar set
//intended to be used multiple times within this project
//The only real difference between the various instances of this control is the behavour of the delegates
//which is why delegates are dynamically loaded from instances on the MainPage

AUIBackgroundRectangle {
    id: thisModelView

    signal populated(int id);
    signal populatedEmpty();
    signal cleared();
    signal headerClicked();
    signal editClicked();
    signal newClicked();
    signal deleteClicked();
    signal delegateDoubleClicked();
    signal delegateClicked(int id);

    //"outward" looking properties, should be set by parent
    property int itemHeight: 40;
    property int headerHeight: itemHeight;
    property int closedHeight: itemHeight;
    property int expandedHeight: (closedHeight * 2) + 10
    property int sideMargin: 10
    property int fontSize: 24
    property string headerState

    //inward looking, bound to inner objects.
    height: thisView.height  //cannot be an alias as is a final property of rectangle

    onHeightChanged: console.log ("height: " + height)

    property alias currentIndex: thisView.currentIndex;
    property string headerText

    property Component customDelegate

    function populate(rs, caller) {
        //if possible we keep the existing index for the selected item,
        //else if non selected (-1), we take the first item
        console.log("populating model: " + headerText)
        var currentIndexOld = (thisView.currentIndex != -1) ? thisView.currentIndex : 0;
        console.log ("currentIndexOld: " + currentIndexOld);
        console.log ("caller: " + caller);
        //if populate is called by a parent, reset currentIndex, from a sibling keep the old value
        var currentIndexNew = (caller == "configure") ? currentIndexOld : 0;
        if (rs.rows.length < (currentIndexOld +1)) { //index starts with 0
            //the old index is higher than the number of rows
            //this can happen when the last row was deleted
            currentIndexNew = 0;
        }
        console.log ("currentIndexNew: " + currentIndexNew);
        thisModel.populate(rs, currentIndexNew);
    }
    function clear() {
        thisModel.clear();
        resize(0, 0);
        thisModelView.cleared();
    }

    function resize(items, extra){
        thisView.resize(items, extra);
    }

   function get(index) {
        return thisModel.get(index);
    }
    function getId() {
        if (thisView.currentIndex == -1) {
            return null;
        }
        else {
            return thisModel.get(thisView.currentIndex).id;
        }
    }

    ListModel {
        id: thisModel
        function populate(rs, index){
            thisModel.clear();
            thisView.resize(rs.rows.length, 0);
            for(var i = 0; i < rs.rows.length; i++) {
                thisModel.append(rs.rows.item(i));
            }
            console.log(headerText + " model populated with rows: " + rs.rows.length + ", index: " + index);
            if (rs.rows.length > 0) {
                console.log("sending populated signal with id: " + rs.rows.item(index).id)
                thisModelView.populated(rs.rows.item(index).id);
                thisView.currentIndex = index;
            }
            else{
                thisModelView.populatedEmpty();
            }
        }
    }

    Component{
        id: thisHeader
        ViewHeader {
            text: thisModelView.headerText
            width: thisView.width
            closedHeight: thisModelView.closedHeight
            expandedHeight: thisModelView.expandedHeight
            fontSize: thisModelView.fontSize
            state: thisModelView.headerState
            onClicked:{
                console.log(text + " Header Clicked");
                thisModelView.headerClicked();
            }
            onNewClicked: {
                thisModelView.newClicked();
            }
            onEditClicked: {
                thisModelView.editClicked();
            }
            onDeleteClicked: {
                thisModelView.deleteClicked();
            }
        }
    }

    Component {
        id: thisHighlightBar
        ViewHighlightBar {
            //width: thisModelView.width;
            width: thisView.width;
            height: thisModelView.itemHeight
            y: (thisView.currentIndex != -1) ? thisView.currentItem.y : 0;
        }
    }

    ListView {
        id: thisView
        anchors.left: parent.left
        anchors.right:parent.right
        anchors.leftMargin: sideMargin
        anchors.rightMargin: sideMargin
        height: parent.height/8
        model: thisModel

        delegate: Row {
            width: thisView.width
            Loader {
                id: loader
                sourceComponent: thisModelView.customDelegate
                // *** Bind current model and index element to the component delegate
                // *** when it's loaded
                Binding {
                    target: loader.item
                    property: "model"
                    value: model
                    when: loader.status == Loader.Ready
                }
                Binding {
                    target: loader.item
                    property: "index"
                    value: index
                    when: loader.status == Loader.Ready
                }
            }

        }

        header: thisHeader
        // Set the highlight delegate. Note we must also set highlightFollowsCurrentItem
        // to false so the highlight delegate can control how the highlight is moved.
        highlight: thisHighlightBar
        highlightFollowsCurrentItem: false
        interactive: false
        function resize(items, extra){
            thisView.height = (items * itemHeight) + ((thisModelView.headerState == 'stateConfigure') ? expandedHeight : headerHeight ) + extra;
        }
    }

}
