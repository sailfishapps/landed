.pragma library
.import "readDataModel.js" as DB
//Qt.include ("readDataModel.js") //Old Qt4 Style Import

function buildDefaultMsg(area_id, template_id, lati, longi, alti) {
    var text = "";
    var tag = "";
    var db = DB.DataModel();
    var rs = db.getTags(area_id, template_id);
    for(var i = 0; i < rs.rows.length; i++) {
        tag = rs.rows.item(i).default_value;
        tag = swapPlaceHolders(tag, lati, longi, alti) + "\n";
        text = text + tag;
    }
    console.log("text: " + text);
    return text;
}

function swapPlaceHolders (tag, lati, longi, alti) {
    var headerTag = "@header@";
    var latiTag = "@lati@";
    var longiTag = "@longi@";
    var altiTag = "@alti@";
    var datetime = "@datetime@"

    if (tag == headerTag) {
        return "*Landed*";
    }if (tag == latiTag) {
        return "Latitude: " + lati;
    }
    else if (tag == longiTag) {
        return "Longitude: " + longi;
    }
    else if (tag == altiTag) {
        return "Altitude: " + alti + " m";
    }
    else if (tag == datetime) {
        var today = new Date();
        return Qt.formatDateTime(today, "dd.MM.yyyy hh:mm:ss")
        //today;
    }
    else return tag;
}
