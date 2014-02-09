#ifndef LANDEDTHEME_H
#define LANDEDTHEME_H
#include <QObject>
#include <QColor>
class LandedTheme : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int MarginSmall READ MarginSmall CONSTANT)
    Q_PROPERTY(int MarginText READ MarginText CONSTANT)

    Q_PROPERTY(QColor BackgroundColorA READ BackgroundColorA CONSTANT)
    Q_PROPERTY(QColor BackgroundColorB READ BackgroundColorB CONSTANT)
    Q_PROPERTY(QColor BackgroundColorC READ BackgroundColorC CONSTANT)
    Q_PROPERTY(QColor BackgroundColorD READ BackgroundColorD CONSTANT)
    Q_PROPERTY(QColor BackgroundColorE READ BackgroundColorE CONSTANT)

    Q_PROPERTY(QColor TextColorActive READ TextColorActive CONSTANT)
    Q_PROPERTY(QColor TextColorEmergency READ TextColorEmergency CONSTANT)
    Q_PROPERTY(QColor TextColorInactive READ TextColorInactive CONSTANT)
    Q_PROPERTY(QColor LabelColorActive READ LabelColorActive CONSTANT)
    Q_PROPERTY(QColor LabelColorInactive READ LabelColorInactive CONSTANT)

    Q_PROPERTY(QColor ButtonColorGreen READ ButtonColorGreen CONSTANT)
    Q_PROPERTY(QColor ButtonColorRed READ ButtonColorRed CONSTANT)
    Q_PROPERTY(QColor ButtonColorGrey READ ButtonColorGrey CONSTANT)
    Q_PROPERTY(QColor ButtonColorWhite READ ButtonColorWhite CONSTANT)

public:
    LandedTheme(QObject* parent = 0) : QObject(parent) {}

    int MarginSmall() const { return 10;}
    int MarginText() const { return 0;} //as sailfish is transparent, no margin needed on textarea / text edit etc.

    QColor BackgroundColorA() const { return "transparent";}
    QColor BackgroundColorB() const { return "transparent";}
    QColor BackgroundColorC() const { return "transparent";}
    QColor BackgroundColorD() const { return "transparent";}
    QColor BackgroundColorE() const { return "transparent";}

    QColor TextColorActive() const { return  "lightgreen";}
    QColor TextColorEmergency() const { return  "red";}
    QColor TextColorInactive() const { return "grey";}
    QColor LabelColorActive() const { return "darkgrey";}
    QColor LabelColorInactive() const { return "grey";}

    QColor ButtonColorGreen() const { return "lightgreen";}
    QColor ButtonColorRed() const { return "red";}
    QColor ButtonColorGrey() const { return "grey";}
    QColor ButtonColorWhite() const { return "white";}

    /*
    //harmattan
    int MarginSmall() const { return 10;}
    int MarginText() const { return 10;}
    QColor BackgroundColorA() const { return "black";}
    QColor BackgroundColorB() const { return "white";}
    QColor BackgroundColorC() const { return "lightyellow";}
    QColor BackgroundColorD() const { return "red";}
    QColor BackgroundColorE() const { return "green";}
    */
};
#endif // LANDEDTHEME_H


