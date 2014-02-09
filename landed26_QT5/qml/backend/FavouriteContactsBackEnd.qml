import QtQuick 2.0
//import QtQuick 1.1
import "../javascript/readDataModel.js" as DB

Item {
    function getPrimaryContact(area_id, template_id) {
        var rs = DB.getPrimaryContact(area_id, template_id, 1);
        return rs;
    }
}

