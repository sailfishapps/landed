import QtQuick 1.1
import SMSHelper 1.0
import "../javascript/settingsDB.js" as DB

//REFACTOR: consider basing the whole thing on an SMSHelper, rather than item.
//this would allow us to drop the import to QtQuick (probably).

Item{id: rectSMS

    property bool smsSent: false

    signal messageState(string msgState)

    function sendSMS(phoneNumber, text) {
        smshelper.sendsms(phoneNumber, text);
    }

    function buildDefaultMsg(template_id) {
        var text = "";
        var tag = "";
        var rs = DB.getTags(template_id);
        for(var i = 0; i < rs.rows.length; i++) {
            tag = rs.rows.item(i).default_value;
            tag = swapPlaceHolders(tag) + "\n";
            text = text + tag;
        }
        return text;
    }

    function swapPlaceHolders (tag) {
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

//TODO: consider if this belongs in a contact back end?
    function getContact(template_id) {
        var rs = DB.getActiveContact(template_id, 1);
        return rs;
    }

    //////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////

    SMSHelper{id: smshelper
        onStateMsg: {
            var today = new Date();
            console.log("state msg received:" + statemsg + " " + today);
            rectSMS.messageState(statemsg);
        }
    }

}

