.pragma library
.import QtQuick.LocalStorage 2.0 as LS

var symb = '@';

// First, let's create a short helper function to get the database connection
function getDatabase() {
    //storage location on Sailfish is /home/nemo/.local/share/data/QML/OfflineStorage/Databases
    return LS.LocalStorage.openDatabaseSync("Landed25", "1.0", "StorageDatabase", 100000);
}

function initiateDb() {
    console.log("initiating DB");
    var db = getDatabase();
    db.transaction(
        function(tx) {
            // Create the database if it doesn't already exist
            tx.executeSql("DROP TABLE IF EXISTS TemplateGroup");
            tx.executeSql('CREATE TABLE IF NOT EXISTS TemplateGroup(id INTEGER PRIMARY KEY, name TEXT, version TEXT, active INTEGER, latitude NUmBER, longitude NUMBER, UNIQUE (name))');
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
            tx.executeSql('INSERT INTO TemplateGroup VALUES(?, ?, ?, ?, ?, ?)', [ null, 'South Africa', '1.0', 1, -33.825, 18.502 ]);
            tx.executeSql('INSERT INTO TemplateGroup VALUES(?, ?, ?, ?, ?, ?)', [ null, 'Greece', '1.0', 0 , 38.1, 21.5]);
            tx.executeSql('INSERT INTO TemplateGroup VALUES(?, ?, ?, ?, ?, ?)', [ null, 'Schweiz', '1.0', 0, 50.0, 10.5 ]);
            tx.executeSql('INSERT INTO TemplateGroup VALUES(?, ?, ?, ?, ?, ?)', [ null, 'Italia', '1.0', 0, 43.55, 13.5 ]);

            tx.executeSql("DELETE FROM Template");

            tx.executeSql('INSERT INTO Template SELECT ?, ?, ?, ?, id, ? FROM TemplateGroup WHERE name = ?', [ null, 'DefaultOKMsg', 'Create Recovery SMS', 'Ok', '1.0', 'South Africa' ]);
            tx.executeSql('INSERT INTO Template SELECT ?, ?, ?, ?, id, ? FROM TemplateGroup WHERE name = ?', [ null, 'DefaultNotOKMsg', 'Create "Help Me!" SMS', 'NotOk', '1.0', 'South Africa' ]);
            tx.executeSql('INSERT INTO Template SELECT ?, ?, ?, ?, id, ? FROM TemplateGroup WHERE name = ?', [ null, 'DefaultOKMsg', 'Create Recovery SMS', 'Ok', '1.0', 'Greece' ]);
            tx.executeSql('INSERT INTO Template SELECT ?, ?, ?, ?, id, ? FROM TemplateGroup WHERE name = ?', [ null, 'DefaultNotOKMsg', 'Create "Help Me!" SMS', 'NotOk', '1.0', 'Greece' ]);
            tx.executeSql('INSERT INTO Template SELECT ?, ?, ?, ?, id, ? FROM TemplateGroup WHERE name = ?', [ null, 'DefaultOKMsg', 'Create Recovery SMS', 'Ok', '1.0', 'Schweiz' ]);
            tx.executeSql('INSERT INTO Template SELECT ?, ?, ?, ?, id, ? FROM TemplateGroup WHERE name = ?', [ null, 'DefaultNotOKMsg', 'Create "Help Me!" SMS', 'NotOk', '1.0', 'Schweiz' ]);
            tx.executeSql('INSERT INTO Template SELECT ?, ?, ?, ?, id, ? FROM TemplateGroup WHERE name = ?', [ null, 'DefaultOKMsg', 'Create Recovery SMS', 'Ok', '1.0', 'Italia' ]);
            tx.executeSql('INSERT INTO Template SELECT ?, ?, ?, ?, id, ? FROM TemplateGroup WHERE name = ?', [ null, 'DefaultNotOKMsg', 'Create "Help Me!" SMS', 'NotOk', '1.0', 'Italia' ]);

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

            name = 'Gussie Fink-Nottle';
            var phone = '+80 79 121 22 33';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 1, parent, grandparent ]);

            name = 'Aunt Agatha';
            var phone = '+80 79 987 45 76';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 0, parent, grandparent ]);

            name = 'Bertie Wooster';
            var phone = '+80 79 123 45 76';
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

            name = 'Gussie Fink-Nottle';
            var phone = '+80 79 121 22 33';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 1, parent, grandparent ]);

            name = 'Aunt Agatha';
            var phone = '+80 79 987 45 76';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 0, parent, grandparent ]);

            name = 'Bertie Wooster';
            var phone = '+80 79 123 45 76';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 0, parent, grandparent ]);


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


            name = 'Glossop';
            phone = '+80 79 555 55 55';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 1, parent, grandparent ]);
            name = 'Jeeves';
            phone = '+80 79 987 12 34';
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

            name = 'Glossop';
            phone = '+80 79 555 55 55';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 1, parent, grandparent ]);
            name = 'Jeeves';
            phone = '+80 79 987 12 34';
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

            name = 'Aunt Agatha';
            var phone = '+80 79 987 45 76';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 0, parent, grandparent ]);

            name = 'Bertie Wooster';
            var phone = '+80 79 123 45 76';
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

            name = 'Aunt Agatha';
            var phone = '+80 79 987 45 76';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 1, parent, grandparent ]);

            name = 'Bertie Wooster';
            var phone = '+80 79 123 45 76';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 0, parent, grandparent ]);

            var grandparent = 'Italia';
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

            name = 'Bertie Wooster';
            var phone = '+80 79 123 45 76';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 1, parent, grandparent ]);

            name = 'Aunt Agatha';
            var phone = '+80 79 987 45 76';
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

            name = 'Aunt Agatha';
            var phone = '+80 79 987 45 76';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 1, parent, grandparent ]);

            name = 'Bertie Wooster';
            var phone = '+80 79 123 45 76';
            tx.executeSql('INSERT INTO Contact SELECT ?, ?, t.id, ?, ? FROM Template t, TemplateGroup g WHERE t.group_id = g.id AND t.name = ? AND g.name = ?', [ null, name, phone, 0, parent, grandparent ]);


            tx.executeSql('commit');
        }
    )
}

