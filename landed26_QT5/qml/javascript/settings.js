.pragma library
.import JSONStorage 1.0 as JSDB //access to the json file via C++ plugin for QML / JS
.import "jsonSupport.js" as JSONSupport // provides query functionality on json data

//Possibly in the future I will migrate the jsonpath.js functionality into the JSONStorage plugin
// this would mean one component would offer data access and query functionality.

const JSONSTORAGE = 'json';
const LOCALSTORAGE = 'local';

//switch these constants to switch the data source
var settingsType = JSONSTORAGE;
//var settingsType = LOCALSTORAGE;

//This is the main object called by our QML code
// it is a wrapper for the json and localstorage objects.
// This means the QML code has no knowledge if the datasource is json / localstorage (and does not need to know this)__
// Settings is polymorphic, returning either a json or localstorage object

//all three objects (yes objects, not functions, this is javascript not java) are ex nihilo object literals
var Settings = function() {
    console.log("settingsType: " + settingsType)
    return new __Json();
}

// don't call this direct: call Settings
var __Json = function() {
    var jsonSupport = JSONSupport.JasonSupport();
    return {
        getDatabase: function() {
            console.log("Settings.js: requested db is of type: " + JSDB.JSONStorage.Settings)
            return JSDB.JSONStorage.openDatabase(JSDB.JSONStorage.Settings);
        },
        getDBLevel: function() {
            var db = this.getDatabase();
            var query = "$.dblevel[]"
            var rs = jsonSupport.executeQuery(db, query);
            return rs;
        }
    }
}
