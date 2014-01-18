import TelepathyHelper 1.0

TelepathyHelper {id: telepathyHelper

    signal messageState(string msgState)

    onStateMsg: {
        var today = new Date();
        messageState(statemsg);
    }
}

