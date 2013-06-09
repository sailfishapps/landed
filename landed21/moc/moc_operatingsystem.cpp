/****************************************************************************
** Meta object code from reading C++ file 'operatingsystem.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../operatingsystem.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'operatingsystem.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_OperatingSystem[] = {

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
      16, 0x0,    8,   18,

 // enum data: key, value
      19, uint(OperatingSystem::Symbian),
      27, uint(OperatingSystem::Mac64),
      33, uint(OperatingSystem::Unix),
      38, uint(OperatingSystem::Win32),
      44, uint(OperatingSystem::Win64),
      50, uint(OperatingSystem::WinCE),
      56, uint(OperatingSystem::Simulator),
      66, uint(OperatingSystem::Other),

       0        // eod
};

static const char qt_meta_stringdata_OperatingSystem[] = {
    "OperatingSystem\0OS\0Symbian\0Mac64\0Unix\0"
    "Win32\0Win64\0WinCE\0Simulator\0Other\0"
};

void OperatingSystem::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    Q_UNUSED(_o);
    Q_UNUSED(_id);
    Q_UNUSED(_c);
    Q_UNUSED(_a);
}

const QMetaObjectExtraData OperatingSystem::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject OperatingSystem::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_OperatingSystem,
      qt_meta_data_OperatingSystem, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &OperatingSystem::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *OperatingSystem::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *OperatingSystem::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_OperatingSystem))
        return static_cast<void*>(const_cast< OperatingSystem*>(this));
    return QObject::qt_metacast(_clname);
}

int OperatingSystem::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    return _id;
}
QT_END_MOC_NAMESPACE
