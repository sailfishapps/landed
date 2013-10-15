#ifndef WINDOWINGSYSTEM_H
#define WINDOWINGSYSTEM_H

#include <QObject>

class WindowingSystem : public QObject
{
    Q_OBJECT
    Q_ENUMS(WS)
public:
    enum WS { Maemo5, Maemo6, Meego, Simulator, Win, WinCE, Mac, QWS, QPA, X11, Other };
};

#endif // WINDOWINGSYSTEM_H
