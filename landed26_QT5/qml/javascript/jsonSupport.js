.pragma library
.import "jsonpath.js" as JSONPath // provides query functionality on json data

var JasonSupport = function() {
    return {
        parseJSONString: function(jsonString, jsonPathQuery) {
            var objectArray = JSON.parse(jsonString);
            if ( jsonPathQuery !== "" ) {
                console.log("jsonSupport.js: to pass DB to JSONPath");
                objectArray = JSONPath.jsonPath(objectArray, jsonPathQuery);
                console.log("jsonSupport.js: objectArray.length: " + objectArray.length);
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
        }
    }
}
