.pragma library

var symb = '@';

// First, let's create a short helper function to get the database connection
function getDatabase() {
    //storage location on Sailfish is /home/nemo/.local/share/data/QML/OfflineStorage/Databases
    //return openDatabaseSync("Landed", "15.0", "StorageDatabase", 100000);
    return openDatabaseSync("Landed21", "15.0", "StorageDatabase", 100000);
}

//////////////////////////////////////////////////////////////////////////////////////////////
// Retrieval functions, get data
//////////////////////////////////////////////////////////////////////////////////////////////

function getGroup(group_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM TemplateGroup g WHERE g.id = ?;', [group_id]);
        }
    )
    return rs;
}

function getActiveGroup() {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM TemplateGroup g WHERE g.active = 1;');
        }
    )
    return rs;
}

function getTemplateGroups() {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM TemplateGroup');
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

function getMessageTemplates(group_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM Template t where t.group_id= ?;', [group_id]);
        }
    )
    return rs;
}

//////////////////////////////////////////////////////////////////////////////////////////////

function getTag(tag_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM Tag t WHERE t.id = ?;', [tag_id]);
        }
    )
    return rs;
}

function getTags(template_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM Tag g WHERE g.template_id = ? ORDER BY tag_order;', [template_id]);
        }
    )
    return rs;
}

//////////////////////////////////////////////////////////////////////////////////////////////

function getContact(template_id, contact_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM Contact c WHERE c.template_id = ? AND c.id = ?;', [template_id, contact_id]);
        }
    )
    return rs;
}


function getActiveContact(template_id, any) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM Contact c WHERE c.template_id = ? AND c.active = 1;', [template_id]);

            if ((rs.rows.length == 0) && (any == 1)) {
                //no active contact available, take the first one
                rs = tx.executeSql('SELECT * FROM Contact c WHERE c.template_id = ? AND ROWNUM <=1;', [template_id]);
            }
        }
    )
    return rs;
}

function getContacts(template_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM Contact c WHERE c.template_id = ? ORDER BY c.active DESC;', [template_id]);
        }
    )
    return rs;
}


//////////////////////////////////////////////////////////////////////////////////////////////
// Data Change Functions
//////////////////////////////////////////////////////////////////////////////////////////////

function activateGroup(group_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('UPDATE TemplateGroup SET active= ?;', [0]);
            rs = tx.executeSql('UPDATE TemplateGroup SET active= ? WHERE id = ?;', [1, group_id]);
            tx.executeSql('commit');
        }
    )
}

function insertGroup(name, active) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            if (active == 1) {
                //deactivate all other groups
                rs = tx.executeSql('UPDATE TemplateGroup SET active= ?;', [0]);
            }
            rs = tx.executeSql('INSERT INTO TemplateGroup VALUES(?, ?, ?, ?)', [ null, name, '1.0', active ]);
            tx.executeSql('commit');
        }
    )
}

function deleteGroup(group_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            //cascade delete child entities first
            rs = tx.executeSql('DELETE FROM Tag WHERE template_id IN (SELECT id FROM Template WHERE group_id = ?);', [group_id]);
            rs = tx.executeSql('DELETE FROM Contact WHERE template_id IN (SELECT id FROM Template WHERE group_id = ?);', [group_id]);
            rs = tx.executeSql('DELETE FROM Template WHERE group_id = ?;', [group_id]);
            rs = tx.executeSql('DELETE FROM TemplateGroup WHERE id = ?;', [group_id]);
            //tx.executeSql('commit');
        }
    )
}

//////////////////////////////////////////////////////////////////////////////////////////////

function insertTemplate(group_id, name, label, msg_status) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            var sql = 'INSERT INTO Template ';
            sql = sql + '(id, group_id, name, button_label, msg_status) ';
            sql = sql + 'VALUES(?, ?, ?, ?, ?)';
            rs = tx.executeSql(sql, [ null, group_id, name, label, msg_status ]);
            //tx.executeSql('commit');
        }
    )
}

function deleteTemplate(group_id, template_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            //cascade delete child entities
            rs = tx.executeSql('DELETE FROM Tag WHERE template_id = ?;', [template_id]);
            rs = tx.executeSql('DELETE FROM Contact WHERE template_id = ?;', [template_id]);
            rs = tx.executeSql('DELETE FROM Template WHERE group_id = ? AND id = ?;', [group_id, template_id]);
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
