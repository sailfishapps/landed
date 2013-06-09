.pragma library

Qt.include("settingsDB.js")

///////////////////////////////////////////////////////////////
// Support / debug functions
///////////////////////////////////////////////////////////////

function allTables() {
    var db = getDatabase();
    var rs;
    db.transaction(
        function(tx) {
            rs = tx.executeSql('SELECT name FROM sqlite_master WHERE type = ?;', ["table"]);
        }
    )
    return rs;
}

function countRecords(table) {
    var db = getDatabase();
    var cntStmt = "Select Count(*) cnt FROM " + table
    var rs;
    db.transaction(
        function(tx) {
            //rs = tx.executeSql('SELECT count(*) cnt FROM ?;', [table]);
            rs = tx.executeSql(cntStmt);
        }
    )
    return rs;
}
