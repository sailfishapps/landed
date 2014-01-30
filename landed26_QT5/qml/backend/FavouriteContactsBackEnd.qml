import QtQuick 2.0
//import QtQuick 1.1
import "../javascript/settingsDB.js" as DB

Item {
    function getContact(template_id) {
        var rs = DB.getActiveContact(template_id, 1);
        return rs;
    }
}

