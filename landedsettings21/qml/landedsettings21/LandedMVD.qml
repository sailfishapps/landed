import QtQuick 1.1
import Sailfish.Silica 1.0
import org.flyingsheep.abstractui 1.0

//This is a generic, resusable Model, View, Delegate, Header and HighlightBar set
//intended to be used multiple times within this project
//The only real difference between the various instances of this control is the behavour of the delegates
//a) where they get their data from, b) the events they call when clicked / pressedAndHeld
//which is why delegates are dynamically loaded from instances on the MainPage

//AUIBackgroundRectangle {
Item {
    id: thisMVD

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

    property int menuHeight
    property int sideMargin: 10
    property int fontSize: 24
    property string headerState

    onHeightChanged: console.log ("thisMVD.onHeightChanged: height: " + height)

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
        thisMVD.cleared();
    }

    function resize(menuOpen){
        //Used to adjust the height of the MVD depending on if the menu is open
        console.log("resize:: thisModel members: " + thisModel.count);
        console.log("resize:: thisMVD.headerHeight: " + thisMVD.headerHeight);
        console.log("resize:: thisMVD.itemHeight: " + thisMVD.itemHeight);
        if (menuOpen)  {
            console.log ("Menu is opening, expand the view");
            thisMVD.height = thisMVD.headerHeight + (thisModel.count * thisMVD.itemHeight) + thisMVD.menuHeight;
            //Note delegate height is changed by binding, attempts to change it from here have failed.
        }
        else if (!menuOpen) {
            console.log("Menu is closing, shrink the MVD to its normal nonexpanded height")
            thisMVD.height = thisMVD.headerHeight + (thisModel.count * thisMVD.itemHeight);
        } 
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
            thisMVD.height = thisMVD.headerHeight + (rs.rows.length * thisMVD.itemHeight)
            for(var i = 0; i < rs.rows.length; i++) {
                thisModel.append(rs.rows.item(i));
            }
            console.log(headerText + " model populated with rows: " + rs.rows.length + ", index: " + index);
            if (rs.rows.length > 0) {
                console.log("sending populated signal with id: " + rs.rows.item(index).id)
                thisMVD.populated(rs.rows.item(index).id);
                thisView.currentIndex = index;
            }
            else{
                thisMVD.populatedEmpty();
            }
        }
    }

    Component{
        id: thisHeader
        ViewHeader {
            text: thisMVD.headerText
            width: thisView.width
            headerHeight: thisMVD.headerHeight
            fontSize: thisMVD.fontSize
            state: thisMVD.headerState
            //onXXX Event handlers here
        }
    }

    Component {
        id: thisHighlightBar
        ViewHighlightBar {
            //width: thisMVD.width;
            width: thisView.width;
            height: thisMVD.itemHeight
            y: (thisView.currentIndex != -1) ? thisView.currentItem.y : 0;
        }
    }

    ListView {
        id: thisView
        objectName: "landedMVDListView"
        //anchors.fill: parent
        anchors.left: parent.left
        anchors.right:parent.right
        anchors.leftMargin: sideMargin
        anchors.rightMargin: sideMargin
        height: parent.height
        model: thisModel

        delegate: Row {
            width: thisView.width
            Loader {
                id: loader
                sourceComponent: thisMVD.customDelegate
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

    }
}
