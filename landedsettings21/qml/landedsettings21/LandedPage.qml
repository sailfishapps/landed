import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

AUIPage {
    id: thisPage
//    tools: commonTools

    signal nextPage(string configureEntity, string configureAction, int currentIndex, string group_id, string template_id, string tag_id, string contact_id)
    signal cancelled()
    signal saved()
    signal backButtonClicked()
    signal backPage(string configureEntity, string configureAction, int currentIndex, string group_id, string template_id, string tag_id, string contact_id)

    property int buttonMargin: 10
    property int buttonHeight: 60
    property int itemHeight: 40;
    property int headerHeight: itemHeight;
    property int viewMargin: 18;
    property int fontSize: 24
    property color backGroundColor: "black"
    property string configureAction

}
