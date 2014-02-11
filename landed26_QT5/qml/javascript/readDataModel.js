.pragma library
.import QtQuick.LocalStorage 2.0 as LS //access to the SQLite Database
.import JSONStorage 1.0 as JSDB //access to the json file via C++ plugin for QML / JS
.import "jsonpath.js" as JSONPath // provides query functionality on json data

//Possibly in the future I will migrate the jsonpath.js functionality into the JSONStorage plugin
// this would ean one component would offer data access and query functionality.

const JSONSTORAGE = 'json';
const LOCALSTORAGE = 'local';

//switch these constants to switch the data source
var storageType = JSONSTORAGE;
//var storageType = LOCALSTORAGE;

//This is the main object called by our QML code
// it is a wrapper for the json and localstorage objects.
// This means the QML code has no knowledge if the datasource is json / localstorage (and does not need to know this)__
// DataModel is polymorphic, returning either a json or localstorage object

//all three objects (yes objects, not functions, this is javascript not java) are ex nihilo object literals
var DataModel = function() {
    console.log("storageType: " + storageType)
    if (storageType == JSONSTORAGE) {
        return new __Json();
    }
    else {
        return new __LocalStorage();
    }
}

//The objects __Json and __LocalStorage have the same methods, with identical signatures,
//but different implementations.
//These could both by subtypes of DataModel, but as they share no implementation, and because JS is dynamic
//there is little benefit from truely inheriting them from DataModel

// don't call this direct: call DataModel
var __Json = function() {
    return {

        getDatabase: function() {
            return JSDB.JSONStorage.openDatabase();
        },
        parseJSONString: function(jsonString, jsonPathQuery) {
            var objectArray = JSON.parse(jsonString);
            if ( jsonPathQuery !== "" ) {
                console.log("about to pass DB to JSONPath");
                objectArray = JSONPath.jsonPath(objectArray, jsonPathQuery);
                console.log("readDataModel.js: objectArray.length: " + objectArray.length);
            }
            return objectArray;
        },
        executeQuery: function (db, query) {
            //This executes the query and packs it as a result set
            //structured like that returned from LocalStorage
            //os our QML does not have to care about the datasource
            var jsonRows = this.parseJSONString(db, query);
            var rs = {
               //rs is a SQLResultSet object
               insertId: 0,
               rowsAffected: 0,
               rows: {
                  //rows is a SQLResultSetRowList object
                  length: jsonRows.length,
                  item: function(index) {
                     return jsonRows [index];
                  }
               }
            }
            return rs;
        },
        getArea: function(area_id) {
            var db = this.getDatabase();
            //('SELECT * FROM Area g WHERE g.id = ?;', [area_id]);
            var query = "$.landed.area[?(@.id == " + area_id + ")]"
            var rs = this.executeQuery(db, query);
            return rs;
        },
        getAreas: function() {
            var db = this.getDatabase();
            //('SELECT * FROM Area');
            var query = "$.landed.area[*]"
            var rs = this.executeQuery(db, query);
            return rs;
        },
        getTemplates: function(area_id) {
            var db = this.getDatabase();
            //('SELECT * FROM Template t where t.area_id= ?;', [area_id]);
            var query = "$.landed.area[?(@.id == " + area_id + ")].template[*]"
            var rs = this.executeQuery(db, query);
            return rs;
        },
        getTags: function(area_id, template_id) {
            console.log("about to getTags: area_id: " + area_id + ", template_id: " + template_id );
            var db = this.getDatabase();
            //('SELECT * FROM Tag t WHERE t.area_id = ? AND t.template_id = ? ORDER BY tag_order;', [area_id, template_id]);
            var query = "$.landed.area[?(@.id == " + area_id + ")].template[?(@.id == " + template_id + ")].tag[*]"
            var rs = this.executeQuery(db, query);
            return rs;
        },
        getPrimaryContact: function(area_id, template_id, any) {
            console.log("about to getPrimaryContact: area_id: " + area_id + ", template_id: " + template_id  + ", any: " + any);
            var db = this.getDatabase();
            //('SELECT * FROM Contact c WHERE c.area_id = ? AND c.template_id = ? AND c.primary_contact = 1;', [area_id, template_id]);
            var query = "$.landed.area[?(@.id == " + area_id + ")].template[?(@.id == " + template_id + ")].contact[?(@.primary_contact == 1)]";
            var rs = this.executeQuery(db, query);
            if (((!rs) || (rs.rows.length == 0)) && (any == 1)) {
                console.log ("no primary contact available, take the first one");
                //('SELECT * FROM Contact c WHERE c.area_id = ? AND c.template_id = ? LIMIT 1;', [area_id, template_id]);
                var query = "$.landed.area[?(@.id == " + area_id + ")].template[?(@.id == " + template_id + ")].contact[0]"
            }
            var rs = this.executeQuery(db, query);
            return rs;
        },
        getContacts: function(area_id, template_id) {
            var db = this.getDatabase();
            //('SELECT * FROM Contact c WHERE c.area_id = ? AND c.template_id = ? ORDER BY c.primary_contact DESC;', [area_id, template_id]);
            var query = "$.landed.area[?(@.id == " + area_id + ")].template[?(@.id == " + template_id + ")].contact[*]"
            var rs = this.executeQuery(db, query);
            return rs;
        }
    }
}

// don't call this direct: call DataModel
var __LocalStorage = function() {
    return {
        getDatabase: function() {
            //storage location on Sailfish is /home/nemo/.local/share/data/QML/OfflineStorage/Databases
            return LS.LocalStorage.openDatabaseSync("Landed25", "1.0", "StorageDatabase", 100000);
        },
        getArea: function(area_id) {
            var db = this.getDatabase();
            var rs;
            db.transaction(
                function(tx) {
                    rs = tx.executeSql('SELECT * FROM Area g WHERE g.id = ?;', [area_id]);
                }
            )
            return rs;
        },
        getPrimaryArea: function() {
            var db = this.getDatabase();
            var rs;
            db.transaction(
                function(tx) {
                    rs = tx.executeSql('SELECT * FROM Area g WHERE g.primary_area = 1;');
                }
            )
            return rs;
        },
        getAreas: function() {
            var db = this.getDatabase();
            var rs;
            db.transaction(
                function(tx) {
                    rs = tx.executeSql('SELECT * FROM Area');
                }
            )
            return rs;
        },
        getTemplate: function(template_id) {
            var db = this.getDatabase();
            var rs;
            db.transaction(
                function(tx) {
                    rs = tx.executeSql('SELECT * FROM Template t WHERE t.id = ?;', [template_id]);
                }
            )
            return rs;
        },
        getTemplates: function(area_id) {
            var db = this.getDatabase();
            var rs;
            db.transaction(
                function(tx) {
                    rs = tx.executeSql('SELECT * FROM Template t where t.area_id= ?;', [area_id]);
                }
            )
            return rs;
        },
        getTags: function(area_id, template_id) {
            var db = this.getDatabase();
            var rs;
            db.transaction(
                function(tx) {
                    rs = tx.executeSql('SELECT * FROM Tag t WHERE t.area_id = ? AND t.template_id = ? ORDER BY tag_order;', [area_id, template_id]);
                }
            )
            return rs;
        },
        getContact: function (area_id, template_id, contact_id) {
            var db = this.getDatabase();
            var rs;
            db.transaction(
                function(tx) {
                    rs = tx.executeSql('SELECT * FROM Contact c WHERE c.area_id = ? AND c.template_id = ? AND c.id = ?;', [area_id, template_id, contact_id]);
                }
            )
            return rs;
        },
        getPrimaryContact: function(area_id, template_id, any) {
            var db = this.getDatabase();
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
        },
        getContacts: function(area_id, template_id) {
            var db = this.getDatabase();
            var rs;
            db.transaction(
                function(tx) {
                    rs = tx.executeSql('SELECT * FROM Contact c WHERE c.area_id = ? AND c.template_id = ? ORDER BY c.primary_contact DESC;', [area_id, template_id]);
                }
            )
            return rs;
        }
    }
}

