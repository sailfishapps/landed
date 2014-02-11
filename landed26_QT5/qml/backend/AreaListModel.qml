import QtQuick 2.0
//import QtQuick 1.1
import "../javascript/readDataModel.js" as DB

ListModel {
    id: areaModel
    function populate(){
        clear();
        var db = DB.DataModel();
        var rs = db.getAreas();
        console.log("area model populating: No Rows: " + rs.rows.length);
        areaView.resize(rs.rows.length);
        for(var i = 0; i < rs.rows.length; i++) {
            areaModel.append({"name": rs.rows.item(i).name, "primary_area":  rs.rows.item(i).primary_area, "area_id":  rs.rows.item(i).id});
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
