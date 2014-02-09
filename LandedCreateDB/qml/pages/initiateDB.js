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
            tx.executeSql("DROP TABLE IF EXISTS Area");
            tx.executeSql('CREATE TABLE IF NOT EXISTS Area(id INTEGER PRIMARY KEY, name TEXT, primary_area INTEGER, latitude NUMBER, longitude NUMBER, UNIQUE (name))');

            tx.executeSql("DROP TABLE IF EXISTS Template");
            tx.executeSql('CREATE TABLE IF NOT EXISTS Template(id INTEGER PRIMARY KEY, name TEXT, button_label TEXT, msg_status TEXT, area_id INTEGER, UNIQUE (name, area_id), FOREIGN KEY(area_id) REFERENCES Area(id))');

            tx.executeSql("DROP TABLE IF EXISTS Tag");
            tx.executeSql('CREATE TABLE IF NOT EXISTS Tag(id INTEGER PRIMARY KEY, name TEXT, default_value TEXT, comment TEXT, tag_order INTEGER, area_id INTEGER, template_id INTEGER, UNIQUE (name, template_id), FOREIGN KEY(area_id) REFERENCES Area(id), FOREIGN KEY(template_id) REFERENCES Template(id))');

            tx.executeSql("DROP TABLE IF EXISTS Contact");
            tx.executeSql('CREATE TABLE IF NOT EXISTS Contact(id INTEGER PRIMARY KEY, name TEXT, phone TEXT, primary_contact INTEGER, area_id INTEGER, template_id INTEGER, UNIQUE (name, template_id), FOREIGN KEY(area_id) REFERENCES Area(id), FOREIGN KEY(template_id) REFERENCES Template(id))');
        }
    )
}

function populateDb() {
    var db = getDatabase();
    db.transaction(
        function(tx) {
            tx.executeSql("DELETE FROM Area");
            tx.executeSql('INSERT INTO Area (id, name, primary_area, latitude, longitude) VALUES (?, ?, ?, ?, ?)', [ null, 'South Africa', 1, -33.825, 18.502 ]);
            tx.executeSql('INSERT INTO Area (id, name, primary_area, latitude, longitude) VALUES (?, ?, ?, ?, ?)', [ null, 'Greece', 0 , 38.1, 21.5]);
            tx.executeSql('INSERT INTO Area (id, name, primary_area, latitude, longitude) VALUES (?, ?, ?, ?, ?)', [ null, 'Schweiz', 0, 50.0, 10.5 ]);
            tx.executeSql('INSERT INTO Area (id, name, primary_area, latitude, longitude) VALUES (?, ?, ?, ?, ?)', [ null, 'Italia', 0, 43.55, 13.5 ]);


            tx.executeSql("DELETE FROM Template");

            tx.executeSql('INSERT INTO Template (id, name, button_label, msg_status, area_id) SELECT ?, ?, ?, ?, id FROM Area WHERE name = ?', [ null, 'DefaultOKMsg', 'Create Recovery SMS', 'Ok', 'South Africa' ]);
            tx.executeSql('INSERT INTO Template (id, name, button_label, msg_status, area_id) SELECT ?, ?, ?, ?, id FROM Area WHERE name = ?', [ null, 'DefaultNotOKMsg', 'Create "Help Me!" SMS', 'NotOk', 'South Africa' ]);
            tx.executeSql('INSERT INTO Template (id, name, button_label, msg_status, area_id) SELECT ?, ?, ?, ?, id FROM Area WHERE name = ?', [ null, 'DefaultOKMsg', 'Create Recovery SMS', 'Ok', 'Greece' ]);
            tx.executeSql('INSERT INTO Template (id, name, button_label, msg_status, area_id) SELECT ?, ?, ?, ?, id FROM Area WHERE name = ?', [ null, 'DefaultNotOKMsg', 'Create "Help Me!" SMS', 'NotOk', 'Greece' ]);
            tx.executeSql('INSERT INTO Template (id, name, button_label, msg_status, area_id) SELECT ?, ?, ?, ?, id FROM Area WHERE name = ?', [ null, 'DefaultOKMsg', 'Create Recovery SMS', 'Ok', 'Schweiz' ]);
            tx.executeSql('INSERT INTO Template (id, name, button_label, msg_status, area_id) SELECT ?, ?, ?, ?, id FROM Area WHERE name = ?', [ null, 'DefaultNotOKMsg', 'Create "Help Me!" SMS', 'NotOk', 'Schweiz' ]);
            tx.executeSql('INSERT INTO Template (id, name, button_label, msg_status, area_id) SELECT ?, ?, ?, ?, id FROM Area WHERE name = ?', [ null, 'DefaultOKMsg', 'Create Recovery SMS', 'Ok', 'Italia' ]);
            tx.executeSql('INSERT INTO Template (id, name, button_label, msg_status, area_id) SELECT ?, ?, ?, ?, id FROM Area WHERE name = ?', [ null, 'DefaultNotOKMsg', 'Create "Help Me!" SMS', 'NotOk', 'Italia' ]);

            tx.executeSql("DELETE FROM Tag");

            var grandparent = 'South Africa';
            var parent = 'DefaultOKMsg';
            var name = 'header';
            var tag_order = 0;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'Used by receiver app to identify as SMS from Landed', tag_order, parent, grandparent ]);
            name = 'intro';
            tag_order = 1;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'Chris has landed at:', 'start of message', tag_order, parent, grandparent ]);
            name = 'lati';
            tag_order = 2;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows latitude', tag_order, parent, grandparent ]);
            name = 'longi';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows longitude', tag_order, parent, grandparent ]);
            name = 'alti';
            tag_order = 4;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows altitude', tag_order, parent, grandparent ]);
            name = 'datetime';
            tag_order = 5;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows date and time', tag_order, parent, grandparent ]);
            name = 'status';
            tag_order = 6;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'Status: OK', 'shows status: Ok or NOT Ok', tag_order, parent, grandparent ]);
            name = 'recovery';
            tag_order = 7;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'He is awaiting recovery', 'shows if recovery requiNotOk', tag_order, parent, grandparent ]);

            name = 'Gussie Fink-Nottle';
            var phone = '+80 79 121 22 33';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 1, parent, grandparent ]);

            name = 'Aunt Agatha';
            var phone = '+80 79 987 45 76';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 0, parent, grandparent ]);

            name = 'Bertie Wooster';
            var phone = '+80 79 123 45 76';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 0, parent, grandparent ]);



            parent = 'DefaultNotOKMsg';
            name = 'header';
            tag_order = 0;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'Used by receiver app to identify as SMS from Landed', tag_order, parent, grandparent ]);
            name = 'intro';
            tag_order = 1;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'Chris has landed at:', 'start of message', tag_order, parent, grandparent ]);
            name = 'lati';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows latitude', tag_order, parent, grandparent ]);
            name = 'longi';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows longitude', tag_order, parent, grandparent ]);
            name = 'alti';
            tag_order = 4;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows altitude', tag_order, parent, grandparent ]);
            name = 'datetime';
            tag_order = 5;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows date and time', tag_order, parent, grandparent ]);
            name = 'status';
            tag_order = 6;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'Status: NOT OK', 'shows status: Ok or NOT Ok', tag_order, parent, grandparent ]);

            name = 'Gussie Fink-Nottle';
            var phone = '+80 79 121 22 33';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 1, parent, grandparent ]);

            name = 'Aunt Agatha';
            var phone = '+80 79 987 45 76';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 0, parent, grandparent ]);

            name = 'Bertie Wooster';
            var phone = '+80 79 123 45 76';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 0, parent, grandparent ]);


            var grandparent = 'Greece';
            parent = 'DefaultOKMsg';
            name = 'header';
            tag_order = 0;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'Used by receiver app to identify as SMS from Landed', tag_order, parent, grandparent ]);
            name = 'intro';
            tag_order = 1;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'Chris has landed at:', 'start of message', tag_order, parent, grandparent ]);
            name = 'lati';
            tag_order = 2;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows latitude', tag_order, parent, grandparent ]);
            name = 'longi';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows longitude', tag_order, parent, grandparent ]);
            name = 'alti';
            tag_order = 4;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows altitude', tag_order, parent, grandparent ]);
            name = 'datetime';
            tag_order = 5;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows date and time', tag_order, parent, grandparent ]);
            name = 'status';
            tag_order = 6;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'Status: OK', 'shows status: Ok or NOT Ok', tag_order, parent, grandparent ]);
            name = 'recovery';
            tag_order = 7;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'He is awaiting recovery', 'shows if recovery requiNotOk', tag_order, parent, grandparent ]);


            name = 'Glossop';
            phone = '+80 79 555 55 55';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 1, parent, grandparent ]);
            name = 'Jeeves';
            phone = '+80 79 987 12 34';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 1, parent, grandparent ]);


            parent = 'DefaultNotOKMsg';
            name = 'header';
            tag_order = 0;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'Used by receiver app to identify as SMS from Landed', tag_order, parent, grandparent ]);
            name = 'intro';
            tag_order = 1;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'Chris has landed at:', 'start of message', tag_order, parent, grandparent ]);
            name = 'lati';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows latitude', tag_order, parent, grandparent ]);
            name = 'longi';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows longitude', tag_order, parent, grandparent ]);
            name = 'alti';
            tag_order = 4;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows altitude', tag_order, parent, grandparent ]);
            name = 'datetime';
            tag_order = 5;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows date and time', tag_order, parent, grandparent ]);
            name = 'status';
            tag_order = 6;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'Status: NOT OK', 'shows status: Ok or NOT Ok', tag_order, parent, grandparent ]);

            name = 'Glossop';
            phone = '+80 79 555 55 55';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 1, parent, grandparent ]);
            name = 'Jeeves';
            phone = '+80 79 987 12 34';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 1, parent, grandparent ]);


            var grandparent = 'Schweiz';
            var parent = 'DefaultOKMsg';
            var name = 'header';
            var tag_order = 0;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'Used by receiver app to identify as SMS from Landed', tag_order, parent, grandparent ]);
            name = 'intro';
            tag_order = 1;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'Chris has landed at:', 'start of message', tag_order, parent, grandparent ]);
            name = 'lati';
            tag_order = 2;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows latitude', tag_order, parent, grandparent ]);
            name = 'longi';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows longitude', tag_order, parent, grandparent ]);
            name = 'alti';
            tag_order = 4;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows altitude', tag_order, parent, grandparent ]);
            name = 'datetime';
            tag_order = 5;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows date and time', tag_order, parent, grandparent ]);
            name = 'status';
            tag_order = 6;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'Status: OK', 'shows status: Ok or NOT Ok', tag_order, parent, grandparent ]);
            name = 'recovery';
            tag_order = 7;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'He is awaiting recovery', 'shows if recovery requiNotOk', tag_order, parent, grandparent ]);

            name = 'Aunt Agatha';
            var phone = '+80 79 987 45 76';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 0, parent, grandparent ]);

            name = 'Bertie Wooster';
            var phone = '+80 79 123 45 76';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 1, parent, grandparent ]);


            parent = 'DefaultNotOKMsg';
            name = 'header';
            tag_order = 0;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'Used by receiver app to identify as SMS from Landed', tag_order, parent, grandparent ]);
            name = 'intro';
            tag_order = 1;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'Chris has landed at:', 'start of message', tag_order, parent, grandparent ]);
            name = 'lati';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows latitude', tag_order, parent, grandparent ]);
            name = 'longi';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows longitude', tag_order, parent, grandparent ]);
            name = 'alti';
            tag_order = 4;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows altitude', tag_order, parent, grandparent ]);
            name = 'datetime';
            tag_order = 5;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows date and time', tag_order, parent, grandparent ]);
            name = 'status';
            tag_order = 6;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'Status: NOT OK', 'shows status: Ok or NOT Ok', tag_order, parent, grandparent ]);

            name = 'Aunt Agatha';
            var phone = '+80 79 987 45 76';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 1, parent, grandparent ]);

            name = 'Bertie Wooster';
            var phone = '+80 79 123 45 76';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 0, parent, grandparent ]);

            var grandparent = 'Italia';
            var parent = 'DefaultOKMsg';
            var name = 'header';
            var tag_order = 0;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'Used by receiver app to identify as SMS from Landed', tag_order, parent, grandparent ]);
            name = 'intro';
            tag_order = 1;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'Chris has landed at:', 'start of message', tag_order, parent, grandparent ]);
            name = 'lati';
            tag_order = 2;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows latitude', tag_order, parent, grandparent ]);
            name = 'longi';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows longitude', tag_order, parent, grandparent ]);
            name = 'alti';
            tag_order = 4;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows altitude', tag_order, parent, grandparent ]);
            name = 'datetime';
            tag_order = 5;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows date and time', tag_order, parent, grandparent ]);
            name = 'status';
            tag_order = 6;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'Status: OK', 'shows status: Ok or NOT Ok', tag_order, parent, grandparent ]);
            name = 'recovery';
            tag_order = 7;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'He is awaiting recovery', 'shows if recovery requiNotOk', tag_order, parent, grandparent ]);

            name = 'Bertie Wooster';
            var phone = '+80 79 123 45 76';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 1, parent, grandparent ]);

            name = 'Aunt Agatha';
            var phone = '+80 79 987 45 76';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 0, parent, grandparent ]);


            parent = 'DefaultNotOKMsg';
            name = 'header';
            tag_order = 0;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'Used by receiver app to identify as SMS from Landed', tag_order, parent, grandparent ]);
            name = 'intro';
            tag_order = 1;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'Chris has landed at:', 'start of message', tag_order, parent, grandparent ]);
            name = 'lati';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows latitude', tag_order, parent, grandparent ]);
            name = 'longi';
            tag_order = 3;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows longitude', tag_order, parent, grandparent ]);
            name = 'alti';
            tag_order = 4;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows altitude', tag_order, parent, grandparent ]);
            name = 'datetime';
            tag_order = 5;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, symb + name + symb, 'shows date and time', tag_order, parent, grandparent ]);
            name = 'status';
            tag_order = 6;
            tx.executeSql('INSERT INTO Tag (id, name, default_value, comment, tag_order, area_id, template_id) SELECT ?, ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, 'Status: NOT OK', 'shows status: Ok or NOT Ok', tag_order, parent, grandparent ]);

            name = 'Aunt Agatha';
            var phone = '+80 79 987 45 76';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 1, parent, grandparent ]);

            name = 'Bertie Wooster';
            var phone = '+80 79 123 45 76';
            tx.executeSql('INSERT INTO Contact (id, name, phone, primary_contact, area_id, template_id) SELECT ?, ?, ?, ?, a.id, t.id FROM Template t, Area a WHERE t.area_id = a.id AND t.name = ? AND a.name = ?', [ null, name, phone, 0, parent, grandparent ]);



            tx.executeSql('commit');
        }
    )
}
