import QtQuick 2.0
//import QtQuick 1.1
import "../javascript/readDataModel.js" as DB

ListModel {
    id: templateModel
    function populate(area_id){
        templateModel.clear();
        var db = DB.DataModel();
        var rs = db.getTemplates(area_id);
        console.log("Template model populating using area_id: " + area_id + ", No Rows: " + rs.rows.length);
        templateView.resize(rs.rows.length+1); //add 1 for the custom button
        for(var i = 0; i < rs.rows.length; i++) {
            //we add the area_id that was passed as a param, rather than expecting it to come from the model
            templateModel.append({"button_label": rs.rows.item(i).button_label, "msg_status": rs.rows.item(i).msg_status, "template_id": rs.rows.item(i).id, "area_id": area_id});
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
