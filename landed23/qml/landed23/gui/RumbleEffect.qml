import QtQuick 1.1
import org.flyingsheep.abstractui.backend 1.0
//import QtMobility.feedback 1.1

/*
HapticsEffect {id: rumbleEffect
    attackIntensity: 0.0
    attackTime: 250
    intensity: 1.0
    duration: 100
    fadeTime: 250
    fadeIntensity: 0.0

}
*/
Item {

    function start() {
        if (simulator != 1) {
            rumbleEffect.start();
        }
        //else do nothing in simulator case due to bug
    }

    AUIHapticsEffect {id: rumbleEffect
        attackIntensity: 0.0
        attackTime: 250
        intensity: 1.0
        duration: 100
        fadeTime: 250
        fadeIntensity: 0.0

    }
}
