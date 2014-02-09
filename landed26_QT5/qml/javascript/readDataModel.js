.pragma library
.import QtQuick.LocalStorage 2.0 as LS

var symb = '@';

// First, let's create a short helper function to get the database connection
function getDatabase() {
    //storage location on Sailfish is /home/nemo/.local/share/data/QML/OfflineStorage/Databases
    return LS.LocalStorage.openDatabaseSync("Landed25", "1.0", "StorageDatabase", 100000);
}

//TODO: refactoring
//separate this file into 3 bits
//one offereing the DB
// a second with just queries (used by Landed)
// a third with DML statemetns (inserts, deletes, updates, upserts)

//If we are clever enough we can then replace the query file with a similar one querying a json file

//////////////////////////////////////////////////////////////////////////////////////////////
// Retrieval functions, get data
//////////////////////////////////////////////////////////////////////////////////////////////

function getArea(area_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM Area g WHERE g.id = ?;', [area_id]);
        }
    )
    return rs;
}

function getPrimaryArea() {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM Area g WHERE g.primary_area = 1;');
        }
    )
    return rs;
}

function getAreas() {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM Area');
        }
    )
    return rs;
}

//////////////////////////////////////////////////////////////////////////////////////////////

function getTemplate(template_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM Template t WHERE t.id = ?;', [template_id]);
        }
    )
    return rs;
}

function getTemplates(area_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM Template t where t.area_id= ?;', [area_id]);
        }
    )
    return rs;
}

//////////////////////////////////////////////////////////////////////////////////////////////

function getTags(area_id, template_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM Tag t WHERE t.area_id = ? AND t.template_id = ? ORDER BY tag_order;', [area_id, template_id]);
        }
    )
    return rs;
}

//////////////////////////////////////////////////////////////////////////////////////////////

function getContact(area_id, template_id, contact_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM Contact c WHERE c.area_id = ? AND c.template_id = ? AND c.id = ?;', [area_id, template_id, contact_id]);
        }
    )
    return rs;
}


function getPrimaryContact(area_id, template_id, any) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM Contact c WHERE c.area_id = ? AND c.template_id = ? AND c.primary_contact = 1;', [area_id, template_id]);

            if ((rs.rows.length == 0) && (any == 1)) {
                //no primary contact available, take the first one
                rs = tx.executeSql('SELECT * FROM Contact c WHERE c.area_id = ? AND c.template_id = ? LIMIT 1;', [area_id, template_id]);
            }
        }
    )
    return rs;
}

function getContacts(area_id, template_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM Contact c WHERE c.area_id = ? AND c.template_id = ? ORDER BY c.primary_contact DESC;', [area_id, template_id]);
        }
    )
    return rs;
}


