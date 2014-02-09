//////////////////////////////////////////////////////////////////////////////////////////////
// Data Change Functions
//////////////////////////////////////////////////////////////////////////////////////////////

function activateArea(area_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('UPDATE Area SET primary_area= ?;', [0]);
            rs = tx.executeSql('UPDATE Area SET primary_area= ? WHERE id = ?;', [1, area_id]);
            tx.executeSql('commit');
        }
    )
}

function insertArea(name, primary_area) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            if (primary_area == 1) {
                //deactivate all other areas
                rs = tx.executeSql('UPDATE Area SET active= ?;', [0]);
            }
            rs = tx.executeSql('INSERT INTO Area VALUES(?, ?, ?, ?)', [ null, name, '1.0', primary_area ]);
            tx.executeSql('commit');
        }
    )
}

function deleteArea(area_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            //cascade delete child entities first
            rs = tx.executeSql('DELETE FROM Tag WHERE template_id IN (SELECT id FROM Template WHERE area_id = ?);', [area_id]);
            rs = tx.executeSql('DELETE FROM Contact WHERE template_id IN (SELECT id FROM Template WHERE area_id = ?);', [area_id]);
            rs = tx.executeSql('DELETE FROM Template WHERE area_id = ?;', [area_id]);
            rs = tx.executeSql('DELETE FROM Area WHERE id = ?;', [area_id]);
            //tx.executeSql('commit');
        }
    )
}

//////////////////////////////////////////////////////////////////////////////////////////////

function insertTemplate(area_id, name, label, msg_status) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            var sql = 'INSERT INTO Template ';
            sql = sql + '(id, area_id, name, button_label, msg_status) ';
            sql = sql + 'VALUES(?, ?, ?, ?, ?)';
            rs = tx.executeSql(sql, [ null, area_id, name, label, msg_status ]);
            //tx.executeSql('commit');
        }
    )
}

function deleteTemplate(area_id, template_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            //cascade delete child entities
            rs = tx.executeSql('DELETE FROM Tag WHERE template_id = ?;', [template_id]);
            rs = tx.executeSql('DELETE FROM Contact WHERE template_id = ?;', [template_id]);
            rs = tx.executeSql('DELETE FROM Template WHERE area_id = ? AND id = ?;', [area_id, template_id]);
            //tx.executeSql('commit');
        }
    )
}

//////////////////////////////////////////////////////////////////////////////////////////////

function upsertTag(tag_id, template_id, name, placeholder, comment, order) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            if (tag_id.length > 0) {
                console.log ("do an update");
                rs = tx.executeSql('UPDATE Tag SET template_id = ?, name = ?, default_value = ?, comment = ?, order = ? WHERE id = ?;', [template_id, name, placeholder, comment, order]);
            }
            else {
                console.log ("do an insert");
                rs = tx.executeSql('INSERT INTO tag (id, name, template_id, default_value, comment, tag_order) VALUES (?, ? ,?, ?, ?, ?)', [ null, name, template_id, placeholder, comment, order ]);
            }
            //tx.executeSql('commit');
        }
    )
}

function deleteTag(template_id, tag_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('DELETE FROM Tag WHERE template_id = ? AND id = ?;', [template_id, tag_id]);
            //tx.executeSql('commit');
        }
    )
}

//////////////////////////////////////////////////////////////////////////////////////////////

function upsertContact(contact_id, template_id, name, phone, active) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            if (active == 1) {
                rs = tx.executeSql('UPDATE Contact SET active= ? WHERE template_id = ?;', [0, template_id]);
            }

            if (contact_id.length > 0) {
                console.log ("do an update");
                rs = tx.executeSql('UPDATE Contact SET template_id = ?, name = ?, phone = ?, active = ? WHERE id = ?;', [template_id, name, phone, active, contact_id]);
            }
            else {
                console.log ("do an insert");
                rs = tx.executeSql('INSERT INTO Contact (id, name, template_id, phone, active) VALUES (?, ? ,?, ?, ?)', [ null, name, template_id, phone, active ]);
            }
            //tx.executeSql('commit');
        }
    )
}

function deleteContact(template_id, contact_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('DELETE FROM Contact WHERE template_id = ? AND id = ?;', [template_id, contact_id]);
            //tx.executeSql('commit');
        }
    )
}

//////////////////////////////////////////////////////////////////////////////////////////////
