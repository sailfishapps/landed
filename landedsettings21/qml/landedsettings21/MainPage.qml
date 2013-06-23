import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
import Sailfish.Silica 1.0
//import com.nokia.meego 1.0
import "debugDB.js" as DBDebug
import "settingsDB.js" as DB
import "initiateDB.js" as DBInit

AUIPageWithMenu {
//AUIPage {
    id: thisPage
//    tools: commonTools
    signal nextPage(string configureEntity, string configureAction, int currentIndex, string group_id, string template_id, string tag_id, string contact_id)
    signal cancelled()

    property string populationMode: "initial"
    property string configureEntity
    property int currentIndex
    property int parentId

    Component.onCompleted: {
        //theme.inverted = true;
        listAllTables();
        console.log ("hasMenu: " + thisPage.hasMenu);
        console.log ("thisPage.width: " + thisPage.width)
    }

    function listAllTables() {
        var rs = DBDebug.allTables();
        if (rs.rows.length == 0) {
            console.log("No database tables found: DB will be initialised‘");
            DBInit.initiateDb();
            DBInit.populateDb();
        }
        else {
            for(var i = 0; i < rs.rows.length; i++) {
                console.log("Found Table: " + rs.rows.item(i).name + "; " + countRecords(rs.rows.item(i).name));
            }
        }
    }

    function countRecords(table) {
        var rs = DBDebug.countRecords(table);
        return ("No recs: " + rs.rows.item(0).cnt )
    }

    onStatusChanged: {
        if (status == AUIPageStatus.Active) {
            console.log("Main Page Active: populationMode is: " + populationMode + ", configureEntity is:" + configureEntity + ", currentIndex is: " + currentIndex);
            var rs;
            if (populationMode == "initial") {
                rs = DB.getTemplateGroups();
                groupMVD.populate(rs, "parent");
            }
            if (populationMode == "transfer") {
                //mode should be "transfer", we are coming back from a configuration page
                //we want to refresh, keeping as many setting as possible
                //but also take into account any changes made on the configuation Page
                if (configureEntity == "Group") {
                    rs = DB.getTemplateGroups();
                    groupMVD.currentIndex = currentIndex;
                    groupMVD.populate(rs, "configure");
                }
                if (configureEntity == "Template") {
                    rs = DB.getMessageTemplates(parentId);
                    templateMVD.currentIndex = currentIndex;
                    templateMVD.populate(rs, "configure");
                }
                if (configureEntity == "Tag") {
                    rs = DB.getTags(parentId);
                    tagMVD.currentIndex = currentIndex;
                    tagMVD.populate(rs, "configure");
                }
                if (configureEntity == "Contact") {
                    rs = DB.getContacts(parentId);
                    contactMVD.currentIndex = currentIndex;
                    contactMVD.populate(rs, "configure");
                }

//If we come back from the configureTemplatesPage we want to
//leave the groupMVD unchanged
//repopulate from the templateModel downwards
            }
        }
    }
/*
    onMenuOpening: {
        console.log ("Menu is opening")
    }
    onMenuClosing: {
        console.log ("Menu is closing")
    }
*/
    property int itemHeight: 45;
    property int headerHeight: itemHeight;
    property int viewMargin: 18;
    property int sideMargin: 20;
    property int fontSize: 24
    property color backGroundColor: "black"

//This MouseArea Stops the PullUpMenu working
//My guess is it steals the mouse input
// Can we use this GUI construct?
//i.e. our stack of MVDs on a Page, and have a Pully Menu
//I may have to stop the mouse area shortly before the bottom of the screen
// leaving a small area about the size of a Harmattan MenuBar to allow for Menu Access
//while this allows the menu to open
//it does not allow menu items to be selected, as presumably the menu is sliding under
//our naughty little mousearea!

    /*
    MouseArea {
        anchors.fill: parent
        //anchors bottomMargin 40 and clip true provides a small margin at the bottom of the
        //page which acts like a tool bar - for the Menu
        anchors.bottomMargin: (thisPage.hasMenu === 3) ? 40 : 0
        //anchors.bottomMargin: 40
        clip: true
        drag.target: parent;
        drag.axis: "YAxis"
        drag.maximumY: 0
        drag.filterChildren: true
*/
    Flickable {
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick

//TODO: pack the MVDs in a column
        ///////////////////////////////////////////////////////////////////////////////////////
        // groupMVD
        ///////////////////////////////////////////////////////////////////////////////////////

        LandedMVD {
            id: groupMVD
            fontSize: thisPage.fontSize
            itemHeight: thisPage.itemHeight
            headerHeight: thisPage.headerHeight
            headerState: "stateView"
            headerText: "Groups:"
            width: thisPage.width
            sideMargin: thisPage.sideMargin
            onPopulated: {
                populateChildModels(id);
            }
            onPopulatedEmpty: {
                console.log("empty group model")
                templateMVD.clear();
                templateMVD.headerState = 'stateParentEmpty';
    //TODO: test if this is cascaded, or if we need to explicitly clear the other models and set their states
            }
            onHeaderClicked:{
                var group_id = getGroupId();
                console.log("groupMVD onHeaderClicked. currentIndex: " + currentIndex);
                openConfigurePage("Group", currentIndex, group_id, null, null, null);
            }

            customDelegate: ViewDelegate{ id: groupDelegate
                width: groupMVD.width   - (2 * sideMargin)
                height: groupMVD.itemHeight
                text: model.name + ", " + model.id
                fontSize: groupMVD.fontSize
                onClicked:{
                    console.log("groupMVD Delegate Clicked");
                    groupMVD.currentIndex = index;
                    groupMVD.populateChildModels(model.id, "parent");
                }
                onPressAndHold: {
                    console.log("groupMVD Delegate Presed and Held");
                    groupMVD.currentIndex = index;
                    console.log ("groupMVD Height is: " + groupMVD.height)
                    console.log ("groupDelegate.height is: " + groupDelegate.height)
                    groupMVD.resize(6, 350);
                    console.log ("groupMVD Height is: " + groupMVD.height)
                    height = groupMVD.itemHeight + 350
                    console.log ("groupDelegate.height is: " + groupDelegate.height)
                    showContextMenu(groupDelegate);
                }
                onMenuClosing: {
                    console.log("groupMVD Delegate Menu Closing");
                    height = groupMVD.itemHeight
                    groupMVD.resize(6, 0);
                }
            }

//will need to add ContextMenu and MenuItem to AbstractUI

            function populateChildModels(id) {
                var group_id = id;
                console.log ("populateChildModel with id: " + id)
                var rs = DB.getMessageTemplates(group_id);
                templateMVD.populate(rs, "parent");
                templateMVD.headerState = 'stateView';
            }
        }


        ///////////////////////////////////////////////////////////////////////////////////////
        // Template ModelViewDelegate
        ///////////////////////////////////////////////////////////////////////////////////////

        LandedMVD {
            id: templateMVD
            fontSize: thisPage.fontSize
            itemHeight: thisPage.itemHeight
            headerHeight: thisPage.headerHeight
            headerState: "stateView"
            headerText: "Templates:"
            anchors.top: groupMVD.bottom
            anchors.topMargin: viewMargin
            width: thisPage.width
            sideMargin: thisPage.sideMargin
            onPopulated: {
                populateChildModels(id);
            }
            onPopulatedEmpty: {
                console.log("empty template model")
                tagMVD.clear();
                tagMVD.headerState = 'stateParentEmpty';
                contactMVD.clear();
                contactMVD.headerState = 'stateParentEmpty';
            }
            onCleared: {
                tagMVD.clear();
                contactMVD.clear();
            }
            onHeaderClicked:{
                var group_id = getGroupId();
                var template_id = getTemplateId();
                openConfigurePage("Template", currentIndex, group_id, template_id, null, null);
            }
            customDelegate: ViewDelegate{ id: templateDelegate
                width: templateMVD.width - (2 * sideMargin)
                height: templateMVD.itemHeight
                text: model.name + ", " + model.id
                fontSize: templateMVD.fontSize
                onClicked:{
                    console.log("templateMVD Delegate Clicked");
                    templateMVD.currentIndex = index;
                    templateMVD.populateChildModels(model.id);
                }
                onDoubleClicked:{
                    console.log("templateMVD Delegate Double Clicked");
                    templateMVD.currentIndex = index;
                    //var group_id = getGroupId();
                    //var template_id = getTemplateId();
                    openConfigurePage("Template", templateMVD.currentIndex, model.group_id, model.id, null, null);
                }
                onPressAndHold: {
                    console.log("templateMVD Delegate Presed and Held");
                    templateMVD.currentIndex = index;
                    console.log ("templateMVD Height is: " + templateMVD.height)
                    console.log ("templateMVD.height is: " + templateMVD.height)
                    showContextMenu(templateDelegate);
                    height = templateMVD.itemHeight + 350
                    console.log ("templateMVD Height is: " + templateMVD.height)
                    console.log ("templateDelegate.height is: " + templateDelegate.height)
                }
                onMenuClosing: {
                    console.log("templateMVD Delegate Menu Closing");
                    height = templateMVD.itemHeight
                }
            }

            function populateChildModels(id) {
                var template_id = id;
                //template has 2 child models, so we populate both
                var rs = DB.getTags(template_id);
                tagMVD.populate(rs, "parent");
                tagMVD.headerState = 'stateView';
                rs = DB.getContacts(template_id);
                contactMVD.populate(rs, "parent");
                contactMVD.headerState = 'stateView';
            }
        }

        ///////////////////////////////////////////////////////////////////////////////////////
        // Tag ModelViewDelegate
        ///////////////////////////////////////////////////////////////////////////////////////

        LandedMVD {
            id: tagMVD
            fontSize: thisPage.fontSize
            itemHeight: thisPage.itemHeight
            headerHeight: thisPage.headerHeight
            headerState: "stateView"
            headerText: "Tags:"
            anchors.top: templateMVD.bottom
            anchors.topMargin: viewMargin
            width: thisPage.width
            sideMargin: thisPage.sideMargin
            customDelegate: ViewDelegate{
                width: tagMVD.width  - (2 * sideMargin)
                height: tagMVD.itemHeight
                text: model.tag_order + ", " + model.name + ", " + model.default_value + ", " + model.template_id + ", " + model.comment
                fontSize: tagMVD.fontSize
                onClicked:{
                    console.log("Tag Delegate Clicked");
                    tagMVD.currentIndex = index;
                    //no child models to populate
                }
                onDoubleClicked:{
                    console.log("Tag Delegate Double Clicked");
                    tagMVD.currentIndex = index;
                    //var group_id = getGroupId();
                    //var template_id = getTemplateId();
                    //var tag_id = getTagId();
                    console.log("opening next page with values:")
                    console.log("currentIndex: " + tagMVD.currentIndex + ", group_id: " + model.group_id + ", template_id: " + model.template_id + ", tag_id: " + model.id )
                    openConfigurePage("Tag", tagMVD.currentIndex, model.group_id, model.template_id, model.id, null);
                }
            }
            //onPopulated:
            //onCleared:
            onHeaderClicked:{
                var group_id = getGroupId();
                var template_id = getTemplateId();
                var tag_id = getTagId();
                openConfigurePage("Tag", currentIndex, group_id, template_id, tag_id, null);
            }
        }

        ///////////////////////////////////////////////////////////////////////////////////////
        // Contact ModelViewDelegate
        ///////////////////////////////////////////////////////////////////////////////////////

        LandedMVD {
            id: contactMVD
            fontSize: thisPage.fontSize
            itemHeight: thisPage.itemHeight
            headerHeight: thisPage.headerHeight
            headerState: "stateView"
            headerText: "Contacts:"
            anchors.top: tagMVD.bottom
            anchors.topMargin: viewMargin
            width: thisPage.width
            sideMargin: thisPage.sideMargin
            customDelegate: ViewDelegate{
                width: contactMVD.width - (2 * sideMargin)
                height: contactMVD.itemHeight
                text: model.name + ", " + model.phone + ", " + model.id
                fontSize: contactMVD.fontSize
                onClicked: {
                    console.log("Contact Delegate Clicked");
                    contactMVD.currentIndex = index;
                    //no child models to populate
                }
                onDoubleClicked:{
                    console.log("Contact Delegate Double Clicked");
                    contactMVD.currentIndex = index;
                    console.log("opening next page with values:");
                    console.log("currentIndex: " + contactMVD.currentIndex + ", group_id: " + model.group_id + ", template_id: " + model.template_id + ", contact_id: " + model.id )
                    openConfigurePage("Contact", contactMVD.currentIndex, model.group_id, model.template_id, null, model.id);
                }
            }
            //onPopulated:
            onHeaderClicked:{
                console.log("click received");
                //var group_id = groupMVD.getGroupId();
                var group_id = getGroupId();
                var template_id = getTemplateId();
                var contact_id = getContactId();
                openConfigurePage("Contact", currentIndex, group_id, template_id, null, contact_id);
            }
        }
    }

    ///////////////////////////////////////////////////////////////////////////////////////
    // Functions
    ///////////////////////////////////////////////////////////////////////////////////////

    function openConfigurePage(entity, currentIndex, group_id, template_id, tag_id, contact_id) {
        //this function is a wrapper for the nextPage signal
        //We first save a reference to the caller MVG,
        //and save the indexes of all MVGs.
        //this info will be used when we pop back from the configure Page.
        populationMode = "transfer";
        nextPage(entity, "Configure", currentIndex, group_id, template_id, tag_id, contact_id);
    }


    function getGroupId() {
        return groupMVD.getId();
    }

    function getTemplateId() {
        return templateMVD.getId();
    }

    function getTagId() {
        return tagMVD.getId();
    }

    function getContactId() {
        return contactMVD.getId();
    }

    menuitems: [
        AUIMenuAction {
            text: (appWindow.fontSize == appWindow.largeFonts) ? qsTr("Small Fonts" ) : qsTr("Large Fonts");
            onClicked: (appWindow.fontSize == appWindow.largeFonts) ? appWindow.fontSize = appWindow.smallFonts : appWindow.fontSize = appWindow.largeFonts;
        },
        AUIMenuAction {
            text: qsTr("Recreate DB");
            onClicked: DBInit.initiateDb();
        },
        AUIMenuAction {
            text: qsTr("Refresh DB")
            onClicked: DBInit.populateDb();
        }
  ]



}
