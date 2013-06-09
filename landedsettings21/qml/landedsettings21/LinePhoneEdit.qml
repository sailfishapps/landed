import QtQuick 1.1
import org.flyingsheep.abstractui 1.0
//import com.nokia.meego 1.0

LineEdit {
    // this sets the initial keyboard as phone type
    //however the user can change to a text keyboard - so we might need to look at this!
    inputMethodHints: Qt.ImhDialableCharactersOnly
}

