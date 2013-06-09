.pragma library

var symb = '@';

// First, let's create a short helper function to get the database connection
function getDatabase() {
     return openDatabaseSync("Landed", "15.0", "StorageDatabase", 100000);
}

function initiateDb() {
    var db = getDatabase();
    db.transaction(
        function(tx) {
            // Create the database if it doesn't already exist
            tx.executeSql("DROP TABLE IF EXISTS TemplateGroup");
            tx.executeSql('CREATE TABLE IF NOT EXISTS TemplateGroup(group_id INTEGER PRIMARY KEY, name TEXT, version TEXT, active INTEGER, UNIQUE (name))');
            tx.executeSql("DROP TABLE IF EXISTS Template");
            tx.executeSql('CREATE TABLE IF NOT EXISTS Template(template_id INTEGER PRIMARY KEY, name TEXT, group_id INTEGER, version TEXT, UNIQUE (name, group_id), FOREIGN KEY(group_id) REFERENCES TemplateGroup(group_id))');
            tx.executeSql("DROP TABLE IF EXISTS Tag");
            tx.executeSql('CREATE TABLE IF NOT EXISTS Tag(tag_id INTEGER PRIMARY KEY, name TEXT, template_id INTEGER, default_value TEXT, comment TEXT, tag_order INTEGER, UNIQUE (name, template_id) FOREIGN KEY(template_id) REFERENCES Template(template_id))');
            tx.executeSql("DROP TABLE IF EXISTS Contact");
            tx.executeSql('CREATE TABLE IF NOT EXISTS Contact(contact_id INTEGER PRIMARY KEY, name TEXT, template_id INTEGER, phone TEXT, UNIQUE (name, template_id))');
        }
    )
}

function populateDb() {
    var db = getDatabase();
    db.transaction(
        function(tx) {
            tx.executeSql("DELETE FROM TemplateGroup");
            tx.executeSql('INSERT INTO TemplateGroup VALUES(?, ?, ?, ?)', [ null, 'South Africa', '1.0', 1 ]);
            tx.executeSql('INSERT INTO TemplateGroup VALUES(?, ?, ?, ?)', [ null, 'Greece', '1.0', 0 ]);

            tx.executeSql("DELETE FROM Template");
            //tx.executeSql('INSERT INTO Template VALUES(?, ?, ?, ?)', [ null, 'DefaultOKMsg', 'South Africa', '1.0' ]);
            //tx.executeSql('INSERT INTO Template VALUES(?, ?, ?, ?)', [ null, 'DefaultNotOKMsg', 'South Africa', '1.0' ]);

            tx.executeSql('INSERT INTO Template SELECT ?, ?, group_id, ? FROM TemplateGroup WHERE name = ?', [ null, 'DefaultOKMsg', '1.0', 'South Africa' ]);
            tx.executeSql('INSERT INTO Template SELECT ?, ?, group_id, ? FROM TemplateGroup WHERE name = ?', [ null, 'DefaultNotOKMsg', '1.0', 'South Africa' ]);
            tx.executeSql('INSERT INTO Template SELECT ?, ?, group_id, ? FROM TemplateGroup WHERE name = ?', [ null, 'DefaultOKMsg', '1.0', 'Greece' ]);

            tx.executeSql("DELETE FROM Tag");
            var grandparent = 'South Africa';
            var parent = 'DefaultOKMsg';
            var name = 'header';
            var tag_order = 0;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'Used by receiver app to identify as SMS from Landed', tag_order, parent, grandparent ]);
            name = 'intro';
            tag_order = 1;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, 'Chris has landed at:', 'start of message', tag_order, parent, grandparent ]);
            name = 'lati';
            tag_order = 2;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows latitude', tag_order, parent, grandparent ]);
            name = 'longi';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows longitude', tag_order, parent, grandparent ]);
            name = 'alti';
            tag_order = 4;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows altitude', tag_order, parent, grandparent ]);
            name = 'datetime';
            tag_order = 5;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows date and time', tag_order, parent, grandparent ]);
            name = 'status';
            tag_order = 6;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, 'Status: OK', 'shows status: Ok or NOT Ok', tag_order, parent, grandparent ]);
            name = 'recovery';
            tag_order = 7;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, 'He is awaiting recovery', 'shows if recovery required', tag_order, parent, grandparent ]);

            name = 'Candice';
            var phone = '+27 82 658 67 19';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, template_id, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, phone, parent, grandparent ]);


            parent = 'DefaultNotOKMsg';
            name = 'header';
            tag_order = 0;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'Used by receiver app to identify as SMS from Landed', tag_order, parent, grandparent ]);
            name = 'intro';
            tag_order = 1;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, 'Chris has landed at:', 'start of message', tag_order, parent, grandparent ]);
            name = 'lati';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows latitude', tag_order, parent, grandparent ]);
            name = 'longi';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows longitude', tag_order, parent, grandparent ]);
            name = 'alti';
            tag_order = 4;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows altitude', tag_order, parent, grandparent ]);
            name = 'datetime';
            tag_order = 5;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows date and time', tag_order, parent, grandparent ]);
            name = 'status';
            tag_order = 6;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, 'Status: NOT OK', 'shows status: Ok or NOT Ok', tag_order, parent, grandparent ]);


            var grandparent = 'Greece';
            parent = 'DefaultOKMsg';
            name = 'header';
            tag_order = 0;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'Used by receiver app to identify as SMS from Landed', tag_order, parent, grandparent ]);
            name = 'intro';
            tag_order = 1;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, 'Chris has landed at:', 'start of message', tag_order, parent, grandparent ]);
            name = 'lati';
            tag_order = 2;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows latitude', tag_order, parent, grandparent ]);
            name = 'longi';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, template_id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows longitude', tag_order, parent, grandparent ]);

            name = 'Paul';
            phone = '+41 79 697 51 20';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, template_id, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.group_id AND t.name = ? AND g.name = ?', [ null, name, phone, parent, grandparent ]);


        }
    )
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

function getContacts(template_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT * FROM Contact c WHERE c.template_id = ?;', [template_id]);
        }
    )
    return rs;
}

function upsertContact(contact_id, template_id, name, phone) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            if (contact_id.length > 0) {
                console.log ("do an update");
                rs = tx.executeSql('UPDATE Contact SET template_id = ?, name = ?, phone = ? WHERE contact_id = ?;', [template_id, name, phone, contact_id]);
            }
            else {
                console.log ("do an insert");
                rs = tx.executeSql('INSERT INTO Contact (contact_id, name, template_id, phone) VALUES (?, ? ,?, ?)', [ null, name, template_id, phone ]);

            }

        }
    )
}

// used by the landed app to build up messages with placeholders that the app will replace before sending

function buildDefaultMessage (template_id) {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT default_value FROM Tag g WHERE g.template_id = ? ORDER BY tag_order;', [template_id]);
        }
    )
    return rs;
}

