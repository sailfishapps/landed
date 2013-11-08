import QtQuick 1.1
import "../javascript/settingsDB.js" as DB

ListModel {
    id: templateModel
    function populate(group_id){
        templateModel.clear();
        var rs = DB.getMessageTemplates(group_id);
        console.log("Template model populating using group_id: " + group_id + ", No Rows: " + rs.rows.length);
        templateView.resize(rs.rows.length+1); //add 1 for the custom button
        for(var i = 0; i < rs.rows.length; i++) {
            templateModel.append({"button_label": rs.rows.item(i).button_label, "msg_status": rs.rows.item(i).msg_status, "template_id": rs.rows.item(i).id});
            console.log("button_label is: " + rs.rows.item(i).button_label + ", msg_status is: " + rs.rows.item(i).msg_status);
        }
        //templateModel.append({"button_label":  "Create Custom SMS", "msg_status": "Ok", "template_id": "-999"});

        if (rs.rows.length > 0) {
            thisModel.populated(rs.rows.item(0).id);
        }
        else{
            thisModel.populated("");
        }
    }
}
