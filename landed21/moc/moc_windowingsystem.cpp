/****************************************************************************
** Meta object code from reading C++ file 'windowingsystem.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../windowingsystem.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'windowingsystem.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_WindowingSystem[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
       0,    0, // properties
       1,   14, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // enums: name, flags, count, data
      16, 0x0,   11,   18,

 // enum data: key, value
      19, uint(WindowingSystem::Maemo5),
      26, uint(WindowingSystem::Maemo6),
      33, uint(WindowingSystem::Meego),
      39, uint(WindowingSystem::Simulator),
      49, uint(WindowingSystem::Win),
      53, uint(WindowingSystem::WinCE),
      59, uint(WindowingSystem::Mac),
      63, uint(WindowingSystem::QWS),
      67, uint(WindowingSystem::QPA),
      71, uint(WindowingSystem::X11),
      75, uint(WindowingSystem::Other),

       0        // eod
};

static const char qt_meta_stringdata_WindowingSystem[] = {
    "WindowingSystem\0WS\0Maemo5\0Maemo6\0Meego\0"
    "Simulator\0Win\0WinCE\0Mac\0QWS\0QPA\0X11\0"
    "Other\0"
};

void WindowingSystem::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    Q_UNUSED(_o);
    Q_UNUSED(_id);
    Q_UNUSED(_c);
    Q_UNUSED(_a);
}

const QMetaObjectExtraData WindowingSystem::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject WindowingSystem::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_WindowingSystem,
      qt_meta_data_WindowingSystem, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &WindowingSystem::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *WindowingSystem::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *WindowingSystem::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_WindowingSystem))
        return static_cast<void*>(const_cast< WindowingSystem*>(this));
    return QObject::qt_metacast(_clname);
}

int WindowingSystem::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    return _id;
}
QT_END_MOC_NAMESPACE
