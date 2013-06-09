import QtQuick 1.1
import org.flyingsheep.abstractui 1.0

AUIHighlightRectangle {
    //color: "darkorange"
    //color: "lightblue"
    radius: 5
    Behavior on y { SmoothedAnimation { duration: 75} }
}
