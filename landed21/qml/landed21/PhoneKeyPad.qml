import QtQuick 1.1

Item { id: thisKeyPad

    signal keyPressed (string key)

    width: 480
    property int rowHeight: 110

    Item { id: keyRow1
        y: 0
        height: rowHeight
        width: parent.width
        PhoneKey{id: key1
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: 0
            text: "1"
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
        PhoneKey{id: key2
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: width;
            text: "2"
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
        PhoneKey{id: key3
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: width*2;
            text: "3"
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
    }

    Item { id: keyRow2
        y: rowHeight
        height: rowHeight
        width: parent.width
        PhoneKey{id: key4
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: 0
            text: "4"
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
        PhoneKey{id: key5
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: width;
            text: "5"
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
        PhoneKey{id: key6
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: width*2;
            text: "6"
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
    }

    Item { id: keyRow3
        y: rowHeight*2
        height: rowHeight
        width: parent.width
        PhoneKey{id: key7
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: 0
            text: "7"
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
        PhoneKey{id: key8
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: width;
            text: "8"
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
        PhoneKey{id: key9
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: width*2;
            text: "9"
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
    }

    Item { id: keyRow4
        y: rowHeight*3
        height: rowHeight
        width: parent.width
        PhoneKey{id: keyPlus
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: 0
            text: "+"
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
        PhoneKey{id: key0
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: width;
            text: "0"
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
        PhoneKey{id: keyHash
            anchors {top: parent.top; bottom: parent.bottom;}
            width: parent.width / 3;
            x: width*2;
            text: "#"
            onKeyPressed: thisKeyPad.keyPressed(key);
        }
    }
}
