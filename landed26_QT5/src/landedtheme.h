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
public:
    LandedTheme(QObject* parent = 0) : QObject(parent) {}
    int MarginSmall() const { return 10;}
    int MarginText() const { return 0;} //as sailfish is transparent, no margin needed on textarea / text edit etc.
    QColor BackgroundColorA() const { return "transparent";}
    QColor BackgroundColorB() const { return "transparent";}
    QColor BackgroundColorC() const { return "transparent";}
    QColor BackgroundColorD() const { return "red";}
    /*
    //harmattan
    int MarginSmall() const { return 10;}
    int MarginText() const { return 10;}
    QColor BackgroundColorA() const { return "black";}
    QColor BackgroundColorB() const { return "white";}
    QColor BackgroundColorC() const { return "lightyellow";}
    QColor BackgroundColorD() const { return "red";}
    */
};
#endif // LANDEDTHEME_H


