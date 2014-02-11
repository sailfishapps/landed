import QtQuick 2.0
//import QtQuick 1.1
import "../javascript/readDataModel.js" as DB

ListModel {
    id: contactModel
    function populate(area_id, template_id){
        clear();
        var db = DB.DataModel();
        var rs = db.getContacts(area_id, template_id);
        console.log("Contact model populating for area_id:" + area_id + ", template: " + template_id + ", No Rows: " + rs.rows.length);
        contactView.resize(rs.rows.length);
        for(var i = 0; i < rs.rows.length; i++) {
            console.log(rs.rows.item(i).name);
//TODO, when populated from JSON, Foreign Keys to parent may not be provided by query. We should take from function params (see SMSTemplateListModel)
            contactModel.append({"name": rs.rows.item(i).name, "phone": rs.rows.item(i).phone, "primary_contact":  rs.rows.item(i).primary_contact, "contact_id":  rs.rows.item(i).id});
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
