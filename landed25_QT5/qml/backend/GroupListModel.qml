import QtQuick 2.0
//import QtQuick 1.1
import "../javascript/settingsDB.js" as DB

ListModel {
    id: groupModel
    function populate(){
        clear();
        var rs = DB.getTemplateGroups();
        console.log("Group model populating: No Rows: " + rs.rows.length);
        groupView.resize(rs.rows.length);
        for(var i = 0; i < rs.rows.length; i++) {
            groupModel.append({"name": rs.rows.item(i).name, "active":  rs.rows.item(i).active, "group_id":  rs.rows.item(i).id});
        }
    }
    function setExclusiveActiveItem(activeItem) {
        //sets one item to active, and all others to inactive
        for(var i = 0; i < count; i++) {
            if (i == activeItem) {
                setProperty(i, "active", 1);
            }
            else {
                //deactivate all other items
                setProperty(i, "active", 0);
            }
        }
    }
}
