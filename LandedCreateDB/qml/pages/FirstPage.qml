import QtQuick 2.0
import Sailfish.Silica 1.0
import "initiateDB.js" as DB


Page {
    id: page

    Component.onCompleted: {
        console.log("initiating and populating DB");
        DB.initiateDb();
        DB.populateDb();
    }

}
