.pragma library

Qt.include("settingsDB.js")

function initiateDb() {
    var db = getDatabase();
    db.transaction(
        function(tx) {
            // Create the database if it doesn't already exist
            tx.executeSql("DROP TABLE IF EXISTS TemplateGroup");
            tx.executeSql('CREATE TABLE IF NOT EXISTS TemplateGroup(id INTEGER PRIMARY KEY, name TEXT, version TEXT, active INTEGER, UNIQUE (name))');
            tx.executeSql("DROP TABLE IF EXISTS Template");
            tx.executeSql('CREATE TABLE IF NOT EXISTS Template(id INTEGER PRIMARY KEY, name TEXT, button_label TEXT, msg_status TEXT, group_id INTEGER, version TEXT, UNIQUE (name, group_id), FOREIGN KEY(group_id) REFERENCES TemplateGroup(id))');
            tx.executeSql("DROP TABLE IF EXISTS Tag");
            tx.executeSql('CREATE TABLE IF NOT EXISTS Tag(id INTEGER PRIMARY KEY, name TEXT, template_id INTEGER, default_value TEXT, comment TEXT, tag_order INTEGER, UNIQUE (name, template_id), FOREIGN KEY(template_id) REFERENCES Template(id))');
            tx.executeSql("DROP TABLE IF EXISTS Contact");
            tx.executeSql('CREATE TABLE IF NOT EXISTS Contact(id INTEGER PRIMARY KEY, name TEXT, template_id INTEGER, phone TEXT, active INTEGER, UNIQUE (name, template_id), FOREIGN KEY(template_id) REFERENCES Template(id))');
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
            tx.executeSql('INSERT INTO TemplateGroup VALUES(?, ?, ?, ?)', [ null, 'Schweiz', '1.0', 0 ]);

            tx.executeSql("DELETE FROM Template");

            tx.executeSql('INSERT INTO Template SELECT ?, ?, ?, ?, id, ? FROM TemplateGroup WHERE name = ?', [ null, 'DefaultOKMsg', 'Create Default Recover SMS', 'Ok', '1.0', 'South Africa' ]);
            tx.executeSql('INSERT INTO Template SELECT ?, ?, ?, ?, id, ? FROM TemplateGroup WHERE name = ?', [ null, 'DefaultNotOKMsg', 'Create Default "Help Me!" SMS', 'NotOk', '1.0', 'South Africa' ]);
            tx.executeSql('INSERT INTO Template SELECT ?, ?, ?, ?, id, ? FROM TemplateGroup WHERE name = ?', [ null, 'DefaultOKMsg', 'Create Default Recover SMS', 'Ok', '1.0', 'Greece' ]);
            tx.executeSql('INSERT INTO Template SELECT ?, ?, ?, ?, id, ? FROM TemplateGroup WHERE name = ?', [ null, 'DefaultNotOKMsg', 'Create Default "Help Me!" SMS', 'NotOk', '1.0', 'Greece' ]);
            tx.executeSql('INSERT INTO Template SELECT ?, ?, ?, ?, id, ? FROM TemplateGroup WHERE name = ?', [ null, 'DefaultOKMsg', 'Create Default Recover SMS', 'Ok', '1.0', 'Schweiz' ]);
            tx.executeSql('INSERT INTO Template SELECT ?, ?, ?, ?, id, ? FROM TemplateGroup WHERE name = ?', [ null, 'DefaultNotOKMsg', 'Create Default "Help Me!" SMS', 'NotOk', '1.0', 'Schweiz' ]);


            tx.executeSql("DELETE FROM Tag");


            var grandparent = 'South Africa';
            var parent = 'DefaultOKMsg';
            var name = 'header';
            var tag_order = 0;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'Used by receiver app to identify as SMS from Landed', tag_order, parent, grandparent ]);
            name = 'intro';
            tag_order = 1;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, 'Chris has landed at:', 'start of message', tag_order, parent, grandparent ]);
            name = 'lati';
            tag_order = 2;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows latitude', tag_order, parent, grandparent ]);
            name = 'longi';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows longitude', tag_order, parent, grandparent ]);
            name = 'alti';
            tag_order = 4;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows altitude', tag_order, parent, grandparent ]);
            name = 'datetime';
            tag_order = 5;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows date and time', tag_order, parent, grandparent ]);
            name = 'status';
            tag_order = 6;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, 'Status: OK', 'shows status: Ok or NOT Ok', tag_order, parent, grandparent ]);
            name = 'recovery';
            tag_order = 7;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, 'He is awaiting recovery', 'shows if recovery requiNotOk', tag_order, parent, grandparent ]);

            name = 'Mary';
            var phone = '+2712345678';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 1, parent, grandparent ]);


            parent = 'DefaultNotOKMsg';
            name = 'header';
            tag_order = 0;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'Used by receiver app to identify as SMS from Landed', tag_order, parent, grandparent ]);
            name = 'intro';
            tag_order = 1;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, 'Chris has landed at:', 'start of message', tag_order, parent, grandparent ]);
            name = 'lati';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows latitude', tag_order, parent, grandparent ]);
            name = 'longi';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows longitude', tag_order, parent, grandparent ]);
            name = 'alti';
            tag_order = 4;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows altitude', tag_order, parent, grandparent ]);
            name = 'datetime';
            tag_order = 5;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows date and time', tag_order, parent, grandparent ]);
            name = 'status';
            tag_order = 6;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, 'Status: NOT OK', 'shows status: Ok or NOT Ok', tag_order, parent, grandparent ]);

            name = 'Mary';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 1, parent, grandparent ]);

            var grandparent = 'Greece';
            parent = 'DefaultOKMsg';
            name = 'header';
            tag_order = 0;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'Used by receiver app to identify as SMS from Landed', tag_order, parent, grandparent ]);
            name = 'intro';
            tag_order = 1;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, 'Chris has landed at:', 'start of message', tag_order, parent, grandparent ]);
            name = 'lati';
            tag_order = 2;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows latitude', tag_order, parent, grandparent ]);
            name = 'longi';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows longitude', tag_order, parent, grandparent ]);

            name = 'Paul';
            phone = '+41791234567';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 1, parent, grandparent ]);


            var grandparent = 'Schweiz';
            var parent = 'DefaultOKMsg';
            var name = 'header';
            var tag_order = 0;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'Used by receiver app to identify as SMS from Landed', tag_order, parent, grandparent ]);
            name = 'intro';
            tag_order = 1;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, 'Chris has landed at:', 'start of message', tag_order, parent, grandparent ]);
            name = 'lati';
            tag_order = 2;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows latitude', tag_order, parent, grandparent ]);
            name = 'longi';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows longitude', tag_order, parent, grandparent ]);
            name = 'alti';
            tag_order = 4;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows altitude', tag_order, parent, grandparent ]);
            name = 'datetime';
            tag_order = 5;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows date and time', tag_order, parent, grandparent ]);
            name = 'status';
            tag_order = 6;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, 'Status: OK', 'shows status: Ok or NOT Ok', tag_order, parent, grandparent ]);
            name = 'recovery';
            tag_order = 7;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, 'He is awaiting recovery', 'shows if recovery requiNotOk', tag_order, parent, grandparent ]);

            name = 'Stefan';
            var phone = '+417998765432';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 1, parent, grandparent ]);

            name = 'Chris';
            var phone = '+417911223344';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 0, parent, grandparent ]);


            parent = 'DefaultNotOKMsg';
            name = 'header';
            tag_order = 0;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'Used by receiver app to identify as SMS from Landed', tag_order, parent, grandparent ]);
            name = 'intro';
            tag_order = 1;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, 'Chris has landed at:', 'start of message', tag_order, parent, grandparent ]);
            name = 'lati';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows latitude', tag_order, parent, grandparent ]);
            name = 'longi';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows longitude', tag_order, parent, grandparent ]);
            name = 'alti';
            tag_order = 4;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows altitude', tag_order, parent, grandparent ]);
            name = 'datetime';
            tag_order = 5;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, symb + name + symb, 'shows date and time', tag_order, parent, grandparent ]);
            name = 'status';
            tag_order = 6;
            tx.executeSql('INSERT INTO Tag SELECT ?, ?, t.id, ?, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, 'Status: NOT OK', 'shows status: Ok or NOT Ok', tag_order, parent, grandparent ]);

            name = 'Stefan';
            var phone = '+417998765432';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 1, parent, grandparent ]);

            name = 'Chris';
            var phone = '+417911223344';;
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 0, parent, grandparent ]);


            tx.executeSql('commit');
        }
    )
}
