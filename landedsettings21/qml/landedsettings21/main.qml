import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0
//import "initiateDB.js" as DB

/*
Things to think about:


2) scrolling of a view with too many items.

3) repopulating of MainPage depending on
a) page pushed - reset currentIndex
b) page popped - from configPage - keep currentIndex if possible
c) MVD repopulated by parent MVD - reset currentIndex

4) Merge LandedGroup and LandedMVD qmls

*/

AUIPageStackWindow {
    id: appWindow

    initialPage: mainPage

    //Global properties, affecting the look and feel of the app (theme)
    //most pages will bind to these
    property int fontSize: largeFonts;
    //Note for some reason on the simulator (platform = 4), fonts are 2 1/3 larger than the N9 and QEMU, and thus smaller sizes must be used.
    //property int largeFonts: (platform == 4) ? 11 : 26
    //property int smallFonts: (platform == 4) ? 6 : 13
    property int largeFonts: (platform == 4) ? 10 : 23
    property int smallFonts: (platform == 4) ? 5 : 12
    property color backGroundColor: "black"


//TODO: We need to add a property / parameter howActivated
// which can either be pushed, or popped
// this is then used by the MVD to decide how the currentIndex should be set

//The real issue is the indexes and keys transfered between instances of our MVDs
//This gives us four modes for population:
//a) Mode INITIAL:
    //when mainPage is pushed there is no currentIndex, so we set everything to 0 --> OK
//b) Mode TRANSFER:
    //when we push from mainPage to a configuePage we want to transfer the settings of the mainPage MVG
    //to the configurePage --> OK
//c) Mode REFRESH:
    //when we pop back from a configuePage to MainPage we want to: --> NOT OK
    //keep the settings as cose as possible to how mainPage was previously, but take into account
    //any changes made in the configure page (add, delete, rename etc), thus a refresh is required.
    //c1) keep the previous mainPage settings as far as is possible (we may have deleted or added items)
    //c2) transfer the focus item from the configure Page to the mainPage (and repopulate childs accordingly)
//d) Mode PARENTCLICKED:
    //on mainPage, repopulate childs according to clicks / double clicks in parent models -->OK

    function copyProps(configureEntity, currentIndex, parentId) {
        //unfortunately pop does not allow properties to be passed, but as we always
        //return to mainPage we can set them directly
        mainPage.configureEntity = configureEntity;
        mainPage.currentIndex = currentIndex;
        if (parentId !== null) {
           mainPage.parentId = parentId;
        }
        else {
           mainPage.parentId =  0;
        }
    }

    MainPage {
        id: mainPage
        fontSize: appWindow.fontSize
        backGroundColor: appWindow.backGroundColor
        onNextPage: {
            console.log("NextPage signal received: configureEntity: " + configureEntity + ", Index : " + currentIndex);
            if (configureEntity =="Contact") pageStack.push(configureContactsPage, {group_id: group_id, template_id: template_id, currentIndex: currentIndex})
            else if (configureEntity =="Tag") pageStack.push(configureTagsPage, {group_id: group_id, template_id: template_id, currentIndex: currentIndex})
            else if (configureEntity =="Template") pageStack.push(configureTemplatesPage, {group_id: group_id, template_id: template_id, currentIndex: currentIndex})
            else if (configureEntity =="Group") pageStack.push(configureGroupsPage, {group_id: group_id, currentIndex: currentIndex})
            else console.log("ERROR: Unkonwn configureEntity for NextPage Signal")
        }
        onCancelled: pageStack.pop();
    }

    ConfigureGroupsPage {
        id: configureGroupsPage
        fontSize: appWindow.fontSize
        backGroundColor: appWindow.backGroundColor
        onNextPage: {
            if ((configureAction == "New") || (configureAction == "Edit")) {
                pageStack.push(newGroupPage, {configureAction: configureAction});
            }
            else if (configureAction == "Delete") {
                pageStack.push(deleteGroupPage, {configureAction: configureAction, group_id: group_id});
            }
        }
        onBackPage: {
            console.log ("outer BackPage. configureEntity: " + configureEntity + ", currentIndex: " + currentIndex);
            copyProps(configureEntity, currentIndex, null);
            pageStack.pop();
        }
    }

    NewGroupPage {
        id: newGroupPage
        fontSize: appWindow.fontSize
        backGroundColor: appWindow.backGroundColor
        onBackPage: pageStack.pop();
        onCancelled: pageStack.pop();
    }

    DeleteGroupPage {
        id: deleteGroupPage
        fontSize: appWindow.fontSize
        backGroundColor: appWindow.backGroundColor
        onBackPage: pageStack.pop();
        onCancelled: pageStack.pop();
    }

    ConfigureTemplatesPage {
        id: configureTemplatesPage
        fontSize: appWindow.fontSize
        backGroundColor: appWindow.backGroundColor
        onNextPage: {
            if ((configureAction == "New") || (configureAction == "Edit")) {
                console.log ("onNextPage; group_id is: " + group_id)
                pageStack.push(newTemplatePage, {configureAction: configureAction, group_id: group_id});
            }
            else if (configureAction == "Delete") {
                pageStack.push(deleteTemplatePage, {configureAction: configureAction, group_id: group_id, template_id: template_id});
            }
        }
        onBackPage: {
            console.log ("outer BackPage. configureEntity: " + configureEntity + ", currentIndex: " + currentIndex);
            copyProps(configureEntity, currentIndex, group_id);
            pageStack.pop();
        }

    }

    NewTemplatePage {
        id: newTemplatePage
        fontSize: appWindow.fontSize
        backGroundColor: appWindow.backGroundColor
        onBackPage: pageStack.pop();
        onCancelled: pageStack.pop();
    }

    DeleteTemplatePage {
        id: deleteTemplatePage
        fontSize: appWindow.fontSize
        backGroundColor: appWindow.backGroundColor
        onBackPage: pageStack.pop();
        onCancelled: pageStack.pop();
    }

    ConfigureTagsPage {
        id: configureTagsPage
        fontSize: appWindow.fontSize
        backGroundColor: appWindow.backGroundColor
        onNextPage: {
            if ((configureAction == "New") || (configureAction == "Edit")) {
                pageStack.push(newTagPage, {configureAction: configureAction, template_id: template_id});
            }
            else if (configureAction == "Delete") {
                pageStack.push(deleteTagPage, {configureAction: configureAction, template_id: template_id, tag_id: tag_id});
            }
        }
        onBackPage: {
            console.log ("outer BackPage. configureEntity: " + configureEntity + ", currentIndex: " + currentIndex);
            copyProps(configureEntity, currentIndex, template_id);
            pageStack.pop();
        }
    }

    NewTagPage {
        id: newTagPage
        fontSize: appWindow.fontSize
        backGroundColor: appWindow.backGroundColor
        onBackPage: pageStack.pop();
        onCancelled: pageStack.pop();
    }

    DeleteTagPage {
        id: deleteTagPage
        fontSize: appWindow.fontSize
        backGroundColor: appWindow.backGroundColor
        onBackPage: pageStack.pop();
        onCancelled: pageStack.pop();
    }

    ConfigureContactsPage {
        id: configureContactsPage
        fontSize: appWindow.fontSize
        backGroundColor: appWindow.backGroundColor
        onNextPage: {
            if ((configureAction == "New") || (configureAction == "Edit")) {
                pageStack.push(newContactPage, {configureAction: configureAction, template_id: template_id, contact_id: contact_id});
            }
            else if (configureAction == "Delete") {
                pageStack.push(deleteContactPage, {configureAction: configureAction, template_id: template_id, contact_id: contact_id});
            }
        }
        onBackPage: {
            console.log ("outer BackPage. configureEntity: " + configureEntity + ", currentIndex: " + currentIndex);
            copyProps(configureEntity, currentIndex, template_id);
            pageStack.pop();
        }
    }

    NewContactPage {
        id: newContactPage
        fontSize: appWindow.fontSize
        backGroundColor: appWindow.backGroundColor
        onBackPage: pageStack.pop();
        onCancelled: pageStack.pop();
    }

    DeleteContactPage {
        id: deleteContactPage
        fontSize: appWindow.fontSize
        backGroundColor: appWindow.backGroundColor
        onBackPage: pageStack.pop();
        onCancelled: pageStack.pop();
    }

/*
    AUIToolBarLayout {
        id: commonTools
        visible: true
        AUIToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    AUIMenu {
        id: myMenu
//        visualParent: pageStack
        AUIMenuLayout {
            AUIMenuItem {
                 text: (appWindow.fontSize == appWindow.largeFonts) ? qsTr("Small Fonts" ) : qsTr("Large Fonts");
                 onClicked: (appWindow.fontSize == appWindow.largeFonts) ? appWindow.fontSize = appWindow.smallFonts : appWindow.fontSize = appWindow.largeFonts;
            }
            AUIMenuItem {
                text: qsTr("Recreate DB")
                onClicked: DB.initiateDb();
            }
            AUIMenuItem {
                text: qsTr("Refresh DB")
                onClicked: DB.populateDb();
            }
        }
    }
*/

}
