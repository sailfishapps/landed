import QtQuick 2.0
//import QtQuick 1.1
import "../javascript/settingsDB.js" as DB

ListModel {
    id: contactModel
    function populate(template_id){
        clear();
        var rs = DB.getContacts(template_id);
        console.log("Contact model populating for template: " + template_id + ", No Rows: " + rs.rows.length);
        contactView.resize(rs.rows.length);
        for(var i = 0; i < rs.rows.length; i++) {
            console.log(rs.rows.item(i).name);
            contactModel.append({"name": rs.rows.item(i).name, "phone": rs.rows.item(i).phone, "active":  rs.rows.item(i).active, "contact_id":  rs.rows.item(i).id});
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
