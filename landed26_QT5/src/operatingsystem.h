#ifndef OPERATINGSYSTEM_H
#define OPERATINGSYSTEM_H

#include <QObject>

class OperatingSystem : public QObject
{
    Q_OBJECT
    Q_ENUMS(OS)
public:
    enum OS { Symbian, Mac64, Unix, Win32, Win64, WinCE, Simulator, Other };
};

#endif // OPERATINGSYSTEM_H
